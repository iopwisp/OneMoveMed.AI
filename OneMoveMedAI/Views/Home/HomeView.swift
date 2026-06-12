import SwiftUI

/// Главный экран: приветствие, баннер AI-помощника, быстрые действия,
/// ближайшая запись, рекомендации и блок экстренной помощи.
struct HomeView: View {
    @Binding var selection: AppTab
    @StateObject private var vm = HomeViewModel()

    private let columns = [GridItem(.flexible()), GridItem(.flexible()),
                           GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                header.appear(index: 0)
                assistantBanner.appear(index: 1)
                quickActionsGrid.appear(index: 2)
                if let next = vm.nextAppointment {
                    nextAppointmentCard(next).appear(index: 3)
                }
                recommendationsSection.appear(index: 4)
                emergencyCard.appear(index: 5)
            }
            .padding(Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Theme.Colors.background.ignoresSafeArea())
    }

    // MARK: Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Здравствуйте,")
                    .font(.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                Text(vm.user.fullName)
                    .font(.title2.bold())
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            Spacer()
            Image(systemName: vm.user.avatarSystemImage)
                .font(.system(size: 40))
                .foregroundColor(Theme.Colors.accent)
        }
    }

    // MARK: Баннер AI-помощника
    private var assistantBanner: some View {
        Button {
            selection = .chat
        } label: {
            HStack(spacing: Theme.Spacing.md) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ваш AI-помощник 24/7")
                        .font(.headline).foregroundColor(.white)
                    Text("Консультация, запись и контроль здоровья в одном приложении")
                        .font(.caption).foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 6) {
                        Image(systemName: "message.fill")
                        Text("Чат с AI").fontWeight(.semibold)
                    }
                    .font(.caption)
                    .padding(.horizontal, 12).padding(.vertical, 7)
                    .background(.white)
                    .foregroundColor(Theme.Colors.accentDark)
                    .clipShape(Capsule())
                    .padding(.top, 2)
                }
                Spacer()
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 52))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(Theme.Spacing.lg)
            .background(
                LinearGradient(colors: [Theme.Colors.accent, Theme.Colors.accentDark],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .shadow(color: Theme.Colors.accent.opacity(0.35), radius: 16, y: 8)
        }
        .buttonStyle(.plain)
    }

    // MARK: Быстрые действия
    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Быстрые действия")
            LazyVGrid(columns: columns, spacing: Theme.Spacing.sm) {
                ForEach(vm.quickActions) { action in
                    QuickActionButton(action: action) {
                        selection = action.destination
                    }
                }
            }
        }
    }

    // MARK: Ближайшая запись
    private func nextAppointmentCard(_ appt: Appointment) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Ближайшая запись", actionTitle: "Все") {
                selection = .appointments
            }
            HStack(spacing: Theme.Spacing.md) {
                DoctorAvatar(doctor: appt.doctor)
                VStack(alignment: .leading, spacing: 4) {
                    Text(appt.doctor.name).font(.subheadline.bold())
                        .foregroundColor(Theme.Colors.textPrimary)
                    Text(appt.doctor.specialty).font(.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                    Label(appt.date.formatted(date: .abbreviated, time: .shortened),
                          systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                Spacer()
                TagPill(text: appt.kind.rawValue, color: Theme.Colors.accent)
            }
            .softCard()
        }
    }

    // MARK: Рекомендации
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Рекомендуем для вас")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(vm.recommendations) { rec in
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            IconBadge(systemName: rec.icon, tint: rec.tint)
                            Text(rec.title).font(.subheadline.weight(.semibold))
                                .foregroundColor(Theme.Colors.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(rec.subtitle).font(.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(width: 150, alignment: .leading)
                        .softCard()
                    }
                }
            }
        }
    }

    // MARK: Экстренная помощь
    private var emergencyCard: some View {
        HStack(spacing: Theme.Spacing.md) {
            IconBadge(systemName: "phone.fill", tint: Theme.Colors.danger, size: 48)
            VStack(alignment: .leading, spacing: 2) {
                Text("Нужна срочная помощь?")
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.Colors.textPrimary)
                Text("AI Call Center работает 24/7 · +7 771 524 2544")
                    .font(.caption).foregroundColor(Theme.Colors.textSecondary)
            }
            Spacer()
            Text("24/7").font(.headline.bold()).foregroundColor(Theme.Colors.danger)
        }
        .softCard()
    }
}
