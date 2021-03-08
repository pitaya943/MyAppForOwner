//
//  ImageRegister.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/7.
//

import SwiftUI

struct ImageRegister: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var currentImage = 0
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text("關於換宿地點")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer()
                
                if check() {
                    Button(action: loginViewModel.signUp, label: {
                        Text("註冊")
                            .fontWeight(.heavy)
                            .foregroundColor(.blue)
                    })
                }
            }
            .padding(.top, 30)
            
            GeometryReader { reader in
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20, content: {
                    
                    ForEach(loginViewModel.images.indices, id: \.self) { index in
                        
                        ZStack {
                            
                            if loginViewModel.images[index].count == 0 {
                                
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 45))
                                    .foregroundColor(.blue)
                            }
                            else {
                                
                                Image(uiImage: UIImage(data: loginViewModel.images[index])!)
                                    .resizable()
                            }
                        }
                        .frame(width: (reader.frame(in: .global).width - 15) / 2, height: (reader.frame(in: .global).height - 20) / 2)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                        .onTapGesture {
                            
                            currentImage = index
                            loginViewModel.picker.toggle()
                        }
                        
                    }
                })
            }
            .padding(.top)
            .padding(.bottom, 30)
        }
        .padding(.horizontal)
        .sheet(isPresented: $loginViewModel.picker) {
            
            ImagePicker(show: $loginViewModel.picker, ImageData: $loginViewModel.images[currentImage])
        }
    }
    
    func check() -> Bool {
        
        for data in loginViewModel.images {
            if data.count == 0 {
                return false
            }
            
        }
        return true
    }
    
}

struct ImageRegister_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
