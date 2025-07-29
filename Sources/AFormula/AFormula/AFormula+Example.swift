import Foundation

public extension AFormula {
    static let example: AFormula = .f(.cosFunction, args: [.p(1 + .variable(id: 1) / 35)]) * .f(.sinFunction, args: [.f(.maxFunction, args: [30, 40, 50])])
}
