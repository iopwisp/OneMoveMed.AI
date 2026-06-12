import SwiftUI

/// Все демо-данные приложения в одном месте.
/// Никаких сетевых запросов и БД — только статичные mock-объекты.
enum MockData {

    // MARK: - Пользователь
    static let user = UserProfile(
        fullName: "Айдана Нурланова",
        city: "Астана",
        phone: "+7 771 524 2544",
        avatarSystemImage: "person.crop.circle.fill",
        insurancePolicy: "ОСМС · активен",
        bloodType: "II (A+)"
    )

    // MARK: - Врачи
    static let doctors: [Doctor] = [
        Doctor(name: "Анварова Г. М.", specialty: "Терапевт",
               clinic: "Городская поликлиника №3", rating: 4.9,
               avatarSystemImage: "stethoscope", isOnlineNow: true),
        Doctor(name: "Сериков Д. А.", specialty: "Кардиолог",
               clinic: "Медцентр «Сункар»", rating: 4.8,
               avatarSystemImage: "heart.text.square.fill", isOnlineNow: true),
        Doctor(name: "Жумабекова А. К.", specialty: "Невролог",
               clinic: "Клиника OneMoveMed", rating: 4.7,
               avatarSystemImage: "brain.head.profile", isOnlineNow: false),
        Doctor(name: "Оспанов Е. Т.", specialty: "Дерматолог",
               clinic: "Медцентр «Сункар»", rating: 4.6,
               avatarSystemImage: "allergens", isOnlineNow: true)
    ]

    // MARK: - Записи на приём
    static let appointments: [Appointment] = [
        Appointment(doctor: doctors[0],
                    date: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
                    status: .upcoming, kind: .inPerson,
                    reason: "Плановый осмотр"),
        Appointment(doctor: doctors[1],
                    date: Calendar.current.date(byAdding: .day, value: 4, to: .now)!,
                    status: .upcoming, kind: .telemedicine,
                    reason: "Контроль давления"),
        Appointment(doctor: doctors[2],
                    date: Calendar.current.date(byAdding: .day, value: -6, to: .now)!,
                    status: .completed, kind: .inPerson,
                    reason: "Головные боли")
    ]

    // MARK: - Сообщения AI-чата (стартовый диалог)
    static let chatHistory: [ChatMessage] = [
        ChatMessage(text: "Здравствуйте! Я AI-ассистент OneMoveMed. Помогу записаться к врачу, напомню о лекарствах и отвечу на вопросы 24/7. Чем могу помочь?",
                    isFromUser: false, time: .now)
    ]

    /// Быстрые «умные» ответы ассистента для демо-сценария.
    static let chatSuggestions: [String] = [
        "Записаться к врачу",
        "Напомнить о лекарствах",
        "Болит голова, что делать?",
        "Вызвать телемедицину"
    ]

    // MARK: - Лекарства
    static let medications: [Medication] = [
        Medication(name: "Аспирин Кардио", dosage: "100 мг",
                   frequency: .once, times: ["08:00"],
                   colorTag: Theme.Colors.danger, takenToday: true),
        Medication(name: "Магний B6", dosage: "1 таблетка",
                   frequency: .twice, times: ["09:00", "21:00"],
                   colorTag: Theme.Colors.info, takenToday: false),
        Medication(name: "Витамин D3", dosage: "2000 МЕ",
                   frequency: .once, times: ["12:00"],
                   colorTag: Theme.Colors.warning, takenToday: false)
    ]

    // MARK: - Показатели здоровья (аналитика)
    static let metrics: [HealthMetric] = [
        HealthMetric(title: "Пульс", value: "72", unit: "уд/мин",
                     icon: "heart.fill", tint: Theme.Colors.danger,
                     trend: [0.4, 0.5, 0.45, 0.6, 0.55, 0.5, 0.58]),
        HealthMetric(title: "Давление", value: "120/80", unit: "мм рт.ст.",
                     icon: "waveform.path.ecg", tint: Theme.Colors.info,
                     trend: [0.5, 0.55, 0.5, 0.52, 0.48, 0.5, 0.51]),
        HealthMetric(title: "Шаги", value: "8 240", unit: "за день",
                     icon: "figure.walk", tint: Theme.Colors.success,
                     trend: [0.3, 0.5, 0.4, 0.7, 0.6, 0.8, 0.75]),
        HealthMetric(title: "Сон", value: "7.2", unit: "часа",
                     icon: "bed.double.fill", tint: Theme.Colors.accent,
                     trend: [0.6, 0.5, 0.65, 0.7, 0.6, 0.68, 0.72])
    ]

    // MARK: - Быстрые действия (главный экран)
    static let quickActions: [QuickAction] = [
        QuickAction(title: "Запись\nна приём", icon: "calendar.badge.plus",
                    tint: Theme.Colors.info, destination: .appointments),
        QuickAction(title: "Телемеди-\nцина", icon: "video.fill",
                    tint: Theme.Colors.accent, destination: .appointments),
        QuickAction(title: "AI чат-бот", icon: "message.fill",
                    tint: Color.purple, destination: .chat),
        QuickAction(title: "Мои\nлекарства", icon: "pills.fill",
                    tint: Theme.Colors.success, destination: .medications)
    ]

    // MARK: - Рекомендации
    static let recommendations: [Recommendation] = [
        Recommendation(title: "Профилактический осмотр",
                       subtitle: "Регулярная проверка здоровья",
                       icon: "checkmark.shield.fill", tint: Theme.Colors.success),
        Recommendation(title: "Вакцинация",
                       subtitle: "Будьте защищены",
                       icon: "syringe.fill", tint: Theme.Colors.info),
        Recommendation(title: "Здоровый образ жизни",
                       subtitle: "Двигайтесь больше",
                       icon: "figure.run", tint: Theme.Colors.warning),
        Recommendation(title: "Психологическая поддержка",
                       subtitle: "Забота о ментальном здоровье",
                       icon: "brain.head.profile", tint: Color.purple)
    ]

    // MARK: - Слайды онбординга
    static let onboardingSlides: [OnboardingSlide] = [
        OnboardingSlide(icon: "cross.case.fill",
                        title: "OneMoveMed.AI",
                        subtitle: "Экосистема здравоохранения. Здоровье — всего в одном шаге от вас."),
        OnboardingSlide(icon: "headphones",
                        title: "AI-оператор 24/7",
                        subtitle: "Круглосуточная поддержка, ответы на вопросы и запись на приём без очередей."),
        OnboardingSlide(icon: "video.fill",
                        title: "Телемедицина",
                        subtitle: "Виртуальные консультации с врачами и маршрутизация пациента к нужному специалисту."),
        OnboardingSlide(icon: "bell.badge.fill",
                        title: "Напоминания и аналитика",
                        subtitle: "Контроль приёма лекарств и наблюдение за показателями здоровья.")
    ]
}
