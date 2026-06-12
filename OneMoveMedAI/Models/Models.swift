import SwiftUI

// MARK: - Пользователь

/// Профиль пациента (demo, без авторизации).
struct UserProfile: Identifiable {
    let id = UUID()
    var fullName: String
    var city: String
    var phone: String
    var avatarSystemImage: String
    var insurancePolicy: String
    var bloodType: String
}

// MARK: - Врач

struct Doctor: Identifiable {
    let id = UUID()
    var name: String
    var specialty: String
    var clinic: String
    var rating: Double
    var avatarSystemImage: String
    /// Доступен ли врач для онлайн-консультации прямо сейчас.
    var isOnlineNow: Bool
}

// MARK: - Запись на приём

enum AppointmentStatus: String {
    case upcoming = "Предстоит"
    case completed = "Завершён"
    case cancelled = "Отменён"

    var color: Color {
        switch self {
        case .upcoming:  return Theme.Colors.info
        case .completed: return Theme.Colors.success
        case .cancelled: return Theme.Colors.danger
        }
    }
}

enum AppointmentKind: String {
    case inPerson = "Очно"
    case telemedicine = "Онлайн"

    var icon: String {
        switch self {
        case .inPerson:     return "building.2.fill"
        case .telemedicine: return "video.fill"
        }
    }
}

struct Appointment: Identifiable {
    let id = UUID()
    var doctor: Doctor
    var date: Date
    var status: AppointmentStatus
    var kind: AppointmentKind
    var reason: String
}

// MARK: - Чат с AI-ассистентом

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var isFromUser: Bool
    var time: Date
}

// MARK: - Напоминания о лекарствах

enum MedicationFrequency: String {
    case once = "1 раз в день"
    case twice = "2 раза в день"
    case thrice = "3 раза в день"
}

struct Medication: Identifiable {
    let id = UUID()
    var name: String
    var dosage: String
    var frequency: MedicationFrequency
    var times: [String]      // например ["08:00", "20:00"]
    var colorTag: Color
    var takenToday: Bool
}

// MARK: - Аналитика / показатели здоровья

struct HealthMetric: Identifiable {
    let id = UUID()
    var title: String
    var value: String
    var unit: String
    var icon: String
    var tint: Color
    /// Точки для мини-графика (нормализованные значения).
    var trend: [Double]
}

// MARK: - Быстрое действие на главном экране

struct QuickAction: Identifiable {
    let id = UUID()
    var title: String
    var icon: String
    var tint: Color
    var destination: AppTab
}

// MARK: - Рекомендация (карточки «Рекомендуем для вас»)

struct Recommendation: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var icon: String
    var tint: Color
}
