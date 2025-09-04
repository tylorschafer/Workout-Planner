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
    @State private var showingDeleteAlert = false
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    exerciseDetailsSection
                    setsSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Edit Exercise")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }
    
    private var exerciseDetailsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Exercise Details")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(spacing: 16) {
                CustomTextField(
                    title: "Exercise Name",
                    text: $exercise.name,
                    icon: "dumbbell.fill"
                )
                
                CustomTextField(
                    title: "Description",
                    text: $exercise.description,
                    icon: "text.alignleft",
                    axis: .vertical
                )
            }
            .padding(20)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var setsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Sets")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: addNewSet) {
                    Label("Add Set", systemImage: "plus.circle.fill")
                }
                .buttonStyle(.glass)
                .labelStyle(.iconOnly)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(Array($exercise.sets.enumerated()), id: \.offset) { index, set in
                    SetRowView(
                        setNumber: index + 1,
                        set: set,
                        numberFormatter: numberFormatter,
                        onDelete: { deleteSet(at: index) }
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: exercise.sets.count)
        }
    }
    
    private func addNewSet() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            let lastSet = exercise.sets.last
            let newSet = Exercise.ExerciseSet(
                weight: lastSet?.weight ?? 0.0,
                reps: lastSet?.reps ?? 0.0
            )
            exercise.sets.append(newSet)
        }
    }
    
    private func deleteSet(at index: Int) {
        guard exercise.sets.count > 1 else { return } // Keep at least one set
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            exercise.sets.remove(at: index)
        }
    }
}

struct SetRowView: View {
    let setNumber: Int
    @Binding var set: Exercise.ExerciseSet
    let numberFormatter: NumberFormatter
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Set number badge
            ZStack {
                Circle()
                    .fill(.blue.gradient)
                    .frame(width: 36, height: 36)
                
                Text("\(setNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    SetInputField(
                        title: "Weight",
                        value: $set.weight,
                        formatter: numberFormatter,
                        unit: "lbs",
                        icon: "scalemass.fill"
                    )
                    
                    SetInputField(
                        title: "Reps",
                        value: $set.reps,
                        formatter: numberFormatter,
                        unit: "",
                        icon: "repeat"
                    )
                }
            }
            
            // Delete button (only show if more than one set)
            if setNumber > 1 {
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.red)
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct SetInputField: View {
    let title: String
    @Binding var value: Double
    let formatter: NumberFormatter
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fontWeight(.medium)
            }
            
            HStack {
                TextField("0", value: $value, formatter: formatter)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let axis: Axis?
    
    init(title: String, text: Binding<String>, icon: String, axis: Axis? = nil) {
        self.title = title
        self._text = text
        self.icon = icon
        self.axis = axis
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                    .font(.headline)
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            TextField("Enter \(title.lowercased())", text: $text, axis: axis ?? .horizontal)
                .textFieldStyle(.plain)
                .font(.body)
                .padding(12)
                .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    @Previewable @State var exercise = Exercise(
        name: "Bench Press",
        description: "Chest exercise performed lying on a bench",
        image: nil,
        sets: [
            Exercise.ExerciseSet(weight: 135, reps: 10),
            Exercise.ExerciseSet(weight: 155, reps: 8),
            Exercise.ExerciseSet(weight: 175, reps: 6)
        ]
    )
    
    EditExerciseView(exercise: $exercise)
}
