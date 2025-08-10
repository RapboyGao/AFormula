import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
private struct AValueToolbarContent: View {
    @Binding var value: AValue?
    var action: (AValue) -> Void
    var valueType: AValueType

    @Environment(\.dismiss) private var dismiss

    private var buttonText: String {
        guard value != nil
        else {
            return I18n.cancel
        }
        return I18n.done
    }

    var body: some View {
        AValueFSContent(value: $value, type: valueType, allowInput: true, name: I18n.newValue, unit: .constant(nil))
            .statusBarHidden()
            .navigationBarBackButtonHidden()
            .toolbar {
                Button(buttonText) {
                    dismiss()
                    guard let newValue = value
                    else {
                        return
                    }
                    action(newValue)
                    self.value = nil
                }
            }
    }
}

@available(iOS 16, *)
public struct AValueToolbarMenu: View {
    @State private var value: AValue?

    var action: (AValue) -> Void

    let types = AValueType.allCases.dropFirst()

    public var body: some View {
        Menu(I18n.insert, systemImage: "plus") {
            ForEach(types) { valueType in
                NavigationLink {
                    AValueToolbarContent(value: $value, action: action, valueType: valueType)
                } label: {
                    Label(valueType.name, systemImage: valueType.symbolName)
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
    AValueToolbarMenu { value in
        print(value)
    }
}

#endif
