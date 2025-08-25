//
//  EditExerciseView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 9/22/24.
//

import SwiftUI

struct EditExerciseView: View {
    @Binding var exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    
    // Local copy for editing
    @State private var editedExercise: Exercise
    
    init(exercise: Binding<Exercise>) {
        self._exercise = exercise
        self._editedExercise = State(initialValue: exercise.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GlassContainer(spacing: DesignSystem.Spacing.xl) {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        exerciseDetailsSection
                        setsSection
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.xl)
                    .padding(.top, DesignSystem.Spacing.lg)
                }
            }
            .background(DesignSystem.Colors.background.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(DesignSystem.CornerRadius.extraLarge)
            .navigationTitle("Edit Exercise")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(DesignSystem.Colors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        exercise = editedExercise
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(DesignSystem.Colors.primaryText)
                }
            }
        }
    }
}

// MARK: - Sections

private extension EditExerciseView {
    
    var exerciseDetailsSection: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            SectionHeader("Exercise Details")
            
            VStack(spacing: DesignSystem.Spacing.lg) {
                GlassTextField("Exercise Name", text: $editedExercise.name)
                GlassTextField("Description", text: $editedExercise.description)
            }
        }
        .padding(DesignSystem.Spacing.xl)
        .glassCard()
    }
    
    var setsSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            HStack {
                SectionHeader("Sets & Reps", subtitle: "\(editedExercise.sets.count) sets")
                Spacer()
                ActionButton(
                    "Add Set",
                    systemImage: "plus.circle.fill",
                    tintColor: DesignSystem.Colors.accentGreen
                ) {
                    withAnimation(DesignSystem.Animation.standard) {
                        editedExercise.sets.append(Exercise.ExerciseSet(weight: 0.0, reps: 0.0))
                    }
                }
            }
            
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(Array($editedExercise.sets.enumerated()), id: \.element.id) { index, setBinding in
                    setCard(for: setBinding, index: index)
                }
            }
        }
        .padding(DesignSystem.Spacing.xl)
        .glassCard()
    }
    
    private func setCard(for setBinding: Binding<Exercise.ExerciseSet>, index: Int) -> some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            HStack {
                Text("Set \(index + 1)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(DesignSystem.Colors.primaryText)
                
                Spacer()
                
                Button(action: {
                    withAnimation(DesignSystem.Animation.standard) {
                        _ = editedExercise.sets.remove(at: index)
                    }
                }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(DesignSystem.Colors.accentRed)
                }
                .opacity(editedExercise.sets.count > 1 ? 1.0 : 0.3)
                .disabled(editedExercise.sets.count <= 1)
            }
            
            HStack(spacing: DesignSystem.Spacing.lg) {
                GlassNumberField("Weight (lbs)", value: setBinding.weight)
                GlassNumberField("Reps", value: setBinding.reps)
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .glassCard(cornerRadius: DesignSystem.CornerRadius.medium, tintColor: DesignSystem.Colors.glassTint.opacity(0.5))
    }
}

#Preview {
    @Previewable @State var exercise = Exercise(
        name: "Dumbbell Curls",
        description: "Bicep strengthening exercise focusing on controlled movement",
        sets: [
            Exercise.ExerciseSet(weight: 20, reps: 12),
            Exercise.ExerciseSet(weight: 25, reps: 10),
            Exercise.ExerciseSet(weight: 30, reps: 8)
        ]
    )
    
    EditExerciseView(exercise: $exercise)
}
