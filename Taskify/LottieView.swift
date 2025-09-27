import SwiftUI
import Lottie

struct LottieView: NSViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    @Binding var isPlaying: Bool
    
    init(name: String, loopMode: LottieLoopMode = .playOnce, animationSpeed: CGFloat = 1.0, isPlaying: Binding<Bool> = .constant(true)) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self._isPlaying = isPlaying
    }
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let animationView = LottieAnimationView(name: name)
        
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        context.coordinator.animationView = animationView
        
        if isPlaying {
            animationView.play()
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        guard let animationView = context.coordinator.animationView else { return }
        
        if isPlaying {
            animationView.play()
        } else {
            animationView.stop()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var animationView: LottieAnimationView?
    }
}

// MARK: - Completion Animation
struct CompletionAnimationView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Lottie animation (if available)
            LottieView(
                name: "checkmark",
                loopMode: .playOnce,
                animationSpeed: 1.5,
                isPlaying: .constant(isAnimating)
            )
            .frame(width: 60, height: 60)
            .scaleEffect(scale)
            .opacity(opacity)
            
            // Fallback SwiftUI animation
            if !isAnimating {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.3)) {
                    scale = 0.0
                    opacity = 0.0
                }
            }
        }
    }
}

// MARK: - Task Completion Overlay
struct TaskCompletionOverlay: View {
    @Binding var isShowing: Bool
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowing = false
                    }
                }
            
            VStack(spacing: 20) {
                CompletionAnimationView()
                
                Text("Task Completed!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Great job! Keep up the momentum.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 20)
            )
            .scaleEffect(isShowing ? 1.0 : 0.5)
            .opacity(isShowing ? 1.0 : 0.0)
        }
        .onAppear {
            onComplete()
        }
    }
}
