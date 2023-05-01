//
//  Utill.swift
//  CombineLatest
//
//  Created by Darshan on 10/04/23.
//
import  UIKit
import Foundation

let kUserDefault = UserDefaults.standard
let kUserEmail = "email"
typealias CompletionHandler = () -> Void


enum Constant{
    static var termsURL = "https://www.testing.com/terms-of-use/"
}
extension UIStoryboard{
        static var mainStoryboard:UIStoryboard{
            return UIStoryboard.init(name: "Main", bundle: nil)
        }
}
protocol BaseURLDelegate:AnyObject{
    var kBaseURL:String {get}
    var isProduction : Bool {get}
    var kDebugBaseURL : String {get}
    var kProductionBaseURL : String {get}
}
final class Utill:BaseURLDelegate{
   
    
    static let shared = Utill()
    
    private init(){}
    
    var loginViewController:ViewController? = {
        return UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
    }()
    var homeViewController:HomeViewController? = {
        return UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }()
    var termsViewController:TermsViewController? = {
        return UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController
    }()
    var kBaseURL: String = ""
    var kDebugBaseURL: String = ""
    var kProductionBaseURL: String = ""
    
    var isProduction: Bool =  false {
        didSet{
            kBaseURL = isProduction ? kProductionBaseURL : kDebugBaseURL
        }
    }
}

protocol UIViewControllerDelegate{
    func configureNavigationLargeTitle()
}
extension UIViewController :UIViewControllerDelegate{
    
    
    func configureNavigationLargeTitle() {
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              let window = delegate.window else { return nil }
              return window
    }
    
    func presentAlert(title:String,message:String,action1:UIAlertAction,action2:UIAlertAction){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action1)
        alert.addAction(action2)
        self.window?.rootViewController?.present(alert, animated: true)
    }
    func alertAction(name:String,style:UIAlertAction.Style,color:UIColor,completion: CompletionHandler?)->UIAlertAction{
        let action = UIAlertAction.init(title:name,style: style){ _ in
            if let completion{
                completion()
            }
        }
        action.setValue(color, forKey: "titleTextColor")
        return action
    }
}

