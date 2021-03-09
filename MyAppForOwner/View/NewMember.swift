//
//  NewMember.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/9.
//

import SwiftUI
import CoreLocation

struct NewMember: View {
    
    @ObservedObject var accountCreation: LoginViewModel
    @AppStorage("newMemberPage") var page = 1
    @AppStorage("newMember") var newMember = false
    
    var body: some View {
        
        ZStack {
            
            if page == 1 {
                NewMemberDetail(accountCreation: accountCreation)
            }
            if page == 2 {
                ImageRegister(accountCreation: accountCreation)
            }
        }
    }
}

struct NewMemberDetail: View {
    
    @ObservedObject var accountCreation: LoginViewModel
    @State var manager = CLLocationManager()
    @AppStorage("newMemberPage") var page = 1

    var body: some View {
        
        VStack {
            
            Text("關於換宿地點(必填)")
                .font(.largeTitle)
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 35)
            
            HStack(spacing: 15) {
                
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                
                TextField("地點/店家名稱", text: $accountCreation.name)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            
            HStack(spacing: 15) {
                
                HStack(spacing: 15) {
                    
                    TextField("詳細地址", text: $accountCreation.location)
                    
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
                .padding(.top)
                
            }
            
            TextEditor(text: $accountCreation.about)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .frame(height: 200)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding(.vertical)
            
            Button(action: { page = 2 }, label: {
                
                HStack {
                    
                    Spacer(minLength: 0)
                    Text("下一步")
                    Spacer(minLength: 0)

                    Image(systemName: "arrow.right")
                    
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(8)
            })
            .opacity((accountCreation.name != "" && accountCreation.about != "" && accountCreation.location != "") ? 1 : 0.6)
            .disabled((accountCreation.name != "" && accountCreation.about != "" && accountCreation.location != "") ? false : true)

        }
        .padding(.horizontal)
        .onAppear(perform: {
            manager.delegate = accountCreation
        })
    }
}
