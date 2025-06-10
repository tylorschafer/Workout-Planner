//
//  ExerciseView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/15/24.
//

import SwiftUI

struct SetView: View {
    let set: Exercise.ExerciseSet
    @State private var isCompleted: Bool = false

    var body: some View {
        VStack {
            Text("Weight: \(set.displayWeight) kg")
                .font(.title2)
                .bold()

            Text("Reps: \(set.displayReps)")
                .font(.body)

            Spacer().frame(height: 10)

            HStack {
                Button(action: {
                    isCompleted = false
                }) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding()
                        .background(isCompleted ? Color.red : Color.blue)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                }

                Spacer()

                Button(action: {
                    // Action to mark as completed
                    isCompleted.toggle()
                }) {
                    Text(isCompleted ? "Marked" : "Complete")
                        .foregroundColor(.white)
                        .padding()
                        .background(isCompleted ? Color.green : Color.gray)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                }
            }

        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.white.opacity(0.9))
        .cornerRadius(18)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
}

struct ExerciseView: View {
    @Binding var exercise: Exercise
    
    @State private var showEditView: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text(exercise.description)
            
            if let image = exercise.image {
                Button {
                    // allow user to pick an image from their photo album
                } label: {
                    image
                }
            }
            
            if !exercise.sets.isEmpty {
                Text("Sets")
                    .bold()
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(exercise.sets) { set in
                        SetView(set: set)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(exercise.name))
        .navigationBarItems(trailing: editButton)
        .sheet(isPresented: $showEditView) {
            EditExerciseView(exercise: $exercise)
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
    @Previewable @State var exercise = Exercise(
        name: "Example Exercise",
        description: "This is just an example exercise. Real exercises will have detailed descriptions and images.",
        image: nil,
        sets: [
            Exercise.ExerciseSet.init(weight: 20, reps: 20),
            Exercise.ExerciseSet.init(weight: 20, reps: 20),
            Exercise.ExerciseSet.init(weight: 20, reps: 20)
        ]
    )
    
    NavigationStack {
        ExerciseView(exercise: $exercise)
    }
}
