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

struct TargetWidgetEntity: Codable {
    let id: String
    let name: String
    let price: Int64
    let current: Int64
    let color: Data
    let currency: String
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

func toData(_ array: [TargetWidgetEntity]) -> Data? {
    do {
        let data = try JSONEncoder().encode(array)
        
        return data
    } catch {
        print("Unable to Encode Note (\(error))")
        
        return nil
    }
}

func toData(_ target: TargetWidgetEntity) -> Data? {
    do {
        let data = try JSONEncoder().encode(target)
        
        return data
    } catch {
        print("Unable to Encode Note (\(error))")
        
        return nil
    }
}

func arrayOfTargetWidgetsFromData(data: Data) -> [TargetWidgetEntity]? {
    do {
        let arr = try JSONDecoder().decode([TargetWidgetEntity].self, from: data)
        
        return arr
    } catch {
        print("Unable to Encode Note (\(error))")
        
        return nil
    }
}

func targetWidgetFromData(data: Data) -> TargetWidgetEntity? {
    do {
        let target = try JSONDecoder().decode(TargetWidgetEntity.self, from: data)
        
        return target
    } catch {
        print("Unable to Encode Note (\(error))")
        
        return nil
    }
}
