//
//  Login.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        
        VStack {
            
            Text("登入")
                .font(.largeTitle)
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 25)
            
            HStack(spacing: 15) {
                
                Text("+\(loginViewModel.getCountryCode())")
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .frame(width: 80)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                
                TextField("手機號碼", text: $loginViewModel.phNumber)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)

                
                
            }
            .padding(.top)
            
            Button(action: loginViewModel.login, label: {
                
                HStack {
                    
                    Spacer()
                    Text("登入")
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(8)
                
            })
            .padding(.top)
            .opacity((loginViewModel.phNumber != "" ? 1 : 0.6))
            .disabled((loginViewModel.phNumber != "" ? false : true))
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
