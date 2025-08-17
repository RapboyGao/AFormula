import AValue
import AViewUI
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct ATokensEditView: View {
    @Binding var status: ATokenEditStatus
    @State private var focused: Bool = true
    @State private var dragPosition = CGPoint()

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.aFormulaEditingHelper) private var helper

    private var tapFocus: some Gesture {
        TapGesture().onEnded { _ in
            focused = true
        }
    }

    public var body: some View {
        AWrappingStack {
            ForEach($status.tokensBeforeCursor) { bindToken in
                ATokenMenu(bindToken) {
                    status.delete(bindToken.wrappedValue)
                } cursorToLeft: {
                    status.setCursor(toBefore: bindToken.wrappedValue)
                } cursorToRight: {
                    status.setCursor(toAfter: bindToken.wrappedValue)
                }
            }

            Text(status.numberInputString)
                .underline()
                .foregroundColor(AValueType.number.color(for: colorScheme))

            Group {
                ZStack {
                    if status.isDraggingCursor {
                        AInputCursorNonAlternating(height: 30)
                    }
                    ACustomUITextField(text: .constant(""), startIndex: .constant(.init(utf16Offset: 0, in: "")), endIndex: .constant(.init(utf16Offset: 0, in: "")), focused: $focused) { _ in
                        ATokensIPhoneKeyboard(status: $status)
                            .environment(\.aFormulaEditingHelper, helper)
                            .frame(height: 350)
                    } makeTextfield: {
                        let textfield = UITextField()
                        textfield.frame = CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: 3, height: 30))
                        return textfield
                    }
                    .opacity(status.isDraggingCursor ? 0 : 1)
                    .offset(y: 4.5)
                }
            }
            .frame(width: 3)

            ForEach($status.tokensAfterCursor) { bindToken in
                ATokenMenu(bindToken) {
                    status.delete(bindToken.wrappedValue)
                } cursorToLeft: {
                    status.setCursor(toBefore: bindToken.wrappedValue)
                } cursorToRight: {
                    status.setCursor(toAfter: bindToken.wrappedValue)
                }
            }
        }
        .onChange(of: status.isDraggingCursor) { _ in
            focused = true
        }
        .onChange(of: focused) { _ in
            focused = true
        }
        .onAppear {
            focused = true
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                AValueToolbarItems { value in
                    status.insert(.value(value))
                }
            }
        }
        .padding()
        .font(.system(size: 22))
        .simultaneousGesture(tapFocus)
    }

    public init(status: Binding<ATokenEditStatus>) {
        _status = status
    }
}

@available(iOS 16, *)
private struct ATokenEditPreview: View {
    @State private var status = ATokenEditStatus(formula: AFormula.example)

    var body: some View {
        NavigationStack {
            VStack {
                ATokensEditView(status: $status)
                Spacer()
                ATokensIPhoneKeyboard(status: $status)
                    .frame(height: 350)
            }
        }
    }
}

@available(iOS 16, *)
#Preview {
    ATokenEditPreview()
}

#endif
