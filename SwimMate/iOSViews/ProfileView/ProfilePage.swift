// SwimMate/iOSViews/ProfileView/ProfilePage.swift

import SwiftUI


struct ProfilePage: View 
{
    @EnvironmentObject var manager: Manager

    var body: some View 
    {
        NavigationStack 
        {
            ScrollView
            {
                VStack(alignment: .leading, spacing: 20)
                {
                    profileHeader
                    statisticsSection
                    graphSection
                }
                .padding()
            }

        }
    }

    var profileHeader: some View 
    {
        VStack(alignment: .leading, spacing: 10) 
        {
            HStack
            {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()

                NavigationLink(destination: SettingsView()) 
                {
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
            }

            Text(manager.userName)
                .font(.title2)
                .padding(.top, 5)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    var statisticsSection: some View 
    {
        VStack(alignment: .center, spacing: 10)
        {
            Text("Swimming Stats")
                .font(.headline)
                .padding(.bottom, 5)
            
            statisticRow(label: "Average Distance:", value: manager.formatDistance(manager.averageDistance))
            statisticRow(label: "Average Calories Burned:", value: "\(Int(manager.averageCalories)) kcal")
            statisticRow(label: "Total Distance:", value: manager.formatDistance(manager.totalDistance))
            statisticRow(label: "Total Calories Burned:", value: "\(Int(manager.totalCalories)) kcal")
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }

    var graphSection: some View 
    {
        VStack(alignment: .center, spacing: 10)
        {
            PaceGraphView()
            LineGraphView()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }

    func statisticRow(label: String, value: String) -> some View 
    {
        HStack
        {
            Text(label)
                .bold()
            Spacer()
            Text(value)
        }
    }
}
struct ProfilePage_Previews: PreviewProvider
{
    static var previews: some View 
    {
        ProfilePage().environmentObject(Manager())
    }
}
