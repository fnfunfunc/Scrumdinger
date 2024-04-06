//
//  History.swift
//  Scrumdinger
//
//  Created by eternal on 2024/4/2.
//

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var attendees: [DailyScrum.Attendee]
    var transcript: String?
    
    init(id: UUID = UUID(), date: Date = .now, attendees: [DailyScrum.Attendee], transcript: String?) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.transcript = transcript
    }
}
