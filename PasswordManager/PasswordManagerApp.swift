//
//  PasswordManagerApp.swift
//  PasswordManager
//
//  Created by HariKrishna on 11/09/24.
//

import SwiftUI
import CoreData

@main
struct PasswordManagerApp: App {
    
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
        }
    }
}
