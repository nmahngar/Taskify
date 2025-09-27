import Foundation
import SwiftUI

class BackgroundManager: ObservableObject {
    @Published var selectedTheme: BackgroundTheme = .gradient
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "selectedBackgroundTheme"
    
    init() {
        loadSelectedTheme()
    }
    
    func setTheme(_ theme: BackgroundTheme) {
        selectedTheme = theme
        saveSelectedTheme()
    }
    
    private func loadSelectedTheme() {
        if let themeRawValue = userDefaults.string(forKey: themeKey),
           let theme = BackgroundTheme(rawValue: themeRawValue) {
            selectedTheme = theme
        }
    }
    
    private func saveSelectedTheme() {
        userDefaults.set(selectedTheme.rawValue, forKey: themeKey)
    }
    
    var backgroundView: some View {
        Group {
            if selectedTheme.isGradient {
                LinearGradient(
                    colors: selectedTheme.colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: selectedTheme.colors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
    }
}
