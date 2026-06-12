import SwiftUI

/// Экран напоминаний о лекарствах: прогресс за день + список с отметкой приёма.
struct MedicationsView: View {
    @StateObject private var vm = MedicationViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    progressCard
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        SectionHeader(title: "Сегодня")
                        ForEach(vm.medications) { med in
                            MedicationRow(medication: med) { vm.toggleTaken(med) }
                        }
                    }
                }
                .padding(Theme.Spacing.md)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Лекарства")
        }
    }

    // MARK: Прогресс приёма
    private var progressCard: some View {
        HStack(spacing: Theme.Spacing.lg) {
            ZStack {
                Circle().stroke(Theme.Colors.accentSoft, lineWidth: 10)
                Circle()
                    .trim(from: 0, to: vm.progress)
                    .stroke(Theme.Colors.accent,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: vm.progress)
                Text("\(Int(vm.progress * 100))%")
                    .font(.headline.bold()).foregroundColor(Theme.Colors.textPrimary)
            }
            .frame(width: 80, height: 80)

            VStack(alignment: .leading, spacing: 6) {
                Text("Приём по плану")
                    .font(.headline).foregroundColor(Theme.Colors.textPrimary)
                Text("Принято \(vm.takenCount) из \(vm.total) на сегодня")
                    .font(.subheadline).foregroundColor(Theme.Colors.textSecondary)
                if vm.takenCount == vm.total {
                    Label("Все лекарства приняты", systemImage: "checkmark.seal.fill")
                        .font(.caption).foregroundColor(Theme.Colors.success)
                }
            }
            Spacer()
        }
        .softCard()
    }
}

// MARK: - Строка лекарства

struct MedicationRow: View {
    let medication: Medication
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            RoundedRectangle(cornerRadius: 6)
                .fill(medication.colorTag)
                .frame(width: 5, height: 46)

            IconBadge(systemName: "pills.fill", tint: medication.colorTag)

            VStack(alignment: .leading, spacing: 3) {
                Text(medication.name).font(.subheadline.bold())
                    .foregroundColor(Theme.Colors.textPrimary)
                Text("\(medication.dosage) · \(medication.frequency.rawValue)")
                    .font(.caption).foregroundColor(Theme.Colors.textSecondary)
                HStack(spacing: 4) {
                    Image(systemName: "clock").font(.caption2)
                    Text(medication.times.joined(separator: ", "))
                        .font(.caption2)
                }
                .foregroundColor(Theme.Colors.textSecondary)
            }
            Spacer()
            Button(action: onToggle) {
                Image(systemName: medication.takenToday ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(medication.takenToday ? Theme.Colors.success : Theme.Colors.textSecondary.opacity(0.4))
            }
            .buttonStyle(.plain)
        }
        .softCard()
    }
}
