//
//  HealthKitService.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/19/24.
//

import Foundation

class HealthKitService: ObservableObject {
    let emeraldKey: EmeraldKey
    
    init(mock: Bool) {
        self.emeraldKey = EmeraldKey(mock: mock)
    }
}
