import SwiftUI

/// Детали записи: карточка врача, информация о приёме и действия
/// (присоединиться к видео / отменить). Demo, без backend.
struct AppointmentDetailView: View {
    let appointment: Appointment
    var onCancel: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var showVideoCall = false

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.lg) {
                doctorCard
                infoCard
                if appointment.status == .upcoming { actions }
            }
            .padding(Theme.Spacing.md)
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle("Детали записи")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showVideoCall) {
            VideoCallMockView(doctor: appointment.doctor)
        }
    }

    // MARK: Врач
    private var doctorCard: some View {
        VStack(spacing: Theme.Spacing.sm) {
            DoctorAvatar(doctor: appointment.doctor, size: 84)
            Text(appointment.doctor.name).font(.title3.bold())
                .foregroundColor(Theme.Colors.textPrimary)
            Text(appointment.doctor.specialty).font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
            HStack(spacing: 4) {
                Image(systemName: "star.fill").foregroundColor(Theme.Colors.warning)
                Text(String(format: "%.1f", appointment.doctor.rating))
                Text("·").foregroundColor(Theme.Colors.textSecondary)
                Text(appointment.doctor.clinic)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .softCard()
    }

    // MARK: Информация
    private var infoCard: some View {
        VStack(spacing: Theme.Spacing.sm) {
            infoRow(icon: appointment.kind.icon, title: "Формат",
                    value: appointment.kind.rawValue, tint: Theme.Colors.accent)
            Divider()
            infoRow(icon: "calendar", title: "Дата и время",
                    value: appointment.date.formatted(date: .long, time: .shortened),
                    tint: Theme.Colors.info)
            Divider()
            infoRow(icon: "doc.text", title: "Причина",
                    value: appointment.reason, tint: Theme.Colors.success)
            Divider()
            infoRow(icon: "checkmark.seal", title: "Статус",
                    value: appointment.status.rawValue, tint: appointment.status.color)
        }
        .softCard()
    }

    private func infoRow(icon: String, title: String, value: String, tint: Color) -> some View {
        HStack(spacing: Theme.Spacing.md) {
            IconBadge(systemName: icon, tint: tint, size: 38)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundColor(Theme.Colors.textSecondary)
                Text(value).font(.subheadline.weight(.medium))
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            Spacer()
        }
    }

    // MARK: Действия
    private var actions: some View {
        VStack(spacing: Theme.Spacing.sm) {
            if appointment.kind == .telemedicine {
                PrimaryButton(title: "Присоединиться к видео", icon: "video.fill") {
                    showVideoCall = true
                }
            }
            Button(role: .destructive) {
                onCancel?()
                dismiss()
            } label: {
                Text("Отменить запись")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.Colors.danger.opacity(0.12))
                    .foregroundColor(Theme.Colors.danger)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}
