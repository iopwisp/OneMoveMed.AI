import SwiftUI

// MARK: - Главный экран

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var user = MockData.user
    @Published var quickActions = MockData.quickActions
    @Published var recommendations = MockData.recommendations

    /// Ближайшая предстоящая запись.
    var nextAppointment: Appointment? {
        MockData.appointments
            .filter { $0.status == .upcoming }
            .sorted { $0.date < $1.date }
            .first
    }
}

// MARK: - AI-чат

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = MockData.chatHistory
    @Published var draft: String = ""
    @Published var isTyping = false

    let suggestions = MockData.chatSuggestions

    /// Отправка сообщения пользователем + имитация ответа ассистента.
    func send(_ text: String? = nil) {
        let content = (text ?? draft).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }

        messages.append(ChatMessage(text: content, isFromUser: true, time: .now))
        draft = ""
        simulateAssistantReply(to: content)
    }

    /// Demo: «умный» ответ выбирается по ключевым словам (без реального AI).
    private func simulateAssistantReply(to text: String) {
        isTyping = true
        let reply = Self.cannedReply(for: text)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.isTyping = false
            self.messages.append(ChatMessage(text: reply, isFromUser: false, time: .now))
        }
    }

    private static func cannedReply(for text: String) -> String {
        let t = text.lowercased()
        if t.contains("запис") || t.contains("врач") {
            return "Подберу свободное время. Ближайший терапевт — Анварова Г. М., завтра в 10:30. Открываю раздел «Записи» 📅"
        }
        if t.contains("лекарств") || t.contains("таблет") {
            return "Сегодня по плану: Магний B6 в 21:00 и Витамин D3 в 12:00. Напомнить за 15 минут? 💊"
        }
        if t.contains("голов") || t.contains("боль") {
            return "Отдохните в тихом помещении и выпейте воды. Если боль сильная или долго не проходит — рекомендую телемедицину с неврологом. Вызвать врача онлайн?"
        }
        if t.contains("телемед") || t.contains("онлайн") {
            return "Сейчас онлайн доступны 3 врача. Подключить видеоконсультацию с терапевтом прямо сейчас? 🎥"
        }
        return "Принял ваш запрос. Я круглосуточный AI-оператор OneMoveMed и помогу с записью, лекарствами и телемедициной. Уточните, что нужно?"
    }
}

// MARK: - Записи на приём

@MainActor
final class AppointmentsViewModel: ObservableObject {
    @Published var appointments: [Appointment] = MockData.appointments

    var upcoming: [Appointment] {
        appointments.filter { $0.status == .upcoming }.sorted { $0.date < $1.date }
    }

    var past: [Appointment] {
        appointments.filter { $0.status != .upcoming }.sorted { $0.date > $1.date }
    }

    func cancel(_ appointment: Appointment) {
        guard let idx = appointments.firstIndex(where: { $0.id == appointment.id }) else { return }
        appointments[idx].status = .cancelled
    }
}

// MARK: - Лекарства

@MainActor
final class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = MockData.medications

    var takenCount: Int { medications.filter { $0.takenToday }.count }
    var total: Int { medications.count }
    var progress: Double { total == 0 ? 0 : Double(takenCount) / Double(total) }

    func toggleTaken(_ med: Medication) {
        guard let idx = medications.firstIndex(where: { $0.id == med.id }) else { return }
        medications[idx].takenToday.toggle()
    }
}

// MARK: - Аналитика

@MainActor
final class AnalyticsViewModel: ObservableObject {
    @Published var metrics: [HealthMetric] = MockData.metrics
}
