// WatchSwimMate Watch App/WatchViewModel/WatchManager.swift

import Foundation
import SwiftUI
import HealthKit
import WatchKit

//TODO: Add settings, finish goal-based features, add segments for workouts (for use with set)

class WatchManager: NSObject, ObservableObject
{
    // swim settings (pool/open water, etc.)
    @Published var isPool: Bool = true
    @Published var poolLength: Double = 25.0
    @Published var poolUnit: String = "meters"
    @Published var running = false

    // health store
    var healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?
    
    // properties for elapsed time tracking
    private var workoutStartDate: Date?
    private var elapsedTimeTimer: Timer?
    
    // path for views
    @Published var path = NavigationPath()
    
    // MARK: - Workout Metrics
    @Published var elapsedTime: TimeInterval = 0
    @Published var laps: Int = 0
    @Published var distance: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var workout: HKWorkout?
    
    // goals
    @Published var goalDistance: Double = 0
    @Published var goalTime: TimeInterval = 0

    // will remove at some point 
    @Published var goalHours: TimeInterval = 0
    @Published var goalMinutes: TimeInterval = 0

    @Published var goalCalories: Double = 0
    
    // only pick workout when selected is not nil
    var selected: HKWorkoutActivityType?
    {
        didSet
        {
            // was not using selected so commented for now 
            // guard let selected = selected else { return }
            startWorkout()
        }
        
    }
    
    // reset back to root (for navigation)
    func resetNav()
    {
        path = NavigationPath()
    }
    
    // showing summary view after workout
    @Published var showingSummaryView = false
    {
        didSet
        {
            if showingSummaryView == false
            {
                selected = nil
            }
        }
    }
    
    // request authorization to use HealthKit
    func requestAuthorization()
    {
        let typesToShare: Set = [HKObjectType.workoutType()]
        let typesToRead: Set = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
            HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Authorization successful for all types")
                } else {
                    print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    //MARK: Workout related functions
    func startWorkout()
    {
        // workout configuration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .swimming
        configuration.swimmingLocationType = isPool ? .pool : .openWater
        configuration.locationType = .outdoor // Add explicit location type
        
        // if pool, set lap length
        if isPool
        {
            // meters
            if poolUnit == "meters"
            {
                configuration.lapLength = HKQuantity(unit: HKUnit.meter(), doubleValue: poolLength)
            }
            
            // yards
            else if poolUnit == "yards"
            {
                configuration.lapLength = HKQuantity(unit: HKUnit.yard(), doubleValue: poolLength)
            }
        }
        
        // try to create workout session & builder
        do 
        {
            // create workout session
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)

            // create workout builder
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
        }
        catch
        {
            // handle exceptions
            return
        }

        // set delegates
        workoutSession?.delegate = self
        workoutBuilder?.delegate = self
        
        // Enhanced data source configuration
        let dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        workoutBuilder?.dataSource = dataSource

        // enable WaterLock before starting the swim
        WKInterfaceDevice.current().enableWaterLock()

        // start workout session & begin data collection
        let startDate = Date()
        workoutStartDate = startDate
        workoutSession?.startActivity(with: startDate)
        workoutBuilder?.beginCollection(withStart: startDate) { (success, error) in
            // start timer for updating elapsed time
            DispatchQueue.main.async {
                self.startElapsedTimeTimer()
                // ENSURE water lock is enabled after workout starts
                WKInterfaceDevice.current().enableWaterLock()
            }
        }
    }
    
    // method to start elapsed time timer
    private func startElapsedTimeTimer() {
        elapsedTimeTimer?.invalidate()
        elapsedTimeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startDate = self.workoutStartDate, self.running else { return }
            self.elapsedTime = Date().timeIntervalSince(startDate)
        }
    }

    // pause
    func pause()
    {
        workoutSession?.pause()
    }

    // resume
    func resume()
    {
        workoutSession?.resume()
        WKInterfaceDevice.current().enableWaterLock()
    }

    // toggle pause/resume (for timer/workout)
    func togglePause()
    {
        if running
        {
            pause()
            elapsedTimeTimer?.invalidate()
        }
        else
        {
            resume()
            startElapsedTimeTimer()
        }
    }

    // end workout
    func endWorkout()
    {
        workoutSession?.end()
        elapsedTimeTimer?.invalidate()
        elapsedTimeTimer = nil
        showingSummaryView = true
    }

    // update stats for watch while swimming
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .distanceSwimming):
                let distanceUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: distanceUnit) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .swimmingStrokeCount):
                // TODO: Add stroke count handling if needed
                break
                
            default:
                return
            }
        }
    }
    
    // update lap count
    func updateLapsCount(from workout: HKWorkout) {
        if let distance = workout.totalDistance, let poolLength = workoutBuilder?.workoutConfiguration.lapLength {
            self.laps = Int(round(distance.doubleValue(for: .meter()) / poolLength.doubleValue(for: .meter())))
        } else {
            self.laps = 0
        }
    }
    
    // reset workout
    func resetWorkout()
    {
        selected = nil
        workoutBuilder = nil
        workout = nil
        workoutSession = nil
        activeEnergy = 0
        distance = 0
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WatchManager: HKWorkoutSessionDelegate 
{
    // workout session changed
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date)
    {
        // aync to main thread
        DispatchQueue.main.async 
        {
            self.running = toState == .running
        }

        // if workout ended
        if toState == .ended 
        {
            // end collection
            self.workoutBuilder?.endCollection(withEnd: date) { (success, error) in
                // finish workout
                self.workoutBuilder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async 
                    {
                        // set workout
                        self.workout = workout
                        // ensure laps are updated
                        self.updateLapsCount(from: workout!)  
                        // workout finished
                        print("Workout finished: \(String(describing: workout))")
                    }
                }
            }
        }
    }

    // failed w/ error
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) 
    {
        print(error)
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WatchManager: HKLiveWorkoutBuilderDelegate 
{
    // workout builder did collect event
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) 
    {
        // TODO: Add event handling if needed
    }

    // Enhanced workout builder data collection
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) 
    {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            
            // Get statistics for this data type
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // Debug logging to see what's happening
            print("Collected data of type: \(quantityType.identifier)")
            
            // Update the metrics based on the statistics
            updateForStatistics(statistics)
        }
    }
}

