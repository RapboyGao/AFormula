import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ATokensIPhoneKeyboard: View {
    @Binding var status: ATokenEditStatus

    @ViewBuilder
    private func tokenButton(_ token: AToken.Content) -> some View {
        AKeyButton {
            status.insert(token)
        } content: { _ in
            Text(token.description)
                .font(.system(size: 25))
        }
    }

    @ViewBuilder
    private var numericKeyboard: some View {
        KeyBoardSpaceAroundStack(columns: 4, rowSpace: 10, columnSpace: 10) {
            tokenButton(.divide)

            AKeyButton {
                //
            } content: { _ in
                Image(systemName: "function")
                    .font(.system(size: 23))
            }

            AKeyButton {
                //
            } content: { _ in
                VStack {
                    HStack {
                        Image(systemName: AValueType.location.symbolName)
                        Image(systemName: AValueType.calendar.symbolName)
                    }
                    Image(systemName: AValueType.point.symbolName)
                }
            }

            AKeyButton {
                status.tryDeleteLeft()
            } content: { _ in
                Image(systemName: "delete.backward")
            }

            tokenButton(.plus)

            ForEach(1 ..< 4) { int in
                AKeyButton {
                    status.numberInputString += int.description
                } content: { _ in
                    ANumKeyVStack(int)
                }
            }

            tokenButton(.minus)

            ForEach(4 ..< 7) { int in
                AKeyButton {
                    status.numberInputString += int.description
                } content: { _ in
                    ANumKeyVStack(int)
                }
            }

            tokenButton(.asterisk)

            ForEach(7 ..< 10) { int in
                AKeyButton {
                    status.numberInputString += int.description
                } content: { _ in
                    ANumKeyVStack(int)
                }
            }

            AKeyButton(colors: .sameAsBackground) {
                //
            } content: { _ in
                Text("+ - =")
            }

            AKeyButton(colors: .sameAsBackground) {
                status.numberInputString += "."
            } content: { _ in
                Text(".")
            }

            AKeyButton {
                status.numberInputString += "0"
            } content: { _ in
                ANumKeyVStack(0)
            }

            AKeyButton(colors: .sameAsBackground) {
                status.insertPairOfParenthesis()
            } content: { _ in
                Text("( )")
            }
        }
    }

    public var body: some View {
        AKeyboardBackgroundView { _ in
            VStack {
//                ADragCursorView(status: $status)
                numericKeyboard
            }
        }
    }
}

#endif
