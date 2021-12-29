import Foundation
import SwiftUI

// MARK: - Deeplink

enum Deeplink: Equatable {
    case view(reference: String)
    case delete(reference: String)
    case deleteAll

    var description: String {
        switch self {
        case .view(let reference):
            return "Preview of item \(reference)"
        case .delete(let reference):
            return "Removing item \(reference)"
        case .deleteAll:
            return "Removing all items"
        }
    }
}

// MARK: - Deeplink EnvironmentKey

struct DeeplinkKey: EnvironmentKey {
    static let defaultValue: Deeplink? = nil
}

extension EnvironmentValues {
    var deeplink: Deeplink? {
        get { self[DeeplinkKey.self] }
        set { self[DeeplinkKey.self] = newValue }
    }
}

// MARK: - Deeplinker

protocol DeeplinkerProtocol {
    func manage(url: URL) -> Deeplink?
}

final class Deeplinker: DeeplinkerProtocol {
    func manage(url: URL) -> Deeplink? {
        guard url.scheme == "defdev" else { return nil }

        guard url.host != "deleteall" else { return .deleteAll }

        guard let reference = url.host else { return nil }

        switch url.query {
        case "view":
            return .view(reference: reference)
        case "delete":
            return .delete(reference: reference)
        default:
            return nil
        }
    }
}
