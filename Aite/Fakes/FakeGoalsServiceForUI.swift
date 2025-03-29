//
//  FakeGoalsServiceForUI.swift
//  Aite
//
//  Created by Jose Tlacuilo on 26/03/25.
//
import Foundation

enum FakeUIError: Error, LocalizedError {
    case goalNotCodable
    case negativeValue

    var errorDescription: String? {
        switch self {
        case .goalNotCodable:
            return String(localized: "The goal is not codable")
        case .negativeValue:
            return String(localized: "The cost cannot be negative")
        }
    }
}

class FakeGoalsServiceForUI: GoalsServiceProtocol {
    private var goals: [Goal] = [
        Goal(name: "Money Goal", target: .money(100)),
        Goal(name: "Timeframe Goal", target: .timeframe(days: 0, weeks: 0, months: 2, years: 0)),
        Goal(name: "Error Goal", target: .money(100)),
    ]

    private var lastActivityDate: Date?

    init(lastActivityDate: Date? = nil, clearGoals: Bool = false) {
        self.lastActivityDate = lastActivityDate

        if clearGoals {
            goals.removeAll()
        }
    }

    func setLastActivityDate(_ date: Date) throws {}

    func getLastActivityDate() -> Date? { return lastActivityDate }

    func clearLastActivityDate() {}

    func getCostPerMonth() -> Double? { return nil }

    func setCostPerMonth(_ cost: Double) {}

    func clearCostPerMonth() {}

    func getAllGoals() -> [Goal] {
        return goals
    }

    func addGoal(_ goal: Goal) throws {
        if goal.name == "Error" {
            throw FakeUIError.goalNotCodable
        }

        if goal.construction == .money(-100) {
            throw FakeUIError.negativeValue
        }

        goals.append(goal)
    }

    func removeGoal(_ goal: Goal) throws {
        if goal.name == "Error Goal" {
            throw FakeUIError.goalNotCodable
        }
        goals.removeAll { $0.id == goal.id }
    }

    func removeAllGoals() {
        goals.removeAll()
    }

    func moveGoals(from: IndexSet, to: Int) throws {
        goals.move(fromOffsets: from, toOffset: to)
    }
}
