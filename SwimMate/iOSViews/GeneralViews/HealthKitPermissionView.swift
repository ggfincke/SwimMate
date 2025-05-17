// SwimMate/iOSViews/GeneralViews/HealthKitPermissionView.swift

import SwiftUI
import HealthKit
import HealthKitUI

struct HealthKitPermissionView: View {
    @EnvironmentObject var manager: Manager
    let allTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.heartRate),
        HKQuantityType(.swimmingStrokeCount),
        HKQuantityType(.waterTemperature),
        HKQuantityType(.underwaterDepth)
    ]

    @State private var trigger = false
    @State private var authenticated = false

    var body: some View {
        VStack 
        {
            if authenticated 
            {
                Text("HealthKit Access Granted")
            } 
            else
            {
                Text("Requesting HealthKit Access...")
            }
        }
        .onAppear 
        {
            requestHealthDataAccess()
        }
        
        // update your views or handle state changes as needed
        .onChange(of: trigger) 
        {
            requestHealthDataAccess()
        }
    }

    private func requestHealthDataAccess() 
    {
        // Ensure Health data is available on the device before requesting access
        guard HKHealthStore.isHealthDataAvailable() else 
        {
            print("HealthKit is not available on this device.")
            return
        }

        manager.healthStore.requestAuthorization(toShare: allTypes, read: allTypes) 
        { success, error in
            if let error = error
            {
                print("*** An error occurred while requesting authentication: \(error.localizedDescription) ***")
            } 
            else
            {
                authenticated = success
            }
        }
    }
}


//
//import SwiftUI
//import HealthKit
//import HealthKitUI
//
//struct HealthKitPermissionView: View
//{
//    // manager
//    @EnvironmentObject var manager : Manager
//    // types of data needed
//    let allTypes: Set = [
//        HKQuantityType.workoutType(),
//        HKQuantityType(.activeEnergyBurned),
//        HKQuantityType(.heartRate),
//        HKQuantityType(.swimmingStrokeCount),
//        HKQuantityType(.waterTemperature),
//        HKQuantityType(.underwaterDepth)
//    ]
//    
//    // implementation from Apple documentation
//    @State var authenticated = false
//    @State var trigger = false
//    
//    var body: some View {
//        Button("Access health data") 
//        {
//            // OK to read or write HealthKit data here.
//        }
//        .disabled(!authenticated)
//        
//        // If HealthKit data is available, request authorization
//        // when this view appears.
//        .onAppear() {
//            
//            // Check that Health data is available on the device.
//            if HKHealthStore.isHealthDataAvailable() {
//                // Modifying the trigger initiates the health data
//                // access request.
//                trigger.toggle()
//            }
//        }
//        
//        // Requests access to share and read HealthKit data types
//        // when the trigger changes.
//        .healthDataAccessRequest(store: manager.healthStore,
//                                 shareTypes: allTypes,
//                                 readTypes: allTypes,
//                                 trigger: trigger) { result in
//            switch result {
//                
//            case .success(_):
//                authenticated = true
//            case .failure(let error):
//                // Handle the error here.
//                fatalError("*** An error occurred while requesting authentication: \(error) ***")
//            }
//        }
//    }
//}
//
////#Preview
////{
////    HealthKitPermissionView()
////}
