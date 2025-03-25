//
//  NewGoalEditor.swift
//  Aite
//
//  Created by Jose Tlacuilo on 24/03/25.
//
import SwiftUI

struct NewGoalEditor: View {
    @State private var newGoal = Goal(name: "", target: .money(0))

    enum EditableTargets {
        case money
        case timeframe
    }

    var body: some View {
        NavigationView {
            Form {
                Section(
                    header:
                        HStack {
                            Text("New Goal")
                            Spacer()
                            Button(action: {
                                guard !newGoal.name.isEmpty else { return }
                                // viewModel.addGoal(newGoal)
                            }) {
                                Text("Add").textCase(nil)
                            }
                            .disabled(newGoal.name.isEmpty)
                        }
                ) {
                    Picker(
                        "Target Type",
                        selection: Binding(
                            get: {
                                switch newGoal.target {
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
                                newGoal = Goal(name: $0, target: newGoal.target)
                            }
                        ))

                    switch newGoal.target {
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
            }
        }
    }
}

#Preview {
    NewGoalEditor()
}
