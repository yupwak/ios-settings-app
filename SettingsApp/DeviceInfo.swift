import UIKit
import Foundation

enum DeviceInfo {
    static var identifier: String {
        var info = utsname()
        uname(&info)
        return withUnsafePointer(to: &info.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 64) { String(cString: $0) }
        }
    }

    static var marketingName: String {
        names[identifier] ?? identifier
    }

    static var systemName: String { UIDevice.current.systemName }
    static var systemVersion: String { UIDevice.current.systemVersion }
    static var deviceName: String { UIDevice.current.name }
    static var model: String { UIDevice.current.model }

    static var processorCount: Int { ProcessInfo.processInfo.processorCount }
    static var activeProcessorCount: Int { ProcessInfo.processInfo.activeProcessorCount }

    static var physicalMemory: Int64 { Int64(ProcessInfo.processInfo.physicalMemory) }

    static var uptime: TimeInterval { ProcessInfo.processInfo.systemUptime }
    static var bootTime: Date { Date(timeIntervalSinceNow: -uptime) }

    static var screenSize: String {
        let b = UIScreen.main.nativeBounds.size
        let s = UIScreen.main.scale
        return "\(Int(b.width)) × \(Int(b.height)) @\(Int(s))x"
    }

    static var screenPoints: String {
        let b = UIScreen.main.bounds.size
        return "\(Int(b.width)) × \(Int(b.height)) pt"
    }

    static var storage: (total: Int64, free: Int64) {
        let url = URL(fileURLWithPath: NSHomeDirectory())
        let values = try? url.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey])
        let total = Int64(values?.volumeTotalCapacity ?? 0)
        let free = values?.volumeAvailableCapacityForImportantUsage ?? 0
        return (total, Int64(free))
    }

    static var locale: String { Locale.current.identifier }
    static var region: String { Locale.current.region?.identifier ?? "—" }
    static var timeZone: String { TimeZone.current.identifier }
    static var language: String {
        Locale.preferredLanguages.first ?? "—"
    }

    static var batteryLevel: String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        guard level >= 0 else { return "未知" }
        return "\(Int(level * 100))%"
    }

    static var batteryState: String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        switch UIDevice.current.batteryState {
        case .charging: return "正在充电"
        case .full: return "已充满"
        case .unplugged: return "使用电池"
        case .unknown: return "未知"
        @unknown default: return "未知"
        }
    }

    static func bytes(_ value: Int64) -> String {
        let f = ByteCountFormatter()
        f.countStyle = .file
        f.allowedUnits = [.useGB, .useMB]
        return f.string(fromByteCount: value)
    }

    private static let names: [String: String] = [
        "iPhone12,1": "iPhone 11", "iPhone12,3": "iPhone 11 Pro", "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone12,8": "iPhone SE (第 2 代)",
        "iPhone13,1": "iPhone 12 mini", "iPhone13,2": "iPhone 12", "iPhone13,3": "iPhone 12 Pro", "iPhone13,4": "iPhone 12 Pro Max",
        "iPhone14,2": "iPhone 13 Pro", "iPhone14,3": "iPhone 13 Pro Max", "iPhone14,4": "iPhone 13 mini",
        "iPhone14,5": "iPhone 13", "iPhone14,6": "iPhone SE (第 3 代)",
        "iPhone14,7": "iPhone 14", "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro", "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone15,4": "iPhone 15", "iPhone15,5": "iPhone 15 Plus",
        "iPhone16,1": "iPhone 15 Pro", "iPhone16,2": "iPhone 15 Pro Max",
        "iPhone16,5": "iPhone 16e",
        "iPad13,1": "iPad Air (第 4 代)", "iPad13,18": "iPad (第 10 代)",
        "iPad14,1": "iPad mini (第 6 代)",
        "arm64": "模拟器"
    ]
}
