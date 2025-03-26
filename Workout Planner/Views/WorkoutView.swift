//
//  WorkoutView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 10/2/24.
//

import SwiftUI

final class WorkoutViewModel: ObservableObject {
    init(exercises: [Exercise] = []) {
        self.exercises = exercises
    }
    
    @Published var exercises: [Exercise]
}

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State var shouldShowDetailView: Bool = false
    @State private var selectedExercise: Exercise?
    
    var body: some View {
        List(viewModel.exercises) { exercise in
            Button {
                selectedExercise = exercise
                shouldShowDetailView = true
            } label: {
                exerciseRow(exercise)
            }
            .foregroundStyle(.primary)
            .sheet(isPresented: $shouldShowDetailView) {
                 if let selectedExercise = Binding($selectedExercise) {
                     NavigationStack {
                         ExerciseView(exercise: selectedExercise)
                     }
                 }
            }
        }
    }
    
    func exerciseRow(_ exercise: Exercise) -> some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.headline)
            ForEach(exercise.sets) { set in
                Text("\(set.displayWeight) lbs x \(set.displayReps) reps")
            }
        }
    }
}

#Preview {
    let viewModel = WorkoutViewModel(exercises: [
        Exercise(name: "Dumbbell Curls", description: "", sets: [
            Exercise.ExerciseSet(weight: 10, reps: 10),
            Exercise.ExerciseSet(weight: 20, reps: 10)
        ]),
        Exercise(name: "Hammer Curls", description: "", sets: [
            Exercise.ExerciseSet(weight: 10, reps: 10),
            Exercise.ExerciseSet(weight: 20, reps: 10)
        ]),
    ])
    
    NavigationStack {
        WorkoutView(viewModel: viewModel)
    }
}
