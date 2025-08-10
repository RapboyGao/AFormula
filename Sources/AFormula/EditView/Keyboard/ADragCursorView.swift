import AViewUI
import CoreHaptics

#if os(iOS)

    @available(iOS 13.0, *)
    private struct MyHaptics {
        static let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        static let engine = try? CHHapticEngine()

        static func vibrateShortAndLight() throws {
            guard supportsHaptics else { return }
            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(
                        parameterID: .hapticIntensity,
                        value: 0.5
                    ),
                    CHHapticEventParameter(
                        parameterID: .hapticSharpness,
                        value: 0.5
                    ),
                ],
                relativeTime: 0,
                duration: 0.1
            )
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        }
    }

    @available(iOS 16, *)
    public struct ADragCursorView: View {
        var interval: CGFloat
        @Binding var status: ATokenEditStatus

        @Environment(\.colorScheme) private var colorScheme

        @State private var geometryWidth: CGFloat = 0
        @State private var touchPosition = CGPoint()
        @State private var previousPosition = CGPoint()

        private var dragGesture: some Gesture {
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    touchPosition = value.location
                    status.isDraggingCursor = true
                    let previousPositionRounded = round(previousPosition.x / interval) * interval
                    let currentPositionRounded = round(touchPosition.x / interval) * interval
                    if currentPositionRounded > previousPositionRounded {
                        status.tryMoveRight()
                        try? MyHaptics.vibrateShortAndLight()
                    } else if currentPositionRounded < previousPositionRounded {
                        status.tryMoveLeft()
                        try? MyHaptics.vibrateShortAndLight()
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
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            AKeyColors.defaultColors.getColor(status.isDraggingCursor, colorScheme)
                        )
                    if !status.isDraggingCursor {
                        Text(I18n.dragToMoveTheCursor)
                            .font(.system(size: 17))
                            .foregroundStyle(.gray)
                            .transition(.combined(.scale)(with: .opacity))
                    }
                }
                .frame(maxHeight: .infinity) // 让VStack占满GeometryReader的高度
                .simultaneousGesture(dragGesture)
                .animation(.easeInOut(duration: 0.2), value: status.isDraggingCursor)
            }
            .frame(height: 30)
        }

        public init(status: Binding<ATokenEditStatus>, interval: CGFloat = 20) {
            _status = status
            self.interval = interval
        }
    }

#endif
