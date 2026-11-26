import SwiftUI

/// 系统「设置」的度量：单行行高 44、图标 29×29 圆角 7、正文 17pt、左右内边距 16。
enum RowMetrics {
    static let height: CGFloat = 44
    static let iconSize: CGFloat = 29
    static let iconCorner: CGFloat = 7
    static let hInset: CGFloat = 16
    static let spacing: CGFloat = 12
    /// 分隔线对齐到文字（图标宽 + 间距）
    static let separatorAfterIcon: CGFloat = iconSize + spacing
}

extension View {
    /// 行高由内容固定，去掉 List 自带的纵向内边距，避免行被撑高
    func settingRowLayout(separatorLeading: CGFloat) -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: RowMetrics.hInset,
                                      bottom: 0, trailing: RowMetrics.hInset))
            .alignmentGuide(.listRowSeparatorLeading) { _ in separatorLeading }
    }
}

/// 单行设置行：可选图标 + 标题 + 右侧数值，高度精确 44
struct SettingsRow: View {
    let title: String
    var symbol: String? = nil
    var color: Color = .gray
    var value: String? = nil

    var body: some View {
        HStack(spacing: RowMetrics.spacing) {
            if let symbol {
                IconBadge(symbol: symbol, color: color)
            }
            Text(title)
                .font(.system(size: 17))
                .foregroundStyle(.primary)
                .lineLimit(1)
            Spacer(minLength: 8)
            if let value {
                Text(value)
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(minHeight: RowMetrics.height)
        .settingRowLayout(separatorLeading: symbol == nil ? 0 : RowMetrics.separatorAfterIcon)
    }
}

/// 两行设置行：标题 + 下方说明，高度随内容（约 60），不加额外内边距
struct SettingsSubtitleRow: View {
    let title: String
    let subtitle: String
    var symbol: String? = nil
    var color: Color = .gray
    var trailing: String? = nil

    var body: some View {
        HStack(spacing: RowMetrics.spacing) {
            if let symbol {
                IconBadge(symbol: symbol, color: color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            if let trailing {
                Text(trailing)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(minHeight: 60)
        .settingRowLayout(separatorLeading: symbol == nil ? 0 : RowMetrics.separatorAfterIcon)
    }
}

/// 键值行（关于本机那种）：左标题右数值，高度精确 44，长内容自动换行
struct KeyValueRow: View {
    let key: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text(key)
                .font(.system(size: 17))
                .foregroundStyle(.primary)
            Spacer(minLength: 8)
            Text(value)
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .frame(minHeight: RowMetrics.height)
        .settingRowLayout(separatorLeading: 0)
    }
}
