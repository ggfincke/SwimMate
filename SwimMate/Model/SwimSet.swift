// SwimMate/Model/SwimSet.swift

// struct for an individual set to send to WatchOS
import Foundation

struct SwimSet: Identifiable, Hashable
{
    var id: UUID = UUID()
    var title: String
    var primaryStroke: Stroke
    var totalDistance: Int
    var measureUnit: MeasureUnit
    var difficulty: Difficulty
    var description: String
    var details: [String]
    
    enum Stroke: String, CaseIterable, Codable
    {
        case freestyle = "Freestyle"
        case breaststroke = "Breaststroke"
        case backstroke = "Backstroke"
        case butterfly = "Butterfly"
        // Individual Medley
        case IM = "IM"
    }
    
    // different measuring units
    enum MeasureUnit: String, CaseIterable, Codable
    {
        case yards = "Yards"
        case meters = "Meters"
    }
    
    // different difficulties
    enum Difficulty: String, CaseIterable
    {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
}

