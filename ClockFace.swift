import SwiftUI

struct Hand: View {
    let size: CGFloat
    let length: CGFloat
    let width: CGFloat
    let angle: Double
    var color: Color = .white

    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: size * width, height: size * length)
            .offset(y: -size * length / 2)
            .rotationEffect(.degrees(angle))
    }
}

struct ClockFace: View {
    let date: Date
    var size: CGFloat = 24
    var showSecondRing = true

    var body: some View {
        let cal = Calendar.current
        let h = Double(cal.component(.hour, from: date) % 12)
        let m = Double(cal.component(.minute, from: date))
        let start = cal.dateInterval(of: .minute, for: date)?.start ?? date

        ZStack {
            if showSecondRing {
                ProgressView(timerInterval: start...start.addingTimeInterval(60), countsDown: false) {
                    EmptyView()
                } currentValueLabel: {
                    EmptyView()
                }
                .progressViewStyle(.circular)
                .tint(.orange)
                .frame(width: size, height: size)
            } else {
                Circle().stroke(Color.white.opacity(0.35), lineWidth: size * 0.03)
            }
            ForEach(0..<12, id: \.self) { i in
                let major = i % 3 == 0
                Capsule()
                    .fill(Color.white.opacity(major ? 0.9 : 0.4))
                    .frame(width: size * 0.025, height: size * (major ? 0.1 : 0.05))
                    .offset(y: -size * 0.3)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            Hand(size: size, length: 0.22, width: 0.05, angle: h * 30 + m * 0.5)
            Hand(size: size, length: 0.32, width: 0.035, angle: m * 6)
            Circle().fill(Color.orange).frame(width: size * 0.09, height: size * 0.09)
        }
        .frame(width: size, height: size)
    }
}
