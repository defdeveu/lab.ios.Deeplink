import Foundation

enum DeepLinkAction: Equatable, Identifiable, Sendable {
    case view(reference: String)
    case delete(reference: String)
    case deleteAll

    var id: String {
        switch self {
        case let .view(reference):
            "view:\(reference)"
        case let .delete(reference):
            "delete:\(reference)"
        case .deleteAll:
            "delete-all"
        }
    }

    var title: String {
        switch self {
        case .view:
            "View item"
        case .delete:
            "Delete item"
        case .deleteAll:
            "Delete all items"
        }
    }

    var message: String {
        switch self {
        case let .view(reference):
            "Preview of item \(reference)"
        case let .delete(reference):
            "Removing item \(reference)"
        case .deleteAll:
            "Removing all items"
        }
    }
}

protocol DeepLinkParsing: Sendable {
    func parse(url: URL) -> DeepLinkAction?
}

struct DeepLinkParser: DeepLinkParsing {
    func parse(url: URL) -> DeepLinkAction? {
        guard url.scheme?.lowercased() == "defdev",
              url.user == nil,
              url.password == nil,
              url.port == nil,
              url.path.isEmpty,
              url.fragment == nil,
              let host = url.host,
              !host.isEmpty
        else {
            return nil
        }

        if host.lowercased() == "deleteall" {
            guard url.query == nil else {
                return nil
            }
            return .deleteAll
        }

        guard isValid(reference: host) else {
            return nil
        }

        switch url.query {
        case "view":
            return .view(reference: host)
        case "delete":
            return .delete(reference: host)
        default:
            return nil
        }
    }

    private func isValid(reference: String) -> Bool {
        reference.count <= 64 && reference.allSatisfy { character in
            character.isLetter || character.isNumber || character == "-" || character == "_"
        }
    }
}
