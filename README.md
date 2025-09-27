# Taskify - macOS To-Do App

A beautiful, animated macOS to-do app.
***!!MACOS ONLY, WEB SUPPORT COMING NEVER!!***

## Features

✨ **Animated To-Do List**
- Smooth animations and transitions
- Category-based organization with color coding
- Priority levels with visual indicators
- Search and filter functionality

📊 **Progress Tracking**
- Real-time completion percentage
- Progress bars and statistics
- Category-wise progress breakdown
- Animated progress rings

🎨 **Customizable Themes**
- Multiple background themes
- Gradient and solid color options
- Persistent theme selection
- Beautiful visual design


💾 **Local Persistence**
- Core Data integration
- Automatic data saving
- Background theme persistence
- Sample data included

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Installation

1. Clone or download this repository
2. Open `Taskify.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

## Project Structure

```
Taskify/
├── TaskifyApp.swift          # Main app entry point
├── ContentView.swift         # Main UI view
├── TaskModel.swift           # Data models and enums
├── TaskManager.swift         # Core Data operations
├── TaskListView.swift        # Task list UI
├── ProgressView.swift        # Progress tracking UI
├── LottieView.swift          # Animation components
├── BackgroundManager.swift   # Theme management
├── Taskify.xcdatamodeld/     # Core Data model
└── checkmark.json           # Lottie animation file
```

## Usage

### Adding Tasks
1. Click the "Add Task" button
2. Fill in task details (title, description, category, priority)
3. Optionally set a due date
4. Click "Add" to save
5. ***Tasks automatically save***

### Managing Tasks
- **Complete**: Click the circle next to any task
- **Delete**: Click the trash icon
- **Filter**: Use category buttons to filter tasks
- **Search**: Type in the search bar to find specific tasks

### Customizing Appearance
1. Click the "Settings" button in the sidebar
2. Choose from various background themes
3. Your selection will be saved automatically
4. ***Settings menu has a known bug where the UI gets hella weird***

### Viewing Progress
- Overall progress is shown in the sidebar
- Category-wise breakdown available
- Animated progress indicators

## Features in Detail

### Categories
- **Personal** (Blue) - Personal tasks and errands
- **Work** (Orange) - Professional tasks
- **Health** (Green) - Health and fitness
- **Shopping** (Purple) - Shopping lists
- **Finance** (Yellow) - Financial tasks
- **Education** (Indigo) - Learning and study
- **Travel** (Cyan) - Travel planning
- **Other** (Gray) - Miscellaneous tasks
- ***Will add custom categories later on***

### Priority Levels
- **Low** (Green) - Not urgent
- **Medium** (Yellow) - Normal priority
- **High** (Orange) - Important
- **Urgent** (Red) - Critical

### Background Themes
- Light, Dark, Blue, Purple, Green, Orange, Pink
- Beautiful gradient theme
- Automatic persistence

## Technical Details

- **Framework**: SwiftUI
- **Data**: Core Data with CloudKit support
- **Animations**: Lottie + SwiftUI animations
- **Architecture**: MVVM pattern
- **Persistence**: UserDefaults + Core Data

## Sample Data

The app includes sample data to help you get started. You can:
- Add sample data from Settings
- Clear all data from Settings
- All data persists between app launches

## Contributing

Feel free to NOT submit issues and enhancement requests!

## License

This project is open source and available under the MIT License.
