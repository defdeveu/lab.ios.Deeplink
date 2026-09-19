import Foundation
import Testing
@testable import lab_ios_Deeplink

@Suite
struct DeepLinkParserTests {
    private let parser = DeepLinkParser()

    @Test
    func parsesViewAction() throws {
        let action = parser.parse(url: try #require(URL(string: "defdev://12345?view")))

        #expect(action == .view(reference: "12345"))
    }

    @Test
    func parsesDeleteAction() throws {
        let action = parser.parse(url: try #require(URL(string: "defdev://item_42?delete")))

        #expect(action == .delete(reference: "item_42"))
    }

    @Test
    func parsesDeleteAllAction() throws {
        let action = parser.parse(url: try #require(URL(string: "defdev://deleteall")))

        #expect(action == .deleteAll)
    }

    @Test
    func rejectsUnregisteredSchemeAndUnknownAction() throws {
        #expect(parser.parse(url: try #require(URL(string: "https://12345?view"))) == nil)
        #expect(parser.parse(url: try #require(URL(string: "defdev://12345?export"))) == nil)
    }

    @Test
    func rejectsUnexpectedPathFragmentAndDeleteAllQuery() throws {
        #expect(parser.parse(url: try #require(URL(string: "defdev://12345/path?view"))) == nil)
        #expect(parser.parse(url: try #require(URL(string: "defdev://12345?view#fragment"))) == nil)
        #expect(parser.parse(url: try #require(URL(string: "defdev://deleteall?view"))) == nil)
    }
}

@MainActor
@Suite
struct ContentViewModelTests {
    @Test
    func copyWritesSampleAndPublishesFeedback() {
        let clipboard = RecordingClipboard()
        let viewModel = ContentViewModel(
            parser: DeepLinkParser(),
            clipboard: clipboard
        )
        let sample = DeepLinkSample(urlText: "defdev://12345?view")

        viewModel.copy(sample)

        #expect(clipboard.writtenText == sample.urlText)
        #expect(viewModel.lastCopiedURL == sample.urlText)
    }

    @Test
    func recognizedURLPublishesActionNotice() throws {
        let viewModel = ContentViewModel(
            parser: DeepLinkParser(),
            clipboard: RecordingClipboard()
        )

        viewModel.handle(url: try #require(URL(string: "defdev://12345?delete")))

        #expect(viewModel.notice == .action(.delete(reference: "12345")))
    }

    @Test
    func unsupportedURLPublishesRejectionNotice() throws {
        let viewModel = ContentViewModel(
            parser: DeepLinkParser(),
            clipboard: RecordingClipboard()
        )
        let url = try #require(URL(string: "https://example.invalid/item"))

        viewModel.handle(url: url)

        #expect(viewModel.notice == .unsupported(url: url))
    }
}

@MainActor
private final class RecordingClipboard: ClipboardWriting {
    private(set) var writtenText: String?

    func write(_ text: String) {
        writtenText = text
    }
}