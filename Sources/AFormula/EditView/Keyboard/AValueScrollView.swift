import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AValueScrollView: View {
    @State private var value: AValue?

    var action: (AValue) -> Void

    let types = AValueType.allCases.dropFirst()

    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(AKeyColors.sameAsBackground.getColor(false, colorScheme))
            LazyVStack(alignment: .center) {
                ScrollView {
                    LazyHStack(alignment: .center, spacing: 15) {
                        ForEach(types) { thisValueType in
                            ASheetButton {
                                guard let _ = value
                                else {
                                    return .init(sheet: .fullScreenCover, button: .button, returnButton: .cancel)
                                }
                                return .init(sheet: .fullScreenCover, button: .button, returnButton: .done)
                            } label: {
                                Image(systemName: thisValueType.symbolName)
                                    .font(.system(size: 20))
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
            }
            .scrollIndicators(.hidden)
        }
        .frame(height: 30)
        .padding(.top, 5)
        .padding([.leading, .trailing], 10)
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
