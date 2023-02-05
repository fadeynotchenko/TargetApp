//
//  ArchiveTargetDetailView.swift
//  Target
//
//  Created by Fadey Notchenko on 03.02.2023.
//

import SwiftUI
import CoreData

struct ArchiveTargetDetailView: View {
    
    @ObservedObject var target: TargetEntity
    
    var body: some View {
        Form {
            PriceSection
            
            DateStartSection
            
            DateFinishSection
            
            NavigationLink {
                ActionsHistoryView(target: target)
            } label: {
                ActionsHistorySection(target: target)
            }
        }
        .navigationBarTitle(Text(target.unwrappedName), displayMode: .large)
    }
    
    private var PriceSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "sum", color: .accentColor)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("accumulated")
                        .foregroundColor(.gray)
                    
                    Text("\(target.price)")
                        .bold()
                        .font(.title3)
                }
            }
        }
    }
    
    private var DateStartSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "clock.fill", color: .blue)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("start")
                        .foregroundColor(.gray)
                    
                    Text(target.unwrappedDateStart, format: .dateTime.year().month().day())
                        .bold()
                        .font(.title3)
                }
            }
        }
    }
    
    private var DateFinishSection: some View {
        Section {
            HStack(spacing: 10) {
                RectangleIcon(systemName: "clock.fill", color: .red)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("finish")
                        .foregroundColor(.gray)
                    
                    if let dateFinish = target.dateFinish {
                        Text(dateFinish, format: .dateTime.year().month().day())
                            .bold()
                            .font(.title3)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ArchiveTargetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetEntity")
        let target = try! PersistenceController.preview.container.viewContext.fetch(req)[1] as! TargetEntity
        
        ArchiveTargetDetailView(target: target)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
