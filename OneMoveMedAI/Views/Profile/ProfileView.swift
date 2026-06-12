import SwiftUI

/// Профиль пациента + настройки (demo, переключатели без сохранения).
/// Отсюда открывается экран «Аналитика».
struct ProfileView: View {
    private let user = MockData.user

    @State private var notificationsEnabled = true
    @State private var medRemindersEnabled = true
    @State private var darkModeEnabled = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    profileHeader
                    infoCard
                    NavigationLink {
                        AnalyticsView()
                    } label: {
                        menuRow(icon: "chart.bar.fill", tint: Theme.Colors.info,
                                title: "Аналитика здоровья", showChevron: true)
                            .softCard()
                    }
                    .buttonStyle(.plain)
                    settingsCard
                    aboutCard
                }
                .padding(Theme.Spacing.md)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Профиль")
        }
    }

    // MARK: Шапка профиля
    private var profileHeader: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: user.avatarSystemImage)
                .font(.system(size: 72))
                .foregroundColor(Theme.Colors.accent)
            Text(user.fullName).font(.title2.bold())
                .foregroundColor(Theme.Colors.textPrimary)
            Text("\(user.city) · \(user.phone)")
                .font(.subheadline).foregroundColor(Theme.Colors.textSecondary)
            TagPill(text: user.insurancePolicy, color: Theme.Colors.success)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.md)
    }

    // MARK: Медкарта
    private var infoCard: some View {
        HStack {
            infoTile(title: "Группа крови", value: user.bloodType, icon: "drop.fill",
                     tint: Theme.Colors.danger)
            Divider().frame(height: 40)
            infoTile(title: "Город", value: user.city, icon: "mappin.circle.fill",
                     tint: Theme.Colors.info)
        }
        .softCard()
    }

    private func infoTile(title: String, value: String, icon: String, tint: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).foregroundColor(tint).font(.title3)
            Text(value).font(.subheadline.bold()).foregroundColor(Theme.Colors.textPrimary)
            Text(title).font(.caption2).foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Настройки
    private var settingsCard: some View {
        VStack(spacing: Theme.Spacing.sm) {
            toggleRow(icon: "bell.fill", tint: Theme.Colors.warning,
                      title: "Уведомления", isOn: $notificationsEnabled)
            Divider()
            toggleRow(icon: "pills.fill", tint: Theme.Colors.success,
                      title: "Напоминания о лекарствах", isOn: $medRemindersEnabled)
            Divider()
            toggleRow(icon: "moon.fill", tint: Color.indigo,
                      title: "Тёмная тема", isOn: $darkModeEnabled)
        }
        .softCard()
    }

    // MARK: О проекте
    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            menuRow(icon: "cross.case.fill", tint: Theme.Colors.accent,
                    title: "О проекте OneMoveMed.AI", showChevron: false)
            Text("Экосистема здравоохранения для расширения доступа к медуслугам, ранней диагностики и поддержки пациентов 24/7.")
                .font(.caption).foregroundColor(Theme.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Text("Версия demo · MVP")
                .font(.caption2).foregroundColor(Theme.Colors.textSecondary.opacity(0.7))
        }
        .softCard()
    }

    // MARK: Переиспользуемые строки
    private func toggleRow(icon: String, tint: Color, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: Theme.Spacing.md) {
            IconBadge(systemName: icon, tint: tint, size: 36)
            Text(title).font(.subheadline).foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            Toggle("", isOn: isOn).labelsHidden().tint(Theme.Colors.accent)
        }
    }

    private func menuRow(icon: String, tint: Color, title: String, showChevron: Bool) -> some View {
        HStack(spacing: Theme.Spacing.md) {
            IconBadge(systemName: icon, tint: tint, size: 36)
            Text(title).font(.subheadline.weight(.medium))
                .foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption).foregroundColor(Theme.Colors.textSecondary)
            }
        }
    }
}
