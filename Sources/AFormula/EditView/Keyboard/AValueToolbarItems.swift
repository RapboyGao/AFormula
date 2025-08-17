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
public struct AValueToolbarItems: View {
    @State private var value: AValue?
    @State private var isColorPickerShown = false

    var action: (AValue) -> Void

    let types = AValueType.allCases.dropFirst()

    private var bindColor: Binding<Color> {
        Binding {
            value?.getColor() ?? .white
        } set: { newColor in
            value = .init(color: newColor)
        }
    }

    public var body: some View {
        Menu(I18n.insert, systemImage: "plus") {
            ForEach(types) { valueType in
                if valueType == .color {
                    Button {
                        isColorPickerShown = true
                    } label: {
                        Label(valueType.name, systemImage: valueType.symbolName)
                    }

                } else if valueType == .boolean {
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
            AEmbeddedColorPicker(color: bindColor, isPresented: $isColorPickerShown)
        }
        .onChange(of: isColorPickerShown) { newValue in
            if newValue == false, let value = value {
                action(value)
            }
        }
    }

    public init(action: @escaping (AValue) -> Void) {
        self.action = action
    }
}

@available(iOS 16, *)
#Preview {
    NavigationStack {
        AValueToolbarItems { value in
            print(value)
        }
    }
}

#endif
