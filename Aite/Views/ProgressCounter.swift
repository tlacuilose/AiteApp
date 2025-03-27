//
//  ProgressCounter.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//
import SwiftUI

struct ProgressCounter: View {
    let progress: String
    let savedAmount: Double

    var body: some View {
        Section {
            Text(progress)
            Text(
                savedAmount.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
            )
        }
    }
}

#Preview("English") {
    ProgressCounter(
        progress: String(localized: "1 Day 2 Hours"),
        savedAmount: 500.0
    )
}
