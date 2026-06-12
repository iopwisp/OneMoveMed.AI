import SwiftUI

// MARK: - Заголовок секции с кнопкой «Все»

struct SectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Theme.Colors.accent)
            }
        }
    }
}

// MARK: - Круглая иконка-чип

struct IconBadge: View {
    let systemName: String
    let tint: Color
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundColor(tint)
            .frame(width: size, height: size)
            .background(tint.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: size * 0.32, style: .continuous))
    }
}

// MARK: - Кнопка быстрого действия (сетка на главном)

struct QuickActionButton: View {
    let action: QuickAction
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Theme.Spacing.sm) {
                IconBadge(systemName: action.icon, tint: action.tint, size: 50)
                Text(action.title)
                    .font(.caption.weight(.medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
            .softCard(padding: 0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Основная акцентная кнопка

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.sm) {
                if let icon { Image(systemName: icon) }
                Text(title).fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(colors: [Theme.Colors.accent, Theme.Colors.accentDark],
                               startPoint: .leading, endPoint: .trailing)
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
            .shadow(color: Theme.Colors.accent.opacity(0.35), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Тег-капсула

struct TagPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.14))
            .clipShape(Capsule())
    }
}

// MARK: - Мини-график (спарклайн) для аналитики

struct Sparkline: View {
    let points: [Double]
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            let maxX = max(CGFloat(points.count - 1), 1)
            Path { path in
                for (index, value) in points.enumerated() {
                    let x = geo.size.width * CGFloat(index) / maxX
                    let y = geo.size.height * (1 - CGFloat(value))
                    if index == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(tint, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
    }
}

// MARK: - Лёгкая анимация появления (fade + slide вверх)

/// Простой «entrance»-эффект: при появлении блок плавно проявляется
/// и поднимается. `delay` задаёт каскад (stagger) между секциями.
struct AppearTransition: ViewModifier {
    let delay: Double
    @State private var shown = false

    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .offset(y: shown ? 0 : 16)
            .onAppear {
                withAnimation(.easeOut(duration: 0.45).delay(delay)) {
                    shown = true
                }
            }
    }
}

extension View {
    /// Каскадное появление секции. `index` — порядковый номер блока.
    func appear(index: Int) -> some View {
        modifier(AppearTransition(delay: Double(index) * 0.08))
    }
}

// MARK: - Аватар врача

struct DoctorAvatar: View {
    let doctor: Doctor
    var size: CGFloat = 52

    var body: some View {
        Image(systemName: doctor.avatarSystemImage)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundColor(Theme.Colors.accentDark)
            .frame(width: size, height: size)
            .background(Theme.Colors.accentSoft)
            .clipShape(Circle())
    }
}
