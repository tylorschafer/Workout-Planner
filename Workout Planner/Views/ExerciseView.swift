//
//  ExerciseView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/15/24.
//

import SwiftUI

struct ExerciseViewModel {
    struct ExerciseSet: Identifiable {
        let id: UUID
        let weight: Double
        let reps: Int
        
        var weightDisplay: String {
            String(format: "%.2f", weight)
        }
    }
    
    let name: String
    let description: String?
    let image: Image?
    let sets: [ExerciseSet]
}

struct ExerciseView: View {
    let viewModel: ExerciseViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Label(viewModel.name, systemImage: "dumbbell")
            if let description = viewModel.description {
                Text(description)
            }
            
            if !viewModel.sets.isEmpty {
                List(viewModel.sets) { set in
                    setView(set)
                }
            }
            Spacer()
        }
    }
    
    private func setView(_ set: ExerciseViewModel.ExerciseSet) -> some View {
        Text("\(set.weightDisplay) lbs x \(set.reps) reps")
    }
}

#Preview {
    let sets = [
        ExerciseViewModel.ExerciseSet.init(id: .init(), weight: 20, reps: 20),
        ExerciseViewModel.ExerciseSet.init(id: .init(), weight: 20, reps: 20),
        ExerciseViewModel.ExerciseSet.init(id: .init(), weight: 20, reps: 20)
    ]
    let viewModel: ExerciseViewModel = .init(name: "Example Exercise", description: "This is just an example exercise. Real exercises will have detailed descriptions and images.", image: nil, sets: sets)
    
    ExerciseView(viewModel: viewModel)
}
