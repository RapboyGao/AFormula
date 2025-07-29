import SwiftUI

public struct AToken: Identifiable, Hashable, Sendable, Codable, CustomStringConvertible {
    public let id: Int
    /// 在第几个括号内
    public var level: Int
    public var content: Content

    public init(_ content: Content) {
        self.id = .random(in: .min ... .max)
        self.content = content
        self.level = 0
    }

    public var description: String {
        content.description
    }

    func toString(rows rowNamesDict: [Int: String], functions functionNamesDict: [Int: String])
        -> String
    {
        content.toString(rows: rowNamesDict, functions: functionNamesDict)
    }
}
