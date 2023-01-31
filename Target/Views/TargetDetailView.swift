//
//  TargetDetailView.swift
//  Target
//
//  Created by Fadey Notchenko on 30.01.2023.
//

import SwiftUI

struct TargetDetailView: View {
    
    @ObservedObject var target: TargetEntity
    @Binding var isNavLinkActive: Bool
    
    @State private var isEditTargetViewShow = false
    
    @State private var progress: CGFloat = 0
    
    @State private var action: Action = .minus
    
    @State private var dateNextNotification: Date?
    
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss
    
    private var percent: Int {
        guard target.price != 0 else { return 0 }
        
        return min(Int(target.currentMoney * 100 / target.price), 100)
    }
    
    var body: some View {
        GeometryReader { reader in
            if !isNavLinkActive {
                Form {
                    ProgressSection
                    
                    NavigationLink {
                        ActionView(target: self.target)
                    } label: {
                        ActionViewSection
                    }
                    
                    TimeAgoSection
                    
                    NavigationLink {
                        ActionsHistory(target: self.target)
                    } label: {
                        ActionHistorySection
                    }
                    
                    if let dateNext = self.dateNextNotification {
                        NotificationSection(dateNext)
                    }
                }
                .navigationBarTitle(Text(target.unwrappedName), displayMode: .large)
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
                .onAppear {
                    self.getNotificationInfo()
                }
            } else {
                Text("placeholder")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .navigationBarTitle(Text(""))
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
                    Text("progress")
                        .foregroundColor(.gray)
                    
                    Text("\(target.currentMoney) / \(target.price) \(target.unwrappedCurrency)")
                        .bold()
                        .font(.title3)
                    
                    GeometryReader { reader in
                        CapsuleProgress(target: self.target, width: min(reader.size.width / 1.5, 180))
                    }
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
                    Text("left")
                        .foregroundColor(.gray)
                    
                    Text("\(target.price - target.currentMoney) \(target.unwrappedCurrency)")
                        .bold()
                        .font(.title3)
                }
                
                Spacer()
                
                Text("actions")
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
                    Text("created")
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
                
                Text("\(NSLocalizedString("history", comment: "")) (\(self.target.arrayOfActions.count))")
                    .bold()
                    .font(.title3)
            }
        }
    }
    
    private func NotificationSection(_ dateNext: Date) -> some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "bell.badge.fill", color: .red)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Next notification:")
                        .foregroundColor(.gray)
                    
                    Text(dateNext, format: .dateTime.year().month().day().hour().minute())
                        .bold()
                        .font(.title3)
                }
            }
        }
    }
}

extension TargetDetailView {
    private func checkFinish(_ price: Int64, _ current: Int64) {
        if current >= price {
            
        }
    }
    
    private func getNotificationInfo() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            guard let request = requests.filter({ $0.identifier == target.unwrappedID.uuidString }).first else { return }
            
            guard let trigger = request.trigger as? UNCalendarNotificationTrigger else { return }
            
            guard let date = trigger.nextTriggerDate() else { return }
            
            self.dateNextNotification = date
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
