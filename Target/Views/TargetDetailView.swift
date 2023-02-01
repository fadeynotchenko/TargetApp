//
//  TargetDetailView.swift
//  Target
//
//  Created by Fadey Notchenko on 30.01.2023.
//

import SwiftUI
import CoreData

struct TargetDetailView: View {
    
    @ObservedObject var target: TargetEntity
    @Binding var navSelection: UUID?
    
    @State private var progress: CGFloat = 0
    
    @State private var action: Action = .minus
    
    @State private var dateNextNotification: Date?
    
    @State private var isEditTargetViewShow = false
    @State private var isFinishViewShow = false
    
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) private var scenePhase
    
    private var percent: Int {
        guard target.price != 0 else { return 0 }
        
        return min(Int(target.currentMoney * 100 / target.price), 100)
    }
    
    var body: some View {
        GeometryReader { reader in
            if navSelection == target.unwrappedID {
                Form {
                    ProgressSection
                    
                    NavigationLink {
                        ActionView(target: target)
                    } label: {
                        ActionViewSection
                    }
                    
                    TimeAgoSection
                    
                    NavigationLink {
                        ActionsHistory(target: target)
                    } label: {
                        ActionHistorySection
                    }
                    .disabled(target.arrayOfActions.isEmpty)
                    
                    if let dateNext = self.dateNextNotification {
                        NotificationSection(dateNext)
                    }
                }
                .navigationBarTitle(Text(target.unwrappedName), displayMode: .large)
                .sheet(isPresented: $isEditTargetViewShow) {
                    NewTargetView(editTarget: target, isNewTargetViewShow: $isEditTargetViewShow, navSelection: $navSelection)
                }
                .fullScreenCover(isPresented: $isFinishViewShow) {
                    FinishView(target: target, isFinishViewShow: $isFinishViewShow, navSelection: $navSelection)
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
                    
                    self.checkFinish(target.price, target.currentMoney)
                }
                .onChange(of: isEditTargetViewShow) { _ in
                    if self.isEditTargetViewShow == false {
                        self.getNotificationInfo()
                    }
                }
                .onChange(of: scenePhase) { scene in
                    self.getNotificationInfo()
                }
                .onChange(of: target.currentMoney) { current in
                    self.checkFinish(target.price, current)
                }
                .onChange(of: target.price) { price in
                    self.checkFinish(price, target.price)
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
                    Text("next_not")
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
            Task {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                
                self.isFinishViewShow.toggle()
            }
        }
    }
    
    private func getNotificationInfo() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            
            if let request = requests.filter({ $0.identifier == target.unwrappedID.uuidString }).first {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    let date = trigger.nextTriggerDate()
                    
                    self.dateNextNotification = date
                    
                    return
                }
            }
            
            self.target.replenishment = 0
            self.target.period = Period.never.rawValue
            self.target.dateNotification = nil
            
            PersistenceController.save(context: viewContext)
        }
    }
}

#if DEBUG
struct TargetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetEntity")
        let target = try! PersistenceController.preview.container.viewContext.fetch(req).first as! TargetEntity
        
        TargetDetailView(target: target, navSelection: .constant(target.unwrappedID))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext) 
    }
}
#endif
