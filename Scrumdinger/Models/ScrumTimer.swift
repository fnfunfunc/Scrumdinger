//
//  ScrumTimer.swift
//  Scrumdinger
//
//  Created by eternal on 2024/3/31.
//

import Foundation

@MainActor
final class ScrumTimer: ObservableObject {
    struct Speaker: Identifiable {
        let name: String
        var isCompleted: Bool
        let id: UUID = UUID()
    }

    @Published var activeSpeaker: String = ""
    @Published var secondsElapsed: Int = 0
    @Published var secondsRemaining: Int = 0

    private(set) var speakers: [Speaker] = []

    private(set) var lengthInMinutes: Int

    var speakerChangedAction: (() -> Void)?

    private weak var timer: Timer?
    private var timerStopped: Bool = false
    private var frequency: TimeInterval {
        1.0 / 60.0
    }

    private var lengthInSeconds: Int {
        lengthInMinutes * 60
    }

    private var secondsPerSpeaker: Int {
        lengthInSeconds / speakers.count
    }

    /// Seconds elapsed for current speaker
    private var secondsElapsedForSpeaker: Int = 0
    /// Current speaker index
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
    }

    private var startDate: Date?

    init(lengthInMinutes: Int = 0, attendees: [DailyScrum.Attendee] = []) {
        self.lengthInMinutes = lengthInMinutes
        speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }

    func startScrum() {
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] _ in
            self?.update()
        }
        timer?.tolerance = 0.1
        changeToSpeaker(at: 0)
    }

    func stopScrum() {
        timer?.invalidate()
        timerStopped = true
    }

    nonisolated func skipSpeaker() {
        Task { @MainActor in
            changeToSpeaker(at: speakerIndex + 1)
        }
    }

    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }

        speakerIndex = index
        activeSpeaker = speakerText

        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        startDate = .now
    }

    private nonisolated func update() {
        Task { @MainActor in
            guard let startDate, !timerStopped else { return }
            let secondsElapsed = Int(Date.now.timeIntervalSince1970 - startDate.timeIntervalSince1970)
            secondsElapsedForSpeaker = secondsElapsed
            self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
            guard secondsElapsed <= secondsPerSpeaker else { // Ensure that current speaker do not exceed the time limit
                return
            }
            secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)

            if secondsElapsedForSpeaker >= secondsPerSpeaker {
                changeToSpeaker(at: speakerIndex + 1)
                speakerChangedAction?()
            }
        }
    }

    func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
        self.lengthInMinutes = lengthInMinutes
        speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
}

extension Array<DailyScrum.Attendee> {
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
        } else {
            map { attendee in
                ScrumTimer.Speaker(name: attendee.name, isCompleted: false)
            }
        }
    }
}
