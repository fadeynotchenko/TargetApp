//
//  NewTargetView.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI
import AnyFormatKitSwiftUI

struct NewTargetView: View {
    
    let isEditMode: Bool
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
        self.newName.isEmpty || self.price == nil
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
            .navigationBarTitle(Text(self.isEditMode ? "edit" : "new_target"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("close") {
                        self.isNewTargetViewShow.toggle()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var CurrencyAndPriceSection: some View {
        Section {
            if !self.isEditMode {
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
            
            if !self.isEditMode {
                FormatSumTextField(numberValue: $currentMoney, placeholder: NSLocalizedString("current", comment: ""), numberFormatter: valueFormatter)
            }
        }
    }
    
    private var NotificationViewLabel: some View {
        HStack(spacing: 5) {
            RectangleIcon(systemName: "bell.fill", color: .red)
                .frame(width: 30, height: 30)
            
            Text("Reminders")
            
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
                if !self.isEditMode {
                    saveNewTarget()
                }
            } label: {
                Text(self.isEditMode ? "save" : "add")
                    .bold()
                    .foregroundColor(isSaveButtonDisabled ? .gray : .blue)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .disabled(isSaveButtonDisabled)
        }
    }
}

extension NewTargetView {
    private func saveNewTarget() {
        let target = Target(context: viewContext)
        
        target.id = UUID()
        target.dateStart = Date()
        target.name = self.newName
        target.price = Int64(truncating: self.price ?? 0)
        target.currentMoney = Int64(truncating: self.currentMoney ?? 0)
        target.currency = self.currency.rawValue
        target.period = self.period.rawValue
        target.color = UIColor(self.color).encode()

        //add notification
        if let replishment = self.replenishment, self.isDatePickerShow {
            target.replenishment = replishment
            
            NotificationHandler.sendNotification(target, dateStart: self.date)
        } else {
            
        }
        
        PersistenceController.save(context: viewContext)
    }
}

private struct NotificationView: View {
    
    @Binding var replishment: NSNumber?
    @Binding var period: Period
    @Binding var date: Date
    @Binding var isDatePickerShow: Bool
    
    var body: some View {
        Form {
            Section {
                FormatSumTextField(numberValue: $replishment, placeholder: NSLocalizedString("rep", comment: ""), numberFormatter: valueFormatter)
            }
            
            Section {
                Picker("repeat", selection: $period) {
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
                }
                .pickerStyle(.inline)
            }
            
            Section {
                Toggle(isOn: $isDatePickerShow) {
                    HStack(spacing: 5) {
                        RectangleIcon(systemName: "calendar", color: .red)
                            .frame(width: 30, height: 30)
                        
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
    }
}

#if DEBUG
struct Previews_NewTargetView_Previews: PreviewProvider {
    static var previews: some View {
        NewTargetView(isEditMode: false, isNewTargetViewShow: .constant(true))
    }
}
#endif
