import Foundation

class GoalsService: GoalsServiceProtocol {
    private let defaults: UserDefaults
    
    enum DefaultsKeys {
        static let lastActivityDate = "lastActivityDate"
        static let goals = "goals"
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func getLastActivityDate() -> Date? {
        return defaults.object(forKey: DefaultsKeys.lastActivityDate) as? Date
    }
    
    func setLastActivityDate(_ date: Date) {
        defaults.set(date, forKey: DefaultsKeys.lastActivityDate)
    }
    
    func getAllGoals() -> [Goal] {
        guard let data = defaults.data(forKey: DefaultsKeys.goals),
              let goals = try? JSONDecoder().decode([Goal].self, from: data) else {
            return []
        }
        return goals
    }
    
    func addGoal(_ goal: Goal) {
        var goals = getAllGoals()
        goals.append(goal)
        if let encoded = try? JSONEncoder().encode(goals) {
            defaults.set(encoded, forKey: DefaultsKeys.goals)
        }
    }
    
    func removeGoal(_ goal: Goal) {
        var goals = getAllGoals()
        goals.removeAll { $0.id == goal.id }
        if let encoded = try? JSONEncoder().encode(goals) {
            defaults.set(encoded, forKey: DefaultsKeys.goals)
        }
    }
    
    func removeAllGoals() {
        defaults.removeObject(forKey: DefaultsKeys.goals)
    }
}
