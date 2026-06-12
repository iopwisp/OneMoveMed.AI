import SwiftUI

/// Вкладки нижнего TabBar.
/// `quickActions` на главном экране используют эти значения для навигации.
enum AppTab: Int, CaseIterable, Identifiable {
    case home
    case chat
    case appointments
    case medications
    case profile

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home:         return "Главная"
        case .chat:         return "AI-чат"
        case .appointments: return "Записи"
        case .medications:  return "Лекарства"
        case .profile:      return "Профиль"
        }
    }

    var icon: String {
        switch self {
        case .home:         return "house.fill"
        case .chat:         return "message.fill"
        case .appointments: return "calendar"
        case .medications:  return "pills.fill"
        case .profile:      return "person.fill"
        }
    }
}
