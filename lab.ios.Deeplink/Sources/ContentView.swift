import SwiftUI

struct ContentView: View {
    @State private var viewModel: ContentViewModel

    @MainActor
    init(viewModel: ContentViewModel = AppRepository.makeContentViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Deep-link actions")
                        .font(.largeTitle.bold())
                    Text("Copy a sample URL, then open it from Safari or another app.")
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.samples) { sample in
                    sampleButton(sample)
                }

                if let copiedURL = viewModel.lastCopiedURL {
                    Label("Copied \(copiedURL)", systemImage: "checkmark.circle.fill")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Copied sample URL")
                }
            }
            .frame(maxWidth: 640, alignment: .leading)
            .padding(24)
        }
        .navigationTitle(AppStrings.appTitle)
        .toolbarTitleDisplayMode(.inline)
        .labToolbar()
        .alert(
            viewModel.notice?.title ?? "Deep link",
            isPresented: Binding(
                get: { viewModel.notice != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearNotice()
                    }
                }
            ),
            presenting: viewModel.notice
        ) { _ in
            Button("OK", role: .cancel, action: viewModel.clearNotice)
        } message: { notice in
            Text(notice.message)
        }
    }

    @ViewBuilder
    private func sampleButton(_ sample: DeepLinkSample) -> some View {
        Button {
            viewModel.copy(sample)
        } label: {
            Label(sample.urlText, systemImage: "doc.on.doc")
                .fontDesign(.monospaced)
        }
        .buttonStyle(SolidButtonStyle())
        .accessibilityHint("Copies this URL to the clipboard")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
