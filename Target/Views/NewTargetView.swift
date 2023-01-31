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
    
    @State private var newName = ""
    
    @State private var currency: Currency = .rub
    @State private var period: Period = .never
    
    @State private var price: NSNumber?
    @State private var currentMoney: NSNumber?
    @State private var replenishment: NSNumber?
    
    @State private var color: Color = .blue
    @State private var date = Date()
    
    @State private var isDatePickerShow = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var isSaveButtonDisabled: Bool {
        self.newName.isEmpty || self.price == nil || self.price == 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("target_name_hint", text: $newName)
                }
                
                CurrencyAndPriceSection
                
                NavigationLink {
                    NotificationView(replishment: $replenishment, period: $period, date: $date, isDatePickerShow: $isDatePickerShow)
                } label: {
                    NotificationViewLabel
                }
                
                Section {
                    ColorPicker("color_picker", selection: $color)
                }
                
                SaveButton
            }
            .navigationBarTitle(Text(self.editTarget == nil ? "new_target" : "edit"), displayMode: .inline)
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
                self.period = Period(rawValue: target.unwrappedPeriod) ?? .never
                self.price = (target.price) as NSNumber
                self.currentMoney = (target.currentMoney) as NSNumber
                self.replenishment = (target.replenishment) as NSNumber
                self.color = Color(uiColor: UIColor.color(withData: target.unwrappedColor))
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
            
            if self.editTarget == nil {
                FormatSumTextField(numberValue: $currentMoney, placeholder: NSLocalizedString("current", comment: ""), numberFormatter: valueFormatter)
            }
        }
    }
    
    private var NotificationViewLabel: some View {
        HStack(spacing: 10) {
            RectangleIcon(systemName: "bell.fill", color: .red)
            
            Text("reminders")
            
            Spacer()
            
            if self.period == Period.never {
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
                if editTarget == nil {
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
}

extension NewTargetView {
    private func saveNewTarget() {
        let target = TargetEntity(context: viewContext)
        
        target.id = UUID()
        target.dateStart = Date()
        target.name = self.newName
        target.price = Int64(truncating: self.price ?? 0)
        target.currentMoney = Int64(truncating: self.currentMoney ?? 0)
        target.currency = self.currency.rawValue
        target.period = self.period.rawValue
        target.color = UIColor(self.color).encode()

        //add notification
        if let replishment = self.replenishment, replishment != 0, self.isDatePickerShow {
            target.replenishment = Int64(truncating: replishment)
            
            NotificationHandler.sendNotification(target, dateStart: self.date)
        }
        
        PersistenceController.save(context: viewContext)
        
        self.isNewTargetViewShow.toggle()
    }
}

private struct NotificationView: View {
    
    @Binding var replishment: NSNumber?
    @Binding var period: Period
    @Binding var date: Date
    @Binding var isDatePickerShow: Bool
    
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        Form {
            Section {
                FormatSumTextField(numberValue: $replishment, placeholder: NSLocalizedString("rep", comment: ""), numberFormatter: valueFormatter)
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
                            .foregroundColor(scheme == .light ? .black : .white)
                    }
                }
                .currentPickerStyle()
                .foregroundColor(.gray)
            }
            
            Section {
                Toggle(isOn: $isDatePickerShow) {
                    HStack(spacing: 10) {
                        RectangleIcon(systemName: "calendar", color: .red) 
                        
                        Text("date")
                    }
                }
                
                if self.isDatePickerShow {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
            }
        }
        .navigationBarTitle(Text("reminders"), displayMode: .inline)
        .onAppear {
            NotificationHandler.requestPermission() { _ in }
        }
    }
}

#if DEBUG
struct Previews_NewTargetView_Previews: PreviewProvider {
    static var previews: some View {
        NewTargetView(isNewTargetViewShow: .constant(true))
    }
}
#endif
