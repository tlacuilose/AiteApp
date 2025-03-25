//
//  FakeGoalsService.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation
@testable import Aite

enum FakeGoalsServiceError: Error {
    case fake
}

class FakeGoalsService: GoalsServiceProtocol {
    private var lastActivityDate: Date?
    private var costPerMonth: Double?
    private var shouldThrow: Bool = false
    
    func setLastActivityDate(_ date: Date) throws {
        if shouldThrow {
            throw FakeGoalsServiceError.fake
        }
        lastActivityDate = date
    }
    
    func getLastActivityDate() -> Date? {
        return lastActivityDate
    }

    func clearLastActivityDate() {
        lastActivityDate = nil
    }

    func getCostPerMonth() -> Double? {
        return costPerMonth
    }
    
    func setCostPerMonth(_ cost: Double) {
        costPerMonth = cost
    }
    
    func clearCostPerMonth() {
        costPerMonth = nil
    }
    
    func enableThrowables() {
        shouldThrow = true
    }
    
    func clearThrowables() {
        shouldThrow = false
    }
    
    func getAllGoals() -> [Goal] {
        return []
    }
    
    func addGoal(_ goal: Goal) {}
    
    func removeGoal(_ goal: Goal) {}
    
    func removeAllGoals() {}
}
