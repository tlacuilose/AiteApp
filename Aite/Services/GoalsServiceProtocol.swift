import Foundation

protocol GoalsServiceProtocol {
    func getLastActivityDate() -> Date?
    func setLastActivityDate(_ date: Date)
    func getAllGoals() -> [Goal]
    func addGoal(_ goal: Goal)
    func removeGoal(_ goal: Goal)
    func removeAllGoals()
}
