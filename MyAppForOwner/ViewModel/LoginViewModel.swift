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
    
    // User details
    @Published var name = ""
    @Published var bio = ""
    @Published var age = ""
    @Published var location = ""
    
    // Login details
    @Published var phNumber = ""
    //@Published var code = ""
    
    @Published var pageNumber = 0
    
    @Published var images = Array(repeating: Data(count: 0), count: 4)
    @Published var picker = false
    
    // Alert details
    @Published var alert = false
    @Published var alertMsg = ""

    // Loading screen
    @Published var isLoading = false
    // For OTP
    @Published var CODE = ""
    // Status
    @AppStorage("log_Status") var status = false
    
    func getCountryCode() -> String {
        
        let regionCode = Locale.current.regionCode ?? ""
        
        return countries_code[regionCode] ?? ""
    }
    
    func login() {
        
        // Getting OTP
        // Disable App verification
        // Undo it while testing with alive phone
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        isLoading.toggle()
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+" + getCountryCode() + phNumber, uiDelegate: nil) { (CODE, err) in
            
            self.isLoading.toggle()

            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            self.CODE = CODE!
            
            // Alert Textfeild
            
            let alertView = UIAlertController(title: "驗證碼", message: "請輸入您的驗證碼", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "取消", style: .destructive, handler: nil)
            let ok = UIAlertAction(title: "確定", style: .default) { (_) in
                
                if let otp = alertView.textFields![0].text {
                    
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: otp)
                    
                    self.isLoading.toggle()
                    
                    Auth.auth().signIn(with: credential) { (res, err) in
                        
                        if err != nil {
                            self.alertMsg = err!.localizedDescription
                            self.alert.toggle()
                            return
                        }
                        
                        // Go to register screen
                        withAnimation { self.pageNumber = 1 }
                        
                        self.isLoading.toggle()
                    }
                }
            }
            
            alertView.addTextField { (text) in
                text.placeholder = "請輸入六位驗證碼"
            }
            
            alertView.addAction(cancel)
            alertView.addAction(ok)
            
            // Presentating
            UIApplication.shared.windows.first?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
    }
    
    func signUp() {
        
        let storage = Storage.storage().reference()
        let ref = storage.child("Owner_Profile_pics").child(Auth.auth().currentUser!.uid)
        
        var urls: [String] = []
        
        for index in images.indices {
            
            self.isLoading.toggle()
            
            ref.child("img\(index)").putData(images[index], metadata: nil) { (_, err) in
                
                self.isLoading.toggle()
                
                if err != nil {
                    
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                ref.child("img\(index)").downloadURL { (url, _) in
                    guard let imageUrl = url else { return }
                    
                    // Appending urls
                    urls.append("\(imageUrl)")
                    
                    // Check all image are uploaded
                    if urls.count == self.images.count {
                        // Update DB
                        self.RegisterUser(urls: urls)
                    }
                }
                
            }
        }
    }
    
    func RegisterUser(urls: [String]) {
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("TestOfOwner").document(uid).setData([
            
            "userName": self.name,
            "bio": self.bio,
            "location": self.location,
            "age": self.age,
            "imageUrls": urls
            
            
        ]) { (err) in
            
            self.isLoading.toggle()
            
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            // Success
            self.status = true
            
        }
    }
    
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
