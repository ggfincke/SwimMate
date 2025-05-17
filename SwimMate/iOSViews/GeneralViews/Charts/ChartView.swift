// SwimMate/iOSViews/GeneralViews/Charts/ChartView.swift

import SwiftUI
import Charts

struct ChartView: View 
{
    @EnvironmentObject var manager: Manager
    @State private var selectedRange: DataRange = .lastTen

    var filteredData: [Swim] 
    {
        switch selectedRange 
        {
        case .lastTen:
            return Array(manager.swims.sorted(by: { $0.date > $1.date }).prefix(10)).filter { $0.totalDistance ?? 0 >= 100 }
        case .lastWeek:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            return manager.swims.filter { $0.date >= oneWeekAgo && ($0.totalDistance ?? 0) >= 100 }.sorted(by: { $0.date > $1.date })
        }
    }


    var body: some View
    {
        VStack
        {
            Picker("Select Range", selection: $selectedRange)
            {
                ForEach(DataRange.allCases, id: \.self) { range in
                    Text(range.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Chart(filteredData)
            { swim in
                if let totalDistance = swim.totalDistance 
                {
                    BarMark(
                        x: .value("Date", swim.date, unit: .day),
                        y: .value("Distance (meters)", totalDistance)
                    )
                    .foregroundStyle(by: .value("Distance", totalDistance))
                }
            }
            .chartYAxis
              {
                  AxisMarks(position: .leading, values: .automatic(desiredCount: 5)) {
                      AxisGridLine()
                      AxisValueLabel()
                  }
              }

              .chartXAxis {
                  AxisMarks(values: .automatic) {
                      AxisGridLine()
                      AxisTick()
                      AxisValueLabel(format: .dateTime.day().month(), centered: true)
                  }
              }
        }
    }

    enum DataRange: String, CaseIterable 
    {
        case lastTen = "Last 10 Workouts"
        case lastWeek = "Last Week"
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = Manager()
        // Add some sample data
        ChartView()
            .environmentObject(manager)
    }
}
