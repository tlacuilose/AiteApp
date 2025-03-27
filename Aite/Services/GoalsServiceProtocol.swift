//
//  GoalsServiceProtocol.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation

protocol GoalsServiceProtocol {
    func getLastActivityDate() -> Date?
    func setLastActivityDate(_ date: Date) throws
    func getCostPerMonth() -> Double?
    func setCostPerMonth(_ cost: Double)
    func getAllGoals() -> [Goal]
    func addGoal(_ goal: Goal) throws
    func removeGoal(_ goal: Goal) throws
    func removeAllGoals()
}
