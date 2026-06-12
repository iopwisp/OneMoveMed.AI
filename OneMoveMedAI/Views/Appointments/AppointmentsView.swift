import SwiftUI

/// Экран записей: предстоящие и прошедшие приёмы + вход в телемедицину.
struct AppointmentsView: View {
    @StateObject private var vm = AppointmentsViewModel()
    @State private var showTelemedicine = false
    @State private var showBooking = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    telemedicineBanner

                    if !vm.upcoming.isEmpty {
                        section(title: "Предстоящие", items: vm.upcoming, cancellable: true)
                    }
                    if !vm.past.isEmpty {
                        section(title: "История", items: vm.past, cancellable: false)
                    }
                }
                .padding(Theme.Spacing.md)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Записи")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showBooking = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.Colors.accent)
                    }
                }
            }
            .sheet(isPresented: $showTelemedicine) {
                TelemedicineView()
            }
            .sheet(isPresented: $showBooking) {
                BookingView(vm: vm)
            }
        }
    }

    // MARK: Баннер телемедицины
    private var telemedicineBanner: some View {
        Button { showTelemedicine = true } label: {
            HStack(spacing: Theme.Spacing.md) {
                IconBadge(systemName: "video.fill", tint: .white, size: 50)
                    .background(Color.white.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 3) {
                    Text("Телемедицина").font(.headline).foregroundColor(.white)
                    Text("Видеоконсультация с врачом онлайн")
                        .font(.caption).foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.white)
            }
            .padding(Theme.Spacing.lg)
            .background(
                LinearGradient(colors: [Theme.Colors.accent, Theme.Colors.accentDark],
                               startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .shadow(color: Theme.Colors.accent.opacity(0.3), radius: 14, y: 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: Секция списка
    private func section(title: String, items: [Appointment], cancellable: Bool) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: title)
            ForEach(items) { appt in
                NavigationLink {
                    AppointmentDetailView(appointment: appt,
                                          onCancel: cancellable ? { vm.cancel(appt) } : nil)
                } label: {
                    AppointmentRow(appointment: appt,
                                   onCancel: cancellable ? { vm.cancel(appt) } : nil)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Строка записи

struct AppointmentRow: View {
    let appointment: Appointment
    var onCancel: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.md) {
                DoctorAvatar(doctor: appointment.doctor)
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.doctor.name).font(.subheadline.bold())
                        .foregroundColor(Theme.Colors.textPrimary)
                    Text("\(appointment.doctor.specialty) · \(appointment.reason)")
                        .font(.caption).foregroundColor(Theme.Colors.textSecondary)
                        .lineLimit(1)
                    Label(appointment.date.formatted(date: .abbreviated, time: .shortened),
                          systemImage: appointment.kind.icon)
                        .font(.caption2).foregroundColor(Theme.Colors.textSecondary)
                }
                Spacer()
                TagPill(text: appointment.status.rawValue, color: appointment.status.color)
            }

            if let onCancel {
                Divider()
                HStack {
                    Spacer()
                    Button(role: .destructive, action: onCancel) {
                        Text("Отменить запись").font(.caption.weight(.medium))
                    }
                }
            }
        }
        .softCard()
    }
}
