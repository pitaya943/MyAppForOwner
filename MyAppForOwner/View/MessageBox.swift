//
//  MessageBox.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/9.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct MessageBox: View {
    
    @EnvironmentObject var datas: ChatObservable
    @State var chat = false
    @State var id = ""
    @State var name = ""
    @State var pic = ""
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
                
                NavigationLink(destination: ChatView(name: self.name, pic: self.pic, uid: self.id, chat: self.$chat).transition(.scale), isActive: self.$chat) { Text("") }
                
                VStack{
                    if self.datas.recents.count == 0 {
                        
                        if self.datas.norecetns {
                            Text("沒有聊天記錄")
                        }
                        else { Indicator() }
                    }
                    else {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            VStack(spacing: 12) {
                                
                                ForEach(datas.recents.sorted(by: {$0.stamp > $1.stamp})) { i in
                                    
                                    Button(action: {
                                            self.id = i.id
                                            self.name = i.name
                                            self.pic = i.pic
                                            self.chat.toggle()
                                        
                                    }) {
                                        RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationBarTitle("訊息箱", displayMode: .inline)
            }
        }
    }
}

struct RecentCellView : View {
    
    var url : String
    var name : String
    var time : String
    var date : String
    var lastmsg : String
    
    var body : some View {
        
        HStack {
            
            AnimatedImage(url: URL(string: url)!)
                .resizable()
                .renderingMode(.original)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(name).foregroundColor(.primary)
                        Text(lastmsg).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 6) {
                        
                         Text(time).foregroundColor(.gray)
                         Text(date).foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Divider()
            }
        }
    }
}


