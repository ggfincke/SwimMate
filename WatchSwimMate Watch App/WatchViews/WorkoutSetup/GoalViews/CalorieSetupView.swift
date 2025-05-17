// WatchSwimMate Watch App/WatchViews/WorkoutSetup/GoalViews/CalorieSetupView.swift

import SwiftUI

struct CalorieSetupView: View
{
    @EnvironmentObject var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    @State private var showWorkoutView = false

    var body: some View 
    {
        NavigationStack 
        {
            VStack(spacing: 10)
            {
                Text("Set Calorie Goal")
                    .font(.headline)
                    .padding()
                
                Text("\(Int(manager.goalCalories)) kcal")
                    .padding()
                
                HStack
                {
                    Button(action: {
                        if manager.goalCalories > 0 {
                            manager.goalCalories -= 1
                        }
                    }) 
                    {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        manager.goalCalories += 1
                    }) 
                    {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .digitalCrownRotation($manager.goalCalories, from: 0, through: 1000, by: 1, sensitivity: .low, isContinuous: false)
                
                Button("Continue") { 
                    manager.path.append(NavState.workoutSetup)
                    dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}



#Preview 
{
    CalorieSetupView()
        .environmentObject(WatchManager())
}
