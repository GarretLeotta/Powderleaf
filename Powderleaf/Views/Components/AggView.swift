//
//  AggView.swift
//  Powderleaf
//
//  Created by Garret Leotta on 6/20/24.
//

import SwiftUI

struct AggView: View {
    let label: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
            HStack(alignment: .bottom, spacing: 0) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(unit)
            }.foregroundStyle(color)
        }
    }
}

#Preview {
    AggView(label: "Heart Rate", value: "150", unit: "BPM", color: .blue)
}
