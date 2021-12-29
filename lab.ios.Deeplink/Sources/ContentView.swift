import SwiftUI
import AlertToast

struct ContentView: View {
    @Environment(\.deeplink) var deeplink
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @State private var showDeeplinkToast = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("The app implements the following actions to be called from Safari:")

                menu()

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { appTitle() }
        .toast(isPresenting: $viewModel.showToast,
               alert: {
            AlertToast(displayMode: .alert,
                       type: .systemImage("checkmark", AppColors.checkmark),
                       title: "Copied!")
        })
        .onChange(of: deeplink) { deeplink in
            guard deeplink != nil else { return }

            showDeeplinkToast = true
        }
        .alert(isPresented: $showDeeplinkToast, content: {
            Alert(title: Text(deeplink?.description ?? "Unknown deeplink"))
        })
    }

    @ViewBuilder
    private func menu() -> some View {
        VStack(spacing: 10) {
            menuButton("defdev://12345?view")
            menuButton("defdev://12345?delete")
            menuButton("defdev://deleteall")
        }
    }

    @ToolbarContentBuilder
    private func appTitle() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                AppImages.appTitleImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .colorInvert()
                // TODO colorInvert as per the scheme
                Text(AppStrings.appTitle)
                    .font(.title.bold())
                    .foregroundColor(AppColors.navigationForeground)
            }
            .padding(.bottom, 8)
        }
    }

    @ViewBuilder
    private func menuButton(_ title: String) -> some View {
        Button {
            viewModel.copyToClipboard(title)
        } label: {
            AppImages.copyImage

            Text(title)
        }
        .buttonStyle(SolidButtonStyle())
    }
}

#if DEBUG
@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
#endif
