import SwiftUI

public struct AToken: Identifiable, Hashable, Sendable, Codable, CustomStringConvertible {
    public let id: Int
    /// 在第几个括号内
    public var level: Int
    public var content: Content
    public var placeholder: String?

    public init(_ content: Content, level: Int = 0, placeholder: String? = nil) {
        self.id = .random(in: .min ... .max)
        self.content = content
        self.level = level
        self.placeholder = placeholder
    }

    public var description: String {
        content.description
    }

    func toString(rows rowNamesDict: [Int: String], functions functionNamesDict: [Int: String])
        -> String?
    {
        content.toString(rows: rowNamesDict, functions: functionNamesDict)
    }
}
