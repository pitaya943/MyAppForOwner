//
//  TabView_schedule.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/9.
//

import SwiftUI
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct TabView_schedule: View {
    
    @AppStorage("user") var user = ""
    @AppStorage("uid") var uid = ""
    @AppStorage("phone") var phone = ""
    @AppStorage("newMember") var newMember = false
    @AppStorage("newMemberPage") var page = 1
    @AppStorage("log_Status") var status = false
    @AppStorage("pic") var pic = ""
    
    let array = UserDefaults.standard.object(forKey:"pic") as? [String] ?? [String]()
    
    var body: some View {
        
        ScrollView {
        
            VStack(spacing: 15) {
             
                Text("Hello \(user)!")
                Text("newMember = \(String(newMember))")
                Text("newMemberPage = \(String(page))")
                Text("log_Status = \(String(status))")
                Text("uid = \(uid)")
                Text("phone = \(phone)")
                
                ForEach(array, id:\.self) { index in
                    AnimatedImage(url: URL(string: index)!)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                        .clipShape(Circle())
                }
            }
        }
        
    }
}

struct TabView_schedule_Previews: PreviewProvider {
    static var previews: some View {
        TabView_schedule()
    }
}
