import Foundation

public extension [AToken] {
    mutating func normalize(startingFrom startLevel: Int) {
        var level = startLevel
        for (index, token) in self.enumerated() {
            func update() {
                var newToken = token
                newToken.level = level
                self[index] = newToken
            }
            switch token.content {
            case .rightParenthesis:
                update()
                level -= 1
            case .leftParenthesis, .functionWithLeftParenthesis:
                level += 1
                fallthrough // 还需要renew
            default:
                update()
            }
        }
    }
}
