//
//  ContentView.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack {
            
            LottieView(filename: "login")
                .frame(height: UIScreen.main.bounds.height / 3.5)
                .padding()
            
            ZStack {
                
                if loginViewModel.pageNumber == 0 {
                    Login()
                }
                else if loginViewModel.pageNumber == 1 {
                    Register()
                        .transition(.move(edge: .trailing))
                }
                else {
                    ImageRegister()
                        .transition(.move(edge: .trailing))
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.clipShape(CustomCorner(corners: [.topLeft, .topRight])).ignoresSafeArea(.all, edges: .bottom))
            
        }
        .background(Color.black.ignoresSafeArea(.all, edges: .all))
        // alert
        .alert(isPresented: $loginViewModel.alert, content: {
            Alert(title: Text("錯誤訊息"), message: Text(loginViewModel.alertMsg), dismissButton: .default(Text("好")))
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
