import Foundation

enum I18n {
    static let dragToMoveTheCursor = NSLocalizedString(
        "Drag to move the cursor", bundle: .module, comment: "Drag to move the cursor / 拖动以移动光标")  // 这段文字放在Formula编辑键盘上的光标移动（Space键）
    static let delete = NSLocalizedString("Delete", bundle: .module, comment: "Delete / 删除")

    static let editOnTheLeft = NSLocalizedString(
        "Edit on the left", bundle: .module, comment: "Edit on the left / 在左侧编辑")
    static let editOnTheRight = NSLocalizedString(
        "Edit on the right", bundle: .module, comment: "Edit on the right / 在右侧编辑")
    static let newValue = NSLocalizedString(
        "New value", bundle: .module, comment: "New value / 新值")
    // "改为"
    static let changeTo = NSLocalizedString(
        "Change to", bundle: .module, comment: "Change to / 改为")
    static let changeToVariable = NSLocalizedString(
        "Change to variable", bundle: .module, comment: "Change to variable / 改为变量")
    static let changeToFunction = NSLocalizedString(
        "Change to function", bundle: .module, comment: "Change to function / 改为函数")
}
