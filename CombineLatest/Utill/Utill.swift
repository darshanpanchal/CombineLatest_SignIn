//
//  Utill.swift
//  CombineLatest
//
//  Created by Darshan on 10/04/23.
//
import  UIKit
import Foundation

enum Stroyboard{
    static var main = UIStoryboard.init(name: "Main", bundle: nil)
}
final class Utill{
    static let shared = Utill()
    private init(){}
    var loginViewController:ViewController? = {
        return Stroyboard.main.instantiateViewController(withIdentifier: "ViewController") as? ViewController
    }()
    var homeViewController:HomeViewController? = {
        return Stroyboard.main.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }()
}
