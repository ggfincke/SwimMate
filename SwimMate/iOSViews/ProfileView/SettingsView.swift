// SwimMate/iOSViews/ProfileView/SettingsView.swift

import SwiftUI

struct SettingsView: View 
{
    var body: some View 
    {
        List
        {
            Section(header: Text("General"))
            {
                NavigationLink("Preferences", destination: PreferencesView())
                NavigationLink("HealthKit Permissions", destination: HealthKitPermissionView())

            }
        }
        .navigationTitle("Settings")
        .listStyle(GroupedListStyle())

    }
}

struct SettingsView_Previews: PreviewProvider 
{
    static var previews: some View 
    {
        SettingsView()
    }
}


#Preview {
    SettingsView()
}
