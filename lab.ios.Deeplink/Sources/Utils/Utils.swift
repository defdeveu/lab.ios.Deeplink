import SwiftUI

// MARK: - Button style

struct SolidButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .frame(minHeight: 48)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Spacer()
        }
        .foregroundColor(AppColors.buttonText)
        .font(.headline)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.buttonOverlay, lineWidth: 2)
        )
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .padding([.top, .bottom], 8)
    }
}

// MARK: - Colors

enum AppColors {
    // TODO color scheme dependency

    static let navigationBackground = Color(UIColor(named: "NavigationBkgdColor") ?? .black)
    static let navigationForeground = Color(UIColor(named: "NavigationFrgdColor") ?? .orange)
    static let buttonOverlay = Color(UIColor(named: "ButtonOverlayColor") ?? .orange)
    static let buttonText = Color(UIColor(named: "ButtonTextColor") ?? .white)
    static let checkmark = Color(UIColor(named: "CheckmarkColor") ?? .green)
    static let deeplink = Color(UIColor(named: "DeeplinkColor") ?? .orange)
}

// MARK: - Strings

enum AppStrings {
    static let appTitle = "DEEPLINK LAB"
}

// MARK: - Images

enum AppImages {
    static let navigationImage = UIImage(named: "bg-banner.ddd.2108.dark")
    static let appTitleImage = Image("logo.ddd.stamp.1905")
    static let copyImage = Image(systemName: "doc.on.doc")
}
