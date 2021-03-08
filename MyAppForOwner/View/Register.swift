//
//  Register.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import SwiftUI
import CoreLocation

struct Register: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var manager = CLLocationManager()
    
    var body: some View {
        
        VStack {
            
            Text("註冊帳號")
                .font(.largeTitle)
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 35)
            
            HStack(spacing: 15) {
                
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                
                TextField("名字", text: $loginViewModel.name)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            
            HStack(spacing: 15) {
                
                HStack(spacing: 15) {
                    
                    TextField("位置", text: $loginViewModel.location)
                    
                    Button(action: { manager.requestWhenInUseAuthorization() }, label: {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                    })
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                

                TextField("年紀", text: $loginViewModel.age)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .frame(width: 80)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .padding(.vertical)
            }
            
            TextEditor(text:  $loginViewModel.bio)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding(.vertical)
            
            Button(action: { loginViewModel.pageNumber = 2 }, label: {
                
                HStack {
                    
                    Spacer(minLength: 0)
                    Text("註冊")
                    Spacer(minLength: 0)

                    Image(systemName: "arrow.right")
                    
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(8)
            })
            .opacity((loginViewModel.name != "" && loginViewModel.age != "" && loginViewModel.bio != "" && loginViewModel.location != "") ? 1 : 0.6)
            .disabled((loginViewModel.name != "" && loginViewModel.age != "" && loginViewModel.bio != "" && loginViewModel.location != "") ? false : true)
            
        }
        .padding(.horizontal)
        .onAppear(perform: {
            manager.delegate = loginViewModel
        })
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
