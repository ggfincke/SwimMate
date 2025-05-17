// WatchSwimMate Watch App/WatchViews/WorkoutSetup/IndoorPoolSetupView.swift

import SwiftUI

struct IndoorPoolSetupView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var showUnitPicker = false
    @State private var showSwimmingView = false

    var swimmySet: SwimSet?

    var body: some View
    {
        VStack
        {
            Text("\(Int(manager.poolLength)) \(manager.poolUnit)")
                .padding()
            
            HStack
            {
                Button(action: {
                    if manager.poolLength > 10 { manager.poolLength -= 1 }
                })
                {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
            

                Button(action: {
                    if manager.poolLength < 50 { manager.poolLength += 1 }
                })
                {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
            }

            Button("Select Unit") 
            {
                showUnitPicker = true
            }
            .sheet(isPresented: $showUnitPicker) 
            {
                UnitPickerView()
            }

            Button("Start Workout") 
            {
                manager.startWorkout()
                // nav or action to start the workout
                if (swimmySet != nil)
                {
                    manager.path.append(NavState.swimmingView(set: swimmySet))
                }
                else
                {
                    manager.path.append(NavState.swimmingView(set: nil))
                }
            }
        }
        .padding()
    }
}


#Preview
{
    IndoorPoolSetupView()
        .environmentObject(WatchManager())
}
