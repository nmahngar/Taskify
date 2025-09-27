import Foundation
import SwiftUI
import CoreData

// MARK: - Task Category
enum TaskCategory: String, CaseIterable, Identifiable {
    case personal = "Personal"
    case work = "Work"
    case health = "Health"
    case shopping = "Shopping"
    case finance = "Finance"
    case education = "Education"
    case travel = "Travel"
    case other = "Other"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .personal:
            return .blue
        case .work:
            return .orange
        case .health:
            return .green
        case .shopping:
            return .purple
        case .finance:
            return .yellow
        case .education:
            return .indigo
        case .travel:
            return .cyan
        case .other:
            return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .personal:
            return "person.fill"
        case .work:
            return "briefcase.fill"
        case .health:
            return "heart.fill"
        case .shopping:
            return "cart.fill"
        case .finance:
            return "dollarsign.circle.fill"
        case .education:
            return "book.fill"
        case .travel:
            return "airplane"
        case .other:
            return "tag.fill"
        }
    }
}

// MARK: - Task Priority
enum TaskPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .orange
        case .urgent:
            return .red
        }
    }
    
    var icon: String {
        switch self {
        case .low:
            return "arrow.down.circle.fill"
        case .medium:
            return "minus.circle.fill"
        case .high:
            return "arrow.up.circle.fill"
        case .urgent:
            return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - Task Item
struct TaskItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var taskDescription: String?
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?
    var category: String
    var priority: String
    var order: Int
    
    init(title: String, description: String? = nil, category: TaskCategory, priority: TaskPriority, dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.taskDescription = description
        self.category = category.rawValue
        self.priority = priority.rawValue
        self.isCompleted = false
        self.createdAt = Date()
        self.dueDate = dueDate
        self.order = 0
    }
}

// MARK: - Background Theme
enum BackgroundTheme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case blue = "Blue"
    case purple = "Purple"
    case green = "Green"
    case orange = "Orange"
    case pink = "Pink"
    case gradient = "Gradient"
    
    var id: String { rawValue }
    
    var colors: [Color] {
        switch self {
        case .light:
            return [Color.white, Color.gray.opacity(0.1)]
        case .dark:
            return [Color.black, Color.gray.opacity(0.3)]
        case .blue:
            return [Color.blue.opacity(0.8), Color.blue.opacity(0.4)]
        case .purple:
            return [Color.purple.opacity(0.8), Color.purple.opacity(0.4)]
        case .green:
            return [Color.green.opacity(0.8), Color.green.opacity(0.4)]
        case .orange:
            return [Color.orange.opacity(0.8), Color.orange.opacity(0.4)]
        case .pink:
            return [Color.pink.opacity(0.8), Color.pink.opacity(0.4)]
        case .gradient:
            return [Color.blue.opacity(0.6), Color.purple.opacity(0.6), Color.pink.opacity(0.6)]
        }
    }
    
    var isGradient: Bool {
        return self == .gradient
    }
}
