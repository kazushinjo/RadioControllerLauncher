import Foundation

struct ControllerTarget: Identifiable, Equatable {
    let id: String
    let name: String
    let shortName: String
    let appName: String
    let bundleIdentifier: String
    let systemImage: String

    var applicationPath: String { "/Applications/\(appName).app" }

    func candidatePaths(homeDirectory: String) -> [String] {
        [
            applicationPath,
            "\(homeDirectory)/Applications/\(appName).app",
            "\(homeDirectory)/アプリ開発/\(sourceDirectory)/\(appName).app"
        ]
    }

    private var sourceDirectory: String {
        switch id {
        case "kx3": "KX3_CAT"
        case "ft817": "FT817_CAT"
        default: "FT857_897_CAT"
        }
    }

    static let all: [ControllerTarget] = [
        .init(id: "kx3", name: "KX3 Controller", shortName: "KX3", appName: "KX3Controller", bundleIdentifier: "jp.shinjo.KX3Controller", systemImage: "radio"),
        .init(id: "ft817", name: "FT-817 Controller", shortName: "FT-817", appName: "FT817Controller", bundleIdentifier: "jp.shinjo.FT817Controller", systemImage: "dot.radiowaves.left.and.right"),
        .init(id: "ft8x7", name: "FT-857D / FT-897D Controller", shortName: "FT-857/897", appName: "FT857897Controller", bundleIdentifier: "jp.shinjo.FT857897Controller", systemImage: "antenna.radiowaves.left.and.right")
    ]
}
