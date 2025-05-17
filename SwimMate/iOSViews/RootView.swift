// SwimMate/iOSViews/RootView.swift

import SwiftUI

// rootView for the project
struct RootView: View
{
    @EnvironmentObject var manager : Manager
    @EnvironmentObject var watchOSManager : WatchConnector

    @State private var selectedTab = 0

    var body: some View
    {
        // different tab views
        TabView(selection: $selectedTab)
        {
            HomePage()
                .tabItem 
            {
                Label("Home", systemImage: "house")
            }
            
            SetPage()
                .environmentObject(manager)
                .environmentObject(watchOSManager)
                .tabItem
            {
                Label("Sets", systemImage: "list.dash")
            }
            
            ProfilePage()
                .tabItem 
            {
                Label("Profile", systemImage: "person.crop.circle")
            }
            
        }
    }
}

#Preview {
    RootView()
        .environmentObject(Manager())
}
