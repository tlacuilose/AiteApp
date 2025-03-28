//
//  Goal.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation

enum GoalConstruction: Codable, Equatable {
    case timeframe(days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0)
    case money(Double)
}

enum GoalTarget {
    case timeframe(Date)
    case money(Double)
}

enum GoalReference {
    case timeframe(from: Date, to: Date)
    case money(from: Double)
}

struct Goal: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let construction: GoalConstruction

    init(name: String, target: GoalConstruction) {
        self.id = UUID()
        self.name = name
        self.construction = target
    }

    func getTarget(reference: GoalReference) -> GoalTarget? {
        switch (construction, reference) {
        case (.timeframe(let days, let weeks, let months, let years), .timeframe(let from, _)):
            var dateComponents = DateComponents()
            dateComponents.day = days
            dateComponents.weekOfMonth = weeks
            dateComponents.month = months
            dateComponents.year = years

            let calendar = Calendar.current
            if let targetDate = calendar.date(byAdding: dateComponents, to: from) {
                return .timeframe(targetDate)
            }
            return nil
        case (.money(let goal), .money):
            return .money(goal)
        default:
            return nil
        }
    }

    func getProgress(reference: GoalReference) -> Double? {
        switch (construction, reference) {
        case (.timeframe, .timeframe(let from, let to)):
            guard let target = getTarget(reference: reference) else { return nil }

            if case .timeframe(let targetDate) = target {
                let totalTimeInterval = targetDate.timeIntervalSince(from)
                let currentTimeInterval = to.timeIntervalSince(from)

                return min(1.0, max(0.0, (currentTimeInterval / totalTimeInterval)))
            }
            return nil
        case (.money(let goal), .money(let current)):
            return min(1.0, max(0.0, (current / goal)))
        default:
            return nil
        }
    }
}
