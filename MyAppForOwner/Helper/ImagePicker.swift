//
//  ImagePicker.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/7.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var show: Bool
    @Binding var ImageData: Data
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
        
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        let controller = PHPickerViewController(configuration: PHPickerConfiguration())
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if !results.isEmpty {
                
                if results.first!.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    
                    results.first!.itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in
                        
                        guard let imageData = image else { return }
                        
                        let data = (imageData as! UIImage).jpegData(compressionQuality: 0.5)!
                        
                        DispatchQueue.main.async {
                            
                            self.parent.ImageData = data
                            self.parent.show.toggle()
                        }
                    }
                }
                else {
                    self.parent.show.toggle()
                }
            }
            else {
                self.parent.show.toggle()
            }
        }
    }
}

//struct ImagePicker : UIViewControllerRepresentable {
//
//    @Binding var picker : Bool
//    @Binding var imagedata : Data
//
//    func makeCoordinator() -> ImagePicker.Coordinator {
//
//        return ImagePicker.Coordinator(parent1: self)
//    }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//
//        let picker = UIImagePickerController()
//        picker.sourceType = .photoLibrary
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//
//
//    }
//
//    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
//
//        var parent : ImagePicker
//
//        init(parent1 : ImagePicker) {
//
//            parent = parent1
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//
//            self.parent.picker.toggle()
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//            let image = info[.originalImage] as! UIImage
//
//            let data = image.jpegData(compressionQuality: 0.45)
//
//            self.parent.imagedata = data!
//
//            self.parent.picker.toggle()
//        }
//    }
//}
