import SwiftUI

@main
struct RadioControllerLauncherApp: App {
    @StateObject private var launcher = ControllerLauncher()

    var body: some Scene {
        MenuBarExtra {
            ForEach(ControllerTarget.all) { target in
                Button {
                    launcher.launch(target)
                } label: {
                    Label {
                        Text(launcher.isRunning(target) ? "\(target.name)（起動中）" : target.name)
                    } icon: {
                        Image(systemName: launcher.isRunning(target) ? "checkmark.circle.fill" : target.systemImage)
                    }
                }
            }

            Divider()

            Button("起動状態を更新", systemImage: "arrow.clockwise") {
                launcher.refreshRunningState()
            }
            Button("ランチャーを終了", systemImage: "power", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Label("Radio Controllers", systemImage: "antenna.radiowaves.left.and.right")
        }
        .menuBarExtraStyle(.menu)
    }
}
