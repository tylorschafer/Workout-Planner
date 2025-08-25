
# Workout Planner

A SwiftUI-based workout planning and tracking application built to explore modern Swift development patterns and glassmorphism design principles.

https://github.com/user-attachments/assets/f6e0203f-99ed-4ada-9052-b4df1c7c5779

## Features

- **Workout Management**: Create and organize workout sessions with multiple exercises
- **Exercise Tracking**: Track sets, reps, and weights for each exercise
- **Interactive Set Completion**: Mark individual sets as completed with visual feedback
- **Exercise Details**: View detailed information and descriptions for each exercise
- **Modern UI**: iOS 26 Glass API and other modern technologies explored.

## Architecture

### Frontend
- **SwiftUI**: Declarative UI framework for all interface components
- **MVVM Pattern**: Clean separation of concerns with `WorkoutViewModel`
- **Custom Modifiers**: Extensive use of glassmorphism effects via `.glassEffect()` modifiers

### Data Layer
- **SwiftData**: Apple's modern data persistence framework for local storage
- **Models**: 
  - `Exercise`: Workout exercise with nested sets
  - `ExerciseSet`: Individual set data (weight, reps, completion status)

### Navigation
- **Sheet-based Navigation**: Modal presentations for detail views
- **Namespace Animations**: Smooth transitions between workout and exercise views

## Technologies

- **iOS 17+**: Target deployment using latest SwiftUI features
- **SwiftData**: Modern Core Data replacement for persistence
- **Combine**: Reactive programming via `@ObservableObject` and `@Published`
- **Xcode**: Native iOS development environment

## Project Structure

```
Workout Planner/
├── Models/
│   └── Exercise.swift          # Core data models
├── Views/
│   ├── WorkoutView.swift       # Main workout list interface
│   ├── ExerciseView.swift      # Exercise detail view
│   ├── SetView.swift           # Individual set tracking
│   └── EditExerciseView.swift  # Exercise editing form
├── ContentView.swift           # Root view controller
├── Workout_PlannerApp.swift    # App entry point
└── Item.swift                  # SwiftData template model
```

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ deployment target
- macOS development environment

### Installation
1. Clone the repository
2. Open `Workout Planner.xcodeproj` in Xcode
3. Build and run on simulator or device

## Development Notes

This project serves as a learning exercise for:
- SwiftUI best practices and modern patterns
- SwiftData integration and data management  
- Custom view modifiers and design systems
- MVVM architecture in SwiftUI applications

## Current Limitations

- Sample data is hardcoded rather than persisted via SwiftData
- No workout session persistence or history
- Limited exercise library (user must create all exercises)
- Basic form validation in edit interfaces

## Future Enhancements

- [ ] Full SwiftData integration for data persistence
- [ ] Workout templates and planning features  
- [ ] Exercise library with images and instructions
- [ ] Progress tracking and workout statistics
- [ ] Workout history and session management
- [ ] Export/import functionality for workout data

## Contributing

This is a personal learning project. Feel free to explore the code and adapt patterns for your own projects.
