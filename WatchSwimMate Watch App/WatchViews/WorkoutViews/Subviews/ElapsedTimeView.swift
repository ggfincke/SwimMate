// WatchSwimMate Watch App/WatchViews/WorkoutViews/Subviews/ElapsedTimeView.swift

import SwiftUI

struct ElapsedTimeView: View 
{
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View
    {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: elapsedTime) 
            {
                timeFormatter.showSubseconds = elapsedTime < 3600
            }
    }
}


// adjusted to show hour field after swimming for an hour & hide subseconds (same behavior as standard workout app)
class ElapsedTimeFormatter: Formatter
{
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true

    override func string(for value: Any?) -> String? 
    {
        guard let time = value as? TimeInterval else
        {
            return nil
        }

        // update allowedUnits based on elapsed time
        if time >= 3600
        {
            componentsFormatter.allowedUnits = [.hour, .minute, .second]
            showSubseconds = false
        } 
        else
        {
            componentsFormatter.allowedUnits = [.minute, .second]
            showSubseconds = true
        }

        guard let formattedString = componentsFormatter.string(from: time) else 
        {
            return nil
        }

        if showSubseconds 
        {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }

        return formattedString
    }
}


