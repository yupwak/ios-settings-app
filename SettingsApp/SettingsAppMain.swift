import SwiftUI

@main
struct SettingsAppMain: App {
    @AppStorage("appearance") private var appearance = 0

    var body: some Scene {
        WindowGroup {
            RootSettingsView()
                .preferredColorScheme(appearance == 1 ? .light : (appearance == 2 ? .dark : nil))
        }
    }
}
