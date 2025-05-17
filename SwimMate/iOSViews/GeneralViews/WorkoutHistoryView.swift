// SwimMate/iOSViews/GeneralViews/WorkoutHistoryView.swift

import SwiftUI

struct WorkoutHistoryView: View 
{
    @EnvironmentObject var manager: Manager
    @State private var selectedSwim: Swim?

    var body: some View 
    {
        VStack
        {

            List(manager.swims, id: \.id)
            { swim in
                Button(action: {
                    selectedSwim = swim
                }) {
                        VStack(alignment: .leading)
                        {
                            Text("Workout on \(swim.date, formatter: dateFormatter)")
                                .foregroundStyle(.black)
                            if let distance = swim.totalDistance, distance > 0 {
                                Text("Total Distance: " + manager.formatDistance(distance))
                                    .foregroundStyle(.black)

                            }
                        }
                    }
                }
            .navigationTitle("Workout History")
            .sheet(item: $selectedSwim) { swim in
                WorkoutView(swim: swim)
            }
        }
    }
}



private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()



