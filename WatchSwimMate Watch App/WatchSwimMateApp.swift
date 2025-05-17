// WatchSwimMate Watch App/WatchSwimMateApp.swift

import SwiftUI
import HealthKit

@main
struct WatchSwimMate_Watch_App: App
{
    @StateObject private var watchManager = WatchManager()

    @SceneBuilder var body: some Scene
    {
        WindowGroup
        {
            NavigationStack(path: $watchManager.path)
            {
                WatchRootView()
                    .navigationDestination(for: NavState.self) { state in
                        switch state 
                        {
                            case .workoutSetup:
                                WorkoutSetupView()
                            case .goalWorkoutSetup:
                                GoalWorkoutSetupView()
                            case .indoorPoolSetup:
                                IndoorPoolSetupView()
                            case .swimmingView(let set):
                                SwimmingView(set: set)
                            case .importSetView:
                                ImportSetView()
                        }
                    }
            }
            .sheet(isPresented: $watchManager.showingSummaryView)
            {
                SwimmingSummaryView()
            }
            .environmentObject(watchManager)
            .environmentObject(iOSWatchConnector())
        }
    }
}
