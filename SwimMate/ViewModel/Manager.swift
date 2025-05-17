// SwimMate/ViewModel/Manager.swift

// the iOS manager/view model
import Foundation
import HealthKit

class Manager: NSObject, ObservableObject
{
    // MARK: vars / init
    // healthkit vars
    var permission: Bool
    let healthStore: HKHealthStore
    var currentWorkoutSession: HKWorkoutSession?
    
    // user preferences
    @Published var userName: String = "User"
    @Published var preferredStroke: SwimSet.Stroke = .freestyle
    @Published var preferredUnit: SwimSet.MeasureUnit = .meters
    @Published var swims: [Swim] = []
    
    // store
    @Published var store: Store = Store(userName: "Default User", preferredStroke: .freestyle, preferredUnit: .meters, swims: [])

    // user totals (calculated values)
    @Published var totalDistance: Double = 0.0
    @Published var averageDistance: Double = 0.0
    @Published var totalCalories: Double = 0.0
    @Published var averageCalories: Double = 0.0

    
    //TODO: replace with remote database integration at some point
    // very long list of sample sets
    let sampleSets: [SwimSet] = [
        SwimSet(title: "Endurance Challenge", primaryStroke: .freestyle, totalDistance: 2000, measureUnit: .meters, difficulty: .intermediate, description: "A challenging endurance set to boost stamina.", details: ["800 warmup mix", "10x100 on 1:30, descend 1-5, 6-10", "10x50 kick on 1:00", "500 cool down easy"]),
        SwimSet(title: "Technique Tuner", primaryStroke: .breaststroke, totalDistance: 1500, measureUnit: .yards, difficulty: .advanced, description: "Focus on technique and power.", details: ["200 swim, 200 pull, 200 kick", "10x50 on 50s, odds drill, evens swim", "4x100 pull with paddles on 1:40", "200 easy"]),
        SwimSet(title: "Backstroke Blast", primaryStroke: .backstroke, totalDistance: 1200, measureUnit: .meters, difficulty: .beginner, description: "Speed work for improving backstroke performance.", details: ["4x100 backstroke on 2:00", "8x50 back fast on 1:00", "4x25 sprint on 30s", "300 easy"]),
        SwimSet(title: "Butterfly Sprint Series", primaryStroke: .butterfly, totalDistance: 800, measureUnit: .yards, difficulty: .intermediate, description: "High-intensity butterfly sprints.", details: ["400 warmup mixed", "8x50 butterfly on 50s", "4x25 fly sprints on 30s", "200 cool down"]),
        SwimSet(title: "IM Pro Series", primaryStroke: .IM, totalDistance: 1500, measureUnit: .meters, difficulty: .advanced, description: "Comprehensive IM workout for all strokes.", details: ["400 IM as 100 of each", "4x100 IM on 1:50", "200 IM kick", "8x50 IM order sprint each", "200 easy"]),
        SwimSet(title: "Marathon Freestyle", primaryStroke: .freestyle, totalDistance: 3000, measureUnit: .yards, difficulty: .advanced, description: "Long-distance freestyle set for endurance.", details: ["1000 straight swim", "5x200 on 2:45", "10x100 on 1:15", "500 cooldown"]),
        SwimSet(title: "Beginner Breaststroke Basics", primaryStroke: .breaststroke, totalDistance: 1000, measureUnit: .meters, difficulty: .beginner, description: "Easy-going set for breaststroke beginners.", details: ["200 easy warmup", "8x50 drill on 1:10", "4x100 swim on 2:00", "200 easy cooldown"]),
        SwimSet(title: "Speedy Freestyle Flicks", primaryStroke: .freestyle, totalDistance: 500, measureUnit: .yards, difficulty: .intermediate, description: "Short distance, high-intensity freestyle sprints.", details: ["50 warmup", "10x25 sprint on 20 seconds", "50 cooldown"]),
        SwimSet(title: "Medley Mastery", primaryStroke: .IM, totalDistance: 2000, measureUnit: .meters, difficulty: .advanced, description: "Advanced set for mastering the individual medley.", details: ["400 IM", "8x100 IM on 1:40", "8x50 IM kick on 1:00", "400 freestyle cool down"]),
        SwimSet(title: "Freestyle Fundamentals", primaryStroke: .freestyle, totalDistance: 500, measureUnit: .meters, difficulty: .beginner, description: "Basic freestyle techniques and endurance.", details: ["200 easy warmup", "8x25 freestyle technique focus", "100 cool down"]),
        SwimSet(title: "Backstroke Basics", primaryStroke: .backstroke, totalDistance: 500, measureUnit: .yards, difficulty: .beginner, description: "Fundamentals of backstroke, focusing on form.", details: ["200 easy warmup", "6x25 backstroke drills", "100 cool down"]),
        SwimSet(title: "Intermediate Butterfly", primaryStroke: .butterfly, totalDistance: 1000, measureUnit: .yards, difficulty: .intermediate, description: "Building strength and technique in butterfly.", details: ["200 mixed warmup", "5x100 butterfly on 2:00", "200 easy cool down"]),
        SwimSet(title: "Stroke Variety Pack", primaryStroke: .IM, totalDistance: 500, measureUnit: .yards, difficulty: .beginner, description: "Introduction to all strokes, focusing on transitions.", details: ["100 IM warmup", "4x50 each stroke focus", "100 easy cooldown"]),
        SwimSet(title: "Breaststroke Endurance", primaryStroke: .breaststroke, totalDistance: 2000, measureUnit: .meters, difficulty: .advanced, description: "Long distance, endurance training for breaststroke.", details: ["500 warmup", "10x100 on 1:50", "500 cool down"])
    ]

    // init
    override init()
    {

        self.healthStore = HKHealthStore()
        self.permission = true
        super.init()
        loadFromJSONOrDefault()

    }

    // MARK: Loading from HealthStore
    // determines whether to load from JSON or if needed to use healthstore imports
    func loadFromJSONOrDefault() 
    {
        let fileManager = FileManager.default
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        
        // check if the JSON file exists
        if fileManager.fileExists(atPath: url.path)
        {
            loadFromJSON()  // attempt to load from JSON
            
            // check if the swims are empty after attempting to load
            if self.swims.isEmpty
            {
                print("No swims data found in JSON, loading from HealthKit.")
                loadAllSwimmingWorkouts()
            } 
            else
            {
                print("Loaded swims from JSON successfully.")
                calcFields()
            }
        } 
        else
        {
            // if JSON file doesn't exist, proceed with loading from HealthKit
            print("No JSON file found, loading from HealthKit.")
            loadAllSwimmingWorkouts()
        }
    }
    
    // load from healthStore
    func loadAllSwimmingWorkouts()
    {
        self.swims.removeAll()
        
        // creating query
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .swimming)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor])
        { [weak self] (query, samples, error) in
            guard let self = self, let workouts = samples as? [HKWorkout], error == nil else
            {
                print("Failed to fetch workouts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // perform updates on main thread - for all workouts
            DispatchQueue.main.async
            {
                for workout in workouts 
                {
                    // making the swim struct
                    let id = UUID()
                    let date = workout.startDate
                    let duration = workout.duration
                    let totalDistance: Double = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
                    let totalEnergyBurned: Double = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
                    var poolLength: Double?
                    var laps = [Lap]()

                    // getting laps in the workout
                    if let events = workout.workoutEvents
                    {
                        for event in events where event.type == .lap
                        {
                            if let metadata = event.metadata 
                            {
                                let lapDuration = event.dateInterval.duration
                                let lap = Lap(duration: lapDuration, metadata: metadata)
                                laps.append(lap)
                            }
                        }
                    }

                    // getting pool length
                    if let metadata = workout.metadata, let metaLap = metadata[HKMetadataKeyLapLength] as? HKQuantity
                    {
                        poolLength = metaLap.doubleValue(for: HKUnit.meter())
                    }

                    // append swim
                    let swim = Swim(id: id, date: date, duration: duration, totalDistance: totalDistance, totalEnergyBurned: totalEnergyBurned, poolLength: poolLength, laps: laps)
                    self.swims.append(swim)
                }
                // once done with loops, calc fields and update storage
                self.calcFields()
                self.updateStore()
            }

        }
        healthStore.execute(query)
    }
    
    // calcs user totals
    func calcFields()
    {
        var tDis = 0.0
        var tCals = 0.0
        var count = 0

        for swim in self.swims
        {
            tDis += swim.totalDistance!
            tCals += swim.totalEnergyBurned ?? 0
            count += 1
        }
        
        totalDistance = tDis
        averageDistance = count > 0 ? tDis / Double(count) : 0
        totalCalories = tCals
        averageCalories = count > 0 ? tCals / Double(count) : 0
    }
    
    // updateStore for JSON
    func updateStore()
    {
        store.swims = swims
        store.preferredStroke = preferredStroke
        store.preferredUnit = preferredUnit
        store.userName = userName
        saveToJSON()
    }
    
    // MARK: Persistence funcs
    
    // save
    func saveToJSON()
    {
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        do 
        {
            let encoder = JSONEncoder()
            let data = try encoder.encode(store)
            // move data writing to background thread
            DispatchQueue.global(qos: .background).async
            {
                do
                {
                    try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
                    DispatchQueue.main.async 
                    {
                        print("Saved to \(url)")
                    }
                } 
                catch
                {
                    DispatchQueue.main.async 
                    {
                        print("Failed to save: \(error)")
                    }
                }
            }
//            try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
        } 
        catch
        {
            print("Failed to save: \(error)")
        }
    }
    
    // load
    func loadFromJSON()
    {
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        do 
        {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            store = try decoder.decode(Store.self, from: data)
            updateLocalStoreValues()
        }
        catch
        {
            print("Failed to load JSON from \(url): \(error)")
        }
    }

    // update local vals
    private func updateLocalStoreValues() 
    {
        self.swims = store.swims
        self.userName = store.userName
        self.preferredStroke = store.preferredStroke
        self.preferredUnit = store.preferredUnit
        calcFields()
    }
    
    // gets document directory for the URL
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    
}

// struct to store for persistence
struct Store: Codable
{
    var userName: String
    var preferredStroke: SwimSet.Stroke
    var preferredUnit: SwimSet.MeasureUnit
    var swims: [Swim]
}


// extended for use in graphs
extension Calendar 
{
    func startOfMonth(for date: Date) -> Date 
    {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}

// distance formatter
extension Manager 
{
    func formatDistance(_ meters: Double) -> String
    {
        if preferredUnit == .yards
        {
            // converts into yards
            let yards = meters * 1.09361
            return String(format: "%.1f yd", yards)
        } 
        // else return string format of meters
        else
        {
            return String(format: "%.1f m", meters)
        }
    }
}

// aggregate data by month
extension Manager
{
    // combine data for swift charts
    func aggregateDataByMonth(swims: [Swim]) -> [Swim]
    {
        // group and sum swims by month
        let grouped = Dictionary(grouping: swims)
        { swim in
            Calendar.current.startOfMonth(for: swim.date)
        }
        return grouped.map
        { (month, swims) in
            Swim(
                id: UUID(),
                date: month,
                duration: swims.reduce(0, { $0 + $1.duration }),
                totalDistance: swims.compactMap({ $0.totalDistance }).reduce(0, +),
                totalEnergyBurned: swims.compactMap({ $0.totalEnergyBurned }).reduce(0, +),
                poolLength: nil
            )
        }.sorted(by: { $0.date < $1.date })
    }
}

