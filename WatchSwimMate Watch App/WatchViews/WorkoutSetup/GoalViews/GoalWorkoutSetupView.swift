// WatchSwimMate Watch App/WatchViews/WorkoutSetup/GoalViews/GoalWorkoutSetupView.swift

import SwiftUI

// changed to sheets instead of using the navStack
struct GoalWorkoutSetupView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var showRegSetupSheet = false
    @State private var showDistanceSetupSheet = false
    @State private var showTimeSetupSheet = false
    @State private var showCalorieSetupSheet = false

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 15)
            {
                Button("Open") {
                    showRegSetupSheet = true
                    manager.path.append(NavState.workoutSetup)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(8)
                .padding(.top)
                .padding(.horizontal)


                Button("Distance") {
                    showDistanceSetupSheet = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal)
                .sheet(isPresented: $showDistanceSetupSheet)
                {
                    DistanceSetupView().environmentObject(manager)
                }

                Button("Time") {
                    showTimeSetupSheet = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
                .padding(.horizontal)
                .sheet(isPresented: $showTimeSetupSheet)
                {
                    TimeSetupView().environmentObject(manager)
                }
                
                Button("Calorie") {
                    showCalorieSetupSheet = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.yellow)
                .cornerRadius(8)
                .padding(.horizontal)
                .sheet(isPresented: $showCalorieSetupSheet)
                {
                    CalorieSetupView().environmentObject(manager)
                }
            }
            .padding()
        }
    }
}

#Preview
{
    GoalWorkoutSetupView()
        .environmentObject(WatchManager())
}

