//
//  ActionView.swift
//  Target
//
//  Created by Fadey Notchenko on 31.01.2023.
//

import SwiftUI
import AnyFormatKitSwiftUI

struct ActionView: View {
    
    @ObservedObject var target: TargetEntity
    
    @State private var actionSelection: Action = .minus
    
    @State private var actionValue: NSNumber?
    
    @State private var date = Date()
    @State private var isDatePickerShow = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    private var isSaveButtonDisabled: Bool {
        actionValue == nil || actionValue == 0
    }
    
    var body: some View {
        Form {
            SelectionSection
            
            ActionTFSection
            
            DateSection
            
            SaveSection
        }
        .navigationBarTitle(Text("Actions"), displayMode: .inline)
    }
    
    private var SelectionSection: some View {
        Section {
            Picker("", selection: $actionSelection) {
                ForEach(Action.allCases, id: \.self) { action in
                    Button(action.rawValue) {
                        self.actionSelection = action
                    }
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    private var ActionTFSection: some View {
        Section {
            switch self.actionSelection {
            case .plus:
                FormatSumTextField(numberValue: $actionValue, placeholder: NSLocalizedString("minus_tf", comment: ""), numberFormatter: valueFormatter)
            case .minus:
                FormatSumTextField(numberValue: $actionValue, placeholder: NSLocalizedString("plus_tf", comment: ""), numberFormatter: valueFormatter)
            }
        }
    }
    
    private var DateSection: some View {
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
    
    private var SaveSection: some View {
        Section {
            Button {
                save()
                
                dismiss()
            } label: {
                Text("save")
                    .bold()
                    .foregroundColor(isSaveButtonDisabled ? .gray : .accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

extension ActionView {
    func save() {
        let action = ActionEntity(context: viewContext)
        action.id = UUID()
        action.action = self.actionSelection.rawValue
        
        guard let actionValue = self.actionValue else { return }
        
        let value = Int64(truncating: actionValue)
        
        switch self.actionSelection {
        case .minus:
            action.value = -value
            
            self.target.currentMoney -= value
        case .plus:
            action.value = value
            
            self.target.currentMoney += value
        }
        
        self.target.addToActions(action)
        
        PersistenceController.save(context: viewContext)
    }
}
