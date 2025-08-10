import AValue
import AViewUI

#if os(iOS)
@available(iOS 15, *)
public struct AFormulaText: View {
    var formula: AFormula
    var rows: [Int: String]
    var functions: [Int: String]

    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        Text(formula.attributedString(colorScheme: colorScheme, rows: rows, functions: functions))
    }

    public init(_ formula: AFormula, rows: [Int: String], functions: [Int: String]) {
        self.formula = formula
        self.rows = rows
        self.functions = functions
    }

    public init(_ formula: AFormula, helper editingHelper: AFormulaEditingHelper) {
        self.formula = formula
        self.rows = editingHelper.rowDict
        self.functions = editingHelper.functionNameDict
    }

    public init(_ formula: AFormula) {
        self.formula = formula
        let helper = Environment(\.aFormulaEditingHelper).wrappedValue
        self.rows = helper.rowDict
        self.functions = helper.functionNameDict
    }
}

@available(iOS 15, *)
#Preview {
    AFormulaText(1 + 12 * .p(12 + 15))
}
#endif
