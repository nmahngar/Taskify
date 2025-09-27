import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var selectedCategory: TaskCategory? = nil
    @Published var searchText: String = ""
    
    init() {
        loadTasks()
    }
    
    // MARK: - Load Tasks
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([TaskItem].self, from: data) {
            tasks = decodedTasks.sorted { !$0.isCompleted && $1.isCompleted }
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    // MARK: - Filtered Tasks
    var filteredTasks: [TaskItem] {
        var filtered = tasks
        
        // Filter by category
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory.rawValue }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                (task.taskDescription?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return filtered
    }
    
    var completedTasks: [TaskItem] {
        return tasks.filter { $0.isCompleted }
    }
    
    var pendingTasks: [TaskItem] {
        return tasks.filter { !$0.isCompleted }
    }
    
    var completionPercentage: Double {
        guard !tasks.isEmpty else { return 0.0 }
        let completedCount = completedTasks.count
        return Double(completedCount) / Double(tasks.count)
    }
    
    // MARK: - Task Operations
    func addTask(title: String, description: String? = nil, category: TaskCategory, priority: TaskPriority, dueDate: Date? = nil) {
        var newTask = TaskItem(title: title, description: description, category: category, priority: priority, dueDate: dueDate)
        newTask.order = tasks.count
        tasks.append(newTask)
        saveTasks()
    }
    
    func toggleTaskCompletion(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func updateTask(_ task: TaskItem, title: String, description: String?, category: TaskCategory, priority: TaskPriority, dueDate: Date?) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].title = title
            tasks[index].taskDescription = description
            tasks[index].category = category.rawValue
            tasks[index].priority = priority.rawValue
            tasks[index].dueDate = dueDate
            saveTasks()
        }
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        var reorderedTasks = filteredTasks
        reorderedTasks.move(fromOffsets: source, toOffset: destination)
        
        for (index, task) in reorderedTasks.enumerated() {
            if let originalIndex = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[originalIndex].order = index
            }
        }
        
        saveTasks()
    }
    
    // MARK: - Category Operations
    func setSelectedCategory(_ category: TaskCategory?) {
        selectedCategory = category
    }
    
    func clearSelectedCategory() {
        selectedCategory = nil
    }
    
    // MARK: - Statistics
    func tasksCount(for category: TaskCategory) -> Int {
        return tasks.filter { $0.category == category.rawValue }.count
    }
    
    func completedTasksCount(for category: TaskCategory) -> Int {
        return tasks.filter { $0.category == category.rawValue && $0.isCompleted }.count
    }
    
    func completionPercentage(for category: TaskCategory) -> Double {
        let totalTasks = tasksCount(for: category)
        guard totalTasks > 0 else { return 0.0 }
        let completedTasks = completedTasksCount(for: category)
        return Double(completedTasks) / Double(totalTasks)
    }
    
    // MARK: - Sample Data
    func addSampleData() {
        guard tasks.isEmpty else { return }
        
        let sampleTasks = [
            ("Complete project proposal", "Finish the Q4 project proposal and send to client", TaskCategory.work, TaskPriority.high),
            ("Buy groceries", "Milk, bread, eggs, and vegetables", TaskCategory.shopping, TaskPriority.medium),
            ("Morning workout", "30 minutes cardio and strength training", TaskCategory.health, TaskPriority.medium),
            ("Read SwiftUI book", "Chapter 5: Advanced animations", TaskCategory.education, TaskPriority.low),
            ("Plan weekend trip", "Research destinations and book accommodation", TaskCategory.travel, TaskPriority.low),
            ("Review monthly budget", "Check expenses and plan for next month", TaskCategory.finance, TaskPriority.medium),
            ("Call dentist", "Schedule annual checkup", TaskCategory.health, TaskPriority.low),
            ("Organize workspace", "Clean desk and organize files", TaskCategory.personal, TaskPriority.low)
        ]
        
        for (title, description, category, priority) in sampleTasks {
            addTask(title: title, description: description, category: category, priority: priority)
        }
    }
}
