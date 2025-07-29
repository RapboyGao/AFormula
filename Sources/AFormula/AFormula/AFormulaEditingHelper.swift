import AFunction
import SwiftUI

public struct AFormulaEditingHelper: Sendable, EnvironmentKey {
    public private(set) var sections: [ASectionAbstract]
    public private(set) var functions: [AFunction]
    public private(set) var rowDict: [Int: String]
    public private(set) var functionNameDict: [Int: String]

    public init(sections: [ASectionAbstract], functions: [AFunction]) {
        self.sections = sections
        self.functions = functions
        self.rowDict = [:]
        self.functionNameDict = [:]
        for function in self.functions {
            functionNameDict[function.id] = function.shortName
        }
        for section in self.sections {
            for row in section.rows {
                rowDict[row.id] = row.shownName
            }
        }
    }

    public static let defaultValue: AFormulaEditingHelper = {
        let row1 = ARowAbstract(id: 1, name: "A", global: "A", type: .number)
        let sections = [
            ASectionAbstract(id: 12, name: "Section1", rows: [row1])
        ]
        return AFormulaEditingHelper(sections: sections, functions: AFunction.allCases)
    }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    @Entry var aFormulaEditingHelper: AFormulaEditingHelper = .defaultValue
}
