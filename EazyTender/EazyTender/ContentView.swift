//
//  ContentView.swift
//  EazyTender
//
//  Created by Kumar Sharma on 26/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SalesRefundPayoutView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Tender")
                }
            
            ReportsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Reports")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }.background(Color(hex: 0x025464))
    }
}
