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
    
    var body: some View {
        ScrollView {
            GlassContainer(spacing: 16) {
                VStack(spacing: 20) {
                    headerView
                    imageView
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
