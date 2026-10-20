import ActivityKit
import Foundation

struct ClockAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var minuteStart: Date
    }
    var name: String
}
