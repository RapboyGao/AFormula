import AViewUI
import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public struct ATokenMenu: View {
    @Binding var token: AToken
    @Environment(\.aFormulaEditingHelper) private var editingHelper

    var handleDelete: () -> Void
    var cursorToLeft: () -> Void
    var cursorToRight: () -> Void

    private var tokenString: String {
        token.toString(rows: editingHelper.rowDict, functions: editingHelper.functionNameDict)
    }

    public var body: some View {
        Menu {
            Text(tokenString)
            Button("Delete", systemImage: "trash", role: .destructive, action: handleDelete)
        } label: {
            Text(tokenString)
                .foregroundStyle(token.colorForLightTheme())
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

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
private struct ATokenMenuPreview: View {
    @State private var token = AToken(.row(id: 1))

    var body: some View {
        ATokenMenu(
            $token, handleDelete: {}, cursorToLeft: {}, cursorToRight: {}
        )
        .environment(\.aFormulaEditingHelper, AFormulaEditingHelper.defaultValue)
    }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
#Preview {
    ATokenMenuPreview()
}
