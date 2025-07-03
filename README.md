# HabitTrackerSwift 🍅

A comprehensive iOS habit tracker app that integrates the Pomodoro Technique to help users build consistent daily habits through focused work sessions.

## Features

### 🎯 Habit Management
- **Create, Edit, Delete Habits**: Add habits with titles and optional descriptions
- **Visual Progress Tracking**: See daily progress with intuitive progress bars
- **Daily Statistics**: Track completed Pomodoros and habits worked on

### ⏰ Pomodoro Timer Integration
- **25-minute Work Sessions**: Focus on your habits with structured time blocks
- **5-minute Break Periods**: Automatic break timers between work sessions
- **Session Tracking**: Monitor completed Pomodoro sessions for each habit
- **Timer Controls**: Start, pause, and stop functionality

### 📝 Note-Taking System
- **Daily Notes**: Write and save short notes for each habit
- **Note History**: View previous notes and track your thoughts
- **Quick Access**: Easy note-taking directly from habit detail view

### 📊 Dashboard & Analytics
- **Daily Overview**: See total Pomodoros completed and habits worked on
- **Progress Visualization**: Visual indicators showing daily achievement
- **Note Highlights**: Quick preview of today's notes

### 💾 Data Persistence
- **Core Data Integration**: Reliable local data storage
- **Data Relationships**: Proper linking between habits, sessions, and notes
- **Future iCloud Sync**: Architecture ready for cloud synchronization

## Technical Stack

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence and management
- **Combine**: Reactive programming for timer functionality
- **iOS 14+**: Target deployment for modern iOS devices

## App Architecture

```
HabitTrackerSwift/
├── Models/
│   ├── PersistenceController.swift    # Core Data stack
│   ├── HabitStore.swift              # Data management
│   └── HabitTrackerModel.xcdatamodeld # Core Data model
├── Views/
│   ├── ContentView.swift             # Main navigation
│   ├── DashboardView.swift           # Daily statistics
│   ├── HabitDetailView.swift         # Individual habit view
│   ├── HabitRowView.swift            # Habit list items
│   ├── AddHabitView.swift            # Create new habits
│   ├── EditHabitView.swift           # Edit existing habits
│   └── AddNoteView.swift             # Note creation
└── Utils/
    └── PomodoroTimer.swift           # Timer functionality
```

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/alexistec/HabitTrackerSwift.git
   ```

2. **Open in Xcode**
   ```bash
   open HabitTrackerSwift.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## How to Use

1. **Add a New Habit**: Tap the "+" button to create a habit with a title and description
2. **Start a Pomodoro Session**: Open any habit and tap "Start" to begin a 25-minute focus session
3. **Take Notes**: Use the notes section to jot down thoughts, progress, or reflections
4. **Track Progress**: Monitor your daily statistics on the main dashboard
5. **Build Consistency**: Aim for multiple Pomodoro sessions per habit daily

## Future Enhancements

- [ ] iCloud synchronization for cross-device access
- [ ] Habit streaks and long-term analytics
- [ ] Custom Pomodoro durations
- [ ] Notification system for break reminders
- [ ] Weekly and monthly progress reports
- [ ] Habit categories and tags

---

## Educational Purpose

This repository was created for educational purposes to demonstrate the functionality of Claude Code alongside Cursor AI for developing iOS applications using prompt engineering techniques. The project showcases how AI-assisted development can accelerate the creation of complex, feature-rich mobile applications while maintaining code quality and architectural best practices.