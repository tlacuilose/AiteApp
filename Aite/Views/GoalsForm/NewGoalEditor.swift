//
//  NewGoalEditor.swift
//  Aite
//
//  Created by Jose Tlacuilo on 24/03/25.
//
import SwiftUI

struct NewGoalEditor: View {
    @EnvironmentObject private var vm: GoalsViewModel

    @State private var newGoal = Goal(name: "", target: .money(0))
    @State private var bounceTrigger: CGFloat = 0
    @State private var errorMessage: String? = nil
    @State private var didErrored = false

    enum EditableTargets {
        case money
        case timeframe
    }

    var body: some View {
        Section(
            header:
                HStack {
                    Text("New Goal")
                    Spacer()
                    Button(action: {
                        guard !newGoal.name.isEmpty else { return }
                        do {
                            try vm.addGoal(newGoal)
                            withAnimation(Animation.linear(duration: 0.6)) {
                                bounceTrigger += 1
                                newGoal = Goal(name: "", target: .money(0))
                            }
                        } catch {
                            errorMessage = error.localizedDescription
                            didErrored = true
                        }
                    }) {
                        Text("Add").textCase(nil)
                    }
                    .disabled(newGoal.name.isEmpty)
                    // Add an animation to fill in the button and fillout if done :D
                }
                .modifier(BounceEffect(animatableData: bounceTrigger))
        ) {
            Picker(
                "Target Type",
                selection: Binding(
                    get: {
                        switch newGoal.construction {
                        case .money:
                            return EditableTargets.money
                        case .timeframe:
                            return EditableTargets.timeframe
                        }
                    },
                    set: { (newType: EditableTargets) in
                        switch newType {
                        case .money:
                            newGoal = Goal(name: newGoal.name, target: .money(0))
                        case .timeframe:
                            newGoal = Goal(
                                name: newGoal.name,
                                target: .timeframe(days: 0, weeks: 0, months: 0, years: 0))

                        }
                    }
                )
            ) {
                Text("Money").tag(EditableTargets.money)
                Text("Timeframe").tag(EditableTargets.timeframe)
            }
            .pickerStyle(SegmentedPickerStyle())

            TextField(
                "Goal Name",
                text: Binding(
                    get: { newGoal.name },
                    set: {
                        newGoal = Goal(name: $0, target: newGoal.construction)
                    }
                ))

            switch newGoal.construction {
            case .money(let amount):
                TextField(
                    "Target Amount",
                    value: Binding(
                        get: { amount },
                        set: { newAmount in
                            newGoal = Goal(name: newGoal.name, target: .money(newAmount))
                        }
                    ),
                    format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                )
                .keyboardType(.decimalPad)
            case .timeframe(let days, let weeks, let months, let years):
                NumberField(
                    title: "Days",
                    value: Binding(
                        get: { days },
                        set: { newDays in
                            newGoal = Goal(
                                name: newGoal.name,
                                target: .timeframe(
                                    days: newDays, weeks: weeks, months: months,
                                    years: years))
                        })
                )

                NumberField(
                    title: "Weeks",
                    value: Binding(
                        get: { weeks },
                        set: { newWeeks in
                            newGoal = Goal(
                                name: newGoal.name,
                                target: .timeframe(
                                    days: days, weeks: newWeeks, months: months,
                                    years: years))
                        })
                )

                NumberField(
                    title: "Months",
                    value: Binding(
                        get: { months },
                        set: { newMonths in
                            newGoal = Goal(
                                name: newGoal.name,
                                target: .timeframe(
                                    days: days, weeks: weeks, months: newMonths,
                                    years: years))
                        })
                )

                NumberField(
                    title: "Years",
                    value: Binding(
                        get: { days },
                        set: { newYears in
                            newGoal = Goal(
                                name: newGoal.name,
                                target: .timeframe(
                                    days: days, weeks: weeks, months: months,
                                    years: newYears))
                        })
                )
            }
        }
        .alert(
            "Error", isPresented: $didErrored,
            actions: {
                Button("Ok", role: .cancel) {}
            },
            message: {
                Text(errorMessage ?? "Unknown error")
            })
    }
}

#Preview {
    Form {
        NewGoalEditor()
            .environmentObject(GoalsViewModel(goalsService: FakeGoalsServiceForUI()))
    }
}

