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
            HStack(spacing: 4) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                Text("無線機")
            }
        }
        .menuBarExtraStyle(.menu)
    }
}
