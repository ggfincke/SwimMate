// WatchSwimMate Watch App/WatchViews/WorkoutViews/GoalProgressView.swift

import SwiftUI

struct GoalProgressView: View 
{
    @EnvironmentObject var manager: WatchManager

    var body: some View
    {
        VStack(spacing: 20) 
        {
            Text("Goal Progress")
                .font(.headline)

            if manager.goalDistance > 0 
            {
                VStack 
                {
                    Text("Distance Goal")
                    ProgressView(value: manager.distance, total: manager.goalDistance)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    Text("\(Int(manager.distance)) / \(Int(manager.goalDistance)) \(manager.poolUnit == "meters" ? "m" : "yd")")
                        .font(.subheadline)
                }
            }

            if manager.goalTime > 0 
            {
                VStack
                {
                    Text("Time Goal")
                    ProgressView(value: manager.elapsedTime, total: manager.goalTime)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    Text("\(formatTime(manager.elapsedTime)) / \(formatTime(manager.goalTime))")
                        .font(.subheadline)
                }
            }

            if manager.goalCalories > 0 
            {
                VStack
                {
                    Text("Calorie Goal")
                    ProgressView(value: manager.activeEnergy, total: manager.goalCalories)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    Text("\(Int(manager.activeEnergy)) / \(Int(manager.goalCalories)) kcal")
                        .font(.subheadline)
                }
            }
        }
        .padding()
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

#Preview
{
    GoalProgressView()
        .environmentObject(WatchManager())
}

