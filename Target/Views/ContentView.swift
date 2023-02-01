//
//  ContentView.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        if Constants.isPhone {
            ActiveTargetsView()
        } else {
            TabView {
                ActiveTargetsView()
                    .tabItem {
                        Image(systemName: "target")
                    }
                
                ArchiveTargetsView()
                    .tabItem {
                        Image(systemName: "archivebox.fill")
                    }
            }
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
