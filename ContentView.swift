import ActivityKit
import SwiftUI

final class ClockController: ObservableObject {
    @Published var running = false
    private var activity: Activity<ClockAttributes>?
    private var timer: Timer?
    private var lastMinute: Date?

    private func minute(_ d: Date) -> Date {
        Calendar.current.dateInterval(of: .minute, for: d)?.start ?? d
    }

    func start() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let m = minute(Date())
        let content = ActivityContent(state: ClockAttributes.ContentState(minuteStart: m), staleDate: nil)
        activity = try? Activity.request(attributes: ClockAttributes(name: "Clock"), content: content)
        lastMinute = m
        running = activity != nil
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        let m = minute(Date())
        guard m != lastMinute else { return }
        lastMinute = m
        let content = ActivityContent(state: ClockAttributes.ContentState(minuteStart: m), staleDate: nil)
        Task { await activity?.update(content) }
    }

    func stop() {
        timer?.invalidate()
        Task {
            await activity?.end(nil, dismissalPolicy: .immediate)
            await MainActor.run { self.running = false }
        }
    }
}

struct ContentView: View {
    @StateObject private var clock = ClockController()

    var body: some View {
        VStack(spacing: 28) {
            ClockFace(date: Date(), size: 160, showSecondRing: false)
            Button(clock.running ? "Остановить" : "Запустить остров") {
                clock.running ? clock.stop() : clock.start()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            Text("Пока приложение открыто, стрелки обновляются раз в минуту.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
