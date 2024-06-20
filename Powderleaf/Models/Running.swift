//
//  Running.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/19/24.
//

import Foundation
import HealthKit

struct Running: Hashable {
    let workout: HKWorkout
    
    var date: Date { workout.startDate }
}

extension Running {
    static let quantities: [HKQuantityTypeIdentifier: HKStatisticsOptions] = [
        .runningGroundContactTime: .discreteAverage,
        .runningPower: .discreteAverage,
        .runningVerticalOscillation: .discreteAverage,
        .runningSpeed: .discreteAverage,
        .runningStrideLength: .discreteAverage,
        .heartRate: .discreteAverage,
        .stepCount: .cumulativeSum,
        .activeEnergyBurned: .cumulativeSum,
        .basalEnergyBurned: .cumulativeSum,
        .distanceWalkingRunning: .cumulativeSum,
    ]
    
    func aggregate(id: HKQuantityTypeIdentifier) -> HKQuantity? {
        if let opt = Running.quantities[id] {
            switch opt {
            case .discreteAverage: return workout.statistics(for: HKQuantityType(id))?.averageQuantity()
            case .cumulativeSum: return workout.statistics(for: HKQuantityType(id))?.sumQuantity()
            default: return nil
            }
        } else {
            return nil
        }
    }
}

extension Running {
    static func mock(_ date: Date) -> Running {
        //TODO: use workoutbuilder
        Running(workout: HKWorkout(activityType: .running, start: date, end: date))
    }
}
