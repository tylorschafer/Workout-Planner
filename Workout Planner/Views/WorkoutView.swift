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
    
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }
    
    @Published var exercises: [Exercise]
}

struct WorkoutView: View {
    @Namespace private var workoutNamespace
    @ObservedObject var viewModel: WorkoutViewModel
    @State var shouldShowDetailView: Bool = false
    @State private var selectedExercise: Exercise?
    @State private var selectedExerciseIndex: Int?
    
    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: 16) {
                VStack(spacing: 20) {
                    // Header Section
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Workout")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Text("\(viewModel.exercises.count) exercises")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Text("\(viewModel.totalSets) sets")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .glassEffect(.regular.tint(.blue.opacity(0.5)).interactive())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Exercises List
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.exercises.enumerated()), id: \.element.id) { index, exercise in
                            exerciseCard(exercise, index: index)
                                .glassEffectID(exercise.id, in: workoutNamespace)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .navigationTitle("Workout")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $shouldShowDetailView) {
            if let selectedExercise = Binding($selectedExercise) {
                NavigationStack {
                    ExerciseView(exercise: selectedExercise)
                }
            }
        }
    }
}

// MARK: - Card

extension WorkoutView {
    private func exerciseCard(_ exercise: Exercise, index: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedExercise = exercise
                selectedExerciseIndex = index
                shouldShowDetailView = true
            }
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                // Exercise Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(exercise.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                        
                        if !exercise.description.isEmpty {
                            Text(exercise.description)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("\(exercise.sets.count)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text("sets")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .glassEffect(.regular.tint(.gray.opacity(0.4)).interactive(), in: RoundedRectangle(cornerRadius: 12))
                }
                
                // Sets Preview
                if !exercise.sets.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { setIndex, set in
                                setChip(set, index: setIndex + 1)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
                
                // Quick Actions
                HStack(spacing: 12) {
                    Button(action: {
                        // Quick start action
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 12, weight: .medium))
                            Text("Start")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .glassEffect(.regular.tint(.green.opacity(0.6)).interactive())
                }
            }
            .padding(20)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.tint(.white.opacity(0.1)).interactive(), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
    
    private func setChip(_ set: Exercise.ExerciseSet, index: Int) -> some View {
        HStack(spacing: 4) {
            Text("\(index)")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 16, height: 16)
                .glassEffect(.regular.tint(.blue.opacity(0.5)), in: Circle())
            
            Text("\(set.displayWeight)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            
            Text("×")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.6))
            
            Text("\(set.displayReps)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .glassEffect(.regular.tint(.white.opacity(0.15)).interactive(), in: Capsule())
    }
}

// MARK: - Extensions

extension WorkoutView {
    private func exerciseRow(_ exercise: Exercise) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            ForEach(exercise.sets) { set in
                Text("\(set.displayWeight) lbs × \(set.displayReps) reps")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    let viewModel = WorkoutViewModel(exercises: [
        Exercise(
            name: "Dumbbell Curls",
            description: "Bicep strengthening exercise focusing on controlled movement",
            sets: [
                Exercise.ExerciseSet(weight: 15, reps: 12),
                Exercise.ExerciseSet(weight: 20, reps: 10),
                Exercise.ExerciseSet(weight: 25, reps: 8)
            ]
        ),
        Exercise(
            name: "Hammer Curls",
            description: "Neutral grip curl targeting brachialis and brachioradialis",
            sets: [
                Exercise.ExerciseSet(weight: 12, reps: 15),
                Exercise.ExerciseSet(weight: 15, reps: 12),
                Exercise.ExerciseSet(weight: 18, reps: 10)
            ]
        ),
        Exercise(
            name: "Overhead Press",
            description: "Compound movement for shoulder and core strength",
            sets: [
                Exercise.ExerciseSet(weight: 45, reps: 8),
                Exercise.ExerciseSet(weight: 50, reps: 6),
                Exercise.ExerciseSet(weight: 55, reps: 4)
            ]
        ),
    ])
    
    NavigationStack {
        WorkoutView(viewModel: viewModel)
    }
    .preferredColorScheme(.dark)
}
