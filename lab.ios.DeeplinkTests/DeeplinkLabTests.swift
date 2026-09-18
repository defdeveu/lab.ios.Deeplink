import Foundation
import XCTest
@testable import lab_ios_Deeplink

final class DeepLinkParserTests: XCTestCase {
    private let parser = DeepLinkParser()

    func testParsesViewAction() throws {
        let action = parser.parse(url: try XCTUnwrap(URL(string: "defdev://12345?view")))

        XCTAssertEqual(action, .view(reference: "12345"))
    }

    func testParsesDeleteAction() throws {
        let action = parser.parse(url: try XCTUnwrap(URL(string: "defdev://item_42?delete")))

        XCTAssertEqual(action, .delete(reference: "item_42"))
    }

    func testParsesDeleteAllAction() throws {
        let action = parser.parse(url: try XCTUnwrap(URL(string: "defdev://deleteall")))

        XCTAssertEqual(action, .deleteAll)
    }

    func testRejectsUnregisteredSchemeAndUnknownAction() throws {
        XCTAssertNil(
            parser.parse(url: try XCTUnwrap(URL(string: "https://12345?view")))
        )
        XCTAssertNil(
            parser.parse(url: try XCTUnwrap(URL(string: "defdev://12345?export")))
        )
    }

    func testRejectsUnexpectedPathFragmentAndDeleteAllQuery() throws {
        XCTAssertNil(
            parser.parse(url: try XCTUnwrap(URL(string: "defdev://12345/path?view")))
        )
        XCTAssertNil(
            parser.parse(url: try XCTUnwrap(URL(string: "defdev://12345?view#fragment")))
        )
        XCTAssertNil(
            parser.parse(url: try XCTUnwrap(URL(string: "defdev://deleteall?view")))
        )
    }
}

@MainActor
final class ContentViewModelTests: XCTestCase {
    func testCopyWritesSampleAndPublishesFeedback() {
        let clipboard = RecordingClipboard()
        let viewModel = ContentViewModel(
            parser: DeepLinkParser(),
            clipboard: clipboard
        )
        let sample = DeepLinkSample(urlText: "defdev://12345?view")

        viewModel.copy(sample)

        XCTAssertEqual(clipboard.writtenText, sample.urlText)
        XCTAssertEqual(viewModel.lastCopiedURL, sample.urlText)
    }

    func testRecognizedURLPublishesActionNotice() throws {
        let viewModel = ContentViewModel(
            parser: DeepLinkParser(),
            clipboard: RecordingClipboard()
        )

        viewModel.handle(url: try XCTUnwrap(URL(string: "defdev://12345?delete")))

        XCTAssertEqual(
            viewModel.notice,
            .action(.delete(reference: "12345"))
        )
    }

    func testUnsupportedURLPublishesRejectionNotice() throws {
        let viewModel = ContentViewModel(
            parser: DeepLinkParser(),
            clipboard: RecordingClipboard()
        )
        let url = try XCTUnwrap(URL(string: "https://example.invalid/item"))

        viewModel.handle(url: url)

        XCTAssertEqual(viewModel.notice, .unsupported(url: url))
    }
}

@MainActor
private final class RecordingClipboard: ClipboardWriting {
    private(set) var writtenText: String?

    func write(_ text: String) {
        writtenText = text
    }
}
