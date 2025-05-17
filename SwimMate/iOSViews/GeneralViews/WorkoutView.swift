// SwimMate/iOSViews/GeneralViews/WorkoutView.swift

import SwiftUI
import HealthKit

// TODO: Add graphs for laps
// TODO: Figure out how to display lap info in a way that makes sense
struct WorkoutView: View
{
    @EnvironmentObject var manager: Manager
    var swim: Swim

    var body: some View 
    {
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20) 
            {
                Text("Swim Details")
                    .font(.largeTitle)
                    .padding(.leading)
                
                Group {
                    Text("Date: \(swim.date, formatter: itemFormatter)")
                        .bold()
                    Text("Duration: \(swim.duration / 60, specifier: "%.0f") minutes")
                    distanceText
                    caloriesText
                    poolLengthText
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                Spacer()
            }
            
            // laps (temporary, eventually replace with charts, or a navView to all the info) 
            VStack(alignment: .center, spacing: 10)
            {
                Text("Laps Details")
                    .font(.headline)
                    .padding(.leading)
                ForEach(swim.laps, id: \.self)
                { lap in
                    VStack(alignment: .leading)
                    {
                        Text("Duration: \(lap.duration, specifier: "%.2f") seconds")
                        Text("Stroke Style: \(lap.strokeStyle?.description ?? "Unknown")")
                        if let swolfScore = lap.swolfScore 
                        {
                            Text("SWOLF Score: \(swolfScore)")
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    var distanceText: some View
    {
        if let distance = swim.totalDistance 
        {
            return Text("Total Distance: \(distance, specifier: "%.0f") meters")
        } 
        else
        {
            return Text("Distance data not available")
        }
    }

    var caloriesText: some View
    {
        if let calories = swim.totalEnergyBurned 
        {
            return Text("Calories Burned: \(calories, specifier: "%.0f") kcal")
        } 
        else
        {
            return Text("Calorie data not available")
        }
    }

    var poolLengthText: some View 
    {
        if let poolLength = swim.poolLength 
        {
            return Text("Pool Length: \(formatPoolLength(poolLength))")
        } 
        else
        {
            return Text("Pool Length: Data not available")
        }
    }

    private func formatPoolLength(_ length: Double) -> String
    {
        let unit = manager.preferredUnit
        if unit == .yards 
        {
            // conversion from meters to yards
            let lengthInYards = length * 1.09361
            return String(format: "%.1f yd", lengthInYards)
        } 
        else
        {
            return String(format: "%.1f m", length)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct WorkoutView_Previews: PreviewProvider 
{
    static var previews: some View
    {
        let sampleLaps = [
             Lap(duration: 45, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 30.5]),
             Lap(duration: 30, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 28.0]),
             Lap(duration: 50, metadata: ["HKSwimmingStrokeStyle": 4, "HKSWOLFScore": 35.0])
         ]
         let sampleSwim = Swim(
             id: UUID(),
             date: Date(),
             duration: 3600,
             totalDistance: 1500,
             totalEnergyBurned: 500,
             poolLength: 25.0,
             laps: sampleLaps
         )
         return WorkoutView(swim: sampleSwim)
             .environmentObject(Manager())
    }
}
