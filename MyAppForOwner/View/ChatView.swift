//
//  ChatView.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/9.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseFirestoreSwift

struct Msg : Identifiable, Hashable {
    
    @DocumentID var id: String?
    var msg : String
    var user : String
}

struct ChatView : View {
    
    var name : String
    var pic : String
    var uid : String
    @Binding var chat : Bool
    @State var msgs = [Msg]()
    @State var txt = ""
    @State var nomsgs = false
    @State var scrolled = false
    
    let myPic = UserDefaults.standard.value(forKey: "pic")
    
    var body : some View {
        
        VStack(spacing: 0) {
            
            if msgs.count == 0 {
                if self.nomsgs {
                    
                    Text("開始聊天吧")
                        .foregroundColor(Color.black.opacity(0.5))
                        .padding(.top)
                    Spacer()
                }
                else {
                    Spacer()
                    Indicator()
                    Spacer()
                }
            }
            else {
                ScrollViewReader { reader in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 12) {
                            
                            ForEach(self.msgs) { i in
                                
                                HStack {
                                    
                                    if i.user == UserDefaults.standard.value(forKey: "uid") as! String {
                                        
                                        Spacer()
                                        
                                        Text(i.msg)
                                            .padding()
                                            .background(Color.blue)
                                            .clipShape(ChatBubble(mymsg: true))
                                            .foregroundColor(.white)
                                        
                                        AnimatedImage(url: URL(string: myPic as! String))
                                            .resizable()
                                            .renderingMode(.original)
                                            .frame(width: 55, height: 55)
                                            .clipShape(Circle())
                                    }
                                    else {
                                        
                                        AnimatedImage(url: URL(string: pic)!)
                                            .resizable()
                                            .renderingMode(.original)
                                            .frame(width: 55, height: 55)
                                            .clipShape(Circle())
                                        
                                        Text(i.msg)
                                            .padding()
                                            .background(Color.green)
                                            .clipShape(ChatBubble(mymsg: false))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                }
                                .onAppear {
                                    if i.id == self.msgs.last!.id && !scrolled {
                                        
                                        reader.scrollTo(msgs.last!.id, anchor: .bottom)
                                        scrolled = true
                                    }
                                }
                            }
                            .onChange(of: msgs, perform: { _ in
                                
                                reader.scrollTo(msgs.last!.id, anchor: .bottom)
                            })
                        }
                        .padding()
                    }
                }
            }
            
            VStack {
                HStack {
                    
                    Button(action: {
                        // toggling image picker
                        
                    }, label: {
                        Image(systemName: "paperclip")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Color.blue)
                            .clipShape(Circle())
                    })
                    
                    TextField("訊息...", text: self.$txt)
                    
                    if self.txt != "" {
                        Button(action: {
                            withAnimation {
                                sendMsg(user: self.name, uid: self.uid, pic: self.pic, date: Date(), msg: self.txt)
                            }
                            self.txt = ""
                            
                        }) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    
                }
                .padding()
                .frame(height: 45)
                .clipShape(Capsule())
                .animation(.default)
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.secondary, lineWidth: 0.5))
            }
            .padding(20)
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .navigationBarTitle("\(name)",displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { self.chat.toggle() }, label: {
                Image(systemName: "arrow.left").resizable().frame(width: 20, height: 15)
                
            }))
        .background(Color.primary.opacity(0.06))
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear { self.getMsgs() }
    }
    
    func getMsgs(){
        
        let db = Firestore.firestore()
        
        let myuid = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(myuid!).collection(self.uid).order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                self.nomsgs = true
                return
            }
            
            if snap!.isEmpty {
                
                self.nomsgs = true
            }
            
            for i in snap!.documentChanges {
                
                if i.type == .added {
                    
                    
                    let id = i.document.documentID
                    let msg = i.document.get("msg") as! String
                    let user = i.document.get("user") as! String
                    
                    self.msgs.append(Msg(id: id, msg: msg, user: user))
                }

            }
            print("Load new message")
        }
    }
}

struct ChatBubble : Shape {
    
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
            
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, mymsg ? .bottomLeft : .bottomRight],  cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
}

func sendMsg(user: String,uid: String,pic: String,date: Date,msg: String) {
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("Owner").document(uid).collection("recents").document(myuid!).getDocument { (snap, err) in
        
        if err != nil {
            
            print((err?.localizedDescription)!)
            // if there is no recents records....
            
            setRecents(user: user, uid: uid, pic: pic, msg: msg, date: date)
            return
        }
        
        if !snap!.exists {
            
            setRecents(user: user, uid: uid, pic: pic, msg: msg, date: date)
            print("Set new chat to recents")
        }
        else {
            
            updateRecents(user: user, uid: uid, pic: pic, msg: msg, date: date)
            print("Update new message to recents")
        }
    }
    
    updateDB(uid: uid, msg: msg, date: date)
    print("Update to each user's database")
}

func setRecents(user: String,uid: String,pic: String,msg: String,date: Date) {
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    let myname = UserDefaults.standard.value(forKey: "user") as! String
    
    let mypic = UserDefaults.standard.value(forKey: "pic") as! String
    
    db.collection("Owner").document(uid).collection("recents").document(myuid!).setData(["name": myname, "pic": mypic, "lastmsg": msg, "date": date]) { (err) in
        
        if err != nil {
            
            print((err?.localizedDescription)!)
            return
        }
    }
    
    db.collection("User").document(myuid!).collection("recents").document(uid).setData(["name": user, "pic": pic, "lastmsg": msg, "date": date]) { (err) in
        
        if err != nil {
            
            print((err?.localizedDescription)!)
            return
        }
    }
}

func updateRecents(user: String,uid: String,pic: String,msg: String,date: Date) {
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    let myname = UserDefaults.standard.value(forKey: "user") as! String
    
    let mypic = UserDefaults.standard.value(forKey: "pic") as! String
    
    db.collection("Owner").document(uid).collection("recents").document(myuid!).updateData(["name": myname, "pic": mypic, "lastmsg": msg, "date": date])
    
    db.collection("User").document(myuid!).collection("recents").document(uid).updateData(["name": user, "pic": pic, "lastmsg": msg, "date": date])
}

func updateDB(uid: String,msg: String,date: Date) {
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("msgs").document(uid).collection(myuid!).document().setData(["msg": msg, "user": myuid!, "date": date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
    
    db.collection("msgs").document(myuid!).collection(uid).document().setData(["msg": msg, "user": myuid!, "date": date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
        
    }
}

