//
//  CreatedTargetSection.swift
//  Target
//
//  Created by Fadey Notchenko on 02.02.2023.
//

import SwiftUI

struct CreatedTargetSection: View {
    
    @ObservedObject var target: TargetEntity
    
    var body: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "clock.fill", color: .gray)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("created")
                        .foregroundColor(.gray)
                    
                    Text(target.unwrappedDateStart.timeAgoDisplay())
                        .bold()
                        .font(.title3)
                }
            }
        }
    }
}

