//
//  MovieLibraryBrowserApp.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/2/25.
//

import SwiftUI
import SwiftData

@main
struct MovieLibraryBrowserApp: App {
    let container: ModelContainer

    init() {
        // Delete corrupted store in debug
        #if DEBUG
        deleteSwiftDataStoreIfNeeded()
        #endif
        self.container = loadModelContainer()
    }
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            MovieModel.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            let container = try ModelContainer(for: MovieModel.self)
//            
//            print("✅ ModelContainer created: \(container)")
//            return container
//        } catch {
//            print("❌ SwiftData container failed: \(error)")
//            fatalError()
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
