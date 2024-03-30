//
//  DetailView.swift
//  Scrumdinger
//
//  Created by eternal on 2024/3/30.
//

import SwiftUI

struct DetailView: View {
    let scrum: DailyScrum

    var body: some View {
        List {
            Section(content: {
                NavigationLink(destination: MeetingView()) {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundStyle(Color.accentColor)
                }
                
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(scrum.theme.name)
                        .padding(4)
                        .foregroundStyle(scrum.theme.accentColor)
                        .background(scrum.theme.mainColor)
                        .clipShape(RoundedRectangle(cornerRadius: 4.0))
                }
                .accessibilityElement(children: .combine)
            }, header: { Text("Meeting info") })
            
            
            Section(content: {
                ForEach(scrum.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            }, header: { Text("Attendees") })
        }
        .navigationTitle(scrum.title)
    }
}

#Preview {
    NavigationStack {
        DetailView(scrum: DailyScrum.sampleData[0])
    }
}
