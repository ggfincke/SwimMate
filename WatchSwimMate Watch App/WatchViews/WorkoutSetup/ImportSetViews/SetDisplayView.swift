// WatchSwimMate Watch App/WatchViews/WorkoutSetup/ImportSetViews/SetDisplayView.swift

import SwiftUI

struct SetDisplayView: View 
{
    var swimSet: SwimSet
    @State private var currentIndex = 0

    var body: some View 
    {
        VStack
        {
            Text(swimSet.title)
                .font(.headline)
            
            if swimSet.details.indices.contains(currentIndex) 
            {
                Text(swimSet.details[currentIndex])
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
            } 
            else
            {
                Text("Complete!")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Spacer()
            HStack
            {
                Button(action: {
                    if currentIndex > 0
                    {
                        currentIndex -= 1
                    }
                }) 
                {
                    Image(systemName: "arrow.left")
                }
                .clipShape(Circle())
                .disabled(currentIndex <= 0)

                Button(action: {
                    if currentIndex < swimSet.details.count - 1 {
                        currentIndex += 1
                    }
                }) 
                {
                    Image(systemName: "arrow.right")
                }
                .clipShape(Circle())
                .disabled(currentIndex >= swimSet.details.count - 1)
            }
            .padding()
        }
    }
}


struct SetDisplayView_Previews: PreviewProvider {
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
        SetDisplayView(swimSet: sampleSet)
    }
}
