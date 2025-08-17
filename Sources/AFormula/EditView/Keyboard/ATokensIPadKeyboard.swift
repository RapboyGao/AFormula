import AValue
import AViewUI
import SwiftUI

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
            // 右侧符号区域 (4列)
            KeyBoardSpaceAroundStack(columns: 4, rowSpace: 12, columnSpace: 12) {
                // 第1行 - 主要运算符
                Group {
                    tokenButton(.plus)
                    tokenButton(.minus)
                    tokenButton(.asterisk)
                    tokenButton(.divide)
                }

                // 第2行 - 关系运算符
                Group {
                    tokenButton(.equal)
                    tokenButton(.greaterThan)
                    tokenButton(.lessThan)
                    tokenButton(.power)
                }

                // 第3行 - 复合关系运算符
                Group {
                    tokenButton(.greaterThanOrEqual)
                    tokenButton(.lessThanOrEqual)
                    tokenButton(.absolute)
                    tokenButton(.comma)
                }

                // 第4行 - 逻辑运算符和特殊符号
                Group {
                    tokenButton(.and)
                    tokenButton(.or)
                    tokenButton(.not)
                    tokenButton(.questionMark)
                }

                // 第5行 - 括号和其他功能
                Group {
                    tokenButtonAsBG(.leftParenthesis)
                    tokenButtonAsBG(.rightParenthesis)
                    tokenButton(.colon)
                }
            }

            // 左侧数字区域 (九宫格布局)
            KeyBoardSpaceAroundStack(columns: 3, rowSpace: 12, columnSpace: 12) {
                // 第1行 - 功能和运算符
                Group {
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
                            .font(.system(size: 28))
                    }
                }

                // 第2行 - 数字1-3 (九宫格第一行)
                Group {
                    AKeyButton {
                        status.numberInputString += "1"
                    } content: { _ in
                        ANumKeyVStack(1)
                    }

                    AKeyButton {
                        status.numberInputString += "2"
                    } content: { _ in
                        ANumKeyVStack(2)
                    }

                    AKeyButton {
                        status.numberInputString += "3"
                    } content: { _ in
                        ANumKeyVStack(3)
                    }
                }

                // 第3行 - 数字4-6 (九宫格第二行)
                Group {
                    AKeyButton {
                        status.numberInputString += "4"
                    } content: { _ in
                        ANumKeyVStack(4)
                    }

                    AKeyButton {
                        status.numberInputString += "5"
                    } content: { _ in
                        ANumKeyVStack(5)
                    }

                    AKeyButton {
                        status.numberInputString += "6"
                    } content: { _ in
                        ANumKeyVStack(6)
                    }
                }

                // 第4行 - 数字7-9 (九宫格第三行)
                Group {
                    AKeyButton {
                        status.numberInputString += "7"
                    } content: { _ in
                        ANumKeyVStack(7)
                    }

                    AKeyButton {
                        status.numberInputString += "8"
                    } content: { _ in
                        ANumKeyVStack(8)
                    }

                    AKeyButton {
                        status.numberInputString += "9"
                    } content: { _ in
                        ANumKeyVStack(9)
                    }
                }

                // 第5行 - 特殊键和0 (九宫格第四行)
                Group {
                    AKeyButton(colors: .sameAsBackground) {
                        status.insertPairOfParenthesis()
                    } content: { _ in
                        Text("( )")
                            .font(.system(size: 28))
                    }

                    AKeyButton {
                        status.numberInputString += "0"
                    } content: { _ in
                        ANumKeyVStack(0)
                    }

                    AKeyButton(colors: .sameAsBackground) {
                        status.numberInputString += "."
                    } content: { _ in
                        Text(".")
                            .font(.system(size: 32))
                    }
                }
            }
        }
    }

    public var body: some View {
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
