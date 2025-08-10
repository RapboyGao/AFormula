import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AValueToolbarMenu: View {
    @State private var value: AValue?

    var action: (AValue) -> Void

    let types = AValueType.allCases.dropFirst()

    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        Menu("Insert", systemImage: "plus") {
            ForEach(types) { thisValueType in
                ASheetButton {
                    guard let _ = value
                    else {
                        return .init(sheet: .fullScreenCover, button: .button, returnButton: .cancel)
                    }
                    return .init(sheet: .fullScreenCover, button: .button, returnButton: .done)
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
        }
    }

    public init(action: @escaping (AValue) -> Void) {
        self.action = action
    }
}

@available(iOS 16, *)
#Preview {
    AValueScrollView { value in
        print(value)
    }
}

#endif
