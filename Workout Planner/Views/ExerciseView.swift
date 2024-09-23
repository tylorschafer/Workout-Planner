//
//  ExerciseView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/15/24.
//

import SwiftUI

final class ExerciseViewModel: ObservableObject {
    @Published var exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
}

struct ExerciseView: View {
    @State var viewModel: ExerciseViewModel
    
    @State private var showEditView: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Label(viewModel.exercise.name, systemImage: "dumbbell")
            Text(viewModel.exercise.description)
            
            if let image = viewModel.exercise.image {
                image
            }
            
            if !viewModel.exercise.sets.isEmpty {
                List(viewModel.exercise.sets) { set in
                    setView(set)
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(viewModel.exercise.name))
        .navigationBarItems(trailing: editButton)
        .sheet(isPresented: $showEditView) {
            EditExerciseView(exercise: $viewModel.exercise)
        }
    }
    
    private var editButton: some View {
        Button(action: { showEditView = true }) {
            Image(systemName: "pencil")
        }
    }
    
    private func setView(_ set: Exercise.ExerciseSet) -> some View {
        Text("\(set.displayWeight) lbs x \(set.displayReps) reps")
    }
}

#Preview {
    let sets = [
        Exercise.ExerciseSet.init(id: .init(), weight: 20, reps: 20),
        Exercise.ExerciseSet.init(id: .init(), weight: 20, reps: 20),
        Exercise.ExerciseSet.init(id: .init(), weight: 20, reps: 20)
    ]
    let viewModel: ExerciseViewModel = .init(exercise: Exercise(name: "Example Exercise", description: "This is just an example exercise. Real exercises will have detailed descriptions and images.", image: nil, sets: sets))
    
    NavigationStack {
        ExerciseView(viewModel: viewModel)
    }
}
