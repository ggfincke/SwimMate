//
//  SwimMateApp.swift
//  SwimMate
//
//  Created by Garrett Fincke on 4/4/24.
//

// TODO: PREP FOR REACT NATIVE MOVE

import SwiftUI
import HealthKit

@main
struct SwimMateApp: App
{
    @StateObject var manager = Manager()
    @StateObject var watchOSManager = WatchConnector()

    var body: some Scene
    {
        WindowGroup
        {
            // TODO: need to add another view(s) for getting healthperms
            if HKHealthStore.isHealthDataAvailable()
            {
                RootView()
                    .environmentObject(manager)
                    .environmentObject(watchOSManager)
            }
            else
            {
                fatalError("Not working (idk)")
            }
        }
    }
}
    
