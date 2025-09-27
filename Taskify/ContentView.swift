import SwiftUI

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    @StateObject private var backgroundManager = BackgroundManager()
    @State private var showingSettings = false
    @State private var hasAddedSampleData = false
    
    var body: some View {
        ZStack {
            // Background
            backgroundManager.backgroundView
            
            HStack(spacing: 0) {
                // Sidebar
                sidebarView
                    .frame(width: 280)
                    .background(.ultraThinMaterial)
                
                Divider()
                
                // Main Content
                mainContentView
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            if !hasAddedSampleData && taskManager.tasks.isEmpty {
                taskManager.addSampleData()
                hasAddedSampleData = true
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(
                backgroundManager: backgroundManager,
                taskManager: taskManager
            )
        }
    }
    
    // MARK: - Sidebar View
    private var sidebarView: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Text("Taskify")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                // Overall Progress
                StatisticsView(taskManager: taskManager)
            }
            .padding(20)
            
            Divider()
            
            // Quick Stats
            quickStatsView
                .padding(20)
            
            Spacer()
            
            // Settings Button
            HStack {
                Button(action: {
                    showingSettings = true
                }) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .padding(20)
        }
    }
    
    // MARK: - Quick Stats View
    private var quickStatsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                StatRowView(
                    icon: "list.bullet",
                    title: "Total Tasks",
                    value: "\(taskManager.tasks.count)",
                    color: .blue
                )
                
                StatRowView(
                    icon: "checkmark.circle",
                    title: "Completed",
                    value: "\(taskManager.completedTasks.count)",
                    color: .green
                )
                
                StatRowView(
                    icon: "clock",
                    title: "Pending",
                    value: "\(taskManager.pendingTasks.count)",
                    color: .orange
                )
                
                StatRowView(
                    icon: "chart.pie",
                    title: "Progress",
                    value: "\(Int(taskManager.completionPercentage * 100))%",
                    color: .purple
                )
            }
        }
    }
    
    // MARK: - Main Content View
    private var mainContentView: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Text("Tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Background Theme Selector
                Menu {
                    ForEach(BackgroundTheme.allCases) { theme in
                        Button(action: {
                            backgroundManager.setTheme(theme)
                        }) {
                            HStack {
                                if backgroundManager.selectedTheme == theme {
                                    Image(systemName: "checkmark")
                                }
                                Text(theme.rawValue)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                        Text("Theme")
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Task List
            TaskListView(taskManager: taskManager)
        }
    }
}

// MARK: - Stat Row View
struct StatRowView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @ObservedObject var backgroundManager: BackgroundManager
    @ObservedObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Background Theme")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(BackgroundTheme.allCases) { theme in
                                ThemePreviewCard(
                                    theme: theme,
                                    isSelected: backgroundManager.selectedTheme == theme
                                ) {
                                    backgroundManager.setTheme(theme)
                                }
                            }
                        }
                    }
                }
                
                Section("Data") {
                    Button("Add Sample Data") {
                        taskManager.addSampleData()
                    }
                    .disabled(!taskManager.tasks.isEmpty)
                    
                    Button("Clear All Tasks") {
                        // Clear all tasks
                        for task in taskManager.tasks {
                            taskManager.deleteTask(task)
                        }
                    }
                    .foregroundColor(.red)
                    .disabled(taskManager.tasks.isEmpty)
                }
                
                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Taskify v1.0")
                            .font(.headline)
                        Text("A beautiful macOS to-do app with animations and progress tracking.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 500, height: 400)
    }
}

// MARK: - Theme Preview Card
struct ThemePreviewCard: View {
    let theme: BackgroundTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        theme.isGradient ?
                        LinearGradient(colors: theme.colors, startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: theme.colors, startPoint: .top, endPoint: .bottom)
                    )
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
                
                Text(theme.rawValue)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    ContentView()
}
