//
//  MotherView.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import SwiftUI

struct MotherView: View {
    
    //@EnvironmentObject var viewRouter: ViewRouter
    @StateObject var loginViewModel = LoginViewModel()
    @AppStorage("log_Status") var status = false

    var body: some View {
        
        
        NavigationView {
            
            if status {
                
                Text("home")
            }
            else {
                ZStack {
                    
                    ContentView()
                        .environmentObject(loginViewModel)
                    
                    if loginViewModel.isLoading { LoadingScreen() }
                }
            }
        }
        
//        switch viewRouter.currentPage {
//
//        case .page1:
//            ContentView()
//
//        case .page2:
//            ContentView()
//                .environmentObject(loginViewModel)
//
//        case .page3:
//            Login()
//        }
    }
}

struct CoverView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            
            Image("cover")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all, edges: .all)
            
            ZStack {
                Color.white
                    .opacity(0.7)
                    .frame(width: 500, height: 50, alignment: .center)
                Text("Welcome")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
            }
            
        }.onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            if self.timeRemaining == 0 {
                withAnimation { viewRouter.currentPage = .page2 }
            }
        }
    }
}
