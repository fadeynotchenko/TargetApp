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
        GeometryReader { reader in
            ZStack {
                Image(systemName: self.systemName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
            }
            .padding(5)
            .background(self.color)
            .frame(width: reader.size.width, height: reader.size.height)
            .cornerRadius(7)
        }
    }
}

#if DEBUG
struct RectangleIcon_Previews: PreviewProvider {
    static var previews: some View {
        RectangleIcon(systemName: "plus", color: .blue)
            .previewLayout(.sizeThatFits)
    }
}
#endif
