//
//  SummaryView.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/19/24.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @EnvironmentObject private var hkService: HealthKitService
    
    @State private var startDate = Date(timeIntervalSinceNow: -604800)
    @State private var endDate = Date()
    @State private var aggregates: [HKQuantityTypeIdentifier: HKQuantity] = [:]
    
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
                        ForEach(Array(aggregates.keys), id: \.self) { id in
                            if let aggregate = aggregates[id] {
                                HStack {
                                    Text("\(id.display())")
                                    Spacer()
                                    Text("\(aggregate)")
                                }
                            }
                        }
                    }.padding(.horizontal)
                }
            }
        }.task {
            load()
        }.onChange(of: startDate) {
            load()
        }.onChange(of: endDate) {
            load()
        }
    }
    
    func load() {
        let store = HKHealthStore()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)
        for id in Running.quantities.keys {
            guard let type = HKQuantityType.quantityType(forIdentifier: id) else {
                continue
            }
            guard let opt = Running.quantities[id] else {
                continue
            }
            
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: opt, completionHandler: { (query, result, error) -> Void in
                    guard let stats = result else {
                        // Handle any errors here.
                        return
                    }
                    let agg: HKQuantity?
                    switch opt {
                    case .discreteAverage: agg = stats.averageQuantity()
                    case .cumulativeSum: agg = stats.sumQuantity()
                    default: agg = nil
                    }
                    print("agg:", agg)
                    if agg != nil {
                        DispatchQueue.main.async {
                            self.aggregates[id] = agg
                        }
                    }
                })
            store.execute(query)
        }
    }
}

#Preview {
    SummaryView()
        .environmentObject(HealthKitService(mock: true))
}
