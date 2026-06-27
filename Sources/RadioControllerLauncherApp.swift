import SwiftUI

@main
struct RadioControllerLauncherApp: App {
    @StateObject private var launcher = ControllerLauncher()

    var body: some Scene {
        MenuBarExtra {
            LauncherMenuView(launcher: launcher)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Text("無線機")
            }
        }
        .menuBarExtraStyle(.window)
    }
}
