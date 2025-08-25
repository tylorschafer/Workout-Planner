//
//  Exercise.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/22/24.
//

import Foundation
import SwiftUI

struct Exercise: Identifiable, Hashable {
    struct ExerciseSet: Identifiable, Hashable {
        let id: UUID = UUID()
        var weight: Double
        var reps: Double
        var isCompleted: Bool = false
        
        var displayWeight: String {
            displayNumber(for: weight)
        }
        
        var displayReps: String {
            displayNumber(for: reps)
        }
        
        func displayNumber(for number: Double) -> String {
            if number.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", number)
            } else {
                return String(format: "%.1f", number)
            }
        }
    }
    let id: UUID = UUID()
    var name: String
    var description: String
    var imageName: String?
    var sets: [ExerciseSet]
    
    // Computed property for the image
    var image: Image? {
        guard let imageName = imageName else { return nil }
        return Image(imageName)
    }
    
    // Custom hash function that excludes the image
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(imageName)
        hasher.combine(sets)
    }
    
    // Custom equality that excludes the computed image property
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.description == rhs.description &&
               lhs.imageName == rhs.imageName &&
               lhs.sets == rhs.sets
    }
}
