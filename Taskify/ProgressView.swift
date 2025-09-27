import SwiftUI

struct TaskProgressView: View {
    let completedTasks: Int
    let totalTasks: Int
    let progress: Double
    
    var body: some View {
        VStack(spacing: 12) {
            // Progress Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Progress")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("\(completedTasks) of \(totalTasks) tasks completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    // Progress Fill
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 12)
                        .animation(.easeInOut(duration: 0.8), value: progress)
                }
            }
            .frame(height: 12)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct CategoryProgressView: View {
    let category: TaskCategory
    let completedCount: Int
    let totalCount: Int
    let progress: Double
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundColor(category.color)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(category.color.opacity(0.1))
                )
            
            // Category Info
            VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("\(completedCount)/\(totalCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Mini Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(category.color)
                        .frame(width: geometry.size.width * progress, height: 6)
                        .animation(.easeInOut(duration: 0.6), value: progress)
                }
            }
            .frame(width: 60, height: 6)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
}

struct StatisticsView: View {
    let taskManager: TaskManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Overall Progress
            TaskProgressView(
                completedTasks: taskManager.completedTasks.count,
                totalTasks: taskManager.tasks.count,
                progress: taskManager.completionPercentage
            )
            
            // Category Breakdown
            if !taskManager.tasks.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("By Category")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    LazyVStack(spacing: 6) {
                        ForEach(TaskCategory.allCases) { category in
                            let totalCount = taskManager.tasksCount(for: category)
                            let completedCount = taskManager.completedTasksCount(for: category)
                            let progress = taskManager.completionPercentage(for: category)
                            
                            if totalCount > 0 {
                                CategoryProgressView(
                                    category: category,
                                    completedCount: completedCount,
                                    totalCount: totalCount,
                                    progress: progress
                                )
                            }
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
            }
        }
    }
}

// MARK: - Animated Progress Ring
struct AnimatedProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    init(progress: Double, lineWidth: CGFloat = 8, size: CGFloat = 100) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [.blue, .purple, .pink, .blue],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animatedProgress)
            
            // Progress Text
            Text("\(Int(progress * 100))%")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}
