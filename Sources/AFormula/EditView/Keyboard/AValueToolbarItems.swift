import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
private struct AValueToolbarFSContent: View {
    @Binding var value: AValue?
    var action: (AValue) -> Void
    var valueType: AValueType

    @State private var isColorPickerShown = true
    @Environment(\.dismiss) private var dismiss

    private var bindColor: Binding<Color> {
        Binding {
            value?.getColor() ?? .white
        } set: { newColor in
            value = .init(color: newColor)
        }
    }

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
        else {
            return
        }
        action(newValue)
        value = nil
    }

    private var bindColorPickerShown: Binding<Bool> {
        Binding {
            isColorPickerShown
        } set: { newValue in
            if !newValue {
                DispatchQueue.main.async {
                    submitNewValue()
                }
            }
        }
    }

    var body: some View {
        if valueType == .color {
            AEmbeddedColorPicker(color: bindColor, isPresented: $isColorPickerShown) {
                ColorPicker(I18n.newValue, selection: bindColor)
            }
        } else {
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
}

@available(iOS 16, *)
public struct AValueToolbarItems: View {
    @State private var value: AValue?

    @Binding var keyboardFocused: Bool

    var action: (AValue) -> Void

    let types = AValueType.allCases.dropFirst()

    private var onTapCancelFocus: some Gesture {
        TapGesture().onEnded { _ in
            keyboardFocused = false
        }
    }

    public var body: some View {
        Menu {
            ForEach(types) { valueType in
                if valueType == .boolean {
                    Menu {
                        Button(AValue.boolean(true).description, systemImage: "checkmark") {
                            action(.boolean(true))
                        }
                        Button(AValue.boolean(false).description, systemImage: "x.circle.fill") {
                            action(.boolean(false))
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
