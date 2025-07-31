import Foundation

public extension [AToken] {
    mutating func normalize(startingFrom startLevel: Int) -> Int {
        var level = startLevel
        for (index, token) in self.enumerated() {
            func _update() {
                var newToken = token
                newToken.level = level
                self[index] = newToken
            }
            switch token.content {
            case .rightParenthesis:
                _update()
                level -= 1
            case .leftParenthesis, .functionWithLeftParenthesis:
                level += 1
                fallthrough // 还需要renew
            default:
                _update()
            }
        }
        if self.last?.content == .rightParenthesis {
            return level - 1
        } else {
            return level
        }
    }
}
