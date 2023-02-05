//
//  Utils.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import Foundation
import SwiftUI

enum Currency: String, CaseIterable {
    case rub = "₽"
    case usd = "$"
    case euro = "€"
}

enum Period: String, CaseIterable, Equatable {
    case never
    case day
    case week
    case month
}

enum Action: String, CaseIterable {
    case minus
    case plus
}

enum Tab: CaseIterable {
    case active
    case archive
}

var valueFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    
    return formatter
}

struct OnFirstAppear: ViewModifier {
    let perform: () -> Void

    @State private var firstTime = true
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if firstTime {
                    firstTime = false
                    
                    perform()
                }
            }
    }
}
