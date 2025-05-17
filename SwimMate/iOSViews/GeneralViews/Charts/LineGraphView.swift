// SwimMate/iOSViews/GeneralViews/Charts/LineGraphView.swift

import SwiftUI
import Charts

struct LineGraphView: View 
{
    @EnvironmentObject var manager: Manager // Assumes Manager holds an array of Swim instances
    @State private var selectedRange: DataRange = .lastTen  // Default selection

    var filteredData: [Swim] 
    {
        switch selectedRange 
        {
        case .lastTen:
            return Array(manager.swims.sorted(by: { $0.date > $1.date }).prefix(10)).filter { $0.totalDistance ?? 0 >= 100 }
        case .lastWeek:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            return manager.swims.filter { $0.date >= oneWeekAgo && ($0.totalDistance ?? 0) >= 100 }.sorted(by: { $0.date > $1.date })
        case .allTime:
            return manager.aggregateDataByMonth(swims: manager.swims)
        }
    }


    var body: some View
    {
        VStack
        {
            Text("Overall Distance")
                .font(.title2)
                .padding(.bottom, 5)
            Picker("Select Range", selection: $selectedRange)
            {
                ForEach(DataRange.allCases, id: \.self) 
                { range in
                    Text(range.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Chart(filteredData) { swim in
                LineMark(
                    x: .value("Date", swim.date),
                    y: .value("Distance (meters)", swim.totalDistance ?? 0)
                )
                .interpolationMethod(.catmullRom) // Smooths the line
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.day().month().year(), centered: true)
                }
            }
        }
    }

    enum DataRange: String, CaseIterable {
        case lastTen = "Last 10"
        case lastWeek = "Last Week"
        case allTime = "All Time"
    }
}


// Preview
//struct LineGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        let manager = Manager()
//        // Add sample data to the manager for preview purposes
//        (1...15).forEach { i in
//            manager.swims.append(Swim(id: UUID(), date: Date().addingTimeInterval(-86400.0 * Double(i)), duration: 3000, totalDistance: Double(1000 + 50 * i), totalEnergyBurned: 400.0, poolLength: 50))
//        }
//
//        LineGraphView()
//            .environmentObject(manager)
//    }
//}

