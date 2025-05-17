// WatchSwimMate Watch App/WatchViews/WorkoutViews/Subviews/SummaryMetricView.swift

import SwiftUI

struct SummaryMetricView: View 
{
    var title: String
    var value: String

    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                    .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        Divider()
    }
}

#Preview 
{
    SummaryMetricView(title: "Swimming", value: "100")
}
