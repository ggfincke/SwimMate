// WatchSwimMate Watch App/WatchViews/WorkoutSetup/UnitPickerView.swift

import SwiftUI

struct UnitPickerView: View 
{
    @EnvironmentObject var manager: WatchManager

    var body: some View
    {
        VStack 
        {
            Button("Meters")
            {
                manager.poolUnit = "meters"
            }


            Button("Yards") 
            {
                manager.poolUnit  = "yards"
            }

        }
    }
}
