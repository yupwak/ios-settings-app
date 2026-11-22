import SwiftUI

struct DisplayView: View {
    @AppStorage("appearance") private var appearance = 0

    var body: some View {
        List {
            Section("外观") {
                ForEach([0, 1, 2], id: \.self) { value in
                    Button {
                        appearance = value
                    } label: {
                        HStack {
                            Text(title(value))
                                .foregroundStyle(.primary)
                            Spacer()
                            if appearance == value {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                }
            }

            Section("屏幕") {
                LabeledContent("分辨率", value: DeviceInfo.screenSize)
                LabeledContent("逻辑尺寸", value: DeviceInfo.screenPoints)
                LabeledContent("缩放", value: "@\(Int(UIScreen.main.scale))x")
            }

            Section {
                Text("外观切换会立即生效，并保存在本机。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("显示与亮度")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func title(_ value: Int) -> String {
        switch value {
        case 1: return "浅色"
        case 2: return "深色"
        default: return "自动"
        }
    }
}
