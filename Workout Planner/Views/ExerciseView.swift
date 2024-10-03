//
//  ExerciseView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/15/24.
//

import SwiftUI

struct SetView: View {
    @Binding var set: Exercise.ExerciseSet
    
    var body: some View {
        Button {
            set.isCompleted.toggle()
        } label: {
            Text("\(set.displayWeight) lbs x \(set.displayReps) reps")
               .font(.body)
               .padding(.vertical, 8)
               .padding(.horizontal, 16)
        }
       .frame(maxWidth: 350)
       .background(set.isCompleted ? Color.green.opacity(0.8) : Color.white)
       .foregroundColor(set.isCompleted ?.white : .black)
       .cornerRadius(8)
       .overlay(
            RoundedRectangle(cornerRadius: 8)
               .stroke(Color.black, lineWidth: 1)
        )
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
                    ForEach($exercise.sets) { set in
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
