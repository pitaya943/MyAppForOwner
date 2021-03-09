//
//  ImageRegister.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/7.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageRegister: View {
    
    @ObservedObject var accountCreation: LoginViewModel
    @State var currentImage = 0
    
    var body: some View {
        
        ZStack {
        
            VStack {
                
                HStack {
                    
                    Text("地點相關照片")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if check() {
                        Button(action: accountCreation.imageSignUp, label: {
                            Text("完成")
                                .fontWeight(.heavy)
                                .foregroundColor(.blue)
                        })
                    }
                }
                .padding(.top, 30)
                
                GeometryReader { reader in
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15, content: {
                        
                        ForEach(accountCreation.images.indices, id: \.self) { index in
                            
                            ZStack {
                                
                                if accountCreation.images[index].count == 0 {
                                    
                                    Image(systemName: "person.badge.plus")
                                        .font(.system(size: 45))
                                        .foregroundColor(.blue)
                                }
                                else {
                                    
    //                                AnimatedImage(url: URL(string: accountCreation.images[index])!)
    //                                    .resizable()
                                    Image(uiImage: UIImage(data: accountCreation.images[index])!)
                                        .resizable()
                                        
                                }
                            }
                            .frame(width: (reader.frame(in: .global).width - 15) / 2, height: (reader.frame(in: .global).height - 20) / 3)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                            .onTapGesture {
                                
                                currentImage = index
                                accountCreation.picker.toggle()
                            }
                            
                        }
                    })
                    
                }
                .padding(.top)
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
            .sheet(isPresented: $accountCreation.picker) {
                
                ImagePicker(show: $accountCreation.picker, ImageData: $accountCreation.images[currentImage])
            }
            
            if accountCreation.loading { LoadingScreen() }
        }
    }
    
    func check() -> Bool {
        
        for data in accountCreation.images {
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
