//
//  GoalsContainer.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//
import SwiftUI

struct GoalsContainer: View {
    @StateObject var vm = GoalsViewModel()
    @State private var editing = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if !editing {
                    ProgressCounter(progress: vm.progress)
                } else {
                    LastActivityPicker()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Toggle(isOn: $editing) {
                        if !editing {
                            Text("Edit")
                        } else {
                            Text("Done")
                        }
                    }
                    .padding()
                }
            }
        }
        .environmentObject(vm)
    }
}

#Preview("English") {
    GoalsContainer()
}
