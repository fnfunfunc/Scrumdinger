//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by eternal on 2024/3/30.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    
    @State private var isPresentingNewScrum: Bool = false

    var body: some View {
        NavigationStack {
            List($scrums) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
            .navigationTitle("Daily scrums")
            .toolbar {
                Button(action: {
                    isPresentingNewScrum = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New scrum")
            }
        }
        .sheet(isPresented: $isPresentingNewScrum) {
            NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrum)
        }
    }
}

#Preview {
    ScrumsView(scrums: .constant(DailyScrum.sampleData))
}
