import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var showingAddTask = false
    @State private var showingCompletionOverlay = false
    @State private var completedTaskId: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Search and Filter
            searchAndFilterView
            
            // Task List
            taskListView
            
            // Add Task Button
            addTaskButton
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(taskManager: taskManager)
        }
        .overlay {
            if showingCompletionOverlay {
                TaskCompletionOverlay(isShowing: $showingCompletionOverlay) {
                    // Completion animation callback
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Stay organized and productive")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Task Count Badge
            HStack(spacing: 8) {
                Text("\(taskManager.pendingTasks.count)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.blue)
                    )
                
                Text("pending")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Search and Filter View
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search tasks...", text: $taskManager.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !taskManager.searchText.isEmpty {
                    Button(action: {
                        taskManager.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
            )
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // All Categories Button
                    CategoryFilterButton(
                        title: "All",
                        isSelected: taskManager.selectedCategory == nil,
                        color: .gray
                    ) {
                        taskManager.clearSelectedCategory()
                    }
                    
                    ForEach(TaskCategory.allCases) { category in
                        CategoryFilterButton(
                            title: category.rawValue,
                            isSelected: taskManager.selectedCategory == category,
                            color: category.color
                        ) {
                            taskManager.setSelectedCategory(category)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    // MARK: - Task List View
    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(Array(taskManager.filteredTasks.enumerated()), id: \.element.id) { index, task in
                    TaskRowView(
                        task: task,
                        taskManager: taskManager,
                        onComplete: {
                            completedTaskId = task.id
                            showingCompletionOverlay = true
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: task.isCompleted)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Add Task Button
    private var addTaskButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                showingAddTask = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.headline)
                    Text("Add Task")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(showingAddTask ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: showingAddTask)
            
            Spacer()
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Category Filter Button
struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color : color.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Task Row View
struct TaskRowView: View {
    let task: TaskItem
    @ObservedObject var taskManager: TaskManager
    let onComplete: () -> Void
    
    @State private var isHovered = false
    @State private var showingDetails = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion Checkbox
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    taskManager.toggleTaskCompletion(task)
                }
                
                if !task.isCompleted {
                    onComplete()
                }
            }) {
                ZStack {
                    Circle()
                        .stroke(categoryColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(task.isCompleted ? 1.0 : 0.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: task.isCompleted)
                    }
                }
                .background(
                    Circle()
                        .fill(task.isCompleted ? categoryColor : Color.clear)
                        .scaleEffect(task.isCompleted ? 1.0 : 0.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: task.isCompleted)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Task Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                        .strikethrough(task.isCompleted)
                    
                    Spacer()
                    
                    // Priority Indicator
                    HStack(spacing: 4) {
                        Image(systemName: priorityIcon)
                            .font(.caption)
                            .foregroundColor(priorityColor)
                        
                        Text(task.priority)
                            .font(.caption)
                            .foregroundColor(priorityColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(priorityColor.opacity(0.1))
                    )
                }
                
                if let description = task.taskDescription, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    // Category Badge
                    HStack(spacing: 4) {
                        Image(systemName: categoryIcon)
                            .font(.caption)
                        Text(task.category)
                            .font(.caption)
                    }
                    .foregroundColor(categoryColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(categoryColor.opacity(0.1))
                    )
                    
                    Spacer()
                    
                    // Due Date
                    if let dueDate = task.dueDate {
                        Text(dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Actions
            HStack(spacing: 8) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingDetails.toggle()
                    }
                }) {
                    Image(systemName: showingDetails ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        taskManager.deleteTask(task)
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(
                    color: isHovered ? categoryColor.opacity(0.2) : .black.opacity(0.1),
                    radius: isHovered ? 8 : 4,
                    x: 0,
                    y: isHovered ? 4 : 2
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    // MARK: - Computed Properties
    private var categoryColor: Color {
        TaskCategory(rawValue: task.category)?.color ?? .gray
    }
    
    private var categoryIcon: String {
        TaskCategory(rawValue: task.category)?.icon ?? "tag.fill"
    }
    
    private var priorityColor: Color {
        TaskPriority(rawValue: task.priority)?.color ?? .gray
    }
    
    private var priorityIcon: String {
        TaskPriority(rawValue: task.priority)?.icon ?? "minus.circle.fill"
    }
}

// MARK: - Add Task View
struct AddTaskView: View {
    @ObservedObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = TaskCategory.personal
    @State private var selectedPriority = TaskPriority.medium
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Task title", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Category & Priority") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(TaskPriority.allCases) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                    .foregroundColor(priority.color)
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                }
                
                Section("Due Date") {
                    Toggle("Set due date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("Add New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .frame(width: 500, height: 400)
    }
    
    private func addTask() {
        taskManager.addTask(
            title: title,
            description: description.isEmpty ? nil : description,
            category: selectedCategory,
            priority: selectedPriority,
            dueDate: hasDueDate ? dueDate : nil
        )
        dismiss()
    }
}
