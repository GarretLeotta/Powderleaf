//
//  RunCard.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/19/24.
//

import SwiftUI
import HealthKit

struct RunCard: View {
    let run: Running
    
    var body: some View {
        HStack {
            Text("Run on \(run.date.formatted())")
            Spacer()
        }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    RunCard(run: .mock(Date()))
}
