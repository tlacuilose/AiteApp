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
    func getAllGoals() -> [Goal]
    func addGoal(_ goal: Goal)
    func removeGoal(_ goal: Goal)
    func removeAllGoals()
}
