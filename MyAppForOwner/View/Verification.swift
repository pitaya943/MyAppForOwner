//
//  Verification.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/9.
//
import SwiftUI

struct Verification: View {
    
    @ObservedObject var accountCreation: LoginViewModel
    @Environment(\.presentationMode) var present
    
    var body: some View {
        
        ZStack {
            VStack {
                Color.white
                Color("loginBackground")
            }.ignoresSafeArea(.all, edges: .all)
            
            VStack {
                VStack {
                    HStack {
                        Button (action: { present.wrappedValue.dismiss() }, label: {
                            
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text("手機驗證")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Spacer()
                        })
                    }
                    
                    Text("驗證碼傳送至 \(accountCreation.phNumber)")
                        .foregroundColor(.gray)
                        .padding()
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 15) {
                        
                        ForEach(0..<6, id: \.self) { index in
                            // Displaying code
                            
                            CodeView(code: getCodeAtIndex(index: index))
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 6) {
                        
                        Text("沒有收到訊息？")
                            .foregroundColor(.gray)
                        
                        Button(action: accountCreation.requestCode, label: {
                            Text("重新傳送")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        })
                    }
                    
                    NavigationLink(destination: NewMember(accountCreation: accountCreation), isActive: $accountCreation.newMember) {
                        Text("")
                            .hidden()
                    }
                    
                    Button(action: accountCreation.verifyCode, label: {
                        Text("驗證後登入")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .background(Color.blue)
                            .cornerRadius(15)
                    })
                    
                }
                .padding()
                .background(Color.white)
                
                CustomNumberPad(value: $accountCreation.code, isVerify: true)
                    .frame(height: UIScreen.main.bounds.height / 2.5)
            }
            .alert(isPresented: $accountCreation.error, content: {
                Alert(title: Text("訊息"), message: Text(accountCreation.errorMsg), dismissButton: .default(Text("確定")))
            })
            
            if accountCreation.loading { LoadingScreen() }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
    
    // Getting Code at each index
    func getCodeAtIndex(index: Int) -> String {
        
        if accountCreation.code.count > index {
            
            let start = accountCreation.code.startIndex
            let current = accountCreation.code.index(start, offsetBy: index)
            
            return String(accountCreation.code[current])
        }
        
        return ""
    }
}

struct CodeView: View {
    
    var code: String
    var body: some View {
        VStack(spacing: 10) {
            Text(code)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .font(.title2)
                .frame(height: 45)
            
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 4)
        }
    }
}
