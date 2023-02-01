//
//  ActiveTargetsView.swift
//  Target
//
//  Created by Fadey Notchenko on 31.01.2023.
//

import SwiftUI
import CoreData

struct ActiveTargetsView: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TargetEntity.dateStart, ascending: true)], animation: .default)
    private var targets: FetchedResults<TargetEntity>
    
    @State private var isNewTargetViewShow = false
    
    @State private var navSelection: UUID?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if Constants.isPhone {
                        NavigationLink {
                            ArchiveTargetsView()
                        } label: {
                            ArchiveButtonLabel
                        }
                        .isDetailLink(false)
                    }
                    
                    ForEach(targets.filter({ $0.dateFinish == nil })) { target in
                        Section {
                            NavigationLink(tag: target.unwrappedID, selection: $navSelection) {
                                TargetDetailView(target: target, navSelection: $navSelection)
                            } label: {
                                TargetRow(target)
                            }
                            .swipeActions {
                                DeleteSwipeActionButton(target)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle(Text("app_name"))
                .sheet(isPresented: $isNewTargetViewShow) {
                    NewTargetView(isNewTargetViewShow: $isNewTargetViewShow, navSelection: $navSelection)
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            self.isNewTargetViewShow.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                if self.targets.isEmpty {
                    Text("empty")
                }
            }
            
            Text("placholder")
        }
        .setCurrentNavigationViewStyle()
    }
    
    private var ArchiveButtonLabel: some View {
        HStack(spacing: 10) {
            RectangleIcon(systemName: "archivebox.fill", color: .accentColor)
            
            Text("\(NSLocalizedString("archive", comment: "")) (\(targets.filter({ $0.dateFinish != nil}).count))")
                .bold()
                .font(.title3)
        }
        .padding(.vertical, 5)
    }
    
    private func TargetRow(_ target: TargetEntity) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(target.unwrappedName)
                .bold()
                .font(.title3)
                .lineLimit(1)
            
            GeometryReader { reader in
                CapsuleProgress(target: target, width: min(reader.size.width / 1.5, 180))
            }
            
            Text("\(target.currentMoney) / \(target.price)")
                .bold()
                .lineLimit(1)
            
        }
        .padding(.vertical)
    }
    
    private func DeleteSwipeActionButton(_ target: TargetEntity) -> some View {
        Button(role: .destructive) {
            withAnimation {
                viewContext.delete(target)
                
                PersistenceController.save(context: viewContext)
            }
        } label: {
            Image(systemName: "trash")
        }
    }
}

#if DEBUG
struct ActiveTargetView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTargetsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
