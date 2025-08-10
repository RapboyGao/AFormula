import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AFormulaEditButton: View {
    @Binding var formula: AFormula
    @Environment(\.aFormulaEditingHelper) private var helper
    @State private var status: ATokenEditStatus

    private var newFormula: AFormula? {
        try? status.toFormula()
    }

    public var body: some View {
        ASheetButton {
            .init(.fullScreenCover, .button, return: newFormula == nil ? .cancel : .done)
        } label: {
            AFormulaText(formula, helper: helper)
        } cover: {
            ATokensEditView(status: $status)
        } onSheetClosed: {
            if let newFormula {
                self.formula = newFormula
            }
        }
    }

    public init(_ formula: Binding<AFormula>) {
        _formula = formula
        _status = State(initialValue: ATokenEditStatus(formula: formula.wrappedValue))
    }
}

@available(iOS 16, *)
private struct Example: View {
    @State var formula = 1 + 3 * .p(25 + 15)

    var body: some View {
        AFormulaEditButton($formula)
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
