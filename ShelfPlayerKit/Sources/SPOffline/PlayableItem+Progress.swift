//
//  File.swift
//
//
//  Created by Rasmus Krämer on 14.01.24.
//

import Foundation
import SwiftUI
import SPFoundation
import SPNetwork

public extension PlayableItem {
    func finished(_ finished: Bool) async throws {
        let success: Bool
        
        do {
            try await AudiobookshelfClient.shared.finished(finished, itemId: identifiers.itemID, episodeId: identifiers.episodeID)
            success = true
        } catch {
            success = false
        }
        
        OfflineManager.shared.finished(finished, item: self, synced: success)
    }
    
    func resetProgress() async throws {
        try await AudiobookshelfClient.shared.deleteProgress(itemId: identifiers.itemID, episodeId: identifiers.episodeID)
        try OfflineManager.shared.resetProgressEntity(itemID: identifiers.itemID, episodeID: identifiers.episodeID)
    }
}
