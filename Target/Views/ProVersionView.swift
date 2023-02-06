//
//  ProVersionView.swift
//  Target
//
//  Created by Fadey Notchenko on 06.02.2023.
//

import SwiftUI

struct ProVersionView: View {
    
    @Binding var isProVersionViewShow: Bool
    
    @EnvironmentObject private var storeVM: StoreViewModel
    
    var body: some View {
        NavigationView {
            Form {
                TopViewSection
                
                NoAdsSection
                
                NoLimitSection
                
                BuySection
            }
            .navigationTitle(Text("pro_title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("close") {
                        self.isProVersionViewShow.toggle()
                    }
                }
            }
        }
    }
    
    private var TopViewSection: some View {
        Section {
            VStack(spacing: 10) {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .frame(width: 150, height: 150)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Покупая PRO Версию приложения Вы получаете: ")
                    .bold()
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
        }
        .listRowBackground(Color.clear)
    }
    
    private var NoAdsSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "eye.slash.fill", color: .accentColor)
                
                Text(NSLocalizedString("noads", comment: ""))
                    .bold()
                    .font(.title3)
            }
            .padding(.vertical, 5)
        }
    }
    
    private var NoLimitSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "list.bullet", color: .purple)
                
                Text(NSLocalizedString("nolimit", comment: ""))
                    .bold()
                    .font(.title3)
            }
            .padding(.vertical, 5)
        }
    }
    
    private var BuySection: some View {
        Section {
            Button {
                Task {
                    await self.storeVM.purchase()
                }
            } label: {
                if let product = storeVM.products.first, storeVM.purchased.isEmpty {
                    Text("\(product.displayPrice) / \(NSLocalizedString("forever", comment: ""))")
                        .bold()
                        .foregroundColor(.accentColor)
                } else {
                    Text("purchased")
                        .bold()
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        } footer: {
            Text("buy_hint")
        }
    }
}

struct ProVersionView_Previews: PreviewProvider {
    static var previews: some View {
        ProVersionView(isProVersionViewShow: .constant(true))
            .environmentObject(StoreViewModel())
    }
}
