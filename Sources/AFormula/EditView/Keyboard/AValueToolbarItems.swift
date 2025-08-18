import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
private struct AValueToolbarFSContent: View {
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

    private func submitNewValue() {
        dismiss()
        guard let newValue = value
        else { return }
        action(newValue)
        value = nil
    }

    var body: some View {
        AValueFSContent(value: $value, type: valueType, allowInput: true, name: I18n.newValue, unit: .constant(nil))
            .statusBarHidden()
            .navigationBarBackButtonHidden()
            .toolbar {
                Button(buttonText) {
                    submitNewValue()
                }
            }
    }
}

@available(iOS 16, *)
public struct AValueToolbarItems: View {
    @Binding var keyboardFocused: Bool

    var action: (AValue) -> Void

    @State private var value: AValue?
    @State private var isColorPickerShown = false

    let types = AValueType.allCases.dropFirst()

    private var onTapCancelFocus: some Gesture {
        TapGesture().onEnded { _ in
            keyboardFocused = false
        }
    }

    private var bindColor: Binding<Color> {
        Binding {
            value?.getColor() ?? .white
        } set: { newColor in
            value = .init(color: newColor)
        }
    }

    func submit() {
        if let value {
            action(value)
        }
        value = nil
    }

    func submit(value: AValue?) {
        if let value {
            action(value)
        }
        self.value = nil
    }

    func submit(_ someBool: Bool) {
        action(.boolean(someBool))
        value = nil
    }

    public var body: some View {
        Menu {
            ForEach(types) { valueType in
                if valueType == .boolean {
                    Menu {
                        Button(AValue.boolean(true).description, systemImage: "checkmark") {
                            submit(true)
                        }
                        Button(AValue.boolean(false).description, systemImage: "x.circle.fill") {
                            submit(false)
                        }
                    } label: {
                        Label(valueType.name, systemImage: valueType.symbolName)
                    }
                } else {
                    NavigationLink {
                        AValueToolbarFSContent(value: $value, action: action, valueType: valueType)
                    } label: {
                        Label(valueType.name, systemImage: valueType.symbolName)
                    }
                }
            }
        } label: {
            Label(I18n.insert, systemImage: "plus")
        }
    }

    public init(keyboard keyboardFocused: Binding<Bool>, action: @escaping (AValue) -> Void) {
        self._keyboardFocused = keyboardFocused
        self.action = action
    }
}

@available(iOS 16, *)
#Preview {
    NavigationStack {
        AValueToolbarItems(keyboard: .constant(true)) { value in
            print(value)
        }
    }
}

#endif
