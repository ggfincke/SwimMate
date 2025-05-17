// WatchSwimMate Watch App/WatchViews/WorkoutSetup/GoalViews/DistanceSetupView.swift

import SwiftUI

struct DistanceSetupView: View 
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
                
                Text("\(Int(manager.goalDistance))" + " Laps")
                    .padding()
                
                // w/ digital crown integration to adjust distance
                HStack
                {
                    Button(action: {
                        if manager.goalDistance > 0
                        {
                            manager.goalDistance -= 1
                        }
                    })
                    {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        manager.goalDistance += 1
                    })
                    {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .digitalCrownRotation($manager.goalDistance, from: 0, through: 1000, by: 1, sensitivity: .low, isContinuous: false)
                
                Button("Continue")
                {
                    manager.path.append(NavState.workoutSetup)
                    dismiss()
                }
                .padding()
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

#Preview 
{
    DistanceSetupView()
        .environmentObject(WatchManager())
}
