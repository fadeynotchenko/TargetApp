//
//  RectangleIcon.swift
//  Target
//
//  Created by Fadey Notchenko on 30.01.2023.
//

import SwiftUI

struct RectangleIcon: View {
    
    let systemName: String
    let color: Color
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .padding(5)
            .background(color)
            .cornerRadius(7)
    }
}

