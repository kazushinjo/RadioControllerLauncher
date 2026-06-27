import SwiftUI
import AppKit

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
                        .frame(width: 28, height: 26)
                }
                .buttonStyle(.borderless)
                .help("起動状態を更新")

                Spacer()

                Text("CONTROLLER SELECT")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(.tertiary)

                Spacer()

                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Image(systemName: "power")
                        .frame(width: 28, height: 26)
                }
                .buttonStyle(.borderless)
                .help("ランチャーを終了")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 360)
        .background(.ultraThinMaterial)
    }

    private var header: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.92, green: 0.55, blue: 0.12))
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 1) {
                Text("無線機コントローラー")
                    .font(.system(size: 15, weight: .bold))
                Text("RADIO CONTROL DESK")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("3 RIGS")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color.primary.opacity(0.045))
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
                    .foregroundStyle(isRunning ? Color.green : Color.secondary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text(target.name)
                        .font(.system(size: 13, weight: .semibold))
                    HStack(spacing: 5) {
                        Circle()
                            .fill(isRunning ? Color.green : Color.secondary.opacity(0.45))
                            .frame(width: 6, height: 6)
                        Text(isRunning ? "起動中" : "停止中")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Image(systemName: isRunning ? "arrow.up.forward.app" : "play.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isRunning ? Color.secondary : Color(red: 0.92, green: 0.55, blue: 0.12))
                    .frame(width: 24)
            }
            .padding(.horizontal, 12)
            .frame(height: 58)
            .background(isHovered ? Color.primary.opacity(0.09) : Color.primary.opacity(0.045))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isRunning ? Color.green.opacity(0.35) : Color.primary.opacity(0.1), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .help(isRunning ? "前面に表示" : "起動")
    }
}
