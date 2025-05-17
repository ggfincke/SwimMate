// WatchSwimMate Watch App/WatchViews/WatchRootView.swift

import SwiftUI

// TODO: Fix the rest of the navigation
struct WatchRootView: View
{
    @EnvironmentObject var manager: WatchManager
    @EnvironmentObject var iosManager: iOSWatchConnector

    var body: some View 
    {
        VStack
        {
            HStack
            {
                // Quick Start button
                Button(action: {
                    manager.path.append(NavState.workoutSetup)
                }) 
                {
                    VStack {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .frame(width: 20, height: 30)
                    }
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.green))
                    .foregroundColor(.white)
                    .padding()
                }
                
                // Set Goal button
                Button(action: {
                    manager.path.append(NavState.goalWorkoutSetup)
                })
                {
                    VStack
                    {
                        Image(systemName: "target")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.blue))
                    .foregroundColor(.white)
                    .padding()
                }
            }
            
            HStack
            {
                //MARK: Fix all below
                // Import Set button
                Button(action: {
                    manager.path.append(NavState.importSetView)
                })
                {
                    VStack
                    {
                        Image(systemName: "square.and.arrow.down.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.orange))
                    .foregroundColor(.white)
                    .padding()
                }
                
                // Settings button
                Button(action: {
                    print("Settings tapped")
                })
                {
                    VStack
                    {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.gray))
                    .foregroundColor(.white)
                    .padding()
                }
            }
        }
        .onAppear
        {
            manager.requestAuthorization()
        }
    }

}

#Preview
{
    WatchRootView()
        .environmentObject(WatchManager())
        .environmentObject(iOSWatchConnector())
}
