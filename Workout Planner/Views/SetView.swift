//
//  SetView.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 6/23/25.
//

import SwiftUI

struct SetView: View {
    @Binding var set: Exercise.ExerciseSet

    var body: some View {
        VStack(spacing: 16) {
            setHeader

            HStack(spacing: 16) {
                resetButton
                doneButton
            }
        }
        .padding(DesignSystem.Spacing.xl)
        .glassCard()
    }
}

private extension SetView {
    private var setHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Text("\(set.displayWeight) lbs")
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
        .padding(.horizontal)
    }
    
    private var resetButton: some View {
        Button {
            withAnimation(DesignSystem.Animation.standard) {
                set.isCompleted = false
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
        .glassCard(tintColor: DesignSystem.Colors.accentRed)
        .scaleEffect(set.isCompleted ? 1.0 : 0.95)
        .animation(DesignSystem.Animation.quick, value: set.isCompleted)
    }
    
    private var doneButton: some View {
        Button {
            withAnimation(DesignSystem.Animation.standard) {
                set.isCompleted.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
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
        .glassCard(tintColor: set.isCompleted ? DesignSystem.Colors.accentGreen : DesignSystem.Colors.accentGray)
        .scaleEffect(set.isCompleted ? 1.05 : 1.0)
        .animation(DesignSystem.Animation.quick, value: set.isCompleted)
    }
}

#Preview {
    @Previewable @State var set = Exercise.ExerciseSet(weight: 100, reps: 10)
    
    SetView(set: $set)
        .background(.black)
}
