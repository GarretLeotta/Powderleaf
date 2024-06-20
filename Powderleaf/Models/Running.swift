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
    static let quantities: [HKQuantityTypeIdentifier: Aggregate] = [
        .runningGroundContactTime: .average,
        .runningPower: .average,
        .runningVerticalOscillation: .average,
        .runningSpeed: .average,
        .runningStrideLength: .average,
        .heartRate: .average,
        .stepCount: .sum,
        .activeEnergyBurned: .sum,
        .basalEnergyBurned: .sum,
        .distanceWalkingRunning: .sum,
    ]
    
    func aggregate(id: HKQuantityTypeIdentifier) -> HKQuantity? {
        switch Running.quantities[id] {
        case .average: workout.statistics(for: HKQuantityType(id))?.averageQuantity()
        case .sum: workout.statistics(for: HKQuantityType(id))?.sumQuantity()
        default: nil
        }
    }
}

extension Running {
    static func mock(_ date: Date) -> Running {
        //TODO: use workoutbuilder
        Running(workout: HKWorkout(activityType: .running, start: date, end: date))
    }
}
