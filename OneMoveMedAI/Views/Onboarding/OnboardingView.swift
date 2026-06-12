import SwiftUI

/// Слайд онбординга.
struct OnboardingSlide: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

/// Стартовый экран-интро. По завершении вызывает `onFinish`.
struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var index = 0
    private let slides = MockData.onboardingSlides

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.Colors.accentSoft, Theme.Colors.background],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Пропустить
                HStack {
                    Spacer()
                    Button("Пропустить", action: onFinish)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(Theme.Colors.textSecondary)
                        .padding()
                }

                TabView(selection: $index) {
                    ForEach(Array(slides.enumerated()), id: \.element.id) { i, slide in
                        slideView(slide).tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Индикатор страниц
                HStack(spacing: 8) {
                    ForEach(slides.indices, id: \.self) { i in
                        Capsule()
                            .fill(i == index ? Theme.Colors.accent : Theme.Colors.textSecondary.opacity(0.25))
                            .frame(width: i == index ? 22 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: index)
                    }
                }
                .padding(.bottom, Theme.Spacing.lg)

                // Кнопка
                PrimaryButton(title: index == slides.count - 1 ? "Начать" : "Далее",
                              icon: index == slides.count - 1 ? "arrow.right.circle.fill" : nil) {
                    if index < slides.count - 1 {
                        withAnimation { index += 1 }
                    } else {
                        onFinish()
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
    }

    private func slideView(_ slide: OnboardingSlide) -> some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Theme.Colors.card)
                    .frame(width: 170, height: 170)
                    .shadow(color: Theme.Colors.accent.opacity(0.25), radius: 24, y: 10)
                Image(systemName: slide.icon)
                    .font(.system(size: 70, weight: .semibold))
                    .foregroundColor(Theme.Colors.accent)
            }

            Text(slide.title)
                .font(.title.bold())
                .foregroundColor(Theme.Colors.textPrimary)
                .multilineTextAlignment(.center)

            Text(slide.subtitle)
                .font(.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.xl)
            Spacer()
        }
    }
}
