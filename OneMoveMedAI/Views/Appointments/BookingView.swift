import SwiftUI

/// Экран записи на приём: выбор врача → даты → времени → подтверждение.
/// Demo: новая запись добавляется в переданную ViewModel (без backend).
struct BookingView: View {
    @ObservedObject var vm: AppointmentsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedDoctor: Doctor = MockData.doctors[0]
    @State private var selectedDate: Date = .now
    @State private var selectedSlot: String?
    @State private var reason: String = ""
    @State private var kind: AppointmentKind = .inPerson
    @State private var showConfirmation = false

    /// Демонстрационные слоты времени.
    private let slots = ["09:00", "10:30", "12:00", "14:00", "15:30", "17:00"]

    private var canBook: Bool { selectedSlot != nil }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    doctorPicker
                    kindPicker
                    datePicker
                    slotsGrid
                    reasonField
                }
                .padding(Theme.Spacing.md)
                .padding(.bottom, 90)
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("Запись на приём")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: canBook ? "Подтвердить запись" : "Выберите время",
                              icon: "checkmark.circle.fill") {
                    book()
                }
                .disabled(!canBook)
                .opacity(canBook ? 1 : 0.5)
                .padding(Theme.Spacing.md)
                .background(.ultraThinMaterial)
            }
            .alert("Вы записаны!", isPresented: $showConfirmation) {
                Button("Готово") { dismiss() }
            } message: {
                Text("\(selectedDoctor.name), \(selectedDate.formatted(date: .abbreviated, time: .omitted)) в \(selectedSlot ?? "")")
            }
        }
    }

    // MARK: Выбор врача
    private var doctorPicker: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Врач")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(MockData.doctors) { doctor in
                        doctorChip(doctor)
                    }
                }
            }
        }
    }

    private func doctorChip(_ doctor: Doctor) -> some View {
        let isSelected = doctor.id == selectedDoctor.id
        return Button { selectedDoctor = doctor } label: {
            VStack(spacing: 6) {
                DoctorAvatar(doctor: doctor, size: 46)
                Text(doctor.name).font(.caption2.weight(.medium))
                    .foregroundColor(Theme.Colors.textPrimary).lineLimit(1)
                Text(doctor.specialty).font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary).lineLimit(1)
            }
            .frame(width: 96)
            .padding(.vertical, Theme.Spacing.sm)
            .background(isSelected ? Theme.Colors.accentSoft : Theme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                    .stroke(isSelected ? Theme.Colors.accent : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: Формат приёма
    private var kindPicker: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Формат")
            Picker("Формат", selection: $kind) {
                Text("Очно").tag(AppointmentKind.inPerson)
                Text("Онлайн").tag(AppointmentKind.telemedicine)
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: Дата
    private var datePicker: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Дата")
            DatePicker("Дата приёма", selection: $selectedDate,
                       in: Date()..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(Theme.Colors.accent)
                .softCard()
        }
    }

    // MARK: Слоты
    private var slotsGrid: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Время")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()),
                                GridItem(.flexible())], spacing: Theme.Spacing.sm) {
                ForEach(slots, id: \.self) { slot in
                    let isSelected = slot == selectedSlot
                    Button { selectedSlot = slot } label: {
                        Text(slot)
                            .font(.subheadline.weight(.medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isSelected ? Theme.Colors.accent : Theme.Colors.card)
                            .foregroundColor(isSelected ? .white : Theme.Colors.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: Причина
    private var reasonField: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            SectionHeader(title: "Причина обращения")
            TextField("Например: плановый осмотр", text: $reason, axis: .vertical)
                .lineLimit(2...4)
                .padding(Theme.Spacing.md)
                .background(Theme.Colors.card)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
        }
    }

    // MARK: Действие
    private func book() {
        guard let slot = selectedSlot else { return }
        let date = Self.combine(date: selectedDate, time: slot)
        let appointment = Appointment(
            doctor: selectedDoctor,
            date: date,
            status: .upcoming,
            kind: kind,
            reason: reason.isEmpty ? "Консультация" : reason
        )
        vm.appointments.append(appointment)
        showConfirmation = true
    }

    /// Совмещает выбранную дату с временем слота "HH:mm".
    private static func combine(date: Date, time: String) -> Date {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return date }
        return Calendar.current.date(bySettingHour: parts[0], minute: parts[1],
                                     second: 0, of: date) ?? date
    }
}
