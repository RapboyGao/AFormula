import AValue

// MARK: - Token

public extension AToken {
    enum Content: Hashable, Sendable, Codable, CustomStringConvertible {
        /// 左括号
        case leftParenthesis
        /// 右括号
        case rightParenthesis
        /// 函数，带括号
        case functionWithLeftParenthesis(id: Int)
        /// 逗号，在function中使用
        case comma

        // 各种类型数据
        case value(AValue)
        // 代表某个row
        case row(id: Int)
        // 各种运算法
        case plus
        case minus
        case asterisk
        case divide
        case remainder
        case power
        case greaterThan, lessThan, greaterThanOrEqual, lessThanOrEqual, equal
        case and, or, not
        case absolute
        case questionMark
        case colon
    }
}

// MARK: - toString

public extension AToken.Content {
    var description: String {
        switch self {
        case .leftParenthesis:
            return "("
        case .rightParenthesis:
            return ")"
        case .functionWithLeftParenthesis:
            return "??("
        case .comma:
            return ", "
        case .value(let value):
            return value.description
        case .row:
            return "??"
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .asterisk:
            return "×"
        case .divide:
            return "÷"
        case .remainder:
            return "%"
        case .power:
            return "^"
        case .greaterThan:
            return ">"
        case .lessThan:
            return "<"
        case .greaterThanOrEqual:
            return "≥"
        case .lessThanOrEqual:
            return "≤"
        case .equal:
            return "="
        case .and:
            return "&"
        case .or:
            return "or"
        case .not:
            return "!"
        case .absolute:
            return "|"
        case .questionMark:
            return "?"
        case .colon:
            return ":"
        }
    }

    func canBeFollowedByLiteral() -> Bool {
        switch self {
        case .leftParenthesis, .functionWithLeftParenthesis, .comma:
            return true
        case .rightParenthesis, .value, .row:
            return false
        case .plus, .minus, .asterisk, .divide, .remainder, .power:
            return true
        case .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal, .and, .or,
             .not, .absolute, .questionMark, .colon:
            return true
        }
    }

    func canBePrefixedByLiteral() -> Bool {
        switch self {
        case .leftParenthesis, .functionWithLeftParenthesis, .value, .row:
            return false
        case .comma, .rightParenthesis:
            return true
        case .plus, .minus, .asterisk, .divide, .remainder, .power:
            return true
        case .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal, .and, .or,
             .not, .absolute, .questionMark, .colon:
            return true
        }
    }

    func toString(
        rows rowNamesDict: [Int: String], functions functionNamesDict: [Int: String]
    ) -> String {
        switch self {
        case .leftParenthesis:
            return "("
        case .rightParenthesis:
            return ")"
        case .functionWithLeftParenthesis(let id):
            if let funcName = functionNamesDict[id] {
                return "\(funcName)("
            } else {
                return "??("
            }
        case .comma:
            return ", "
        case .value(let value):
            return value.description
        case .row(let id):
            if let rowName = rowNamesDict[id] {
                return rowName
            } else {
                return "??"
            }
        case .plus:
            return " + "
        case .minus:
            return " - "
        case .asterisk:
            return " × "
        case .divide:
            return " ÷ "
        case .remainder:
            return " % "
        case .power:
            return " ^ "
        case .greaterThan:
            return " > "
        case .lessThan:
            return " < "
        case .greaterThanOrEqual:
            return " ≥ "
        case .lessThanOrEqual:
            return " ≤ "
        case .equal:
            return " = "
        case .and:
            return " & "
        case .or:
            return " or "
        case .not:
            return "!"
        case .absolute:
            return "|"
        case .questionMark:
            return "? "
        case .colon:
            return " : "
        }
    }
}
