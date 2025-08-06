//
//  Persistence.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 8/6/25.
//

import Foundation
import SwiftData

func loadModelContainer() -> ModelContainer {
    do {
        return try ModelContainer(for: MovieModel.self)
    } catch {
        print("Initial SwiftData load failed: \(error)")
        
        // Delete and retry once
        deleteSwiftDataStoreIfNeeded()
        do {
            return try ModelContainer(for: MovieModel.self)
        } catch {
            fatalError("❌ Still couldn't load SwiftData container: \(error)")
        }
    }
}

func deleteSwiftDataStoreIfNeeded() {
    let fileManager = FileManager.default
    let supportURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(
        .applicationSupportDirectory, .userDomainMask, true).first!)

    let storeURL = supportURL.appendingPathComponent("MovieLibraryBrowser") // This should match your bundle/app name

    if fileManager.fileExists(atPath: storeURL.path) {
        do {
            try fileManager.removeItem(at: storeURL)
            print("🧨 Deleted old SwiftData store at: \(storeURL.path)")
        } catch {
            print("⚠️ Failed to delete SwiftData store: \(error)")
        }
    }
    
    if let contents = try? fileManager.contentsOfDirectory(atPath: supportURL.path) {
        for path in contents {
            let fullPath = supportURL.appendingPathComponent(path)
            try? fileManager.removeItem(at: fullPath)
            print("🧨 Deleted: \(fullPath)")
        }
    }

}
