//
//  SummaryView.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/19/24.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject private var hkService: HealthKitService
    
    @State private var runs: [Running] = []
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Select your dates here")
                HStack {
                    DatePicker(selection: $startDate, displayedComponents: .date) {
                        Text("Start")
                    }.datePickerStyle(.compact)
                        .labelsHidden()
                    DatePicker(selection: $endDate, displayedComponents: .date) {
                        Text("End")
                    }.datePickerStyle(.compact)
                        .labelsHidden()
                }
                
                ScrollView {
                    Group {
                        ForEach(filtered(), id: \.self) { run in
                            NavigationLink(destination:
                                BreakdownView(run: run)
                            ) {
                                RunCard(run: run)
                            }
                            
                        }
                    }.padding(.horizontal)
                }
            }
        }.task {
            //TODO: should be an observable or something
            //^^^^: good opportunity to try out @Observable
            runs = hkService.emeraldKey.runs
        }
    }
    
    private func filtered() -> [Running] {
        runs.filter { $0.date >= startDate && $0.date < endDate }
    }
}

#Preview {
    SummaryView()
        .environmentObject(HealthKitService(mock: true))
}
