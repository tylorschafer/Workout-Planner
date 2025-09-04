//
//  ExerciseView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/15/24.
//

import SwiftUI

struct ExerciseView: View {
    @Binding var exercise: Exercise
    @State private var showEditView: Bool = false
    @State private var isWorkoutInProgress: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            GlassContainer(spacing: 16) {
                VStack(spacing: 20) {
                    headerView
                    imageView
                    startWorkoutSection
                    setsSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(exercise.name)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if isWorkoutInProgress {
                    Button("Finish") {
                        finishWorkout()
                    }
                    .buttonStyle(.glass)
                    .foregroundStyle(.green)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showEditView = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.glass)
            }
        }
        .sheet(isPresented: $showEditView) {
            EditExerciseView(exercise: $exercise)
        }
    }
    @Namespace private var exerciseNamespace
    
    private func startWorkout() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isWorkoutInProgress = true
            // Reset all sets to incomplete when starting workout
            for index in exercise.sets.indices {
                exercise.sets[index].isCompleted = false
            }
        }
    }
    
    private func finishWorkout() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isWorkoutInProgress = false
        }
    }
    
    private var completedSets: Int {
        exercise.sets.filter(\.isCompleted).count
    }
    
    private var totalSets: Int {
        exercise.sets.count
    }
}

private extension ExerciseView {
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Description")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            Text(exercise.description)
                .font(.body)
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(nil)
        }
        .padding(20)
        .glassCard()
    }
    
    private var startWorkoutSection: some View {
        VStack(spacing: 16) {
            if !isWorkoutInProgress {
                // Start Workout Button
                Button(action: startWorkout) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Start Workout")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Begin tracking your sets")
                                .font(.subheadline)
                                .opacity(0.8)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.title3)
                    }
                    .foregroundStyle(.white)
                    .padding(20)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.tint(.green.opacity(0.4)).interactive(), in: RoundedRectangle(cornerRadius: 20))
            } else {
                // Workout Progress
                VStack(spacing: 12) {
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "stopwatch.fill")
                                .foregroundStyle(.green)
                            Text("Workout in Progress")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        Text("\(completedSets)/\(totalSets)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Progress Bar
                    ProgressView(value: totalSets > 0 ? Double(completedSets) / Double(totalSets) : 0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .scaleEffect(y: 2)
                }
                .padding(20)
                .glassEffect(.regular.tint(.green.opacity(0.2)), in: RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    @ViewBuilder
    private var setsSection: some View {
        if !exercise.sets.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Sets")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(exercise.sets.count) sets")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glassCard(cornerRadius: 12, tintColor: .blue.opacity(0.5))
                }
                
                LazyVStack(spacing: 12) {
                    ForEach(Array($exercise.sets.enumerated()), id: \.element.id) { index, setBinding in
                        HStack {
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                                .glassCard(cornerRadius: 12, tintColor: .blue.opacity(0.6))
                            
                            SetView(set: setBinding)
                        }
                    }
                }
            }
            .padding(20)
            .glassCard()
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let image = exercise.image {
            Button {
                // Allow user to pick an image from their photo album
            } label: {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .glassCard()
        }
    }
}

#Preview {
    @Previewable @State var exercise = Exercise(
        name: "Example Exercise",
        description: "This is just an example exercise. Real exercises will have detailed descriptions and images that help demonstrate proper form and technique.",
        sets: [
            Exercise.ExerciseSet(weight: 20, reps: 20),
            Exercise.ExerciseSet(weight: 25, reps: 18),
            Exercise.ExerciseSet(weight: 30, reps: 15)
        ]
    )
    
    NavigationStack {
        ExerciseView(exercise: $exercise)
    }
    .preferredColorScheme(.dark)
}
