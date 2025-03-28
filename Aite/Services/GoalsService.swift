//
//  GoalsService.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation

enum TimespaceError: Error, LocalizedError {
    case futureActivity
    case negativeValue

    var errorDescription: String? {
        switch self {
        case .futureActivity:
            return String(localized: "The activity date can't be in the future")
        case .negativeValue:
            return String(localized: "The cost cannot be negative")
        }
    }
}

enum CodableError: Error, LocalizedError {
    case goalNotCodable

    var errorDescription: String? {
        switch self {
        case .goalNotCodable:
            return String(localized: "The goal is not codable")
        }
    }
}

class GoalsService: GoalsServiceProtocol {
    static let shared = GoalsService()

    private let defaults: UserDefaults

    enum DefaultsKeys {
        static let lastActivityDate = "lastActivityDate"
        static let costPerMonth = "costPerMonth"
        static let goals = "goals"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // 23 May 2025 - 2:35am
    func getLastActivityDate() -> Date? {
        return defaults.object(forKey: DefaultsKeys.lastActivityDate) as? Date
    }

    func setLastActivityDate(_ date: Date) throws {
        guard date <= Date() else {
            throw TimespaceError.futureActivity
        }
        defaults.set(date, forKey: DefaultsKeys.lastActivityDate)
    }

    // $40,000
    func getCostPerMonth() -> Double? {
        return defaults.object(forKey: DefaultsKeys.costPerMonth) as? Double
    }

    func setCostPerMonth(_ cost: Double) throws {
        if cost < 0 {
            throw TimespaceError.negativeValue
        }
        defaults.set(cost, forKey: DefaultsKeys.costPerMonth)
    }

    func getAllGoals() -> [Goal] {
        guard let data = defaults.data(forKey: DefaultsKeys.goals),
            let goals = try? JSONDecoder().decode([Goal].self, from: data)
        else {
            return []
        }
        return goals
    }

    func addGoal(_ goal: Goal) throws {
        switch goal.construction {
        case .money(let amount):
            if amount < 0 {
                throw TimespaceError.negativeValue
            }
        case .timeframe(let days, let weeks, let months, let years):
            if days < 0 || weeks < 0 || months < 0 || years < 0 {
                throw TimespaceError.negativeValue
            }
        }

        var goals = getAllGoals()
        goals.append(goal)
        try saveGoals(goals)
    }

    func removeGoal(_ goal: Goal) throws {
        var goals = getAllGoals()
        goals.removeAll { $0.id == goal.id }
        try saveGoals(goals)
    }

    func removeAllGoals() {
        defaults.removeObject(forKey: DefaultsKeys.goals)
    }

    private func saveGoals(_ goals: [Goal]) throws {
        do {
            let encoded = try JSONEncoder().encode(goals)
            defaults.set(encoded, forKey: DefaultsKeys.goals)
        } catch {
            throw CodableError.goalNotCodable
        }
    }
}
