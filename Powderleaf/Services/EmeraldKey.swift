//
//  EmeraldKey.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/19/24.
//

import Foundation
import HealthKit

class EmeraldKey {
    var runs: [Running]
    
    init(mock: Bool) {
        if mock {
            runs = [.mock(Date())]
        } else {
            //TODO: loading indicator
            self.runs = []
            Task {
                await EmeraldKey.requestAccess()
                if let workouts = await EmeraldKey.readWorkouts() {
                    self.runs = workouts.map { Running(workout: $0) }
                } else {
                    fatalError("Couldn't get access to workouts, handle this better lol")
                }
            }
        }
    }
    
    ///Array of HK types that we request access to
    static let allTypes: Set = [
        .workoutType(),
        HKQuantityType.workoutType(),
        
        HKQuantityType(.heartRate),
        HKQuantityType(.heartRateRecoveryOneMinute),
        
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.stepCount),
        HKQuantityType(.distanceWalkingRunning),
        
        HKQuantityType(.runningPower),
        HKQuantityType(.runningSpeed),
        HKQuantityType(.runningStrideLength),
        HKQuantityType(.runningVerticalOscillation),
        
        HKQuantityType(.physicalEffort),
        
        HKSeriesType.activitySummaryType(),
        
        HKSeriesType.workoutRoute(),
        HKSeriesType.workoutType(),
    ]
    
    static func requestAccess() async {
        do {
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                let healthStore = HKHealthStore()
                // Asynchronously request authorization to the data.
                try await healthStore.requestAuthorization(toShare: [], read: allTypes)
                print("got access")
            }
        } catch {
            fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
        }
    }
    
    static func readWorkouts() async -> [HKWorkout]? {
        let store = HKHealthStore()
        
        let pred = HKQuery.predicateForWorkouts(with: .running)
        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            store.execute(HKSampleQuery(
                sampleType: .workoutType(),
                predicate: pred,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)],
                resultsHandler: { query, samples, error in
                
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }
                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }
                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }
        return workouts
    }
    
//    func getAVGHeartRate() {
//        let store = HKHealthStore()
//        
//        var typeHeart = HKQuantityType.quantityType(forIdentifier: .heartRate)
//        var startDate = Date() - 7 * 24 * 60 * 60 // start date is a week
//        var predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
//
//        var squery = HKStatisticsQuery(quantityType: typeHeart!, quantitySamplePredicate: predicate, options: .discreteAverage, completionHandler: {(query: HKStatisticsQuery,result: HKStatistics?, error: Error?) -> Void in
//            DispatchQueue.main.async(execute: {() -> Void in
//                var quantity: HKQuantity? = result?.averageQuantity()
//                var beats: Double? = quantity?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
//                print("got: \(String(format: "%.f", beats!))")
//            })
//            })
//        store.execute(squery)
//    }
}
