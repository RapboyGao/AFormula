import AFunction
import AValue
import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ASectionsMenuKeyButton: View {
    var sections: [ASectionAbstract]
    var action: (ARowAbstract) -> Void

    public var body: some View {
        Menu {
            ForEach(sections) { section in
                Menu(section.name) {
                    ForEach(section.rows) { row in
                        Button {
                            action(row)
                        } label: {
                            Label(row.name, systemImage: row.valueType?.symbolName ?? "questionmark.circle.dashed")
                        }
                    }
                }
            }
        } label: {
            AKeyButton {} content: { _ in
                Image(systemName: "list.bullet.indent")
                    .font(.system(size: 23))
            }
        }
    }

    public init(_ sections: [ASectionAbstract], action: @escaping (ARowAbstract) -> Void) {
        self.sections = sections
        self.action = action
    }
}

@available(iOS 16, *)
#Preview {
    ASectionsMenuKeyButton(AFormulaEditingHelper.defaultValue.sections) { _ in
        ()
    }
}

#endif
