import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension AToken {
    // 定义不同层级括号在浅色主题下的颜色，与Material Theme保持一致
    private func lightThemeColorsForParentheses() -> [Color] {
        return [
            Color(red: 0.129, green: 0.588, blue: 0.953), // Blue 600
            Color(red: 0.184, green: 0.804, blue: 0.443), // Green 500
            Color(red: 0.612, green: 0.259, blue: 0.706), // Purple 500
            Color(red: 0.933, green: 0.298, blue: 0.627), // Pink 500
            Color(red: 1.0, green: 0.651, blue: 0.0), // Orange 500
        ]
    }

    // 定义不同层级括号在深色主题下的颜色，与Material Theme保持一致
    private func darkThemeColorsForParentheses() -> [Color] {
        return [
            Color(red: 0.412, green: 0.749, blue: 1.0), // Blue 300
            Color(red: 0.463, green: 0.933, blue: 0.647), // Green 300
            Color(red: 0.776, green: 0.588, blue: 0.839), // Purple 300
            Color(red: 1.0, green: 0.659, blue: 0.824), // Pink 300
            Color(red: 1.0, green: 0.827, blue: 0.529), // Orange 300
        ]
    }

    func color(for colorScheme: SwiftUI.ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return colorForLightTheme()
        case .dark:
            return colorForDarkTheme()
        @unknown default:
            return colorForLightTheme()
        }
    }

    func colorForLightTheme() -> Color {
        switch content {
        case .leftParenthesis, .rightParenthesis, .comma, .functionWithLeftParenthesis:
            let colors = lightThemeColorsForParentheses()
            return colors[level % colors.count]
        case .value(let value):
            return value.type.colorForLightTheme()
        case .plus, .minus, .asterisk, .divide, .remainder, .power,
             .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal,
             .and, .or, .not, .absolute, .questionMark, .colon:
            return Color(red: 0.502, green: 0.502, blue: 0.502) // Gray 500
        case .row:
            return .accentColor
        }
    }

    func colorForDarkTheme() -> Color {
        switch content {
        case .leftParenthesis, .rightParenthesis, .comma, .functionWithLeftParenthesis:
            let colors = darkThemeColorsForParentheses()
            return colors[level % colors.count]
        case .value(let value):
            return value.type.colorForDarkTheme()
        case .plus, .minus, .asterisk, .divide, .remainder, .power,
             .greaterThan, .lessThan, .greaterThanOrEqual, .lessThanOrEqual, .equal,
             .and, .or, .not, .absolute, .questionMark, .colon:
            return Color(red: 0.749, green: 0.749, blue: 0.749) // Gray 300
        case .row:
            return .accentColor
        }
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public extension AToken {
    func attributedString(
        colorScheme: ColorScheme, rows rowNamesDict: [Int: String],
        functions functionNamesDict: [Int: String]
    ) -> AttributedString {
        if case .row(let id) = content, let string = rowNamesDict[id] {
            var attributedString = AttributedString(" " + string + " ")
            attributedString.foregroundColor = .white
            attributedString.backgroundColor = color(for: colorScheme)
            return attributedString
        } else if let string = toString(rows: rowNamesDict, functions: functionNamesDict) {
            var attributedString = AttributedString(string)
            attributedString.foregroundColor = color(for: colorScheme)
            return attributedString
        } else {
            var attributedString = AttributedString("??")
            attributedString.foregroundColor = .gray
            attributedString.strikethroughStyle = .single
            attributedString.strikethroughColor = .gray
            return attributedString
        }
    }
}
