import SwiftUI

struct PrivacyView: View {
    private let items: [(String, String, String)] = [
        ("定位服务", "location.fill", "由系统控制，本应用未申请"),
        ("麦克风", "mic.fill", "未申请"),
        ("相机", "camera.fill", "未申请"),
        ("照片", "photo.fill", "未申请"),
        ("通讯录", "person.2.fill", "未申请"),
        ("网络", "wifi", "仅访问公开接口")
    ]

    var body: some View {
        List {
            Section {
                ForEach(items, id: \.0) { item in
                    HStack(spacing: 12) {
                        IconBadge(symbol: item.1, color: .blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.0)
                            Text(item.2)
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 60)
                    .settingRowLayout(separatorLeading: RowMetrics.separatorAfterIcon)
                }
            }

            Section {
                Text("权限开关在系统「设置」中管理，可点右上角按钮直接跳转。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("隐私与安全")
        .navigationBarTitleDisplayMode(.inline)
    }
}
