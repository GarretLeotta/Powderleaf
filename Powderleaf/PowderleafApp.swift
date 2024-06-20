//
//  PowderleafApp.swift
//  Powderleaf
//
//  Created by Garret Leotta on 3/23/24.
//

import SwiftUI
import SwiftData

@main
struct PowderleafApp: App {
    @StateObject private var hkService: HealthKitService
    @State private var tab: Tab = .summary
    
    init() {
        _hkService = StateObject(wrappedValue: HealthKitService(mock: false))
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            TabView(selection: $tab) {
                SummaryView()
                    .tabItem { Label("Summary", systemImage: "calendar") }
                    .tag(Tab.summary)
                BreakdownView()
                    .tabItem { Label("Breakdown", systemImage: "chart.bar.fill") }
                    .tag(Tab.summary)
            } //: TABVIEW
        }
        .environmentObject(hkService)
        .modelContainer(sharedModelContainer)
    }
    
    //TODO: remove this auto-gen code
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

enum Tab: String {
    case summary
    case breakdown
}
