// SwimMate/iOSViews/GeneralViews/WeekView.swift

import SwiftUI

struct WeekView: View
{
    @EnvironmentObject var manager: Manager

    var body: some View 
    {
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let weeklySwims = manager.swims.filter { $0.date >= lastWeekDate }
        let totalWorkouts = weeklySwims.count
        let totalTime = weeklySwims.reduce(0) { $0 + Int($1.duration / 60) } // assuming duration is in seconds
        let totalDistance = weeklySwims.compactMap { $0.totalDistance }.reduce(0, +)

        VStack 
        {
            Text("Weekly Summary")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10)
            {
                HStack
                {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.red)
                    Text("Workouts: \(totalWorkouts)")
                }

                HStack 
                {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                    Text("Total Time: \(totalTime) mins")
                }

                HStack 
                {
                    Image(systemName: "water.waves")
                        .foregroundColor(.blue)
                    Text("Distance: " +  manager.formatDistance(totalDistance))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .padding()
    }
}

// Preview
struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
            .environmentObject(Manager()) // Ensure Manager is populated with sample data for realistic preview
    }
}


//#Preview 
//{
//    WeekView()
//}
