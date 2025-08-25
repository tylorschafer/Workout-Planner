//
//  ContentView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
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

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
