import SwiftUI
import UIKit

struct RootSettingsView: View {
    @AppStorage("appearance") private var appearance = 0
    @State private var query = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        AppleAccountView()
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle().fill(Color(.secondarySystemFill))
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.tertiary)
                            }
                            .frame(width: 60, height: 60)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(DeviceInfo.deviceName)
                                    .font(.system(size: 19, weight: .semibold))
                                Text(MockAccount.email)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                ForEach(filteredSections) { section in
                    if let title = section.title {
                        Section(title) {
                            ForEach(section.items) { item in
                                row(item)
                            }
                        }
                    } else {
                        Section {
                            ForEach(section.items) { item in
                                row(item)
                            }
                        }
                    }
                }

                Section {
                    Text("本应用为独立开发的系统设置界面示例，与 Apple Inc. 无关。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("设置")
            .searchable(text: $query, prompt: "搜索")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image(systemName: "arrow.up.forward.app")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func row(_ item: SettingsItem) -> some View {
        switch item.destination {
        case .about:
            NavigationLink { AboutView() } label: { label(item) }
        case .general:
            NavigationLink { GeneralView() } label: { label(item) }
        case .display:
            NavigationLink { DisplayView() } label: { label(item) }
        case .storage:
            NavigationLink { StorageView() } label: { label(item) }
        case .battery:
            NavigationLink { BatteryView() } label: { label(item) }
        case .privacy:
            NavigationLink { PrivacyView() } label: { label(item) }
        case .aboutApp:
            NavigationLink { AppInfoView() } label: { label(item) }
        }
    }

    private func label(_ item: SettingsItem) -> some View {
        HStack(spacing: 12) {
            IconBadge(symbol: item.symbol, color: item.color)
            Text(item.title)
                .font(.system(size: 16))
            Spacer()
            if let value = item.value {
                Text(value)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private var sections: [SettingsSection] {
        [
            SettingsSection(title: nil, items: [
                SettingsItem(title: "通用", symbol: "gearshape.fill", color: .gray, destination: .general),
                SettingsItem(title: "显示与亮度", symbol: "sun.max.fill", color: .blue, destination: .display),
                SettingsItem(title: "电池", symbol: "battery.100", color: .green, destination: .battery),
                SettingsItem(title: "存储空间", symbol: "internaldrive.fill", color: .indigo, destination: .storage),
                SettingsItem(title: "隐私与安全", symbol: "hand.raised.fill", color: .blue, destination: .privacy)
            ]),
            SettingsSection(title: "本机", items: [
                SettingsItem(title: "关于本机", symbol: "info.circle.fill", color: .gray, destination: .about,
                             value: "iOS \(DeviceInfo.systemVersion)"),
                SettingsItem(title: "外观", symbol: "circle.lefthalf.filled", color: .gray, destination: .display,
                             value: appearanceName)
            ]),
            SettingsSection(title: "App", items: [
                SettingsItem(title: "关于本应用", symbol: "app.badge.fill", color: .orange, destination: .aboutApp)
            ])
        ]
    }

    private var filteredSections: [SettingsSection] {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return sections }
        return sections.compactMap { section in
            let items = section.items.filter { $0.title.localizedCaseInsensitiveContains(q) }
            return items.isEmpty ? nil : SettingsSection(title: section.title, items: items)
        }
    }

    private var appearanceName: String {
        switch appearance {
        case 1: return "浅色"
        case 2: return "深色"
        default: return "自动"
        }
    }
}

struct IconBadge: View {
    let symbol: String
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 7, style: .continuous)
            .fill(color.gradient)
            .frame(width: 29, height: 29)
            .overlay(
                Image(systemName: symbol)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            )
    }
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let symbol: String
    let color: Color
    let destination: Destination
    var value: String? = nil

    enum Destination { case about, general, display, storage, battery, privacy, aboutApp }
}

struct SettingsSection: Identifiable {
    let id = UUID()
    let title: String?
    let items: [SettingsItem]
}
