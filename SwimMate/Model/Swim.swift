// SwimMate/Model/Swim.swift

// this file is for all information on a specific swim workout.
// can be imported from iOS fitness or will be created in watch app 
import Foundation
import HealthKit

// swim class; contains all info on a swim workout
class Swim: Identifiable, Codable 
{
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let totalDistance: Double?
    let totalEnergyBurned: Double?
    var poolLength: Double?
    var laps: [Lap]

    // coding keys
    enum CodingKeys: String, CodingKey
    {
        case id, date, duration, totalDistance, totalEnergyBurned, poolLength, laps
    }

    // init
    init(id: UUID, date: Date, duration: TimeInterval, totalDistance: Double?, totalEnergyBurned: Double?, poolLength: Double?, laps: [Lap] = [])
    {
        self.id = id
        self.date = date
        self.duration = duration
        self.totalDistance = totalDistance
        self.totalEnergyBurned = totalEnergyBurned
        self.poolLength = poolLength
        self.laps = laps
    }
    
    // decoding from swim
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        totalDistance = try container.decodeIfPresent(Double.self, forKey: .totalDistance)
        totalEnergyBurned = try container.decodeIfPresent(Double.self, forKey: .totalEnergyBurned)
        poolLength = try container.decodeIfPresent(Double.self, forKey: .poolLength)
        laps = try container.decodeIfPresent([Lap].self, forKey: .laps) ?? []
        let timestamp = try container.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestamp)
    }

    // encoding to json
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(totalDistance, forKey: .totalDistance)
        try container.encodeIfPresent(totalEnergyBurned, forKey: .totalEnergyBurned)
        try container.encodeIfPresent(poolLength, forKey: .poolLength)
        try container.encode(laps, forKey: .laps)
        try container.encode(date.timeIntervalSince1970, forKey: .date)

    }
}

// elements of a lap
struct Lap: Codable, Hashable
{
    let duration: TimeInterval
    let strokeStyle: StrokeStyle?
    let swolfScore: Double?

    init(duration: TimeInterval, metadata: [String: Any]) 
    {
        self.duration = duration
        self.strokeStyle = StrokeStyle(rawValue: metadata["HKSwimmingStrokeStyle"] as? Int ?? 0)
        self.swolfScore = metadata["HKSWOLFScore"] as? Double
    }
}


// enum StrokeStyle
enum StrokeStyle: Int, Codable
{
    case unknown = 0
    case mixed = 1
    case freestyle = 2
    case backstroke = 3
    case breaststroke = 4
    case butterfly = 5
    case kickboard = 6

    var description: String {
        switch self {
        case .unknown: return "Unknown"
        case .mixed: return "Mixed"
        case .freestyle: return "Freestyle"
        case .backstroke: return "Backstroke"
        case .breaststroke: return "Breaststroke"
        case .butterfly: return "Butterfly"
        case .kickboard: return "Kickboard"
        }
    }
}
