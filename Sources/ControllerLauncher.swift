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
        Task { await launchExclusively(target) }
    }

    private func launchExclusively(_ target: ControllerTarget) async {
        let otherApplications = ControllerTarget.all
            .filter { $0.id != target.id }
            .flatMap { NSRunningApplication.runningApplications(withBundleIdentifier: $0.bundleIdentifier) }

        otherApplications.forEach { $0.terminate() }

        if !otherApplications.isEmpty {
            for _ in 0..<30 {
                if otherApplications.allSatisfy({ $0.isTerminated }) { break }
                try? await Task.sleep(for: .milliseconds(100))
            }
            guard otherApplications.allSatisfy({ $0.isTerminated }) else {
                presentError("起動中のControllerを終了できませんでした。終了を確認してから再実行してください。")
                refreshRunningState()
                return
            }
        }

        if let running = NSRunningApplication.runningApplications(withBundleIdentifier: target.bundleIdentifier).first {
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
        runningBundleIDs = Set(ControllerTarget.all.compactMap { target in
            NSRunningApplication.runningApplications(withBundleIdentifier: target.bundleIdentifier).isEmpty ? nil : target.id
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
