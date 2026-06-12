import SwiftUI

/// Экран аналитики здоровья: карточки показателей с мини-графиками
/// и сводка по маршрутизации пациента (из презентации).
struct AnalyticsView: View {
    @StateObject private var vm = AnalyticsViewModel()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                LazyVGrid(columns: columns, spacing: Theme.Spacing.sm) {
                    ForEach(vm.metrics) { metric in
                        MetricCard(metric: metric)
                    }
                }
                routingSummary
            }
            .padding(Theme.Spacing.md)
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Аналитика")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Сводка маршрутизации пациента
    private var routingSummary: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            SectionHeader(title: "Маршрутизация пациента")
            HStack(spacing: Theme.Spacing.md) {
                statTile(value: "20+", label: "Обращений", tint: Theme.Colors.accent)
                statTile(value: "5", label: "Экстренных", tint: Theme.Colors.danger)
                statTile(value: "20", label: "Квот", tint: Theme.Colors.success)
            }
            Text("AI-оператор обработал обращения и направил пациентов к нужным специалистам, снизив нагрузку на персонал.")
                .font(.caption).foregroundColor(Theme.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .softCard()
    }

    private func statTile(value: String, label: String, tint: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title.bold()).foregroundColor(tint)
            Text(label).font(.caption2).foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.sm)
        .background(tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
    }
}

// MARK: - Карточка показателя

struct MetricCard: View {
    let metric: HealthMetric

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                IconBadge(systemName: metric.icon, tint: metric.tint, size: 38)
                Spacer()
            }
            Text(metric.title).font(.caption).foregroundColor(Theme.Colors.textSecondary)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(metric.value).font(.title3.bold())
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(metric.unit).font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            Sparkline(points: metric.trend, tint: metric.tint)
                .frame(height: 28)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .softCard()
    }
}
