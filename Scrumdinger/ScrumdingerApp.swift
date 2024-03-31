//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by eternal on 2024/3/29.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData
    
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $scrums)
        }
    }
}
