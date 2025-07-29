import AFunction
import AValue
import Foundation

public enum AFormulaEvaluatorError: Error, Sendable, Codable {
    case invalidOperation // 无效操作
    case divisionByZero // 除零错误
    case comparisonError // 比较错误
    case rowNotFound(id: Int) // 行未找到错误，包含未找到的行ID
    case functionNotFound(id: Int) // 函数未找到错误，包含未找到的函数ID
    case indexOutOfBounds // 索引越界错误
    case typeMismatch(expected: AValueType, actual: AValueType) // 类型不匹配错误，包含期望类型和实际类型
    case invalidToken
}


public struct AFormulaEvaluator: Sendable {
    public var rowValues: [Int: AValue]
    public var functions: [Int: @Sendable ([AValue]) throws -> AValue]

    public init(rowValues: [Int: AValue], _ functions: [Int: @Sendable ([AValue]) throws -> AValue] = AFunction.functionInstances) {
        self.rowValues = rowValues
        self.functions = functions
    }

    @Sendable public func evaluate(formula: AFormula) throws -> AValue {
        switch formula {
        case .value(let value):
            return value
        case .variable(let id):
            guard let value = rowValues[id] else {
                throw AFormulaEvaluatorError.rowNotFound(id: id)
            }
            return value
        case .function(let id, let args):
            guard let function = functions[id] else {
                throw AFormulaEvaluatorError.functionNotFound(id: id)
            }
            let evaluatedArgs = try args.map { try evaluate(formula: $0) }
            return try function(evaluatedArgs)
        case .add(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.add(rightValue)
        case .subtract(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.subtract(rightValue)
        case .multiply(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.multiply(by: rightValue)
        case .divide(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.divide(by: rightValue)
        case .power(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.power(of: rightValue)
        case .remainder(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.remainder(dividingBy: rightValue)
        case .and(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.and(rightValue)
        case .or(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try leftValue.or(rightValue)
        case .not(let formula):
            let value = try evaluate(formula: formula)
            return try value.not()
        case .greaterThan(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try .boolean(leftValue.isGreater(than: rightValue))
        case .lessThan(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try .boolean(leftValue.isLess(than: rightValue))
        case .greaterThanOrEqual(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try .boolean(leftValue.isGreaterOrEqual(to: rightValue))
        case .lessThanOrEqual(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return try .boolean(leftValue.isLessThanOrEqual(to: rightValue))
        case .equal(let left, let right):
            let leftValue = try evaluate(formula: left)
            let rightValue = try evaluate(formula: right)
            return .boolean(leftValue == rightValue)
        case .parenthesis(let formula):
            return try evaluate(formula: formula)
        case .absolute(let formula):
            let value = try evaluate(formula: formula)
            return try value.absolute()
        case .negative(let formula):
            let someValue = try evaluate(formula: formula)
            return try someValue.negative()
        case .ternary(let condition, let trueFormula, let falseFormula):
            let conditionValue = try evaluate(formula: condition)
            guard case .boolean(let conditionResult) = conditionValue else {
                throw AFormulaEvaluatorError.typeMismatch(expected: .boolean, actual: conditionValue.type)
            }
            return try evaluate(formula: conditionResult ? trueFormula : falseFormula)
        }
    }
}
