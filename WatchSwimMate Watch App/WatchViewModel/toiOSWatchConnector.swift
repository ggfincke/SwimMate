// WatchSwimMate Watch App/WatchViewModel/toiOSWatchConnector.swift

import Foundation
import WatchConnectivity
class iOSWatchConnector: NSObject, WCSessionDelegate, ObservableObject
{
    var session: WCSession
    @Published var receivedSets: [SwimSet] = []  // store received sets

    init(session: WCSession = .default)
    {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    // MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    {
        if let error = error
        {
            print("WC Session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: \(activationState)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        // handle incoming message data, assuming data keys match those sent by iOS
        if let title = message["title"] as? String,
           let strokeRaw = message["stroke"] as? String,
           let totalDistance = message["totalDistance"] as? Int,
           let measureUnitRaw = message["measureUnit"] as? String,
           let difficultyRaw = message["difficulty"] as? String,
           let description = message["description"] as? String,
           let details = message["details"] as? [String] {
            
            let primaryStroke = SwimSet.Stroke(rawValue: strokeRaw) ?? .freestyle
            let measureUnit = SwimSet.MeasureUnit(rawValue: measureUnitRaw) ?? .meters
            let difficulty = SwimSet.Difficulty(rawValue: difficultyRaw) ?? .intermediate
            
            let newSet = SwimSet(title: title, primaryStroke: primaryStroke, totalDistance: totalDistance, measureUnit: measureUnit, difficulty: difficulty, description: description, details: details)
            DispatchQueue.main.async {
                self.receivedSets.append(newSet)
            }
        }
    }
    
    //TODO: will need to add a func for sending data back to watch
    // should the swim struct store a corresponding set if completed in the watchOS app?
}
