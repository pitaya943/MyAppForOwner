//
//  LoadingScreen.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/8.
//

import SwiftUI

struct LoadingScreen: View {
    
    var body: some View {
        
        ZStack {
            
            Color.black.opacity(0.2).ignoresSafeArea(.all, edges: .all)
            
            ProgressView()
                .padding(20)
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
