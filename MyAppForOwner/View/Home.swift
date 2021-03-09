//
//  Home.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/9.
//

import SwiftUI

var tabs = ["mainView", "messageBox"]

struct Home: View {
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let rect = proxy.frame(in: .global)
            ScrollableTabBar(tabs: tabs, rect: rect, offset: $offset) {
                
                HStack(spacing: 0) {
                    
                    MainView()
                        .cornerRadius(0)

                    MessageBox()
                        .environmentObject(ChatObservable())
                        .cornerRadius(0)
                    
                }
                .ignoresSafeArea()
            }
        }
        .ignoresSafeArea()
    }
}

enum Tab {
    case home, schedule, notification, profile
}

struct MainView: View {
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            TabView_home()
                .tabItem { Label("首頁", systemImage: selectedTab == Tab.home ? "house.fill" : "house") }
                .tag(Tab.home)
                .navigationBarHidden(true)
            
            TabView_schedule()
                .tabItem { Label("行程", systemImage: selectedTab == Tab.schedule ? "calendar.circle.fill" : "calendar.circle") }
                .tag(Tab.schedule)
                .navigationBarHidden(true)
            
            Text("notification")
                .tabItem { Label("通知", systemImage: selectedTab == Tab.notification ? "bell.fill" : "bell") }
                .tag(Tab.notification)
                .navigationBarHidden(true)
            
            Text("profile")
                .tabItem { Label("個人資料", systemImage: selectedTab == Tab.profile ? "person.crop.circle.fill" : "person.crop.circle") }
                .tag(Tab.profile)
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
