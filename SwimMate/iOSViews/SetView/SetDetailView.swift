// SwimMate/iOSViews/SetView/SetDetailView.swift

import SwiftUI

import SwiftUI

struct SetDetailView: View 
{
    let swimSet: SwimSet
    @EnvironmentObject var watchConnector: WatchConnector
    
    var body: some View 
    {
        
        VStack
        {
            List
            {
                Text(swimSet.title).font(.headline)
                
                // basic info
                Section(header: Text("Overview")) {
                    Text("Stroke: \(swimSet.primaryStroke.rawValue)")
                    Text("Total Distance: \(swimSet.totalDistance) \(swimSet.measureUnit.rawValue)")
                    Text("Difficulty: \(swimSet.difficulty.rawValue)")
                }
                
                // desc
                Section(header: Text("Description")) {
                    Text(swimSet.description)
                        .fixedSize(horizontal: false, vertical: true)
                    // ensure  text does not get truncated
                }
                
                // the actual set
                Section(header: Text("Set:")) {
                    ForEach(swimSet.details, id: \.self) { detail in
                        Text(detail)
                    }
                }
            }
            .navigationTitle("\(swimSet.primaryStroke.rawValue) Set")

            Button(action: {
                watchConnector.sendSwimSet(swimSet: swimSet)
            })
            {
                HStack 
                {
                    Image(systemName: "paperplane.fill")
                    Text("Send to Watch")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
    }
}

// Preview of the SetDetailView
struct SetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSet = SwimSet(
            title: "Sample",
            primaryStroke: .freestyle,
            totalDistance: 2000,
            measureUnit: .meters,
            difficulty: .intermediate,
            description: "A challenging set designed to improve endurance and pace.",
            details: ["800 warmup mix", "10x100 on 1:30, descend 1-5, 6-10", "10x50 kick on 1:00", "500 cool down easy"]
        )
        SetDetailView(swimSet: sampleSet)
    }
}


//#Preview
//{
//    let sSet = SwimSet(primaryStroke: .freestyle, totalDistance: 200, measureUnit: .meters, details: ["8x25s Freestyle on 30 seconds", "2x25s easy"])
//
//    SetDetailView(swimSet: sSet)
//}
