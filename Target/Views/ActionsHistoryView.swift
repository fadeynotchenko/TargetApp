//
//  ActionsHistory.swift
//  Target
//
//  Created by Fadey Notchenko on 31.01.2023.
//

import SwiftUI

struct ActionsHistoryView: View {
    
    @ObservedObject var target: TargetEntity
    
    private var arrayOfDate: [Date] {
        let dates = target.arrayOfActions.map({ $0.unwrappedDate })
        let set = Set(dates)
        
        return set.sorted { $0 < $1 }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                ForEach(arrayOfDate, id: \.self) { date in
                    Section {
                        let arrayOfActions = target.arrayOfActions.filter({ $0.unwrappedDate == date })
                        
                        ForEach(Array(arrayOfActions.enumerated()), id: \.element) { i, action in
                            ActionRow(action)
                            
                            if i != arrayOfActions.count - 1 {
                                Divider()
                            }
                        }
                    } header: {
                        PinnedHeader(date)
                    }
                }
            }
        }
        .navigationBarTitle(Text("history"), displayMode: .inline)
    }
    
    private func PinnedHeader(_ date: Date) -> some View {
        Text(date, format: .dateTime.year().month().day())
            .bold()
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.ultraThickMaterial)
    }
    
    private func ActionRow(_ action: ActionEntity) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                RectangleIcon(systemName: action.unwrappedAction == Action.minus.rawValue ? "arrow.down" : "arrow.up", color: action.unwrappedAction == Action.minus.rawValue ? .red : .green)
                
                Text("\(action.value) \(self.target.unwrappedCurrency)")
                    .bold()
                    .font(.title3)
                
                Spacer()
            }
            
            if let comment = action.comment, !comment.isEmpty {
                Text(comment)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}
