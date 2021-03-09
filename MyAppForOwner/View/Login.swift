//
//  Login.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import SwiftUI

struct Login: View {
    
    @StateObject var accountCreation = LoginViewModel()

    var body: some View {
        
        ZStack {
                        
            VStack {
                Color.black
                Color("loginBackground")
            }
            VStack {
                
                LottieView(filename: "login")
                    
                VStack {
                    VStack {
                        Text("手機驗證")
                            .fontWeight(.heavy)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                        
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("請輸入您的手機號碼")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            
                            Text("+ \(accountCreation.getCountryCode()) \(accountCreation.phNumber)")
                                .foregroundColor(Color.black)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer(minLength: 0)
                        
                        NavigationLink(destination: Verification(accountCreation: accountCreation), isActive: $accountCreation.goToVerify) {
                            Text("")
                                .hidden()
                        }
                        
                        Button(action: accountCreation.sendCode, label: {
                            Text("取得驗證碼")
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(accountCreation.phNumber == "" ? Color.blue.opacity(0.5): Color.blue)
                            .cornerRadius(15)
                        })
                        .disabled(accountCreation.phNumber == "" ? true: false)
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.white)
                    .cornerRadius(20)
                    
                }
                .frame(width: UIScreen.main.bounds.width * 8 / 9)
                
                CustomNumberPad(value: $accountCreation.phNumber, isVerify: false)
                    .frame(height: UIScreen.main.bounds.height / 2.5)
                
            }
            .padding(.vertical, 25)
            .alert(isPresented: $accountCreation.error, content: {
                Alert(title: Text("訊息"), message: Text(accountCreation.errorMsg), dismissButton: .default(Text("確定")))
            })
            
            if accountCreation.loading { LoadingScreen() }

        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
