import SwiftUI

/// Экран телемедицины: список врачей онлайн и имитация запуска видеозвонка.
struct TelemedicineView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var connectingDoctor: Doctor?

    private var doctors: [Doctor] { MockData.doctors }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    Text("Выберите врача для видеоконсультации прямо сейчас.")
                        .font(.subheadline).foregroundColor(Theme.Colors.textSecondary)

                    ForEach(doctors) { doctor in
                        DoctorOnlineRow(doctor: doctor) {
                            connectingDoctor = doctor
                        }
                    }
                }
                .padding(Theme.Spacing.md)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Телемедицина")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") { dismiss() }
                }
            }
            .sheet(item: $connectingDoctor) { doctor in
                VideoCallMockView(doctor: doctor)
            }
        }
    }
}

// MARK: - Строка врача (онлайн-статус)

struct DoctorOnlineRow: View {
    let doctor: Doctor
    let onCall: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack(alignment: .bottomTrailing) {
                DoctorAvatar(doctor: doctor)
                Circle()
                    .fill(doctor.isOnlineNow ? Theme.Colors.success : Theme.Colors.textSecondary)
                    .frame(width: 13, height: 13)
                    .overlay(Circle().stroke(.white, lineWidth: 2))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(doctor.name).font(.subheadline.bold())
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(doctor.specialty).font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.caption2)
                        .foregroundColor(Theme.Colors.warning)
                    Text(String(format: "%.1f", doctor.rating))
                        .font(.caption2).foregroundColor(Theme.Colors.textSecondary)
                }
            }
            Spacer()
            Button(action: onCall) {
                Image(systemName: "video.fill")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(doctor.isOnlineNow ? Theme.Colors.accent : Theme.Colors.textSecondary)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(!doctor.isOnlineNow)
        }
        .softCard()
    }
}

// MARK: - Имитация видеозвонка

struct VideoCallMockView: View {
    let doctor: Doctor
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.accentDark, Color.black],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                Spacer()
                Image(systemName: doctor.avatarSystemImage)
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .frame(width: 150, height: 150)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Circle())
                Text(doctor.name).font(.title2.bold()).foregroundColor(.white)
                Text("Соединение…").font(.subheadline).foregroundColor(.white.opacity(0.8))
                Spacer()

                HStack(spacing: Theme.Spacing.xl) {
                    callButton("mic.slash.fill", color: .white.opacity(0.2))
                    callButton("phone.down.fill", color: Theme.Colors.danger) { dismiss() }
                    callButton("video.slash.fill", color: .white.opacity(0.2))
                }
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
    }

    private func callButton(_ icon: String, color: Color, action: (() -> Void)? = nil) -> some View {
        Button { action?() } label: {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(color)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
