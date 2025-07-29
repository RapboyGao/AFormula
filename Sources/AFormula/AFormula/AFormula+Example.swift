import Foundation

public extension AFormula {
    static let example: AFormula = .p(1 + .variable(id: 1) / 35) * .function(id: 1, args: [60]) // cos(60)
}
