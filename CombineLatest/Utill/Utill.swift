//
//  Utill.swift
//  CombineLatest
//
//  Created by Darshan on 10/04/23.
//
import  UIKit
import Foundation

enum Constant{
    static var mainStory = UIStoryboard.init(name: "Main", bundle: nil)
    static var termsURL = "https://www.testing.com/terms-of-use/"
}
final class Utill{
    
    static let shared = Utill()
    private init(){}
    
    var loginViewController:ViewController? = {
        return Constant.mainStory.instantiateViewController(withIdentifier: "ViewController") as? ViewController
    }()
    var homeViewController:HomeViewController? = {
        return Constant.mainStory.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }()
    var termsViewController:TermsViewController? = {
        return Constant.mainStory.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController
    }()
}
