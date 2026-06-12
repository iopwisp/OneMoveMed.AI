import SwiftUI

/// Единая дизайн-система demo-приложения.
/// Светлая тема, бирюзовый акцент, мягкие тени — стиль Apple Health.
enum Theme {

    // MARK: - Цвета
    enum Colors {
        /// Основной бирюзовый акцент (из логотипа OneMoveMed.AI).
        static let accent = Color(red: 0.05, green: 0.73, blue: 0.78)
        static let accentDark = Color(red: 0.02, green: 0.55, blue: 0.62)
        static let accentSoft = Color(red: 0.05, green: 0.73, blue: 0.78).opacity(0.12)

        /// Фон экранов и карточек.
        static let background = Color(red: 0.96, green: 0.97, blue: 0.98)
        static let card = Color.white

        /// Текст.
        static let textPrimary = Color(red: 0.10, green: 0.13, blue: 0.18)
        static let textSecondary = Color(red: 0.45, green: 0.50, blue: 0.56)

        /// Статусы.
        static let success = Color(red: 0.20, green: 0.78, blue: 0.50)
        static let warning = Color(red: 0.98, green: 0.69, blue: 0.20)
        static let danger = Color(red: 0.95, green: 0.35, blue: 0.38)
        static let info = Color(red: 0.30, green: 0.55, blue: 0.95)
    }

    // MARK: - Отступы
    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 22
        static let xl: CGFloat = 32
    }

    // MARK: - Скругления
    enum Radius {
        static let sm: CGFloat = 12
        static let md: CGFloat = 18
        static let lg: CGFloat = 26
    }
}

// MARK: - Переиспользуемые модификаторы

/// Мягкая «карточная» тень в стиле Apple Health.
struct SoftCardStyle: ViewModifier {
    var padding: CGFloat = Theme.Spacing.md
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 14, x: 0, y: 6)
    }
}

extension View {
    /// Применяет фирменный стиль карточки.
    func softCard(padding: CGFloat = Theme.Spacing.md) -> some View {
        modifier(SoftCardStyle(padding: padding))
    }
}
