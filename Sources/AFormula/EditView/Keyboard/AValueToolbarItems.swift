import AValue
import AViewUI

#if os(iOS)

// 自定义颜色选择器，支持监听显示状态
@available(iOS 16, *)
private struct ObservableColorPicker: UIViewRepresentable {
    @Binding var color: Color
    @Binding var isPresented: Bool // 用于跟踪是否打开的状态

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 检查是否需要显示颜色选择器
        if isPresented && context.coordinator.picker == nil {
            let picker = UIColorPickerViewController()
            picker.selectedColor = UIColor(color)
            picker.delegate = context.coordinator
            context.coordinator.picker = picker

            // 获取当前的UIViewController并 present 选择器
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.present(picker, animated: true)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        var parent: ObservableColorPicker
        var picker: UIColorPickerViewController?

        init(_ parent: ObservableColorPicker) {
            self.parent = parent
        }

        // 颜色选择变化时调用
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.color = Color(color)
        }

        // 选择器即将显示时调用
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            // 选择器关闭时更新状态
            parent.isPresented = false
            picker = nil
        }
    }
}

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
                        ObservableColorPicker(color: bindColor, isPresented: $isColorPickerShown)
                    }
                } else {
                    NavigationLink {
                        AValueToolbarFSContent(value: $value, action: action, valueType: valueType)
                    } label: {
                        Label(valueType.name, systemImage: valueType.symbolName)
                    }
                }
            }
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
