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
    
    @State private var comment = ""
    
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
                .onChange(of: self.actionValue) { _ in
                    calculateMax()
                }
                .onChange(of: self.actionSelection) { _ in
                    calculateMax()
                }
            
            CommentSection
            
            DateSection
            
            SaveSection
        }
        .navigationBarTitle(Text("actions"), displayMode: .inline)
        ._safeAreaInsets(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
    }
    
    private var SelectionSection: some View {
        Section {
            Picker("", selection: $actionSelection) {
                ForEach(Action.allCases, id: \.self) { action in
                    Button(NSLocalizedString(action.rawValue, comment: "")) {
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
            case .minus:
                FormatSumTextField(numberValue: $actionValue, placeholder: NSLocalizedString("minus_tf", comment: ""), numberFormatter: valueFormatter)
                    .keyboardType(.numberPad)
            case .plus:
                FormatSumTextField(numberValue: $actionValue, placeholder: NSLocalizedString("plus_tf", comment: ""), numberFormatter: valueFormatter)
                    .keyboardType(.numberPad)
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
    
    private var CommentSection: some View {
        Section {
            TextField("comment", text: $comment)
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
    func calculateMax() {
        switch self.actionSelection {
        case .minus:
            if Int64(truncating: self.actionValue ?? 0) > self.target.currentMoney {
                self.actionValue = (self.target.currentMoney) as NSNumber
            }
            
        case .plus:
            let delta = self.target.price - self.target.currentMoney
            
            if Int64(truncating: self.actionValue ?? 0) > delta {
                self.actionValue = delta as NSNumber
            }
        }
    }
    
    func save() {
        guard let actionValue = self.actionValue else { return }
        
        let action = ActionEntity(context: viewContext)
        
        action.id = UUID()
        action.action = self.actionSelection.rawValue
        action.comment = self.comment
        action.date = self.date.stripTime()
        
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
