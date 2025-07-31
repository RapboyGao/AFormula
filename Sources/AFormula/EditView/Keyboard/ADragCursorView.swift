import SwiftUI

#if os(iOS)

    @available(iOS 16, *)
    public struct ADragCursorView: View {
        var interval: CGFloat
        @Binding var status: ATokenEditStatus

        @State private var geometryWidth: CGFloat = 0
        @State private var touchPosition = CGPoint()
        @State private var previousPosition = CGPoint()

        private var color: Color {
            status.isDraggingCursor ? .blue : .gray
        }

        private var gradient: some ShapeStyle {
            LinearGradient(
                gradient: Gradient(colors: [color.opacity(0.7), color.opacity(0.95)]),
                startPoint: .top,
                endPoint: .bottom
            )
        }

        private var touchPositionGradient: some ShapeStyle {
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.9),
                    color.opacity(0.8),
                    color.opacity(0.5),
                ]),
                center: status.isDraggingCursor
                    ? .init(x: touchPosition.x / geometryWidth, y: 0.5) : .init(x: 0.5, y: 0.5), // 默认状态下居中
                startRadius: 8,
                endRadius: 40
            )
        }

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
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) { // 明确设置垂直居中对齐
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color.opacity(0.6), color.opacity(0.9)]
                                ), startPoint: .top, endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(touchPositionGradient)
                        )
                        .frame(width: geometry.size.width, height: status.isDraggingCursor ? 10 : 32)
                        .shadow(
                            color: status.isDraggingCursor
                                ? color.opacity(0.4) : .black.opacity(0.15),
                            radius: status.isDraggingCursor ? 8 : 4,
                            x: 0,
                            y: status.isDraggingCursor ? 4 : 2
                        )
                        .animation(.easeInOut(duration: 0.2), value: status.isDraggingCursor)
                        .onAppear { geometryWidth = geometry.size.width }
                        .onChange(of: geometry.size.width) { geometryWidth = $0 }
                }
                .frame(maxHeight: .infinity) // 让VStack占满GeometryReader的高度
                .simultaneousGesture(dragGesture)
            }
            .frame(height: 32)
        }

        public init(status: Binding<ATokenEditStatus>, interval: CGFloat = 15) {
            self._status = status
            self.interval = interval
        }
    }

#endif
