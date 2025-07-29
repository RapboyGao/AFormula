import SwiftUI

#if os(iOS)

    @available(iOS 16, *)
    public struct ADragCursorView: View {
        var interval: CGFloat = 10
        @Binding var status: ATokenEditStatus

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

        private var color: Color {
            status.isDraggingCursor ? .blue : .gray
        }

        public var body: some View {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(color)
                        .frame(width: geometry.size.width, height: 30)
                }
                .simultaneousGesture(dragGesture)
            }
        }

        public init(status: Binding<ATokenEditStatus>, interval: CGFloat = 10) {
            self._status = status
            self.interval = interval
        }
    }

#endif
