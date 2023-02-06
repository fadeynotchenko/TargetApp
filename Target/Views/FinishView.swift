//
//  FinishView.swift
//  Target
//
//  Created by Fadey Notchenko on 01.02.2023.
//

import SwiftUI
import CoreData
import StoreKit

struct FinishView: View {
    
    @ObservedObject var target: TargetEntity
    @Binding var isFinishViewShow: Bool
    @Binding var navSelection: UUID?
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { reader in
            NavigationView {
                ZStack {
                    if colorScheme == .light {
                        Color(uiColor: .secondarySystemBackground).edgesIgnoringSafeArea(.all)
                    } else {
                        Color.black
                    }
                    
                    Form {
                        TopViewSection
                        
                        PriceSection
                        
                        CreatedTargetSection(target: target)
                        
                        SaveButtonSection
                    }
                    .frame(maxWidth: 600)
                }
                .onAppear {
                    if let windowScene = UIApplication.shared.windows.first?.windowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }
    
    private var TopViewSection: some View {
        Section {
            VStack(spacing: 5) {
                Text("finish1")
                    .bold()
                    .font(.title)
                
                Text("finish2")
                    .bold()
                    .foregroundColor(.gray)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                Text("'\(target.unwrappedName)'")
                    .bold()
                    .font(.title)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .listRowBackground(Color.clear)
    }
    
    private var PriceSection: some View {
        HStack(spacing: 10) {
            RectangleIcon(systemName: "sum", color: .accentColor)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("accumulated")
                    .foregroundColor(.gray)
                
                Text("\(target.price) \(target.unwrappedCurrency)")
                    .bold()
                    .font(.title3)
            }
        }
    }
    
    private var SaveButtonSection: some View {
        Section {
            Button {
                self.target.dateFinish = Date()
                
                PersistenceController.save(context: viewContext)
                
                self.isFinishViewShow.toggle()
                self.navSelection = nil
            } label: {
                Text("save")
                    .bold()
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        } footer: {
            Text("finish_hint")
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }
    }
}

extension FinishView {
    private func getSpacerLenght(_ height: CGFloat) -> CGFloat {
        if Constants.isPhone {
            return height / 3
        }
        
        return height / 2
    }
}

#if DEBUG
struct FinishView_Previews: PreviewProvider {
    static var previews: some View {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetEntity")
        let target = try! PersistenceController.preview.container.viewContext.fetch(req).first as! TargetEntity
        
        FinishView(target: target, isFinishViewShow: .constant(false), navSelection: .constant(nil))
    }
}
#endif
