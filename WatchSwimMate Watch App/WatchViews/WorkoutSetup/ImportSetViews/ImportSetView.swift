// WatchSwimMate Watch App/WatchViews/WorkoutSetup/ImportSetViews/ImportSetView.swift

import SwiftUI
import HealthKit


struct ImportSetView: View
{
    @EnvironmentObject var watchConnector: iOSWatchConnector
    @EnvironmentObject var manager: WatchManager

    var body: some View 
    {
        List(watchConnector.receivedSets, id: \.self)
        { swimSet in
            Button(action: {
                manager.path.append(NavState.swimmingView(set: swimSet))
                manager.startWorkout()
            })
            {
                VStack(alignment: .leading) 
                {
                    Text(swimSet.title).font(.headline)
                    Text("\(swimSet.totalDistance) \(swimSet.measureUnit.rawValue) - \(swimSet.primaryStroke.rawValue)")
                }
            }
        }
        .navigationTitle("Imported Sets")
    }
}




#Preview {
    ImportSetView()
        .environmentObject(iOSWatchConnector())
        .environmentObject(WatchManager())

}
