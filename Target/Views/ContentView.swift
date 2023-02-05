//
//  ContentView.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var selection: Tab = .active
    
    var body: some View {
        NavigationView {
            if Constants.isPhone {
                ActiveTargetsView()
                
                Text("placeholder")
            } else {
                VStack {
                    switch selection {
                    case .active:
                        ActiveTargetsView()
                    case .archive:
                        ArchiveTargetsView()
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 40) {
                        Button {
                            self.selection = .active
                        } label: {
                            Image(systemName: "target")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(selection == .active ? .accentColor : .gray)
                                .frame(width: 25, height: 25)
                        }
                        
                        Button {
                            self.selection = .archive
                        } label: {
                            Image(systemName: "archivebox.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(selection == .archive ? .accentColor : .gray)
                                .frame(width: 25, height: 25)
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.ultraThickMaterial)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .setCurrentNavigationViewStyle()
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
