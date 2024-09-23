//
//  Exercise.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/22/24.
//

import Foundation
import SwiftUICore

struct Exercise {
    struct ExerciseSet: Identifiable {
        let id: UUID
        var weight: Double
        var reps: Double
        
        var displayWeight: String {
            displayNumber(for: weight)
        }
        
        var displayReps: String {
            displayNumber(for: reps)
        }
        
        func displayNumber(for number: Double) -> String {
            String(format: "%.2f", number)
        }
    }
    
    var name: String
    var description: String
    var image: Image?
    var sets: [ExerciseSet]
}
