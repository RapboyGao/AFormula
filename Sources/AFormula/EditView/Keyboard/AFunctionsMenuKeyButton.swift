import AFunction
import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct AFunctionsMenuKeyButton: View {
    var funcGroups: [AFunctionGroup]
    var action: (AFunction) -> Void

    public var body: some View {
        Menu {
            ForEach(funcGroups) { funcGroup in
                Menu(funcGroup.id.shortName, systemImage: funcGroup.id.systemImage) {
                    ForEach(funcGroup.functions) { someFunction in
                        Button(someFunction.description) {
                            action(someFunction)
                        }
                    }
                }
            }
        } label: {
            AKeyButton {} content: { _ in
                Image(systemName: "function")
                    .font(.system(size: 23))
                    .foregroundColor(.primary)
            }
        }
    }

    public init(_ funcGroups: [AFunctionGroup], action: @escaping (AFunction) -> Void) {
        self.funcGroups = funcGroups
        self.action = action
    }
}

#endif
