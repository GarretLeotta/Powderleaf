//
//  TestView.swift
//  Powderleaf
//
//  Created by Garret Leotta on 3/23/24.
//

import SwiftUI
import HealthKit

struct TestView: View {
    @EnvironmentObject private var hkService: HealthKitService
    @State private var stats: [HKStatistics] = []
    
    @State private var runs: [Running] = []
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(runs, id: \.self) { run in
                    RunCard(run: run)
                }
            }.padding(.horizontal)
        }.task {
            runs = hkService.emeraldKey.runs
        }
    }
}

#Preview {
    TestView()
        .environmentObject(HealthKitService(mock: true))
}
