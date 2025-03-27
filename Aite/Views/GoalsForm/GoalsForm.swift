//
//  GoalsForm.swift
//  Aite
//
//  Created by Jose Tlacuilo on 26/03/25.
//
import SwiftUI

struct GoalsForm: View {
    var body: some View {
        Form {
            VariablesEditor()
            NewGoalEditor()
            GoalsEditor()
        }
    }
}

#Preview {
    GoalsForm()
        .environmentObject(GoalsViewModel())
}
