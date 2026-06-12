import SwiftUI

/// Точка входа в приложение.
/// Demo-MVP: вся навигация строится вокруг Onboarding -> RootTabView.
@main
struct OneMoveMedAIApp: App {
    /// Простое состояние «прошёл ли пользователь онбординг».
    /// В demo хранится только в памяти (без backend и авторизации).
    @State private var didFinishOnboarding = false

    var body: some Scene {
        WindowGroup {
            if didFinishOnboarding {
                RootTabView()
                    .transition(.opacity)
            } else {
                OnboardingView {
                    withAnimation(.easeInOut) {
                        didFinishOnboarding = true
                    }
                }
                .transition(.opacity)
            }
        }
    }
}
