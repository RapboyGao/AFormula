import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ATokensIPadKeyboard: View {
    @Binding var status: ATokenEditStatus
    @Environment(\.aFormulaEditingHelper) private var helper

    // 为iPad设计的按钮样式
    @ViewBuilder
    private func tokenButton(_ token: AToken.Content) -> some View {
        AKeyButton {
            status.insert(token)
        } content: { _ in
            Text(token.description)
                .font(.system(size: 28)) // iPad上使用稍大的字体
        }
    }

    @ViewBuilder
    private func tokenButtonAsBG(_ token: AToken.Content) -> some View {
        AKeyButton(colors: .sameAsBackground) {
            status.insert(token)
        } content: { _ in
            Text(token.description)
                .font(.system(size: 28))
        }
    }

    // 数字和符号集成的键盘布局，充分利用iPad的宽屏
    @ViewBuilder
    private var integratedKeyboard: some View {
        // 定义iPad键盘的两大部分：左侧数字部分和右侧符号部分
        HStack(spacing: 15) {
            // 左侧数字区域 (5列)
            KeyBoardSpaceAroundStack(columns: 5, rowSpace: 12, columnSpace: 12) {
                // 第1行 - 功能和运算符
                Group {
                    AFunctionsMenuKeyButton(helper.functionGroups) { thisFunction in
                        status.insert(func: thisFunction)
                    }

                    ASectionsMenuKeyButton(helper.sections) { row in
                        status.insert(.row(id: row.id))
                    }

                    tokenButton(.plus)
                    tokenButton(.minus)
                    tokenButton(.divide)
                }

                // 第2行 - 数字1-5
                Group {
                    ForEach(1..<6) { int in
                        AKeyButton {
                            status.numberInputString += int.description
                        } content: { _ in
                            ANumKeyVStack(int)
                        }
                    }
                }

                // 第3行 - 数字6-9和0
                Group {
                    ForEach(6..<10) { int in
                        AKeyButton {
                            status.numberInputString += int.description
                        } content: { _ in
                            ANumKeyVStack(int)
                        }
                    }

                    AKeyButton {
                        status.numberInputString += "0"
                    } content: { _ in
                        ANumKeyVStack(0)
                    }
                }

                // 第4行 - 小数点和括号
                Group {
                    AKeyButton(colors: .sameAsBackground) {
                        status.numberInputString += "."
                    } content: { _ in
                        Text(".")
                            .font(.system(size: 32))
                    }

                    tokenButtonAsBG(.leftParenthesis)
                    tokenButtonAsBG(.rightParenthesis)
                    tokenButton(.power)
                    tokenButton(.asterisk)
                }
            }

            // 右侧符号区域 (4列)
            KeyBoardSpaceAroundStack(columns: 4, rowSpace: 12, columnSpace: 12) {
                // 第1行 - 关系运算符
                Group {
                    tokenButton(.equal)
                    tokenButton(.greaterThan)
                    tokenButton(.lessThan)
                    tokenButton(.comma)
                }

                // 第2行 - 复合关系运算符
                Group {
                    tokenButton(.greaterThanOrEqual)
                    tokenButton(.lessThanOrEqual)
                    tokenButton(.absolute)
                    tokenButton(.questionMark)
                }

                // 第3行 - 逻辑运算符
                Group {
                    tokenButton(.and)
                    tokenButton(.or)
                    tokenButton(.not)
                    tokenButton(.colon)
                }

                // 第4行 - 特殊功能和删除
                Group {
                    AKeyButton(colors: .sameAsBackground) {
                        status.insertPairOfParenthesis()
                    } content: { _ in
                        Text("( )")
                    }

                    AKeyButton(colors: .sameAsBackground) {
                        // 可以添加一个iPad特有的功能按钮
                    } content: { _ in
                        Text("...")
                    }

                    AKeyButton {
                        status.tryDeleteLeft()
                    } content: { _ in
                        Image(systemName: "delete.backward")
                            .font(.system(size: 28))
                    }
                }
            }
        }
    }

    public var body: some View {
        VStack {
            AKeyboardBackgroundView { _ in
                VStack {
                    Spacer()
                    ADragCursorView(status: $status)
                        .padding([.leading, .trailing], 15)
                        .frame(height: 40) // iPad上稍微增加光标视图的高度
                    integratedKeyboard
                        .padding([.leading, .trailing, .bottom], 15) // 增加iPad上的边距
                }
            }
        }
    }
}

#endif

#if os(iOS) && DEBUG

@available(iOS 16, *)
private struct Example: View {
    @State private var status = ATokenEditStatus(formula: 1 + 2)

    public var body: some View {
        ATokensIPadKeyboard(status: $status)
            .frame(height: 350)
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
