import AValue
import Foundation

public struct ASectionAbstract: Sendable, Hashable, Identifiable, Codable {
    public let id: Int
    public let name: String
    public let rows: [ARowAbstract]

    public init(id: Int, name: String, rows: [ARowAbstract]) {
        self.id = id
        self.name = name
        self.rows = rows
    }
}
