import SwiftUI
import AppKit

private enum LauncherPalette {
    static let chassis = Color(red: 0.075, green: 0.085, blue: 0.09)
    static let header = Color(red: 0.11, green: 0.125, blue: 0.13)
    static let surface = Color(red: 0.13, green: 0.145, blue: 0.15)
    static let hover = Color(red: 0.17, green: 0.19, blue: 0.195)
    static let amber = Color(red: 0.96, green: 0.58, blue: 0.14)
    static let cyan = Color(red: 0.22, green: 0.82, blue: 0.78)
    static let muted = Color(red: 0.60, green: 0.64, blue: 0.65)
}

struct LauncherMenuView: View {
    @ObservedObject var launcher: ControllerLauncher

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(spacing: 8) {
                ForEach(ControllerTarget.all) { target in
                    ControllerRow(target: target,
                                  isRunning: launcher.isRunning(target)) {
                        launcher.launch(target)
                    }
                }
            }
            .padding(12)

            Divider()

            HStack(spacing: 8) {
                Button {
                    launcher.refreshRunningState()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(LauncherPalette.cyan)
                        .frame(width: 28, height: 26)
                }
                .buttonStyle(.borderless)
                .help("起動状態を更新")

                Spacer()

                Text("CONTROLLER SELECT")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(LauncherPalette.muted)

                Spacer()

                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Image(systemName: "power")
                        .foregroundStyle(Color(red: 0.95, green: 0.36, blue: 0.32))
                        .frame(width: 28, height: 26)
                }
                .buttonStyle(.borderless)
                .help("ランチャーを終了")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 360)
        .background(LauncherPalette.chassis)
    }

    private var header: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(LauncherPalette.amber)
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 1) {
                Text("無線機コントローラー")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                Text("RADIO CONTROL DESK")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundStyle(LauncherPalette.muted)
            }

            Spacer()

            Text("3 RIGS")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(LauncherPalette.cyan)
        }
        .padding(14)
        .background(LauncherPalette.header)
    }
}

private struct ControllerRow: View {
    let target: ControllerTarget
    let isRunning: Bool
    let action: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: target.systemImage)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(isRunning ? LauncherPalette.cyan : LauncherPalette.muted)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text(target.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                    HStack(spacing: 5) {
                        Circle()
                            .fill(isRunning ? LauncherPalette.cyan : LauncherPalette.muted.opacity(0.45))
                            .frame(width: 6, height: 6)
                        Text(isRunning ? "起動中" : "停止中")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(LauncherPalette.muted)
                    }
                }

                Spacer()

                Image(systemName: isRunning ? "arrow.up.forward.app" : "play.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isRunning ? LauncherPalette.cyan : LauncherPalette.amber)
                    .frame(width: 24)
            }
            .padding(.horizontal, 12)
            .frame(height: 58)
            .background(isHovered ? LauncherPalette.hover : LauncherPalette.surface)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isRunning ? LauncherPalette.cyan.opacity(0.55) : LauncherPalette.muted.opacity(0.18), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .help(isRunning ? "前面に表示" : "起動")
    }
}
