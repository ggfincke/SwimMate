// WatchSwimMate Watch App/WatchViews/WorkoutViews/SwimmingView.swift

import SwiftUI
import WatchKit

// view shown when swimming
struct SwimmingView: View
{
    @EnvironmentObject var manager: WatchManager
    enum Tab
    {
        case controls, metrics, set, goal
    }
    var set: SwimSet?
    @State private var selection: Tab = .metrics

    // init to see if set exists
    init(set: SwimSet?) 
    {
        self.set = set
    }


    var body: some View
    {
        // initial selection is dependent on goal and set
        let initialSelection: Tab = {
            if let _ = set
            {
                return .set
            } 
            else if manager.goalDistance > 0 || manager.goalTime > 0 || manager.goalCalories > 0
            {
                return .goal
            } 
            else
            {
                return .metrics
            }
        }()
        
        // tabview for selection
        TabView(selection: $selection)
        {
            WorkoutControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            if let set = set
            {
                SetDisplayView(swimSet: set).tag(Tab.set)
            }
            if manager.goalDistance > 0 || manager.goalTime > 0 || manager.goalCalories > 0 
            {
                GoalProgressView().tag(Tab.goal)
            }
        }
        .onAppear 
        {
            selection = initialSelection
        }
        // hide back buttons at the top
        .navigationBarBackButtonHidden(true)

    }
}

// for preview
let sampleSet = SwimSet(
    title: "Sample",
    primaryStroke: .freestyle,
    totalDistance: 2000,
    measureUnit: .meters,
    difficulty: .intermediate,
    description: "A challenging set designed to improve endurance and pace.",
    details: ["800 warmup mix", "10x100 on 1:30, descend 1-5, 6-10", "10x50 kick on 1:00", "500 cool down easy"]
)

#Preview
{
    SwimmingView(set: sampleSet)
        .environmentObject(WatchManager())
}

