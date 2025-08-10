import AViewUI

#if os(iOS)

    @available(iOS 16, *)
    public struct ADragCursorView: View {
        var interval: CGFloat
        @Binding var status: ATokenEditStatus

        @Environment(\.colorScheme) private var colorScheme

        @State private var geometryWidth: CGFloat = 0
        @State private var touchPosition = CGPoint()
        @State private var previousPosition = CGPoint()

        private var dragGesture: some Gesture {
            DragGesture()
                .onChanged { value in
                    touchPosition = value.location
                    status.isDraggingCursor = true
                    let previousPositionRounded = round(previousPosition.x / interval) * interval
                    let currentPositionRounded = round(touchPosition.x / interval) * interval
                    if currentPositionRounded > previousPositionRounded {
                        status.tryMoveRight()
                    } else if currentPositionRounded < previousPositionRounded {
                        status.tryMoveLeft()
                    }
                    previousPosition = touchPosition
                }
                .onEnded { _ in
                    touchPosition = CGPoint()
                    previousPosition = CGPoint()
                    status.isDraggingCursor = false
                }
        }

        public var body: some View {
            GeometryReader { _ in
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        AKeyColors.defaultColors.getColor(status.isDraggingCursor, colorScheme)
                    )
                    .frame(maxHeight: .infinity) // 让VStack占满GeometryReader的高度
                    .simultaneousGesture(dragGesture)
                    .animation(.easeInOut(duration: 0.1), value: status.isDraggingCursor)
            }
            .frame(height: 30)
        }

        public init(status: Binding<ATokenEditStatus>, interval: CGFloat = 15) {
            self._status = status
            self.interval = interval
        }
    }

#endif
