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
    @State private var isProVersionViewShow = false
    
    @State private var navSelection: UUID?
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var storeVM: StoreViewModel
    
    var body: some View {
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
                            ActiveTargetDetailView(target: target, navSelection: $navSelection)
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
            .sheet(isPresented: $isProVersionViewShow) {
                ProVersionView(isProVersionViewShow: $isProVersionViewShow)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        if targets.filter({ $0.dateFinish == nil }).count >= 1 && storeVM.purchased.isEmpty {
                            self.isProVersionViewShow.toggle()
                        } else {
                            self.isNewTargetViewShow.toggle()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("PRO") {
                        self.isProVersionViewShow.toggle()
                    }
                }
            }
            
            if self.targets.isEmpty {
                Text("empty")
            }
        }
    }
    
    private var ArchiveButtonLabel: some View {
        HStack(spacing: 10) {
            RectangleIcon(systemName: "archivebox.fill", color: .accentColor)
            
            Text(NSLocalizedString("archive", comment: ""))
                .bold()
                .font(.title3)
            
            Spacer()
            
            Text("(\(targets.filter({ $0.dateFinish != nil}).count))")
                .foregroundColor(.gray)
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
            
            Text("\(target.currentMoney) / \(target.price) \(target.unwrappedCurrency)")
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
