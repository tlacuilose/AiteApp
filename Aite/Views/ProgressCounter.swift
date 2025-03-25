//
//  ProgressCounter.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//
import SwiftUI

struct ProgressCounter: View {
    let progress: String
    
    var body: some View {
        Text(progress)
    }
}

#Preview("English") {
    ProgressCounter(progress: String(localized: "1 Day 2 Hours"))
}
