import SwiftUI

// MARK: - 模拟账户数据

enum MockAccount {
    static let name = "Lxp"
    static let email = "lxp@icloud.com"
    static let birthday = "2000年1月1日"
    static let phone = "+86 •••• •••• 8888"
    static let address = "浙江 杭州 西湖区 ···· 路 ·· 号"
    static let gender = "未设置"

    struct Device: Identifiable {
        let id = UUID()
        let name: String
        let model: String
        let symbol: String
        let isCurrent: Bool
    }

    static let devices: [Device] = [
        Device(name: "Lxp 的 iPhone", model: "iPhone 15 Pro", symbol: "iphone", isCurrent: true),
        Device(name: "Lxp 的 iPad", model: "iPad Air (M2)", symbol: "ipad", isCurrent: false),
        Device(name: "Lxp 的 MacBook Pro", model: "MacBook Pro 14 英寸", symbol: "laptopcomputer", isCurrent: false)
    ]

    struct Subscription: Identifiable {
        let id = UUID()
        let name: String
        let detail: String
        let price: String
        let symbol: String
        let color: Color
    }

    static let subscriptions: [Subscription] = [
        Subscription(name: "iCloud+", detail: "2 TB 存储空间", price: "¥68.00/月", symbol: "icloud.fill", color: .blue),
        Subscription(name: "Apple Music", detail: "个人方案", price: "¥11.00/月", symbol: "music.note", color: .pink)
    ]

    struct Family: Identifiable {
        let id = UUID()
        let name: String
        let role: String
    }

    static let family: [Family] = [
        Family(name: "Lxp", role: "组织者"),
        Family(name: "家庭成员 A", role: "成员"),
        Family(name: "家庭成员 B", role: "成员")
    ]
}

// MARK: - Apple 账户主页

struct AppleAccountView: View {
    @State private var showSignOut = false

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    ZStack {
                        Circle().fill(Color(.secondarySystemFill))
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 92))
                            .foregroundStyle(.tertiary)
                    }
                    .frame(width: 92, height: 92)

                    Text(MockAccount.name)
                        .font(.system(size: 23, weight: .semibold))

                    Text(MockAccount.email)
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)

                    Text("查看个人资料")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.accentColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .listRowBackground(Color.clear)
            }

            Section {
                NavigationLink {
                    PersonalInfoView()
                } label: {
                    HStack(spacing: 12) {
                        IconBadge(symbol: "person.text.rectangle.fill", color: .blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("个人信息")
                            Text("姓名、生日、联系方式")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 48)
                }

                NavigationLink {
                    SecurityView()
                } label: {
                    HStack(spacing: 12) {
                        IconBadge(symbol: "lock.shield.fill", color: .green)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("登录与安全")
                            Text("密码、双重认证、恢复联系人")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 48)
                }
            }

            Section {
                NavigationLink {
                    PaymentView()
                } label: {
                    HStack(spacing: 12) {
                        IconBadge(symbol: "creditcard.fill", color: .orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("付款与配送")
                            Text("Visa •••• 1234")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 48)
                }

                NavigationLink {
                    SubscriptionsView()
                } label: {
                    HStack(spacing: 12) {
                        IconBadge(symbol: "arrow.triangle.2.circlepath", color: .pink)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("订阅")
                            Text("2 项进行中的订阅")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 48)
                }
            }

            Section {
                NavigationLink {
                    FamilyView()
                } label: {
                    HStack(spacing: 12) {
                        IconBadge(symbol: "person.2.fill", color: .purple)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("家人共享")
                            Text("3 位成员")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 48)
                }

                NavigationLink {
                    MediaView()
                } label: {
                    HStack(spacing: 12) {
                        IconBadge(symbol: "app.badge.fill", color: .blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("媒体与购买项目")
                            Text("App Store、iTunes Store")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 48)
                }
            } header: {
                Text("账户")
            }

            Section("设备") {
                ForEach(MockAccount.devices) { device in
                    NavigationLink {
                        DeviceDetailView(device: device)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: device.symbol)
                                .font(.system(size: 20))
                                .foregroundStyle(.secondary)
                                .frame(width: 29)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(device.name)
                                Text(device.model)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if device.isCurrent {
                                Text("此设备")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            Section {
                Button(role: .destructive) {
                    showSignOut = true
                } label: {
                    Text("退出登录")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Apple 账户")
        .navigationBarTitleDisplayMode(.inline)
        .alert("退出登录？", isPresented: $showSignOut) {
            Button("取消", role: .cancel) {}
            Button("退出登录", role: .destructive) {}
        } message: {
            Text("演示应用，不会真的退出任何账户。")
        }
    }
}

// MARK: - 个人信息

struct PersonalInfoView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    ZStack {
                        Circle().fill(Color(.secondarySystemFill))
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 86))
                            .foregroundStyle(.tertiary)
                    }
                    .frame(width: 86, height: 86)
                    Text("编辑头像")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.accentColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .listRowBackground(Color.clear)
            }

            Section {
                LabeledContent("姓名", value: MockAccount.name)
                LabeledContent("生日", value: MockAccount.birthday)
                LabeledContent("性别", value: MockAccount.gender)
            }

            Section("可联系到你的方式") {
                LabeledContent("电子邮件", value: MockAccount.email)
                LabeledContent("电话号码", value: MockAccount.phone)
                LabeledContent("通讯地址", value: MockAccount.address)
            }
        }
        .navigationTitle("个人信息")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 登录与安全

struct SecurityView: View {
    var body: some View {
        List {
            Section {
                LabeledContent("双重认证", value: "已开启")
            } footer: {
                Text("双重认证可为你的账户增加一层保护，登录新设备时需要验证码。")
            }

            Section {
                NavigationLink("更改密码") { PlaceholderView(title: "更改密码", symbol: "key.fill") }
                NavigationLink("账户恢复") { PlaceholderView(title: "账户恢复", symbol: "arrow.counterclockwise") }
                NavigationLink("恢复联系人") { PlaceholderView(title: "恢复联系人", symbol: "person.crop.circle.badge.checkmark") }
            }

            Section("受信任电话号码") {
                LabeledContent("电话号码", value: MockAccount.phone)
            }

            Section("受信任设备") {
                ForEach(MockAccount.devices) { device in
                    HStack {
                        Image(systemName: device.symbol).foregroundStyle(.secondary)
                        Text(device.name)
                        Spacer()
                        if device.isCurrent {
                            Text("此设备").font(.system(size: 12)).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("登录与安全")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 付款与配送

struct PaymentView: View {
    var body: some View {
        List {
            Section("付款方式") {
                HStack(spacing: 12) {
                    IconBadge(symbol: "creditcard.fill", color: .orange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Visa")
                        Text("尾号 1234 · 有效期 08/29")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("配送地址") {
                VStack(alignment: .leading, spacing: 3) {
                    Text(MockAccount.name)
                    Text(MockAccount.address)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text(MockAccount.phone)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }

            Section {
                NavigationLink("添加付款方式") { PlaceholderView(title: "添加付款方式", symbol: "plus.circle") }
                NavigationLink("添加配送地址") { PlaceholderView(title: "添加配送地址", symbol: "mappin.and.ellipse") }
            }
        }
        .navigationTitle("付款与配送")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 订阅

struct SubscriptionsView: View {
    var body: some View {
        List {
            Section {
                ForEach(MockAccount.subscriptions) { sub in
                    HStack(spacing: 12) {
                        IconBadge(symbol: sub.symbol, color: sub.color)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(sub.name)
                            Text(sub.detail)
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(sub.price)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    .frame(minHeight: 48)
                }
            } header: {
                Text("进行中")
            }

            Section {
                NavigationLink("查看全部订阅") { PlaceholderView(title: "全部订阅", symbol: "list.bullet") }
            }
        }
        .navigationTitle("订阅")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 家人共享

struct FamilyView: View {
    var body: some View {
        List {
            Section {
                ForEach(MockAccount.family) { member in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(Color(.secondarySystemFill))
                            Image(systemName: "person.fill").foregroundStyle(.secondary)
                        }
                        .frame(width: 36, height: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.name)
                            Text(member.role)
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 48)
                }
            } header: {
                Text("成员")
            }

            Section {
                NavigationLink("邀请家人") { PlaceholderView(title: "邀请家人", symbol: "person.badge.plus") }
                NavigationLink("购买共享") { PlaceholderView(title: "购买共享", symbol: "bag.fill") }
                NavigationLink("屏幕使用时间") { PlaceholderView(title: "屏幕使用时间", symbol: "hourglass") }
            }
        }
        .navigationTitle("家人共享")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 媒体与购买项目

struct MediaView: View {
    var body: some View {
        List {
            Section {
                LabeledContent("App Store", value: MockAccount.email)
                LabeledContent("iTunes Store", value: MockAccount.email)
            }
            Section {
                NavigationLink("查看账户") { PlaceholderView(title: "查看账户", symbol: "person.crop.circle") }
                NavigationLink("购买记录") { PlaceholderView(title: "购买记录", symbol: "list.bullet.rectangle") }
                NavigationLink("订阅管理") { SubscriptionsView() }
            }
        }
        .navigationTitle("媒体与购买项目")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 设备详情

struct DeviceDetailView: View {
    let device: MockAccount.Device

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: device.symbol)
                        .font(.system(size: 54, weight: .light))
                        .foregroundStyle(.secondary)
                    Text(device.name)
                        .font(.system(size: 17, weight: .semibold))
                    Text(device.model)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
            }

            Section {
                LabeledContent("状态", value: device.isCurrent ? "此设备" : "已登录")
                LabeledContent("系统版本", value: "iOS \(DeviceInfo.systemVersion)")
                LabeledContent("查找我的", value: "已开启")
            }

            Section {
                NavigationLink("从账户移除") { PlaceholderView(title: "从账户移除", symbol: "minus.circle") }
            }
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 占位页

struct PlaceholderView: View {
    let title: String
    let symbol: String

    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    Image(systemName: symbol)
                        .font(.system(size: 44, weight: .light))
                        .foregroundStyle(.tertiary)
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                    Text("演示界面，此页面未实现具体功能。")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
