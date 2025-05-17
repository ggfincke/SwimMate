// SwimMate/ViewModel/WatchConnector.swift

// used for sending sets to the watchOS component
import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject
{
    var session: WCSession
    init(session: WCSession = .default)
    {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    // send a set to watchOS companion 
    func sendSwimSet(swimSet: SwimSet)
    {
        if WCSession.isSupported() && session.isReachable
        {
            let swimSetData: [String: Any] = [
                "title": swimSet.title,
                "stroke": swimSet.primaryStroke.rawValue,
                "totalDistance": swimSet.totalDistance,
                "measureUnit": swimSet.measureUnit.rawValue,
                "difficulty": swimSet.difficulty.rawValue,
                "description": swimSet.description,
                "details": swimSet.details
            ]
            session.sendMessage(swimSetData, replyHandler: nil)
            { 
                error in
                print("Failed to send swim set: \(error.localizedDescription)")
            }
            print("Worked?")
        }
        else
        {
            print("Tried")
        }
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

    func sessionDidBecomeInactive(_ session: WCSession) 
    {
        // handle session becoming inactive
        print("WC Session did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) 
    {
        // handle session deactivation (reactivate the session after it’s been deactivated)
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        print("received")
    }

}
