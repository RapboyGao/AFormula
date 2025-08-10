import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ATokensEditView: View {
    @Binding var status: ATokenEditStatus
    @FocusState private var focused: Bool
    @State private var dragPosition = CGPoint()

    @Environment(\.colorScheme) private var colorScheme

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
                        AInputCursorNonAlternating()
                    }
                    TextField("", text: .constant(""))
                        .aKeyboardView { _ in
                            ATokensIPhoneKeyboard(status: $status)
                                .frame(height: 380)
                        }
                        .focused($focused)
                        .opacity(status.isDraggingCursor ? 0 : 1)
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
                    .frame(height: 380)
            }
        }
    }
}

@available(iOS 16, *)
#Preview {
    ATokenEditPreview()
}

#endif
