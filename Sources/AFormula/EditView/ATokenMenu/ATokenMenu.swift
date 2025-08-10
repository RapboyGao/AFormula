import AValue
import AViewUI
import SwiftUI

#if os(iOS)
@available(iOS 16, *)
public struct ATokenMenu: View {
    @Binding var token: AToken
    @Environment(\.aFormulaEditingHelper) private var editingHelper

    var handleDelete: () -> Void
    var cursorToLeft: () -> Void
    var cursorToRight: () -> Void

    private var tokenString: String? {
        token.toString(rows: editingHelper.rowDict, functions: editingHelper.functionNameDict)
    }

    public var body: some View {
        Menu {
            Button(I18n.delete, systemImage: "trash", role: .destructive, action: handleDelete)
            Button(I18n.editOnTheLeft, systemImage: "arrow.left", action: cursorToLeft)
            Button(I18n.editOnTheRight, systemImage: "arrow.right", action: cursorToRight)

            Menu {
                ForEach(editingHelper.sections) { section in
                    Menu(section.name) {
                        ForEach(section.rows) { row in
                            Button(row.name) {
                                token.content = .row(id: row.id)
                            }
                        }
                    }
                }
            } label: {
                Label(I18n.changeToVariable, systemImage: "list.bullet.indent")
            }

//            Menu {
//                ForEach(editingHelper.functionGroups) { funcGroup in
//                    Menu(funcGroup.id.shortName, systemImage: funcGroup.id.systemImage) {
//                        ForEach(funcGroup.functions) { someFunction in
//                            Button(someFunction.description) {
//                                //
//                            }
//                        }
//                    }
//                }
//            } label: {
//                Label(I18n.changeToVariable, systemImage: "list.bullet.indent")
//            }

        } label: {
            if let tokenString = tokenString {
                Text(tokenString)
                    .foregroundStyle(token.colorForLightTheme())
            } else if case let .value(value) = token.content {
                AValueAsArgumentView(value: value, precision: .fractionLength(0 ... 20), unit: nil, name: "Value")
            } else {
                Text(token.placeholder ?? "??")
                    .foregroundStyle(.gray)
            }
        }
    }

    public init(
        _ token: Binding<AToken>, handleDelete: @escaping () -> Void,
        cursorToLeft: @escaping () -> Void, cursorToRight: @escaping () -> Void
    ) {
        self._token = token
        self.handleDelete = handleDelete
        self.cursorToLeft = cursorToLeft
        self.cursorToRight = cursorToRight
    }
}

@available(iOS 16, *)
private struct ATokenMenuPreview: View {
    @State private var token = AToken(.row(id: 1))

    var body: some View {
        ATokenMenu(
            $token, handleDelete: {}, cursorToLeft: {}, cursorToRight: {}
        )
        .environment(\.aFormulaEditingHelper, AFormulaEditingHelper.defaultValue)
    }
}

@available(iOS 16, *)
#Preview {
    ATokenMenuPreview()
}

#endif
