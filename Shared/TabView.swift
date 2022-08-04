//
//  TabView.swift
//  webview
//
//  Created by boncor chen on 2022/7/9.
//

import SwiftUI

struct tabView: View {
@State var selectedTab = "One"
    @State var label: LocalizedStringKey = "label2"
    @State var lable1: LocalizedStringKey = "label3"
    var body: some View {

        TabView(selection: $selectedTab) {
                ContentView()
                .tabItem {Label(label, systemImage: "house.fill")
                }
                .tag("One")
                CustomView()
                    .tabItem {Label(lable1, systemImage: "person.fill")
                    }.tag("Two")
            }

    }
}

struct tabView_Previews: PreviewProvider {
    static var previews: some View {
        tabView()
    }
}

