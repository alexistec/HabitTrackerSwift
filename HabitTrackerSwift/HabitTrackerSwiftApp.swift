//
//  HabitTrackerSwiftApp.swift
//  HabitTrackerSwift
//
//  Created by Alexis Quiñonez on 03/07/2025.
//

import SwiftUI

@main
struct HabitTrackerSwiftApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

