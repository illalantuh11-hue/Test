import ActivityKit
import SwiftUI
import WidgetKit

struct ClockLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ClockAttributes.self) { context in
            HStack(spacing: 16) {
                ClockFace(date: context.state.minuteStart, size: 64)
                Text(context.state.minuteStart, style: .time)
                    .font(.system(size: 34, weight: .thin, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding()
            .activityBackgroundTint(.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ClockFace(date: context.state.minuteStart, size: 90)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.minuteStart, style: .time)
                        .font(.system(size: 22, weight: .light, design: .rounded))
                }
            } compactLeading: {
                ClockFace(date: context.state.minuteStart, size: 24)
            } compactTrailing: {
                Text(context.state.minuteStart, style: .time)
                    .font(.system(size: 12, weight: .light).monospacedDigit())
                    .frame(maxWidth: 44)
            } minimal: {
                ClockFace(date: context.state.minuteStart, size: 22)
            }
        }
    }
}
