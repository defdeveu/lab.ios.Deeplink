import Foundation
import Combine
import UIKit

class ContentViewModel: ObservableObject {

    @Published var showToast: Bool = false

    init() {
    }

    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        showToast = true
    }
}
