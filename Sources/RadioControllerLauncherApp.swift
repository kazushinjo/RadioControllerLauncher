import AppKit
import SwiftUI

@main
@MainActor
final class LauncherAppDelegate: NSObject, NSApplicationDelegate {
    private let launcher = ControllerLauncher()
    private var launcherWindow: NSWindow?
    private var statusItem: NSStatusItem?

    static func main() {
        let application = NSApplication.shared
        let delegate = LauncherAppDelegate()
        application.delegate = delegate
        application.setActivationPolicy(.regular)
        application.finishLaunching()
        delegate.configureInterface()
        application.run()
    }

    private func configureInterface() {
        guard statusItem == nil else { return }
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = item.button else { return }
        button.image = NSImage(systemSymbolName: "antenna.radiowaves.left.and.right",
                               accessibilityDescription: "無線機コントローラー")
        button.imagePosition = .imageLeading
        button.title = " 無線機"
        button.target = self
        button.action = #selector(togglePopover(_:))
        statusItem = item

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 286),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "無線機コントローラー"
        window.appearance = NSAppearance(named: .darkAqua)
        window.backgroundColor = NSColor(red: 0.075, green: 0.085, blue: 0.09, alpha: 1)
        window.isReleasedWhenClosed = false
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.contentViewController = NSHostingController(rootView: LauncherMenuView(launcher: launcher))
        window.center()
        self.launcherWindow = window

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.showLauncherWindow()
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showLauncherWindow()
        return true
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        if launcherWindow?.isVisible != true {
            showLauncherWindow()
        }
    }

    @objc private func togglePopover(_ sender: NSStatusBarButton) {
        guard let launcherWindow else { return }
        if launcherWindow.isVisible {
            launcherWindow.orderOut(sender)
        } else {
            showLauncherWindow()
        }
    }

    private func showLauncherWindow() {
        guard let launcherWindow else { return }
        launcher.refreshRunningState()
        launcherWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
