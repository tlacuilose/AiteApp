//
//  GoalDetail.swift
//  Aite
//
//  Created by Jose Tlacuilo on 26/03/25.
//
import SwiftUI

struct GoalDetail: View {
    let goal: Goal
    let goalReference: GoalReference

    private let goalTarget: GoalTarget?
    private let goalProgress: Double?

    private let gradient: Gradient

    init(goal: Goal, goalReference: GoalReference) {
        self.goal = goal
        self.goalReference = goalReference
        goalTarget = goal.getTarget(reference: goalReference)
        goalProgress = goal.getProgress(reference: goalReference)

        switch goal.construction {
        case .money:
            gradient = Gradient(colors: [.green, .yellow, .red])
        case .timeframe:
            gradient = Gradient(colors: [.blue, .pink, .purple])
        }
    }

    var body: some View {
        HStack {
            if let progress = goalProgress {
                Gauge(value: progress) {
                    Text("\(Int(progress * 100))%")
                        .foregroundStyle(
                            LinearGradient(
                                gradient: gradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(gradient)
                .scaleEffect(0.7)
                .fixedSize()
            }
            VStack(alignment: .leading) {
                Text(goal.name)
                    .font(.headline)

                switch (goal.construction, goalTarget) {
                case (.money, .money(let amount)):
                    Text(
                        amount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD")
                    )
                    .font(.subheadline)
                case (.timeframe, .timeframe(let date)):
                    Text(date.formatted())
                        .font(.subheadline)
                default:
                    Text("Errored goal")
                        .font(.caption)
                        .strikethrough(true)
                }

            }
        }
    }
}

#Preview("Money 0%") {
    GoalDetail(goal: Goal(name: "Some goal", target: .money(100)), goalReference: .money(from: 0))
}

#Preview("Money 20%") {
    GoalDetail(goal: Goal(name: "Some goal", target: .money(100)), goalReference: .money(from: 20))
}

#Preview("Timeframe 20%") {
    let startDate = Date()
    let currentDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
    GoalDetail(
        goal: Goal(name: "Some goal", target: .timeframe(days: 30)),
        goalReference: .timeframe(from: startDate, to: currentDate)
    )
}

#Preview("Timeframe 100%") {
    let startDate = Date()
    let currentDate = Calendar.current.date(byAdding: .day, value: 30, to: startDate)!
    GoalDetail(
        goal: Goal(name: "Some goal", target: .timeframe(days: 30)),
        goalReference: .timeframe(from: startDate, to: currentDate)
    )
}

#Preview("Errored") {
    GoalDetail(
        goal: Goal(name: "Some goal", target: .money(0)),
        goalReference: .timeframe(from: Date(), to: Date())
    )
}
