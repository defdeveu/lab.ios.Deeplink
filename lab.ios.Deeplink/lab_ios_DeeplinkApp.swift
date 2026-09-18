import SwiftUI

@main
struct DeeplinkLabApp: App {
    @State private var viewModel: ContentViewModel

    @MainActor
    init() {
        _viewModel = State(initialValue: AppRepository.makeContentViewModel())
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(viewModel: viewModel)
            }
            .tint(.orange)
            .onOpenURL(perform: viewModel.handle)
        }
    }
}
