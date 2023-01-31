//
//  CapsuleProgressView.swift
//  Target
//
//  Created by Fadey Notchenko on 31.01.2023.
//

import SwiftUI

struct CapsuleProgress: View {
    @ObservedObject var target: TargetEntity
    
    //with animation
    @State private var percent: CGFloat = 0
    //without animation
    @State private var percentInt: Int = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            ZStack(alignment: .trailing) {
                HStack {
                    Capsule()
                        .fill(.gray.opacity(0.2))
                        .frame(width: 180, height: 12)
                    
                    Text("(\(Int(percentInt)) %)")
                        .foregroundColor(.gray)
                        .bold()
                }
            }
            
            Capsule()
                .fill(Color(UIColor.color(withData: target.unwrappedColor)))
                .frame(width: percent / 100 * 180, height: 12)
        }
        .onAppear {
            calculatePercent(price: target.price, current: target.currentMoney)
        }
        .onChange(of: target.currentMoney) { new in
            calculatePercent(price: target.price, current: new)
        }
        .onChange(of: target.price) { new in
            calculatePercent(price: new, current: target.currentMoney)
        }
    }
    
    private func calculatePercent(price: Int64, current: Int64) {
        guard price != 0 else { return }
        
        percentInt = Int(min(current * 100 / price, 100))
        
        withAnimation(.easeInOut(duration: 2.0)) {
            percent = min(CGFloat(current * 100 / price), 100.0)
        }
    }
}
