import SwiftUI

/// Экран чата с AI-ассистентом (demo: ответы имитируются по ключевым словам).
struct AIAssistantView: View {
    @StateObject private var vm = ChatViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                messagesList
                if vm.messages.count <= 1 { suggestionsRow }
                inputBar
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .navigationTitle("AI-ассистент")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 0) {
                        Text("AI-ассистент").font(.headline)
                        Text("онлайн · 24/7")
                            .font(.caption2).foregroundColor(Theme.Colors.success)
                    }
                }
            }
        }
    }

    // MARK: Лента сообщений
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.sm) {
                    ForEach(vm.messages) { msg in
                        MessageBubble(message: msg).id(msg.id)
                    }
                    if vm.isTyping { TypingIndicator().id("typing") }
                }
                .padding(Theme.Spacing.md)
            }
            .onChange(of: vm.messages.count) { _ in
                withAnimation { proxy.scrollTo(vm.messages.last?.id, anchor: .bottom) }
            }
            .onChange(of: vm.isTyping) { typing in
                if typing { withAnimation { proxy.scrollTo("typing", anchor: .bottom) } }
            }
        }
    }

    // MARK: Подсказки
    private var suggestionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(vm.suggestions, id: \.self) { suggestion in
                    Button { vm.send(suggestion) } label: {
                        Text(suggestion)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 14).padding(.vertical, 9)
                            .background(Theme.Colors.card)
                            .foregroundColor(Theme.Colors.accentDark)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Theme.Colors.accent.opacity(0.3)))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.sm)
        }
    }

    // MARK: Поле ввода
    private var inputBar: some View {
        HStack(spacing: Theme.Spacing.sm) {
            TextField("Сообщение…", text: $vm.draft, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, 10)
                .background(Theme.Colors.card)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            Button { vm.send() } label: {
                Image(systemName: "arrow.up")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                    .background(Theme.Colors.accent)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(vm.draft.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(vm.draft.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
        }
        .padding(Theme.Spacing.md)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Пузырь сообщения

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 40) }
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 3) {
                Text(message.text)
                    .font(.subheadline)
                    .foregroundColor(message.isFromUser ? .white : Theme.Colors.textPrimary)
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, 10)
                    .background(bubbleBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                Text(message.time.formatted(date: .omitted, time: .shortened))
                    .font(.caption2).foregroundColor(Theme.Colors.textSecondary)
            }
            if !message.isFromUser { Spacer(minLength: 40) }
        }
    }

    @ViewBuilder private var bubbleBackground: some View {
        if message.isFromUser {
            LinearGradient(colors: [Theme.Colors.accent, Theme.Colors.accentDark],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            Theme.Colors.card
        }
    }
}

// MARK: - Индикатор «печатает…»

struct TypingIndicator: View {
    @State private var phase = 0.0
    var body: some View {
        HStack {
            HStack(spacing: 5) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(Theme.Colors.textSecondary)
                        .frame(width: 7, height: 7)
                        .opacity(phase == Double(i) ? 1 : 0.3)
                }
            }
            .padding(.horizontal, Theme.Spacing.md).padding(.vertical, 12)
            .background(Theme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever()) { phase = 2 }
        }
    }
}
