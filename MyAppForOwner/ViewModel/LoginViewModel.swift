//
//  LoginViewModel.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import SwiftUI
import Firebase
import CoreLocation

class LoginViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    // User details
    @Published var name = ""
    @Published var about = ""
    @Published var location = ""
    @Published var email = ""
    @Published var type = ""
    
    // Login details
    @Published var phNumber = ""
    @Published var code = ""
        
    @Published var images = Array(repeating: Data(count: 0), count: 6)
    @Published var picker = false
    
    // DataModdel for error view
    @Published var errorMsg = ""
    @Published var error = false

    // Loading screen
    @Published var loading = false
    // Go to verify screen
    @Published var goToVerify = false
    // For OTP
    @Published var CODE = ""
    
    // Status
    @AppStorage("log_Status") var status = false
    @AppStorage("newMember") var newMember = false

    
    // UserDefault Informations
    @AppStorage("uid") var uid = ""
    @AppStorage("user") var user = ""
    @AppStorage("phone") var phone = ""
    @AppStorage("pic") var pic = ""
    
    // Storage in firebase
    let storage = Storage.storage().reference()
    // Firebase
    let db = Firestore.firestore()
    
    func getCountryCode() -> String {
        
        let regionCode = Locale.current.regionCode ?? ""
        
        return countries_code[regionCode] ?? ""
    }
    
    // Sending code to user
    func sendCode() {
        
        // Disabling App Verification...
        // Undo it while testing with live Phone....
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        loading = true
        let number = "+\(getCountryCode())\(phNumber)"
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (CODE, err) in

            if let error = err {
                
                self.errorMsg = error.localizedDescription
                withAnimation{ self.error.toggle() }
                self.loading.toggle()
                return
            }
            self.CODE = CODE ?? ""
            self.goToVerify = true
            self.loading = false
        }
    }
    
    func verifyCode() {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: code)
        
        loading = true
        
        Auth.auth().signIn(with: credential) { (res, err) in
            
            self.loading.toggle()
            
            if err != nil {
                self.errorMsg = err!.localizedDescription
                withAnimation{ self.error.toggle() }
                return
            }
            
            // Else user logged in Successfully
            self.getUserData()

            print("Userdefault: --------")
            print("Hello \(self.user)!")
            print("log_Status = \(String(self.status))")
            print("uid = \(self.uid)")
            print("phone = \(self.phone)")
            print("pic = \(self.pic)")
            
        }
    }
    
    func requestCode() {
        
        sendCode()
        withAnimation {
            self.errorMsg = "驗證碼已傳送"
            self.error.toggle()
        }
    }
    
    func getUserData() {
        
        uid = Auth.auth().currentUser?.uid ?? ""
        phone = Auth.auth().currentUser?.phoneNumber ?? ""
        let userRef = db.collection("TestOfOwner").document(uid)
                
        loading.toggle()
        // If user exist, read Data else write new one
        userRef.getDocument { (document, err) in
            // If exist
            if let document = document, document.exists {
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                // Getting user name for userdefault from firebase
                UserDefaults.standard.set(document.get("name") as! String, forKey: "user")
                
                let arrayData = document.get("pic") as? [String] ?? [String]()
                UserDefaults.standard.set(arrayData, forKey: "pic")
                print("arrayData:\(arrayData)", "\npic:\(UserDefaults.standard.array(forKey: "pic") as? [String] ?? [String]())")
                
                print("Logging user data: \(dataDescription)")
                self.loading.toggle()
                withAnimation { self.status = true }
                
            // New member
            }
            else {
                do {
                    
                    // initialize user data
                    try userRef.setData(from: Owner(id: self.uid, name: self.name, location: self.location, email: self.email, phoneNumber: self.phone, pic: [String](), about: self.about, type: self.type))
                    
                    print("New user logged!!!")
                    
                    // If user not exist then toggle newMember
                    self.loading.toggle()
                    self.newMember = true
                    
                } catch {
                    print("Error \(error)")
                }
            }
        }

    }
    
    // MARK: Update All User Infomation
    func updateAllInformation(urls: [String]) {
        
        uid = Auth.auth().currentUser?.uid ?? ""
        phone = Auth.auth().currentUser?.phoneNumber ?? ""
        let userRef = db.collection("TestOfOwner").document(uid)
        
        loading.toggle()
        
        userRef.getDocument { (document, err) in
            
            if let document = document, document.exists {
                do {
                    
                    try userRef.setData(from: Owner(id: self.uid, name: self.name, location: self.location, email: self.email, phoneNumber: self.phone, pic: urls, about: self.about, type: self.type), merge: true)
                    
                    print("User data updated!!!")
                                        
                    withAnimation {
                        self.newMember.toggle()
                        self.status.toggle()
                        self.loading.toggle()
                    }
                    
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    // MARK: - Image store & dowload
    
    func imageSignUp() {

        self.loading.toggle()

        let storage = Storage.storage().reference()
        let ref = storage.child("Owner_Profile_pics").child(Auth.auth().currentUser!.uid)

        var urls: [String] = []

        for index in images.indices {

            self.loading.toggle()

            ref.child("img\(index)").putData(images[index], metadata: nil) { (_, err) in

                self.loading.toggle()

                if err != nil {

                    self.errorMsg = err!.localizedDescription
                    self.error.toggle()
                    return
                }

                ref.child("img\(index)").downloadURL { (url, _) in
                    guard let imageUrl = url else { return }

                    // Appending urls
                    urls.append("\(imageUrl)")

                    // Check all image are uploaded
                    if urls.count == self.images.count {
                        // Update DB
                        self.loading.toggle()
                        self.updateAllInformation(urls: urls)

                        // Set userdefault from first pic
                        UserDefaults.standard.set(urls, forKey: "pic")
                        print("setting pic userdefault = \(UserDefaults.standard.array(forKey: "pic") as? [String] ?? [String]())")
                    }
                }
            }
        }
        
        print("Image been stored in firebase")
    }
    
    // MARK: - Getting User Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         
        let last = locations.last!
        
        CLGeocoder().reverseGeocodeLocation(last) { (place, _) in
            guard let placeMarks = place else { return }
            
            self.location = (placeMarks.first?.name ?? "") + ", " + (placeMarks.first?.locality ?? "")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
}
