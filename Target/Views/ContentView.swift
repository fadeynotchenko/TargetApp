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
            ActiveTargetView()
        } else {
            TabView {
                ActiveTargetView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "target")
                    }
                
                ArchiveTargetsView()
                    .tag(1)
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
