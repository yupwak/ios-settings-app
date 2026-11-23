import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let outgoing: Bool
    let time: Date
}

struct ChatDemoView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "在吗？", outgoing: false, time: Date().addingTimeInterval(-120)),
        ChatMessage(text: "在的，怎么了", outgoing: true, time: Date().addingTimeInterval(-100))
    ]
    @State private var draft = ""
    @State private var notificationOn = true

    private let replies = [
        "收到，我在忙，稍后回你",
        "好的，看下就回你",
        "等下我打个电话给你",
        "这个我处理一下"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(messages) { message in
                            bubble(message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .defaultScrollAnchor(.bottom)
                .onChange(of: messages.count) {
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            Divider()

            HStack(spacing: 10) {
                TextField("发消息", text: $draft, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )

                Button {
                    send()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(draft.trimmingCharacters(in: .whitespaces).isEmpty ? Color.secondary : Color.accentColor)
                }
                .buttonStyle(.plain)
                .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Lxp")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Toggle("", isOn: $notificationOn)
                    .labelsHidden()
            }
        }
    }

    private func bubble(_ message: ChatMessage) -> some View {
        HStack {
            if message.outgoing { Spacer(minLength: 60) }

            VStack(alignment: message.outgoing ? .trailing : .leading, spacing: 3) {
                Text(message.text)
                    .font(.system(size: 15.5))
                    .foregroundStyle(message.outgoing ? Color.white : Color.primary)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: 17, style: .continuous)
                            .fill(message.outgoing ? Color.accentColor : Color(.secondarySystemBackground))
                    )

                Text(message.time.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 4)
            }

            if !message.outgoing { Spacer(minLength: 60) }
        }
    }

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        draft = ""
        messages.append(ChatMessage(text: text, outgoing: true, time: Date()))

        // 3 秒后模拟对方回复，同时推一条系统通知
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            let reply = replies.randomElement() ?? "收到"
            messages.append(ChatMessage(text: reply, outgoing: false, time: Date()))
            if notificationOn {
                NotificationManager.shared.send(title: "Lxp", body: reply, after: 1)
            }
        }
    }
}
