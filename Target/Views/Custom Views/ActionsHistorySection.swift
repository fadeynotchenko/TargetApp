//
//  ActionsHistorySection.swift
//  Target
//
//  Created by Fadey Notchenko on 03.02.2023.
//

import SwiftUI

struct ActionsHistorySection: View {
    
    @ObservedObject var target: TargetEntity
    
    var body: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "folder.fill", color: .green)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                Text(NSLocalizedString("history", comment: ""))
                    .bold()
                    .font(.title3)
                
                Spacer()
                
                Text("(\(target.arrayOfActions.count))")
                    .foregroundColor(.gray)
            }
        }
    }
}
