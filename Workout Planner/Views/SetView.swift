//
//  SetView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 6/23/25.
//

import SwiftUI

struct SetView: View {
    let set: Exercise.ExerciseSet
    @State private var isCompleted: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            setHeader

            HStack(spacing: 16) {
                resetButton
                doneButton
            }
        }
        .padding(20)
        .glassEffect(.regular.tint(.white.opacity(0.1)).interactive(), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
}

private extension SetView {
    private var setHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Text("\(set.displayWeight) kg")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Reps")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Text("\(set.displayReps)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var resetButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCompleted = false
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 14, weight: .medium))
                Text("Reset")
                    .font(.system(size: 15, weight: .medium))
            }
            .frame(height: 24)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .glassEffect(.regular.tint(.red.opacity(0.6)).interactive())
        .scaleEffect(isCompleted ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.2), value: isCompleted)
    }
    
    private var doneButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCompleted.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 14, weight: .medium))
                Text("Complete")
                    .font(.system(size: 15, weight: .medium))
            }
            .frame(height: 24)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .glassEffect(
            .regular
                .tint(isCompleted ? .green.opacity(0.6) : .gray.opacity(0.4))
                .interactive()
        )
        .scaleEffect(isCompleted ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isCompleted)
    }
}

#Preview {
    let set = Exercise.ExerciseSet(weight: 100, reps: 10)
    
    SetView(set: set)
}
