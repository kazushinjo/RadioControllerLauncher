import AppKit
import Foundation

@MainActor
final class ControllerLauncher: ObservableObject {
    @Published private(set) var runningBundleIDs: Set<String> = []

    private let workspace = NSWorkspace.shared
    private var timer: Timer?

    init() {
        refreshRunningState()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.refreshRunningState() }
        }
    }

    func isRunning(_ target: ControllerTarget) -> Bool {
        runningBundleIDs.contains(target.id)
    }

    func launch(_ target: ControllerTarget) {
        if let running = workspace.runningApplications.first(where: {
            $0.localizedName == target.name || $0.localizedName == target.appName
        }) {
            running.activate(options: [.activateAllWindows])
            refreshRunningState()
            return
        }

        let home = FileManager.default.homeDirectoryForCurrentUser.path
        guard let path = target.candidatePaths(homeDirectory: home).first(where: {
            FileManager.default.fileExists(atPath: $0)
        }) else {
            presentError("\(target.name)が見つかりません。Applicationsフォルダーへ配置してください。")
            return
        }

        workspace.openApplication(at: URL(fileURLWithPath: path),
                                  configuration: NSWorkspace.OpenConfiguration()) { [weak self] _, error in
            Task { @MainActor in
                if let error { self?.presentError("\(target.name)を起動できませんでした: \(error.localizedDescription)") }
                self?.refreshRunningState()
            }
        }
    }

    func refreshRunningState() {
        let names = Set(workspace.runningApplications.compactMap(\.localizedName))
        runningBundleIDs = Set(ControllerTarget.all.compactMap { target in
            names.contains(target.name) || names.contains(target.appName) ? target.id : nil
        })
    }

    private func presentError(_ message: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "起動できません"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
