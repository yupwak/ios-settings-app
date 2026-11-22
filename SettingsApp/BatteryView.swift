import SwiftUI

struct BatteryView: View {
    @State private var level: String = DeviceInfo.batteryLevel
    @State private var state: String = DeviceInfo.batteryState

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "battery.100")
                        .font(.system(size: 34))
                        .foregroundStyle(level == "未知" ? Color.secondary : Color.green)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(level)
                            .font(.system(size: 26, weight: .semibold))
                        Text(state)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 6)
            }

            Section {
                LabeledContent("电池电量", value: level)
                LabeledContent("充电状态", value: state)
                LabeledContent("低电量模式", value: ProcessInfo.processInfo.isLowPowerModeEnabled ? "开启" : "关闭")
            }

            Section {
                Button("刷新") {
                    level = DeviceInfo.batteryLevel
                    state = DeviceInfo.batteryState
                }
            }
        }
        .navigationTitle("电池")
        .navigationBarTitleDisplayMode(.inline)
    }
}
