import AValue
import AViewUI
import SwiftUI
import UIKit

#if os(iOS)

@available(iOS 16, *)
public struct ATokensKeyboard: View {
    @Binding var status: ATokenEditStatus
    @Environment(\.aFormulaEditingHelper) private var helper
    
    // 检测当前设备是否为iPad
    private var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // 根据设备类型选择合适的键盘高度
    private var keyboardHeight: CGFloat {
        isiPad ? 380 : 350
    }
    
    public var body: some View {
        Group {
            if isiPad {
                ATokensIPadKeyboard(status: $status)
                    .environment(\.aFormulaEditingHelper, helper)
            } else {
                ATokensIPhoneKeyboard(status: $status)
                    .environment(\.aFormulaEditingHelper, helper)
            }
        }
        .frame(height: keyboardHeight)
    }
    
    public init(status: Binding<ATokenEditStatus>) {
        _status = status
    }
}

#endif

#if os(iOS) && DEBUG

@available(iOS 16, *)
private struct Example: View {
    @State private var status = ATokenEditStatus(formula: 1 + 2)
    
    public var body: some View {
        ATokensKeyboard(status: $status)
    }
}

@available(iOS 16, *)
#Preview { 
    Example()
}

#endif