@MainActor
enum AppRepository {
    static func makeContentViewModel() -> ContentViewModel {
        ContentViewModel(
            parser: DeepLinkParser(),
            clipboard: SystemClipboard()
        )
    }
}
