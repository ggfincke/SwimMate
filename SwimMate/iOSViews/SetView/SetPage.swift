// SwimMate/iOSViews/SetView/SetPage.swift

import SwiftUI

struct SetPage: View
{
    @EnvironmentObject var manager : Manager
    @EnvironmentObject var watchOSManager : WatchConnector

    @State private var selectedStroke = SwimSet.Stroke.freestyle
    @State private var selectedUnit = SwimSet.MeasureUnit.meters
    @State private var selectedDifficulty = SwimSet.Difficulty.intermediate

    var recommendedSets: [SwimSet] {
        manager.sampleSets.filter { $0.primaryStroke == manager.preferredStroke && $0.measureUnit == manager.preferredUnit}
    }
    var filteredSets: [SwimSet] {
        manager.sampleSets.filter { $0.primaryStroke == selectedStroke && $0.measureUnit == selectedUnit && $0.difficulty == selectedDifficulty}
    }

    var body: some View {
        NavigationView 
        {
            VStack
            {
                Text("Recommended Sets:")
                .font(.headline)
                .padding()
            
                List 
                {
                    ForEach(recommendedSets)
                    { set in
                        NavigationLink(destination: SetDetailView(swimSet: set).environmentObject(watchOSManager)) 
                        {
                            VStack(alignment: .leading)
                            {
                                Text(set.title).font(.headline)
                                Text("\(set.totalDistance) \(set.measureUnit.rawValue) - \(set.primaryStroke.rawValue)")
                                Text(set.description).font(.subheadline)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                
                Text("Search:")
                    .font(.headline)
                    .padding(.top)
                HStack
                {
                    VStack
                    {
                        Text("Stroke:")
                            .font(.headline)
                            .padding(.top)
                        Picker("Stroke", selection: $selectedStroke)
                        {
                            ForEach(SwimSet.Stroke.allCases, id: \.self) { stroke in
                                Text(stroke.rawValue).tag(stroke)
                            }
                        }
                        .padding(.bottom)
                        .padding(.leading)
                    }
                    Spacer()
                    VStack 
                    {
                        Text("Difficulty:")
                            .font(.headline)
                            .padding(.top)
                        Picker("Difficulty", selection: $selectedDifficulty) 
                        {
                            ForEach(SwimSet.Difficulty.allCases, id: \.self) { difficulty in
                                Text(difficulty.rawValue).tag(difficulty)
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    Spacer()

                    VStack
                    {
                        Text("Unit:")
                            .font(.headline)
                            .padding(.top)
                        Picker("Unit", selection: $selectedUnit)
                        {
                            ForEach(SwimSet.MeasureUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .padding(.bottom)
                        .padding(.trailing)
                    }
                }
                List
                {
                    ForEach(filteredSets) 
                    { set in
                        NavigationLink(destination: SetDetailView(swimSet: set)) 
                        {
                            SetSummaryView(swimmySet: set)
                        }
                    }
                }
            }
            .navigationTitle("Swim Sets")
        }
    }
}




#Preview 
{
    SetPage()
        .environmentObject(Manager())
        .environmentObject(WatchConnector())
}
