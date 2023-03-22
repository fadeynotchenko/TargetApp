//
//  ArchiveTargetsView.swift
//  Target
//
//  Created by Fadey Notchenko on 31.01.2023.
//

import SwiftUI

struct ArchiveTargetsView: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TargetEntity.dateStart, ascending: true)], animation: .default)
    private var targets: FetchedResults<TargetEntity>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            List {
                ForEach(targets.filter({ $0.dateFinish != nil })) { target in
                    Section {
                        NavigationLink {
                            ArchiveTargetDetailView(target: target)
                        } label: {
                            ArchiveTargetRow(target)
                                .swipeActions {
                                    DeleteButton(target)
                                }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            
            if targets.filter({ $0.dateFinish != nil }).isEmpty {
                Text("archive_empty")
                    .multilineTextAlignment(.center)
            }
        }
        .navigationTitle(Text("archive"))
    }
    
    private func ArchiveTargetRow(_ target: TargetEntity) -> some View {
        Section {
            HStack {
                RectangleIcon(systemName: "target", color: Color(UIColor.color(withData: target.unwrappedColor)))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(target.unwrappedName)
                        .bold()
                        .font(.title3)
                        .lineLimit(1)
                    
                    Text("\(target.price) \(target.unwrappedCurrency)")
                        .bold()
                }
            }
            .padding(.vertical)
        }
    }
    
    private func DeleteButton(_ target: TargetEntity) -> some View {
        Button(role: .destructive) {
            withAnimation {
                PersistenceController.deleteTarget(target, context: viewContext)
            }
        } label: {
            Image(systemName: "trash")
        }
    }
}

#if DEBUG
struct ArchiveTargetsView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveTargetsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
