// WatchSwimMate Watch App/WatchViews/WorkoutViews/SwimmingSummaryView.swift

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SwimmingSummaryView: View
{
    @EnvironmentObject var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View
    {
        if manager.workout == nil
        {
            ProgressView("Saving Workout")
//                .navigationBarHidden(true)
        }
        else
        {
            ScrollView 
            {
                VStack(alignment: .leading) 
                {
                    SummaryMetricView(
                        title: "Total Time",
                        value: durationFormatter
                            .string(from: manager.workout?.duration ?? 0.0) ?? ""
                    ).accentColor(Color.yellow)
                    SummaryMetricView(
                        title: "Total Distance",
                        value: Measurement(
                            value: manager.workout?.totalDistance?
                                .doubleValue(for: .meter()) ?? 0,
                            unit: UnitLength.meters
                        ).formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .road
                            )
                        )
                    ).accentColor(Color.green)
                    SummaryMetricView(
                        title: "Total Energy",
                        value: Measurement(
                            value: manager.workout?.totalEnergyBurned?
                                            .doubleValue(for: .kilocalorie()) ?? 0,
                            unit: UnitEnergy.kilocalories
                        ).formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .workout
                            )
                        )
                    ).accentColor(Color.pink)
                    SummaryMetricView(
                        title: "Avg. Heart Rate",
                        value: manager.averageHeartRate
                            .formatted(
                                .number.precision(.fractionLength(0))
                            )
                        + " bpm"
                    ).accentColor(Color.red)

                    Button("Done") 
                    {
                        dismiss()
                    }

                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview 
{
    SwimmingSummaryView()
        .environmentObject(WatchManager())
}

