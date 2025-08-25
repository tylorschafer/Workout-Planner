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
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        ScrollView {
            GlassContainer(spacing: 16) {
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
                            .glassCard(cornerRadius: DesignSystem.CornerRadius.small, tintColor: DesignSystem.Colors.accentBlue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Exercises List
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.exercises.enumerated()), id: \.element.id) { index, exercise in
                            NavigationLink(destination: ExerciseView(
                                exercise: Binding(
                                    get: { viewModel.exercises[index] },
                                    set: { newExercise in
                                        viewModel.exercises[index] = newExercise
                                    }
                                )
                            )) {
                                exerciseCard(exercise, index: index)
                            }
                            .buttonStyle(.plain)
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
    }
}

// MARK: - Card

extension WorkoutView {
    private func exerciseCard(_ exercise: Exercise, index: Int) -> some View {
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
                    .glassCard(cornerRadius: DesignSystem.CornerRadius.small, tintColor: DesignSystem.Colors.accentGray)
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
                    .glassCard(cornerRadius: DesignSystem.CornerRadius.medium, tintColor: DesignSystem.Colors.accentGreen)
                }
            }
        .padding(20)
        .glassCard()
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
    
    private func setChip(_ set: Exercise.ExerciseSet, index: Int) -> some View {
        HStack(spacing: 4) {
            Text("\(index)")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 16, height: 16)
                .glassCard(cornerRadius: 8, tintColor: DesignSystem.Colors.accentBlue)
            
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
        .glassCard(cornerRadius: 12, tintColor: DesignSystem.Colors.glassTint.opacity(0.8))
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
