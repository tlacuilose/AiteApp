//
//  Goal.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation

enum GoalTarget: Codable, Equatable {
    case timeframe(days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0)
    case money(Double)
}

struct Goal: Codable, Equatable {
    let id: UUID
    let name: String
    let target: GoalTarget

    init(name: String, target: GoalTarget) {
        self.id = UUID()
        self.name = name
        self.target = target
    }
}
