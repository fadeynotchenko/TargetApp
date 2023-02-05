//
//  NewTargetView.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI
import AnyFormatKitSwiftUI

struct NewTargetView: View {
    
    var editTarget: TargetEntity?
    @Binding var isNewTargetViewShow: Bool
    @Binding var navSelection: UUID?
    
    @State private var newName = ""
    
    @State private var currency: Currency = .rub
    @State private var period: Period = .never
    
    @State private var price: NSNumber?
    @State private var currentMoney: NSNumber?
    @State private var replenishment: NSNumber?
    
    @State private var color: Color = .pink
    @State private var date = Date()
    
    @State private var isDatePickerShow = false
    @State private var isNotificationsOn = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var isSaveButtonDisabled: Bool {
        self.newName.isEmpty || self.price == nil || self.price == 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    Section {
                        TextField("target_name_hint", text: $newName)
                    }
                    
                    CurrencyAndPriceSection
                        .onChange(of: currentMoney) { _ in
                            let current = Int64(truncating: currentMoney ?? 0)
                            let price = Int64(truncating: price ?? 0)
                            
                            self.currentMoney = min(current, price) as NSNumber
                        }
                    
                    NavigationLink {
                        NotificationView(replishment: $replenishment, period: $period, date: $date, isDatePickerShow: $isDatePickerShow, isNotificationsOn: $isNotificationsOn)
                    } label: {
                        NotificationViewLabel
                    }
                    
                    Section {
                        ColorPicker("color_picker", selection: $color)
                    }
                    
                    SaveButton
                    
                    if let target = editTarget {
                        DeleteButton(target)
                    }
                }
            }
            .navigationBarTitle(Text(self.editTarget == nil ? "new_target" : "edit"), displayMode: .inline)
            ._safeAreaInsets(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("close") {
                        self.isNewTargetViewShow.toggle()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if let target = editTarget {
                self.newName = target.unwrappedName
                self.currency = Currency(rawValue: target.unwrappedCurrency) ?? .rub
                self.price = (target.price) as NSNumber
                self.currentMoney = (target.currentMoney) as NSNumber
                self.color = Color(uiColor: UIColor.color(withData: target.unwrappedColor))
                
                if target.replenishment != 0 {
                    self.replenishment = (target.replenishment) as NSNumber
                    self.period = Period(rawValue: target.unwrappedPeriod) ?? .never
                    
                    if let date = target.dateNotification {
                        self.isDatePickerShow = true
                        self.date = date
                    }
                    
                    self.isNotificationsOn = true
                }
            }
        }
    }
    
    private var CurrencyAndPriceSection: some View {
        Section {
            if self.editTarget == nil {
                Picker("currency", selection: $currency) {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        Button {
                            self.currency = currency
                        } label: {
                            Text(currency.rawValue)
                        }
                    }
                }
                .pickerStyle(.menu)
            }
            
            FormatSumTextField(numberValue: $price, placeholder: NSLocalizedString("price", comment: ""), numberFormatter: valueFormatter )
                .keyboardType(.numberPad)
            
            if self.editTarget == nil {
                FormatSumTextField(numberValue: $currentMoney, placeholder: NSLocalizedString("current", comment: ""), numberFormatter: valueFormatter)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private var NotificationViewLabel: some View {
        HStack(spacing: 10) {
            RectangleIcon(systemName: "bell.fill", color: .red)
            
            Text("reminders")
            
            Spacer()
            
            if !self.isNotificationsOn {
                Text("no")
                    .foregroundColor(.gray)
            } else if self.period == Period.never {
                Text(NSLocalizedString(period.rawValue, comment: ""))
                    .foregroundColor(.gray)
            } else {
                Text("\(NSLocalizedString("one_in", comment: "")) \(NSLocalizedString(self.period.rawValue, comment: ""))")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var SaveButton: some View {
        Section {
            Button {
                if let editTarget = self.editTarget {
                    updateTarget(editTarget)
                } else {
                    saveNewTarget()
                }
            } label: {
                Text(self.editTarget == nil ? "add" : "save")
                    .bold()
                    .foregroundColor(isSaveButtonDisabled ? .gray : .accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .disabled(isSaveButtonDisabled)
        }
    }
    
    private func DeleteButton(_ target: TargetEntity) -> some View {
        Section {
            Button {
                PersistenceController.deleteTarget(target, context: viewContext)
                
                self.isNewTargetViewShow.toggle()
                self.navSelection = nil
            } label: {
                Text("delete")
                    .foregroundColor(.red)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

extension NewTargetView {
    private func saveNewTarget() {
        let target = TargetEntity(context: viewContext)
        
        target.id = UUID()
        target.dateStart = Date().addingTimeInterval(-1)
        target.name = self.newName
        target.price = Int64(truncating: self.price ?? 0)
        target.currentMoney = Int64(truncating: self.currentMoney ?? 0)
        target.currency = self.currency.rawValue
        target.period = self.period.rawValue
        target.color = UIColor(self.color).encode()

        //add notification
        if let replishment = self.replenishment, replishment != 0, self.isNotificationsOn {
            target.replenishment = Int64(truncating: replishment)
            target.dateNotification = self.date
            
            NotificationHandler.sendNotification(target)
        } else {
            NotificationHandler.deleteNotification(by: target.unwrappedID.uuidString)
        }
        
        PersistenceController.save(context: viewContext)
        
        self.isNewTargetViewShow.toggle()
    }
    
    func updateTarget(_ target: TargetEntity) {
        target.name = self.newName
        target.price = Int64(truncating: self.price ?? 0)
        target.period = self.period.rawValue
        target.color = UIColor(self.color).encode()

        //add notification
        NotificationHandler.deleteNotification(by: target.unwrappedID.uuidString)
        
        if let replishment = self.replenishment, replishment != 0, self.isNotificationsOn {
            target.replenishment = Int64(truncating: replishment)
            target.dateNotification = self.date
            
            NotificationHandler.sendNotification(target)
        }
        
        Task {
            PersistenceController.save(context: viewContext)
        }
        
        self.isNewTargetViewShow.toggle()
    }
}

private struct NotificationView: View {
    
    @Binding var replishment: NSNumber?
    @Binding var period: Period
    @Binding var date: Date
    @Binding var isDatePickerShow: Bool
    @Binding var isNotificationsOn: Bool
    
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $isNotificationsOn) {
                    Text("not_on")
                }
            }
            
            if self.isNotificationsOn {
                Section {
                    FormatSumTextField(numberValue: $replishment, placeholder: NSLocalizedString("rep", comment: ""), numberFormatter: valueFormatter)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Picker(selection: $period) {
                        ForEach(Period.allCases, id: \.self) { period in
                            Button {
                                self.period = period
                            } label: {
                                if period == Period.never {
                                    Text(NSLocalizedString(period.rawValue, comment: ""))
                                } else {
                                    Text("\(NSLocalizedString("one_in", comment: "")) \(NSLocalizedString(period.rawValue, comment: ""))")
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            RectangleIcon(systemName: "arrow.triangle.2.circlepath", color: .gray)
                            
                            Text("repeat")
                        }
                    }
                    .currentPickerStyle()
                }
                
                Section {
                    Toggle(isOn: $isDatePickerShow) {
                        HStack(spacing: 10) {
                            RectangleIcon(systemName: "calendar", color: .red)
                            
                            Text("date")
                        }
                    }
                    
                    if self.isDatePickerShow {
                        DatePicker("", selection: $date)
                            .datePickerStyle(.graphical)
                    }
                }
            }
        }
        .navigationBarTitle(Text("reminders"), displayMode: .inline)
        ._safeAreaInsets(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
        .onChange(of: self.isNotificationsOn) { _ in
            NotificationHandler.requestPermission() { _ in }
        }
    }
}

#if DEBUG
struct NewTargetView_Previews: PreviewProvider {
    static var previews: some View {
        NewTargetView(isNewTargetViewShow: .constant(true), navSelection: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
#endif
