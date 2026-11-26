import SwiftUI

struct ComponentsView: View {
    @State private var toggleOn = true
    @State private var volume: Double = 0.55
    @State private var segment = 0
    @State private var pickerChoice = "自动"
    @State private var count = 3
    @Namespace private var glassNS
    @State private var merged = false

    private let choices = ["自动", "浅色", "深色"]

    var body: some View {
        List {
            Section {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 118), spacing: 10)], spacing: 10) {
                    ForEach(BtnKind.allCases) { kind in
                        button(kind)
                    }
                }
                .padding(.vertical, 4)
            } header: {
                Text("按钮样式")
            } footer: {
                Text(iOS26Hint("玻璃与玻璃强调是 iOS 26 的原生样式，低版本自动回落描边。"))
            }

            Section("尺寸") {
                HStack(spacing: 8) {
                    Button("小") {}.controlSize(.small).buttonStyle(.borderedProminent)
                    Button("中") {}.controlSize(.regular).buttonStyle(.borderedProminent)
                    Button("大") {}.controlSize(.large).buttonStyle(.borderedProminent)
                }
                .buttonBorderShape(.capsule)
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 8) {
                    Button("小") {}.controlSize(.small)
                    Button("中") {}
                    Button("大") {}.controlSize(.large)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle(radius: 10))
            }

            Section("形状") {
                HStack(spacing: 8) {
                    Button("胶囊") {}.buttonBorderShape(.capsule)
                    Button("圆角") {}.buttonBorderShape(.roundedRectangle(radius: 10))
                    Button("圆形") { Image(systemName: "plus") }
                        .buttonBorderShape(.circle)
                }
                .buttonStyle(.bordered)
            }

            Section {
                glassShowcase
            } header: {
                Text("玻璃容器")
            } footer: {
                Text("GlassEffectContainer 让相邻的玻璃元素在靠近时融合，这是 iOS 26 才有的行为。")
            }

            Section("常用控件") {
                Toggle("低电量模式", isOn: $toggleOn)
                Slider(value: $volume) { Text("音量") } minimumValueLabel: {
                    Image(systemName: "speaker.fill")
                } maximumValueLabel: {
                    Image(systemName: "speaker.wave.3.fill")
                }
                Picker("外观", selection: $segment) {
                    Text("自动").tag(0)
                    Text("浅色").tag(1)
                    Text("深色").tag(2)
                }
                .pickerStyle(.segmented)
                Stepper("数量 \(count)", value: $count, in: 1...10)
                Picker("模式", selection: $pickerChoice) {
                    ForEach(choices, id: \.self) { Text($0) }
                }
            }

            Section("导航与弹窗") {
                NavigationLink("二级页面") {
                    ComponentsDetailView()
                }
                Button("原生提示") {
                    showAlert = true
                }
            }
        }
        .navigationTitle("界面元素")
        .navigationBarTitleDisplayMode(.inline)
        .alert("原生弹窗", isPresented: $showAlert) {
            Button("知道了", role: .cancel) {}
            Button("继续") {}
        } message: {
            Text("这是 SwiftUI 的系统 alert，样式由系统决定。")
        }
    }

    @State private var showAlert = false

    // MARK: - 按钮

    private enum BtnKind: String, CaseIterable, Identifiable {
        case glass = "玻璃"
        case glassProminent = "玻璃强调"
        case borderedProminent = "描边强调"
        case bordered = "描边"
        case plain = "纯文本"
        case borderless = "无边框"
        var id: String { rawValue }
    }

    @ViewBuilder
    private func button(_ kind: BtnKind) -> some View {
        switch kind {
        case .glass:
            if #available(iOS 26.0, *) {
                Button(kind.rawValue) {}.buttonStyle(.glass)
            } else {
                Button(kind.rawValue) {}.buttonStyle(.bordered)
            }
        case .glassProminent:
            if #available(iOS 26.0, *) {
                Button(kind.rawValue) {}.buttonStyle(.glassProminent)
            } else {
                Button(kind.rawValue) {}.buttonStyle(.borderedProminent)
            }
        case .borderedProminent:
            Button(kind.rawValue) {}.buttonStyle(.borderedProminent)
        case .bordered:
            Button(kind.rawValue) {}.buttonStyle(.bordered)
        case .plain:
            Button(kind.rawValue) {}.buttonStyle(.plain).foregroundStyle(Color.accentColor)
        case .borderless:
            Button(kind.rawValue) {}.buttonStyle(.borderless).foregroundStyle(Color.accentColor)
        }
    }

    // MARK: - 玻璃

    @ViewBuilder
    private var glassShowcase: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: merged ? 8 : 26) {
                HStack(spacing: merged ? 8 : 26) {
                    glassIcon("bolt.fill", tint: .orange, id: "bolt")
                    glassIcon("heart.fill", tint: .pink, id: "heart")
                    glassIcon("gearshape.fill", tint: .blue, id: "gear")
                }
                .frame(maxWidth: .infinity)
                .animation(.spring(response: 0.45, dampingFraction: 0.75), value: merged)
            }
            .padding(.vertical, 12)
            .onTapGesture { merged.toggle() }

            Button(merged ? "分开" : "靠拢") {
                merged.toggle()
            }
            .buttonStyle(.glass)
        } else {
            HStack(spacing: 26) {
                fallbackIcon("bolt.fill", .orange)
                fallbackIcon("heart.fill", .pink)
                fallbackIcon("gearshape.fill", .blue)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }

    @available(iOS 26.0, *)
    private func glassIcon(_ symbol: String, tint: Color, id: String) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: 54, height: 54)
            .glassEffect(.regular.tint(tint.opacity(0.35)).interactive(), in: .circle)
            .glassEffectID(id, in: glassNS)
    }

    private func fallbackIcon(_ symbol: String, _ tint: Color) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: 54, height: 54)
            .background(.ultraThinMaterial, in: Circle())
    }

    private func iOS26Hint(_ text: String) -> String {
        if #available(iOS 26.0, *) { return text }
        return text
    }
}

struct ComponentsDetailView: View {
    var body: some View {
        List {
            Section {
                Text("二级页面用的是系统 NavigationStack 的推入动画，返回按钮和标题栏都是原生外观。")
                    .font(.callout)
            }
            Section {
                LabeledContent("标题栏", value: "原生")
                LabeledContent("返回手势", value: "边缘右滑")
                LabeledContent("背景", value: "系统分组背景")
            }
        }
        .navigationTitle("二级页面")
        .navigationBarTitleDisplayMode(.inline)
    }
}
