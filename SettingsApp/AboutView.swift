import SwiftUI

struct AboutView: View {
    private var storage: (total: Int64, free: Int64) { DeviceInfo.storage }

    var body: some View {
        List {
            Section {
                VStack(spacing: 6) {
                    Image(systemName: "iphone.gen3")
                        .font(.system(size: 46, weight: .light))
                        .foregroundStyle(.secondary)
                    Text(DeviceInfo.marketingName)
                        .font(.system(size: 17, weight: .semibold))
                    Text("iOS \(DeviceInfo.systemVersion)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
            }

            Section {
                infoRow("名称", DeviceInfo.deviceName)
                infoRow("机型", DeviceInfo.marketingName)
                infoRow("型号", DeviceInfo.identifier)
                infoRow("系统版本", "\(DeviceInfo.systemName) \(DeviceInfo.systemVersion)")
            }

            Section {
                infoRow("处理器核心", "\(DeviceInfo.processorCount)（活动 \(DeviceInfo.activeProcessorCount)）")
                infoRow("运行内存", DeviceInfo.bytes(DeviceInfo.physicalMemory))
                infoRow("可用容量", DeviceInfo.bytes(storage.free))
                infoRow("总容量", DeviceInfo.bytes(storage.total))
            }

            Section {
                infoRow("屏幕分辨率", DeviceInfo.screenSize)
                infoRow("逻辑尺寸", DeviceInfo.screenPoints)
                infoRow("开机时间", DeviceInfo.bootTime.formatted(date: .abbreviated, time: .shortened))
                infoRow("已运行", uptimeText)
            }

            Section {
                infoRow("语言", DeviceInfo.language)
                infoRow("区域", DeviceInfo.region)
                infoRow("时区", DeviceInfo.timeZone)
            }
        }
        .navigationTitle("关于本机")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var uptimeText: String {
        let t = Int(DeviceInfo.uptime)
        let d = t / 86400, h = (t % 86400) / 3600, m = (t % 3600) / 60
        if d > 0 { return "\(d) 天 \(h) 小时" }
        if h > 0 { return "\(h) 小时 \(m) 分钟" }
        return "\(m) 分钟"
    }

    private func infoRow(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
