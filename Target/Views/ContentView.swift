//
//  ContentView.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TargetEntity.dateStart, ascending: true)], animation: .default)
    private var targets: FetchedResults<TargetEntity>
    
    @State private var isNewTargetViewShow = false

    var body: some View {
        NavigationView {
            List {
                //archive button
                NavigationLink {
                    
                } label: {
                    ArchiveButtonLabel
                }
                .isDetailLink(false)
                
                ForEach(targets) { target in
                    Section {
                        NavigationLink {
                            TargetDetailView(target: target)
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
                NewTargetView(isNewTargetViewShow: $isNewTargetViewShow)
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
            
            Text("placholder")
        }
    }
    
    private var ArchiveButtonLabel: some View {
        HStack(spacing: 10) {
            RectangleIcon(systemName: "archivebox.fill", color: .accentColor)
            
            Text("\(NSLocalizedString("archive", comment: "")) (\(10))")
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
            
            CapsuleProgress(target: target)
            
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
