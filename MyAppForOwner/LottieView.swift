//
//  LottieView.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
  typealias UIViewType = UIView
  var filename: String
  
  func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
    let view = UIView(frame: .zero)
    
    let animationView = AnimationView()
    let animation = Animation.named(filename)
    animationView.animation = animation
    animationView.loopMode = .loop
    animationView.animationSpeed = 2
    animationView.contentMode = .scaleAspectFit
    animationView.play()
    
    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)
    
    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
      animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) { }
}
