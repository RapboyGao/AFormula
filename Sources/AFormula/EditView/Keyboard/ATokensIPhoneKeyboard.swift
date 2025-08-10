import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ATokensIPhoneKeyboard: View {
    @Binding var status: ATokenEditStatus
    @Environment(\.aFormulaEditingHelper) private var helper

    @State private var usingSymbolKeyboard = false

    @ViewBuilder
    private func tokenButton(_ token: AToken.Content) -> some View {
        AKeyButton {
            status.insert(token)
            usingSymbolKeyboard = false
        } content: { _ in
            Text(token.description)
                .font(.system(size: 25))
        }
    }

    @ViewBuilder
    private func tokenButtonAsBG(_ token: AToken.Content) -> some View {
        AKeyButton(colors: .sameAsBackground) {
            status.insert(token)
            usingSymbolKeyboard = false
        } content: { _ in
            Text(token.description)
                .font(.system(size: 25))
        }
    }

    @ViewBuilder
    private var numericKeyboard: some View {
        KeyBoardSpaceAroundStack(columns: 4, rowSpace: 10, columnSpace: 10) {
            // 第1行 ---
            Group {
                tokenButton(.divide)

                AFunctionsMenuKeyButton(helper.functionGroups) { thisFunction in
                    status.insert(func: thisFunction)
                }

                ASectionsMenuKeyButton(helper.sections) { row in
                    status.insert(.row(id: row.id))
                }

                AKeyButton {
                    status.tryDeleteLeft()
                } content: { _ in
                    Image(systemName: "delete.backward")
                }
            }

            // 第2行 ---
            Group {
                tokenButton(.plus)

                ForEach(1 ..< 4) { int in
                    AKeyButton {
                        status.numberInputString += int.description
                    } content: { _ in
                        ANumKeyVStack(int)
                    }
                }
            }

            // 第3行 ---
            Group {
                tokenButton(.minus)

                ForEach(4 ..< 7) { int in
                    AKeyButton {
                        status.numberInputString += int.description
                    } content: { _ in
                        ANumKeyVStack(int)
                    }
                }
            }

            // 第4行 ---
            Group {
                tokenButton(.asterisk)

                ForEach(7 ..< 10) { int in
                    AKeyButton {
                        status.numberInputString += int.description
                    } content: { _ in
                        ANumKeyVStack(int)
                    }
                }
            }

            // 第5行 ---
            Group {
                AKeyButton(colors: .sameAsBackground) {
                    usingSymbolKeyboard.toggle()
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
    }

    @ViewBuilder
    private var symbolsKeyboard: some View {
        KeyBoardSpaceAroundStack(columns: 4, rowSpace: 10, columnSpace: 10) {
            // 第1行 ---
            Group {
                tokenButton(.divide)
                tokenButton(.comma)
                tokenButton(.questionMark)
                tokenButton(.colon)
            }

            // 第2行 ---
            Group {
                tokenButton(.plus)
                tokenButton(.equal)
                tokenButton(.greaterThan)
                tokenButton(.greaterThanOrEqual)
            }

            // 第3行 ---
            Group {
                tokenButton(.minus)
                tokenButton(.absolute)
                tokenButton(.lessThan)
                tokenButton(.lessThanOrEqual)
            }

            // 第4行 ---
            Group {
                tokenButton(.asterisk)
                tokenButton(.and)
                tokenButton(.or)
                tokenButton(.not)
            }

            // 第5行 ---
            Group {
                AKeyButton(colors: .sameAsBackground) {
                    usingSymbolKeyboard.toggle()
                } content: { _ in
                    Text("123")
                }

                tokenButtonAsBG(.leftParenthesis)
                tokenButton(.power)
                tokenButtonAsBG(.rightParenthesis)
            }
        }
    }

    public var body: some View {
        VStack {
            AKeyboardBackgroundView { _ in
                VStack {
                    Spacer()
                    ADragCursorView(status: $status)
                        .padding([.leading, .trailing], 10)
                    if usingSymbolKeyboard {
                        symbolsKeyboard
                    } else {
                        numericKeyboard
                    }
                }
            }
        }
    }
}

#endif
