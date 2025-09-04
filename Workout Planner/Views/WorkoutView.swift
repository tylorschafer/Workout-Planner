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
    @State private var selectedExercise: Exercise?
    @State private var selectedExerciseIndex: Int?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                workoutHeader
                exercisesList
            }
            .padding()
            .padding(.bottom, 100)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(.tertiarySystemBackground),
                    Color(.systemGray4).opacity(0.5),
                    Color(.systemMint.withProminence(.secondary))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Today's Workout")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedExercise) { exercise in
            NavigationStack {
                if let selectedIndex = selectedExerciseIndex {
                    ExerciseView(exercise: $viewModel.exercises[selectedIndex])
                } else {
                    ExerciseView(exercise: .constant(exercise))
                }
            }
        }
    }
    
    @Namespace private var workoutNamespace
    
    private var totalSets: Int {
        viewModel.exercises.reduce(0) { $0 + $1.sets.count }
    }
    
    private var completedSets: Int {
        viewModel.exercises.reduce(0) { total, exercise in
            total + exercise.sets.filter(\.isCompleted).count
        }
    }
    
    private var workoutHeader: some View {
        VStack(spacing: 20) {
            // Progress Overview
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text("\(completedSets) of \(totalSets) sets completed")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Circular Progress
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 8)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: totalSets > 0 ? Double(completedSets) / Double(totalSets) : 0)
                        .stroke(.mint.gradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.8), value: completedSets)
                    
                    Text("\(totalSets > 0 ? Int((Double(completedSets) / Double(totalSets)) * 100) : 0)%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                    .shadow(color: Color(.systemGray4).opacity(0.3), radius: 8, x: 0, y: 4)
            )
            
            // Quick Stats
            HStack(spacing: 16) {
                statCard(title: "Exercises", value: "\(viewModel.exercises.count)", icon: "dumbbell.fill", color: .orange)
                statCard(title: "Total Sets", value: "\(totalSets)", icon: "list.number", color: .blue)
                statCard(title: "Completed", value: "\(completedSets)", icon: "checkmark.circle.fill", color: .mint)
            }
        }
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color.gradient)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: Color(.systemGray4).opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
    
    private var exercisesList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Exercises")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.exercises.enumerated()), id: \.element.id) { index, exercise in
                    exerciseCard(exercise, index: index)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                }
            }
        }
    }
    
    private func exerciseCard(_ exercise: Exercise, index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                selectedExercise = exercise
                selectedExerciseIndex = index
            }
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                // Exercise Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(exercise.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                        
                        if !exercise.description.isEmpty {
                            Text(exercise.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                    
                    // Exercise completion badge
                    let completedSets = exercise.sets.filter(\.isCompleted).count
                    HStack(spacing: 4) {
                        if completedSets == exercise.sets.count && !exercise.sets.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Image(systemName: "circle.dashed")
                                .foregroundStyle(.orange)
                        }
                        
                        Text("\(completedSets)/\(exercise.sets.count)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5).opacity(0.8))
                    )
                }
                
                // Sets Preview
                if !exercise.sets.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { setIndex, set in
                                setChip(set, index: setIndex + 1)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
            .padding(20)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: Color(.systemGray4).opacity(0.15), radius: 6, x: 0, y: 3)
        )
    }
    
    private func setChip(_ set: Exercise.ExerciseSet, index: Int) -> some View {
        HStack(spacing: 6) {
            // Set number with completion indicator
            ZStack {
                Circle()
                    .fill(set.isCompleted ? Color.mint : Color(.systemGray3))
                    .frame(width: 24, height: 24)
                
                if set.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                } else {
                    Text("\(index)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(set.displayWeight)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text("lbs")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 4) {
                    Text(set.displayReps)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text("reps")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6).opacity(0.8))
                .stroke(
                    set.isCompleted ? Color.mint.opacity(0.6) : Color(.systemGray4).opacity(0.3),
                    lineWidth: 1
                )
        )
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
            image: nil,
            sets: [
                Exercise.ExerciseSet(weight: 15, reps: 12, isCompleted: true),
                Exercise.ExerciseSet(weight: 20, reps: 10, isCompleted: true),
                Exercise.ExerciseSet(weight: 25, reps: 8, isCompleted: false)
            ]
        ),
        Exercise(
            name: "Hammer Curls",
            description: "Neutral grip curl targeting brachialis and brachioradialis",
            image: nil,
            sets: [
                Exercise.ExerciseSet(weight: 12, reps: 15, isCompleted: false),
                Exercise.ExerciseSet(weight: 15, reps: 12, isCompleted: false),
                Exercise.ExerciseSet(weight: 18, reps: 10, isCompleted: false)
            ]
        ),
        Exercise(
            name: "Overhead Press",
            description: "Compound movement for shoulder and core strength",
            image: nil,
            sets: [
                Exercise.ExerciseSet(weight: 45, reps: 8, isCompleted: true),
                Exercise.ExerciseSet(weight: 50, reps: 6, isCompleted: true),
                Exercise.ExerciseSet(weight: 55, reps: 4, isCompleted: true)
            ]
        ),
    ])
    
    NavigationStack {
        WorkoutView(viewModel: viewModel)
    }
}
