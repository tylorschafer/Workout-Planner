//
//  EditExerciseView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/22/24.
//

import SwiftUI


struct EditExerciseView: View {
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    @Binding var exercise: Exercise

    var body: some View {
        Form {
            Section(header: Text("Edit Exercise")) {
                TextField("Name", text: $exercise.name)
                TextField("Description", text: $exercise.description)
            }
            Section(header: Text("Sets and Reps")) {
                ForEach(Array($exercise.sets.enumerated()), id: \.offset) { index, set in
                    Text("Set #\(index + 1)")
                        .bold()
                    
                    HStack {
                        Text("Weight")
                        TextField("Value", value: set.weight, formatter: formatter)
                            .keyboardType(.numberPad)
                            .foregroundStyle(.blue)
                    }
                    HStack {
                        Text("Reps")
                        TextField("Value", value: set.reps, formatter: formatter)
                            .keyboardType(.numberPad)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    let sets = [
        Exercise.ExerciseSet.init(id: .init(), weight: 20, reps: 20),
        Exercise.ExerciseSet.init(id: .init(), weight: 20, reps: 20),
        Exercise.ExerciseSet.init(id: .init(), weight: 20, reps: 20)
    ]
    let exercise = Exercise(name: "Exercise", description: "", sets: sets)
    
    EditExerciseView(exercise: .constant(exercise))
}
