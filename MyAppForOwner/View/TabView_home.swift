//
//  TabView_home.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/9.
//

import SwiftUI

struct TabView_home: View {
    
    var body: some View {
        
        outButton()
    }
}

struct outButton: View {
    
    @AppStorage("log_Status") var status = false
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        
        Button(action: {
                status.toggle()
                viewRouter.currentPage = .page2
                resetUserdefault()
                print("User logout!") }, label: {
            Text("登出")
                .foregroundColor(.red)
        })
    }
    
    func resetUserdefault() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print("Userdefault clear")
    }
    
}

struct TabView_home_Previews: PreviewProvider {
    static var previews: some View {
        TabView_home()
    }
}
