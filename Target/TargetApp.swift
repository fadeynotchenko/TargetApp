//
//  TargetApp.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI

@main
struct TargetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
