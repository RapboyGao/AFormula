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
}
