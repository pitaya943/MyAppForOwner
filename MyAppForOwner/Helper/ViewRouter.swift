//
//  ViewRouter.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/8.
//
import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .page1
    
}

enum Page {
    
    case page1
    case page2
    case page3
}
