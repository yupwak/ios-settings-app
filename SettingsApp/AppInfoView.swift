import SwiftUI

struct AppInfoView: View {
    private var version: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.secondary)
                    Text("设置")
                        .font(.system(size: 17, weight: .semibold))
                    Text("版本 \(version)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
            }

            Section {
                LabeledContent("开发者", value: "Lxp")
                LabeledContent("技术栈", value: "SwiftUI · iOS 26")
                LabeledContent("构建", value: "GitHub Actions")
            }

            Section {
                Text("这是一个仿 iOS 系统设置界面的演示应用，所有信息读取自本机真实接口。与 Apple Inc. 无关联。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("关于本应用")
        .navigationBarTitleDisplayMode(.inline)
    }
}
