import SwiftUI

/// Корневой контейнер с нижним TabBar.
/// `selection` общий, чтобы быстрые действия с главного экрана могли
/// переключать вкладки.
struct RootTabView: View {
    @State private var selection: AppTab = .home

    init() {
        // Настройка внешнего вида TabBar под светлую тему.
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView(selection: $selection)
                .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.icon) }
                .tag(AppTab.home)

            AIAssistantView()
                .tabItem { Label(AppTab.chat.title, systemImage: AppTab.chat.icon) }
                .tag(AppTab.chat)

            AppointmentsView()
                .tabItem { Label(AppTab.appointments.title, systemImage: AppTab.appointments.icon) }
                .tag(AppTab.appointments)

            MedicationsView()
                .tabItem { Label(AppTab.medications.title, systemImage: AppTab.medications.icon) }
                .tag(AppTab.medications)

            ProfileView()
                .tabItem { Label(AppTab.profile.title, systemImage: AppTab.profile.icon) }
                .tag(AppTab.profile)
        }
        .tint(Theme.Colors.accent)
    }
}
