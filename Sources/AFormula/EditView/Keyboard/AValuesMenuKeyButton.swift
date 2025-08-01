import AFunction
import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AValuesMenuKeyButton: View {
    @State private var value: AValue?

    var action: (AValue) -> Void

    public var body: some View {
        Menu {
            ForEach(AValueType.allCases) { thisValueType in
                ASheetButton {
                    guard let _ = value
                    else {
                        return .init(sheet: .sheet, button: .button, returnButton: .cancel)
                    }
                    return .init(sheet: .sheet, button: .button, returnButton: .done)
                } label: {
                    Label(thisValueType.name, systemImage: thisValueType.symbolName)
                } cover: {
                    AValueFSContent(value: $value, type: thisValueType, allowInput: true, name: "Input Value", unit: .constant(nil))
                } onSheetClosed: {
                    guard let value = value
                    else {
                        return
                    }
                    action(value)
                }
            }
        } label: {
            AKeyButton {
                //
            } content: { _ in
                VStack {
                    HStack {
                        Image(systemName: AValueType.location.symbolName)
                        Image(systemName: AValueType.calendar.symbolName)
                    }
                    Image(systemName: AValueType.point.symbolName)
                }
            }
        }
    }

    public init(action: @escaping (AValue) -> Void) {
        self.action = action
    }
}

#endif
