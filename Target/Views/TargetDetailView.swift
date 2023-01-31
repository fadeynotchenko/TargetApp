//
//  TargetDetailView.swift
//  Target
//
//  Created by Fadey Notchenko on 30.01.2023.
//

import SwiftUI

struct TargetDetailView: View {
    
    @ObservedObject var target: TargetEntity
    
    @State private var isEditTargetViewShow = false
    
    @State private var progress: CGFloat = 0
    
    @State private var action: Action = .minus
    
    @Environment(\.colorScheme) private var scheme
    
    private var percent: Int {
        guard target.price != 0 else { return 0 }
        
        return min(Int(target.currentMoney * 100 / target.price), 100)
    }
    
    var body: some View {
        Form {
            ProgressSection
            
            NavigationLink {
                ActionView(target: self.target)
            } label: {
                ActionViewSection
            }
            
            TimeAgoSection
            
            NavigationLink {
                
            } label: {
                ActionHistorySection
            }
        }
        .navigationBarTitle(Text(target.unwrappedName), displayMode: .large)
        .frame(maxWidth: Constants.isPhone ? .infinity : 450)
        .sheet(isPresented: $isEditTargetViewShow) {
            NewTargetView(editTarget: self.target, isNewTargetViewShow: $isEditTargetViewShow)
        }
        .toolbar {
            ToolbarItem {
                Button("edit") {
                    self.isEditTargetViewShow.toggle()
                }
            }
        }
    }
    
    private var ProgressSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "sum", color: .accentColor)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Progress:")
                        .foregroundColor(.gray)
                    
                    Text("\(target.currentMoney) / \(target.price) \(target.unwrappedCurrency)")
                        .bold()
                        .font(.title3)
                    
                    CapsuleProgress(target: self.target)
                }
            }
        }
    }
    
    
    private var ActionViewSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "plus.forwardslash.minus", color: .blue)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Left:")
                        .foregroundColor(.gray)
                    
                    Text("\(target.price - target.currentMoney) \(target.unwrappedCurrency)")
                        .bold()
                        .font(.title3)
                }
                
                Spacer()
                
                Text("Actions")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var TimeAgoSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "clock.fill", color: .gray)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Ago:")
                        .foregroundColor(.gray)
                    
                    Text(target.unwrappedDateStart.timeAgoDisplay())
                        .bold()
                        .font(.title3)
                }
            }
        }
    }
    
    private var ActionHistorySection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "folder.fill", color: .green)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                Text("Action history (\(self.target.arrayOfActions.count))")
                    .bold()
                    .font(.title3)
            }
        }
    }
}

extension TargetDetailView {
    private func calculateProgress(_ price: Int64, _ current: Int64) {
        guard price != 0 else { return }
        
        withAnimation(.easeInOut(duration: 2.0)) {
            progress = CGFloat(current * 100 / price) / 100
        }
        
        checkFinish(price, current)
    }
    
    private func checkFinish(_ price: Int64, _ current: Int64) {
        if current >= price {
            
        }
    }
}

#if DEBUG
struct TargetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
