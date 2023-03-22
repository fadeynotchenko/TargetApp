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
                
                Text("pro1")
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
                
                Text("noads")
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
                
                Text("nolimit")
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
                    let isPurchased = await self.storeVM.purchase()
                    
                    self.isProVersionViewShow = !isPurchased
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
            .disabled(!storeVM.purchased.isEmpty)
            .frame(maxWidth: .infinity, alignment: .center)
        } footer: {
            Button("restore") {
                Task {
                    let isRestored = await self.storeVM.restore()
                    
                    self.isProVersionViewShow = !isRestored
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
        }
    }
}

#if DEBUG
struct ProVersionView_Previews: PreviewProvider {
    static var previews: some View {
        ProVersionView(isProVersionViewShow: .constant(true))
            .environmentObject(StoreViewModel())
    }
}
#endif
