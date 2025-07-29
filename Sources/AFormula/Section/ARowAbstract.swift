import AValue
import Foundation

public struct ARowAbstract: Sendable, Hashable, Identifiable, Codable {
    public let id: Int
    public let name: String
    public let shownName: String
    /// 如果可以推测出类型
    public let valueType: AValueType?

    public init(id: Int, name: String, global globalName: String, type valueType: AValueType? = nil) {
        self.id = id
        self.name = name
        self.shownName = globalName
        self.valueType = valueType
    }
}
