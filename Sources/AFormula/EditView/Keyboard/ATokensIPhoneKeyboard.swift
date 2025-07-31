import AViewUI

#if os(iOS)

@available(iOS 16, *)
public struct ATokensIPhoneKeyboard: View {
    @Binding var status: ATokenEditStatus

    public var body: some View {
        AKeyboardBackgroundView { _ in
            VStack {
                ADragCursorView(status: $status)
                    .padding(3)
                KeyBoardSpaceAroundStack(columns: 5, rowSpace: 10, columnSpace: 10) {
                    AKeyButton {
                        //
                    } content: { _ in
                        Image(systemName: "plusminus")
                    }
                    ForEach(1 ..< 4) { int in
                        AKeyButton {
                            status.numberInputString += int.description
                        } content: { _ in
                            ANumKeyVStack(int)
                        }
                    }
                    AKeyButton {
                        status.tryDeleteLeft()
                    } content: { _ in
                        Image(systemName: "delete.backward")
                    }

                    ForEach(4 ..< 7) { int in
                        AKeyButton {
                            status.numberInputString += int.description
                        } content: { _ in
                            ANumKeyVStack(int)
                        }
                    }
                }
            }
        }
    }
}

#endif
