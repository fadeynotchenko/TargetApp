//
//  TargetApp.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI

@main
struct TargetApp: App {
    
    @StateObject private var storeVM = StoreViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(storeVM)
        }
    }
}
