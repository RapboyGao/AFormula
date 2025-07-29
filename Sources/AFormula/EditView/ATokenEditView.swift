import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ATokenEditView: View {
    @Binding var status: ATokenEditStatus
    @FocusState private var focused: Bool
    @State private var dragPosition = CGPoint()

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

            Group {
                if status.isDraggingCursor {
                    AInputCursorNonAlternating()
                } else {
                    TextField("", text: .constant(""))
                        .focused($focused)
                }
            }
            .frame(width: 5)

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
        VStack {
            ATokenEditView(status: $status)
            ADragCursorView(status: $status)
                .padding(3)
        }
    }
}

@available(iOS 16, *)
#Preview {
    ATokenEditPreview()
}

#endif
