import SwiftUI

struct StorageView: View {
    private var storage: (total: Int64, free: Int64) { DeviceInfo.storage }

    private var used: Int64 { max(0, storage.total - storage.free) }
    private var ratio: Double {
        storage.total > 0 ? Double(used) / Double(storage.total) : 0
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(DeviceInfo.bytes(used))
                            .font(.system(size: 30, weight: .bold))
                        Text("已使用")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }

                    ProgressView(value: ratio)
                        .tint(.accentColor)

                    HStack {
                        legend("可用", DeviceInfo.bytes(storage.free))
                        Spacer()
                        legend("总计", DeviceInfo.bytes(storage.total))
                    }
                }
                .padding(.vertical, 6)
            }

            Section {
                LabeledContent("总容量", value: DeviceInfo.bytes(storage.total))
                LabeledContent("可用容量", value: DeviceInfo.bytes(storage.free))
                LabeledContent("已使用", value: DeviceInfo.bytes(used))
            }
        }
        .navigationTitle("存储空间")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func legend(_ key: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(key).font(.system(size: 11)).foregroundStyle(.secondary)
            Text(value).font(.system(size: 13, weight: .medium))
        }
    }
}
