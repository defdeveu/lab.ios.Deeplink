import Foundation
import Observation
import UIKit

struct DeepLinkSample: Equatable, Identifiable, Sendable {
    let urlText: String

    var id: String { urlText }
}

struct DeepLinkNotice: Equatable, Identifiable, Sendable {
    let id: String
    let title: String
    let message: String

    static func action(_ action: DeepLinkAction) -> DeepLinkNotice {
        DeepLinkNotice(id: action.id, title: action.title, message: action.message)
    }

    static func unsupported(url: URL) -> DeepLinkNotice {
        DeepLinkNotice(
            id: "unsupported:\(url.absoluteString)",
            title: "Unsupported link",
            message: "The app did not recognize \(url.absoluteString)."
        )
    }
}

@MainActor
protocol ClipboardWriting {
    func write(_ text: String)
}

@MainActor
struct SystemClipboard: ClipboardWriting {
    func write(_ text: String) {
        UIPasteboard.general.string = text
    }
}

@MainActor
@Observable
final class ContentViewModel {
    let samples = [
        DeepLinkSample(urlText: "defdev://12345?view"),
        DeepLinkSample(urlText: "defdev://12345?delete"),
        DeepLinkSample(urlText: "defdev://deleteall")
    ]

    private(set) var lastCopiedURL: String?
    var notice: DeepLinkNotice?

    @ObservationIgnored private let parser: any DeepLinkParsing
    @ObservationIgnored private let clipboard: any ClipboardWriting

    init(
        parser: any DeepLinkParsing,
        clipboard: any ClipboardWriting
    ) {
        self.parser = parser
        self.clipboard = clipboard
    }

    func copy(_ sample: DeepLinkSample) {
        clipboard.write(sample.urlText)
        lastCopiedURL = sample.urlText
    }

    func handle(url: URL) {
        guard let action = parser.parse(url: url) else {
            notice = .unsupported(url: url)
            return
        }
        notice = .action(action)
    }

    func clearNotice() {
        notice = nil
    }
}
