# OneMoveMed.AI — iOS Demo (SwiftUI MVP)

Демо-прототип мобильного приложения **OneMoveMed.AI** — когнитивной экосистемы
здравоохранения. Сделан для показа идеи продукта инвестору или на хакатоне.

> ⚠️ Это **demo-MVP**: без backend, без реальной авторизации, без интеграций
> (AI / Telegram / WhatsApp / медсистемы / API / БД). Все данные — моковые.

## 💡 Идея

«Здоровье — всего в одном шаге от вас». Приложение объединяет AI-оператора 24/7,
чат-бота, телемедицину, напоминания о лекарствах, аналитику здоровья и
маршрутизацию пациента к нужному специалисту — чтобы расширить доступ к
медуслугам и сократить бюрократию.

## 🛠 Стек

- **SwiftUI** (iOS 16+, `NavigationStack`, `TabView`)
- **MVVM** (`ObservableObject` ViewModels)
- **Mock Data** (статичные данные, без сети)

## 📱 Экраны

| Экран | Что показывает |
|-------|----------------|
| **Onboarding** | 4 слайда-интро о ключевых возможностях |
| **Home** | Приветствие, баннер AI-помощника, быстрые действия, ближайшая запись, рекомендации, блок 24/7 |
| **AI Assistant Chat** | Чат с имитацией ответов ассистента + быстрые подсказки + индикатор «печатает» |
| **Appointments** | Предстоящие/прошедшие записи, отмена записи, вход в телемедицину, кнопка «+» |
| **Booking** | Запись на приём: выбор врача → формата → даты → слота → подтверждение |
| **Appointment Detail** | Карточка врача, инфо о приёме, «Присоединиться к видео» / отмена |
| **Telemedicine** | Врачи онлайн + имитация видеозвонка |
| **Medications** | Напоминания о лекарствах, прогресс приёма за день, отметка «принято» |
| **Analytics** | Карточки показателей с мини-графиками + сводка маршрутизации пациента |
| **Profile / Settings** | Медкарта, настройки (переключатели), вход в аналитику, о проекте |

## 📂 Структура проекта

```
OneMoveMedAI/
├── App/
│   ├── OneMoveMedAIApp.swift     # @main, Onboarding -> RootTabView
│   └── AppTab.swift              # вкладки TabBar
├── Theme/
│   └── Theme.swift               # цвета, отступы, стиль карточек
├── Models/
│   └── Models.swift              # User, Doctor, Appointment, ChatMessage, Medication, HealthMetric…
├── MockData/
│   └── MockData.swift            # все демо-данные
├── ViewModels/
│   └── ViewModels.swift          # Home/Chat/Appointments/Medication/Analytics VM
├── Components/
│   └── Components.swift          # SectionHeader, IconBadge, QuickActionButton, PrimaryButton, Sparkline…
└── Views/
    ├── RootTabView.swift         # нижний TabBar
    ├── Onboarding/OnboardingView.swift
    ├── Home/HomeView.swift
    ├── Chat/AIAssistantView.swift
    ├── Appointments/AppointmentsView.swift
    ├── Appointments/BookingView.swift
    ├── Appointments/AppointmentDetailView.swift
    ├── Telemedicine/TelemedicineView.swift
    ├── Medications/MedicationsView.swift
    ├── Analytics/AnalyticsView.swift
    └── Profile/ProfileView.swift
```

## ▶️ Как запустить (нужен macOS + Xcode 16+)

1. Открыть **`OneMoveMedAI.xcodeproj`** в Xcode (двойной клик).
2. Выбрать схему **OneMoveMedAI** и симулятор iPhone 15 / 16.
3. Нажать ▶️ Run.

Проект использует **синхронизированную файловую группу** (Xcode 16): все файлы
из папки `OneMoveMedAI/` подхватываются автоматически — добавлять их вручную
не нужно. Минимальная цель развёртывания — **iOS 16.0**. Все иконки —
системные **SF Symbols**.

> Если Xcode старше 16: создайте новый SwiftUI-проект `OneMoveMedAI` и
> перетащите в него содержимое папки `OneMoveMedAI/` (Copy items if needed).

📋 Готовый сценарий показа инвестору — см. [`DEMO.md`](DEMO.md).
🏗 Текст слайда «Технологии и архитектура» для питч-дека — см. [`ARCHITECTURE.md`](ARCHITECTURE.md).

## ✅ Что уже готово в demo

- Полная навигация: Onboarding → TabBar (5 вкладок) + sheet-экраны.
- 8 экранов из презентации с реальными пользовательскими сценариями.
- AI-чат с имитацией «умных» ответов по ключевым словам.
- Интерактив: отметка приёма лекарств, отмена записи, имитация видеозвонка.
- Единая дизайн-система (бирюзовый акцент, мягкие тени, стиль Apple Health).
- MVVM + переиспользуемые компоненты.

## 🔜 Что можно добавить позже

- Реальный backend (REST/GraphQL) и БД вместо `MockData`.
- Настоящую авторизацию (ОСМС / eGov / OTP).
- Реальную интеграцию AI (LLM-оператор, распознавание голоса).
- Каналы: телефон, WhatsApp, Telegram (многоканальность из презентации).
- Push-уведомления для напоминаний о лекарствах.
- Реальную видеосвязь (WebRTC) для телемедицины.
- Интеграцию с медицинскими информационными системами и страховыми.
- Локализацию (KZ/RU/EN), тёмную тему, доступность.

---

OneMoveMed.AI · demo MVP · Основатель: Адильхан Макашули · +7 771 524 2544
