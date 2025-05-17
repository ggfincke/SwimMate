// WatchSwimMate Watch App/WatchViews/WorkoutSetup/GoalViews/TimeSetupView.swift

import SwiftUI

struct TimeSetupView: View 
{
    @EnvironmentObject var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    @State private var showWorkoutView = false

    
    var hours: [Int] = Array(0...23)
    var minutes: [Int] = Array(0...59)
    var body: some View
    {
        NavigationStack
        {
            VStack(spacing: 0)
            {
                Text("Set Time Goal")
                    .font(.headline)
                    .padding()
                
                // Custom picker for hours
                HStack {
                    Picker(selection: Binding(
                        get: { Int(manager.goalTime / 3600) }, // Convert seconds to hours
                        set: { manager.goalTime = TimeInterval($0 * 3600 + Int(manager.goalTime.truncatingRemainder(dividingBy: 3600))) } // Update goalTime
                    ), label: Text("Hours")) {
                        ForEach(hours, id: \.self) { hour in
                            Text(String(format: "%02d", hour)).tag(hour)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 50, height: 50)
                    .clipped()

                    Text(":")
                        .foregroundColor(.green)

                    Picker(selection: Binding(
                        get: { Int(manager.goalTime.truncatingRemainder(dividingBy: 3600) / 60) }, // Convert seconds to minutes
                        set: { manager.goalTime = TimeInterval(Int(manager.goalTime / 3600) * 3600 + $0 * 60) } // Update goalTime
                    ), label: Text("Minutes")) {
                        ForEach(minutes, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 50, height: 50)
                    .clipped()
                }
                .padding()
                
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

#Preview {
    TimeSetupView()
        .environmentObject(WatchManager())
}
