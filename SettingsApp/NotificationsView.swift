import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @State private var status: UNAuthorizationStatus = .notDetermined
    @State private var pendingCount = 0
    @State private var sentNote: String?

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(status == .authorized ? Color.green : Color.secondary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(statusText)
                            .font(.system(size: 16, weight: .semibold))
                        Text("推送权限")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            } footer: {
                Text("通知走系统本地推送通道，前台会显示横幅，锁屏和后台会进入通知中心。")
            }

            Section("模拟消息") {
                Button {
                    send(title: "Lxp", body: "在吗？看到消息回我一下")
                } label: {
                    row("微信消息", "在吗？看到消息回我一下", symbol: "message.fill", color: .green)
                }

                Button {
                    send(title: "小七资源库", body: "你关注的资源有更新了")
                } label: {
                    row("资源更新", "你关注的资源有更新了", symbol: "square.grid.2x2.fill", color: .blue)
                }

                Button {
                    send(title: "设置", body: "iCloud 存储空间即将用完", symbol: "exclamationmark.triangle.fill")
                } label: {
                    row("系统提醒", "iCloud 存储空间即将用完", symbol: "exclamationmark.triangle.fill", color: .orange)
                }
            }

            Section {
                LabeledContent("延迟", value: "5 秒")
                LabeledContent("待发送", value: "\(pendingCount) 条")
                if let sentNote {
                    Text(sentNote)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button("清除角标") {
                    NotificationManager.shared.clearBadge()
                    sentNote = "角标已清除"
                }
                if status != .authorized {
                    Button("去系统设置开启通知") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
        .navigationTitle("通知")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { reload() }
        .task {
            NotificationManager.shared.refreshStatus { _ in }
        }
    }

    private func row(_ title: String, _ body: String, symbol: String, color: Color) -> some View {
        HStack(spacing: 12) {
            IconBadge(symbol: symbol, color: color)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(.primary)
                Text(body)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "paperplane.fill")
                .font(.system(size: 13))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }

    private func send(title: String, body: String, symbol: String? = nil) {
        NotificationManager.shared.send(title: title, body: body, after: 5)
        sentNote = "已安排，5 秒后弹出。现在可以把 App 切到后台再看。"
        reload()
    }

    private func reload() {
        NotificationManager.shared.refreshStatus { value in
            status = value
        }
        NotificationManager.shared.pending { count in
            pendingCount = count
        }
    }

    private var statusText: String {
        switch status {
        case .authorized, .provisional, .ephemeral: return "已允许通知"
        case .denied: return "已关闭通知"
        default: return "尚未选择"
        }
    }
}
