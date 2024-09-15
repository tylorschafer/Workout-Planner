//
//  Item.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/15/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
