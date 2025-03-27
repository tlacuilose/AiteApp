//
//  GoalsTests.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation
import Testing

@testable import Aite

@Suite
struct GoalTests {

    @Test
    func initializeGoal_whenMoneyType_setsCorrectProperties() throws {
        let targetAmount = 1000.0
        let goal = Goal(name: "Save money", target: .money(targetAmount))

        #expect(goal.name == "Save money")
        if case .money(let amount) = goal.construction {
            #expect(amount == targetAmount)
        } else {
            Issue.record("Goals target should be money type")
        }
    }

    @Test
    func initializeGoal_whenTimeframeType_setsCorrectProperties() throws {
        let goal = Goal(name: "Exercise daily", target: .timeframe(days: 30, weeks: 2))

        #expect(goal.name == "Exercise daily")
        if case .timeframe(let days, let weeks, let months, let years) = goal.construction {
            #expect(days == 30)
            #expect(weeks == 2)
            #expect(months == 0)
            #expect(years == 0)
        } else {
            Issue.record("Goal target should be timeframe type")
        }
    }

    @Test
    func compareGoals_whenSameInstance_returnsEqual() throws {
        let goal = Goal(name: "Exercise", target: .timeframe(weeks: 4))
        let sameGoal = goal  // Same instance should be equal

        #expect(goal == sameGoal)
    }

    @Test
    func compareGoals_whenDifferentInstances_returnsNotEqual() throws {
        let goal1 = Goal(name: "Save money", target: .money(1000.0))
        let goal2 = Goal(name: "Save money", target: .money(1000.0))

        // Even with same properties, goals should be different due to unique IDs
        #expect(goal1 != goal2)
    }

    @Test
    func encodeAndDecodeGoal_whenValidGoal_maintainsProperties() throws {
        let goal = Goal(name: "Long term saving", target: .timeframe(months: 6, years: 1))

        // Test encoding and decoding
        let encodedData = try JSONEncoder().encode(goal)
        let decodedGoal = try JSONDecoder().decode(Goal.self, from: encodedData)

        #expect(goal == decodedGoal)
    }

    @Test
    func getTarget_whenTimeframeDays_returnsCorrectDate() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: "2025-01-01")!

        let goal = Goal(name: "Complete project", target: .timeframe(days: 10))
        let reference = GoalReference.timeframe(from: startDate, to: startDate)

        guard let target = goal.getTarget(reference: reference) else {
            Issue.record("Target should not be nil")
            return
        }

        if case .timeframe(let targetDate) = target {
            let targetDateString = dateFormatter.string(from: targetDate)
            #expect(targetDateString == "2025-01-11")
        } else {
            Issue.record("Target should be timeframe type")
        }
    }

    @Test
    func getTarget_whenTimeframeWeeks_returnsCorrectDate() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: "2025-01-01")!

        let goal = Goal(name: "Complete project", target: .timeframe(weeks: 2))
        let reference = GoalReference.timeframe(from: startDate, to: startDate)

        guard let target = goal.getTarget(reference: reference) else {
            Issue.record("Target should not be nil")
            return
        }

        if case .timeframe(let targetDate) = target {
            let targetDateString = dateFormatter.string(from: targetDate)
            #expect(targetDateString == "2025-01-15")  // 2 weeks = 14 days, so Jan 1 + 14 = Jan 15
        } else {
            Issue.record("Target should be timeframe type")
        }
    }

    @Test
    func getTarget_whenTimeframeMonths_returnsCorrectDate() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: "2025-01-01")!

        let goal = Goal(name: "Complete project", target: .timeframe(months: 1))
        let reference = GoalReference.timeframe(from: startDate, to: startDate)

        guard let target = goal.getTarget(reference: reference) else {
            Issue.record("Target should not be nil")
            return
        }

        if case .timeframe(let targetDate) = target {
            let targetDateString = dateFormatter.string(from: targetDate)
            #expect(targetDateString == "2025-02-01")
        } else {
            Issue.record("Target should be timeframe type")
        }
    }

    @Test
    func getTarget_whenTimeframeYears_returnsCorrectDate() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: "2025-01-01")!

        let goal = Goal(name: "Complete project", target: .timeframe(years: 1))
        let reference = GoalReference.timeframe(from: startDate, to: startDate)

        guard let target = goal.getTarget(reference: reference) else {
            Issue.record("Target should not be nil")
            return
        }

        if case .timeframe(let targetDate) = target {
            let targetDateString = dateFormatter.string(from: targetDate)
            #expect(targetDateString == "2026-01-01")
        } else {
            Issue.record("Target should be timeframe type")
        }
    }

    @Test
    func getTarget_whenTimeframeCombined_returnsCorrectDate() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: "2025-01-01")!

        let goal = Goal(
            name: "Complete project", target: .timeframe(days: 10, weeks: 2, months: 1, years: 1))
        let reference = GoalReference.timeframe(from: startDate, to: startDate)

        guard let target = goal.getTarget(reference: reference) else {
            Issue.record("Target should not be nil")
            return
        }

        if case .timeframe(let targetDate) = target {
            let targetDateString = dateFormatter.string(from: targetDate)
            // 1 year + 1 month + 2 weeks + 10 days = 2026-02-25
            #expect(targetDateString == "2026-02-25")
        } else {
            Issue.record("Target should be timeframe type")
        }
    }

    @Test
    func getTarget_whenMoneyType_returnsCorrectAmount() throws {
        let targetAmount = 5000.0
        let goal = Goal(name: "Save money", target: .money(targetAmount))
        let reference = GoalReference.money(from: 1000.0)

        guard let target = goal.getTarget(reference: reference) else {
            Issue.record("Target should not be nil")
            return
        }

        if case .money(let amount) = target {
            #expect(amount == targetAmount)
        } else {
            Issue.record("Target should be money type")
        }
    }

    @Test
    func getTarget_whenTypeMismatch_returnsNil() throws {
        let goal = Goal(name: "Save money", target: .money(1000.0))
        let reference = GoalReference.timeframe(from: Date(), to: Date())

        let target = goal.getTarget(reference: reference)
        #expect(target == nil)
    }

    @Test
    func getProgress_whenTimeframeHalfway_returnsCorrectPercentage() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: "2025-01-01")!
        let middleDate = dateFormatter.date(from: "2025-01-06")!

        let goal = Goal(name: "Complete project", target: .timeframe(days: 10))
        let reference = GoalReference.timeframe(from: startDate, to: middleDate)

        guard let progress = goal.getProgress(reference: reference) else {
            Issue.record("Progress should not be nil")
            return
        }

        // With 5 days passed out of 10, progress should be 50%
        #expect(progress >= 0.49 && progress <= 0.51)
    }

    @Test
    func getProgress_whenMoneyHalfway_returnsCorrectPercentage() throws {
        let goal = Goal(name: "Save money", target: .money(1000.0))
        let reference = GoalReference.money(from: 500.0)

        guard let progress = goal.getProgress(reference: reference) else {
            Issue.record("Progress should not be nil")
            return
        }

        #expect(progress == 0.5)
    }

    @Test
    func getProgress_whenTypeMismatch_returnsNil() throws {
        let goal = Goal(name: "Save money", target: .money(1000.0))
        let reference = GoalReference.timeframe(from: Date(), to: Date())

        let progress = goal.getProgress(reference: reference)
        #expect(progress == nil)
    }
}
