import SwiftUI

struct GeneralView: View {
    var body: some View {
        List {
            Section {
                NavigationLink("关于本机") { AboutView() }
                NavigationLink("存储空间") { StorageView() }
            }
            Section {
                LabeledContent("系统版本", value: "iOS \(DeviceInfo.systemVersion)")
                LabeledContent("机型", value: DeviceInfo.marketingName)
            }
            Section("说明") {
                Text("这里展示的是本机真实系统信息，由系统接口读取。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("通用")
        .navigationBarTitleDisplayMode(.inline)
    }
}
