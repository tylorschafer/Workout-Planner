//
//  DesignSystem.swift
//  Workout Planner
//
//  Created by Tylor Schafer on 8/25/25.
//

import SwiftUI

// MARK: - Design Constants
enum DesignSystem {
    
    // MARK: - Colors
    enum Colors {
        static let background = Color.black
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.7)
        static let tertiaryText = Color.white.opacity(0.6)
        
        static let glassTint = Color.white.opacity(0.1)
        static let accentBlue = Color.blue.opacity(0.5)
        static let accentGreen = Color.green.opacity(0.6)
        static let accentRed = Color.red.opacity(0.6)
        static let accentGray = Color.gray.opacity(0.4)
        
        static let shadowColor = Color.black.opacity(0.25)
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 24
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }
    
    // MARK: - Animation
    enum Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.4)
    }
}

// MARK: - Custom View Modifiers

struct GlassCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    let tintColor: Color
    
    init(cornerRadius: CGFloat = DesignSystem.CornerRadius.large, tintColor: Color = DesignSystem.Colors.glassTint) {
        self.cornerRadius = cornerRadius
        self.tintColor = tintColor
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(tintColor)
                    .shadow(color: DesignSystem.Colors.shadowColor, radius: 12, x: 0, y: 6)
            )
    }
}

struct GlassButtonModifier: ViewModifier {
    let cornerRadius: CGFloat
    let tintColor: Color
    let isPressed: Bool
    
    init(cornerRadius: CGFloat = DesignSystem.CornerRadius.medium, tintColor: Color = DesignSystem.Colors.glassTint, isPressed: Bool = false) {
        self.cornerRadius = cornerRadius
        self.tintColor = tintColor
        self.isPressed = isPressed
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(tintColor)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(DesignSystem.Animation.quick, value: isPressed)
    }
}

// MARK: - Sheet Background Modifier

struct SheetBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DesignSystem.Colors.background.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(DesignSystem.CornerRadius.extraLarge)
    }
}

// MARK: - View Extensions

extension View {
    func glassCard(cornerRadius: CGFloat = DesignSystem.CornerRadius.large, tintColor: Color = DesignSystem.Colors.glassTint) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius, tintColor: tintColor))
    }
    
    func glassButton(cornerRadius: CGFloat = DesignSystem.CornerRadius.medium, tintColor: Color = DesignSystem.Colors.glassTint, isPressed: Bool = false) -> some View {
        modifier(GlassButtonModifier(cornerRadius: cornerRadius, tintColor: tintColor, isPressed: isPressed))
    }
    
    func sheetBackground() -> some View {
        modifier(SheetBackgroundModifier())
    }
}

// MARK: - Reusable Components

struct GlassContainer<Content: View>: View {
    let content: Content
    let spacing: CGFloat
    
    init(spacing: CGFloat = DesignSystem.Spacing.lg, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.spacing = spacing
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String?
    
    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(DesignSystem.Colors.primaryText)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(DesignSystem.Colors.secondaryText)
                }
            }
            Spacer()
        }
    }
}

struct GlassTextField: View {
    let title: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    
    init(_ title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self._text = text
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(DesignSystem.Colors.secondaryText)
            
            TextField(title, text: $text)
                .textFieldStyle(.plain)
                .font(.body)
                .foregroundStyle(DesignSystem.Colors.primaryText)
                .padding(DesignSystem.Spacing.lg)
                .glassCard(cornerRadius: DesignSystem.CornerRadius.medium)
                .keyboardType(keyboardType)
        }
    }
}

struct GlassNumberField: View {
    let title: String
    @Binding var value: Double
    private let formatter: NumberFormatter
    
    init(_ title: String, value: Binding<Double>) {
        self.title = title
        self._value = value
        self.formatter = NumberFormatter()
        self.formatter.numberStyle = .decimal
        self.formatter.maximumFractionDigits = 2
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(DesignSystem.Colors.secondaryText)
            
            TextField(title, value: $value, formatter: formatter)
                .textFieldStyle(.plain)
                .font(.body)
                .foregroundStyle(DesignSystem.Colors.primaryText)
                .padding(DesignSystem.Spacing.lg)
                .glassCard(cornerRadius: DesignSystem.CornerRadius.medium)
                .keyboardType(.decimalPad)
        }
    }
}

struct ActionButton: View {
    let title: String
    let systemImage: String
    let tintColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(_ title: String, systemImage: String, tintColor: Color = DesignSystem.Colors.accentBlue, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.tintColor = tintColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .medium))
                Text(title)
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundStyle(DesignSystem.Colors.primaryText)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .glassButton(tintColor: tintColor, isPressed: isPressed)
        }
        .buttonStyle(.plain)
        .onTapGesture {
            withAnimation(DesignSystem.Animation.quick) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(DesignSystem.Animation.quick) {
                    isPressed = false
                }
            }
            action()
        }
    }
}