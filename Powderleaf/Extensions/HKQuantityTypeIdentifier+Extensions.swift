//
//  HKQuantityTypeIdentifier+Extensions.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/20/24.
//

import Foundation
import HealthKit

extension HKQuantityTypeIdentifier {
    func display() -> String {
        return switch self {
        case .activeEnergyBurned: "Active Calories"
        case .basalEnergyBurned: "Resting Calories"
        case .distanceWalkingRunning: "Distance"
        case .heartRate: "Avg. Heart Rate"
        case .runningGroundContactTime: "Avg. Ground Contact Time"
        case .runningPower: "Avg. Power"
        case .runningSpeed: "Avg. Speed"
        case .runningStrideLength: "Avg. Stride Length"
        case .runningVerticalOscillation: "Avg. Oscillation"
        case .stepCount: "Steps"
        default: "Unsupported Quantity"
        }
    }
}
