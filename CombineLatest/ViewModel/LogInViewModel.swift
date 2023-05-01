//
//  LogInViewModel.swift
//  CombineLatest
//
//  Created by Darshan on 05/04/23.
//

import Foundation
import UIKit
import Combine
import Firebase
import FirebaseAuth
import ProgressHUD
import CoreData

enum State{
    case signIn
    case signUp
}
 enum Key {
    static let email = "email"
    static let password = "password"
    static let confirmpassword = "confirmpassword"
}
typealias FirebaseLogIn = (Result<CDUser,Error>) -> Void
typealias EmailPassword = (String,String)


protocol LogInViewModelDelegate:AnyObject{
    //Property
    var strSignIn:String { get set}
    var strSignUp:String { get set}
    var manager:UserManager { get set }
    var currentState:State { get set}
    var dictionarySignIn:[String:Any] {get set}
    
    //Validation
    func validateSingIn()->Bool
    func validateSingUp()->Bool
    func isValidEmail(_ email: String) -> Bool
    func getEmailPassword()->EmailPassword
    func getCurrentUserFromDB()->CDUser?
    func getAllUserRecord()->[UserModel]?
    
    //HTTPUtility
    var httpUtill:HttpUtility {get set}
    
}

final class LogInViewModel:LogInViewModelDelegate{
    
    var dictionarySignIn: [String : Any]
    var manager: UserManager
    var currentState: State
    var strSignIn: String
    var strSignUp: String
    var httpUtill: HttpUtility
    
    static let shared:LogInViewModel = {
       return LogInViewModel()
    }()

    private init(){
        self.manager = UserManager()
        self.dictionarySignIn = [:]
        self.currentState = .signIn
        self.strSignIn = "Sign In"
        self.strSignUp = "Sign Up"
        self.httpUtill = HttpUtility.shared
    }
}
//API
extension LogInViewModel{
    
    func userLogIn(comletionHandler:@escaping (Result<SignInResponse?,HTTPError>)->Void){
        SignInDataResource().dataRequest(request: self.logInRequest()) { result in
            comletionHandler(result)
        }
    }
    func userLoginRequest(_ completion:@escaping FirebaseLogIn){
        ProgressHUD.show()
        //Sign In User
         FirebaseAuth.Auth.auth().signIn(withEmail: self.getEmailPassword().0, password: self.getEmailPassword().1,completion:
            {[weak self] result, error in
             ProgressHUD.dismiss()
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let user:User = result?.user else {return}
                kUserDefault.set(user.email, forKey: kUserEmail)
                kUserDefault.synchronize()
             
                //Create Core Data User
                let usermodel =  UserModel.init(email: user.email ?? "",id: UUID(),password: self?.getEmailPassword().1)
                
             
                guard let coreDataUser = self?.manager.fetchUser(byEmail: user.email ?? "") else {
                    if let newUser = self?.manager.createUser(user: usermodel){
                        completion(.success(newUser))
                    }
                return}
                let _ = self?.manager.updateUser(user: usermodel)
                completion(.success(coreDataUser))
            })
    }
    
    func userRegisterRequest(_ completion:@escaping FirebaseLogIn){
        ProgressHUD.show()
        //Register In User
        FirebaseAuth.Auth.auth().createUser(withEmail: self.getEmailPassword().0, password:  self.getEmailPassword().1,completion:
           { [weak self] result, error in
            ProgressHUD.dismiss()
               guard error == nil else {
                   completion(.failure(error!))
                   return
               }
               guard let user:User = result?.user else {return}
                kUserDefault.set(user.email, forKey: kUserEmail)
                kUserDefault.synchronize()
               let usermodel =  UserModel.init(email: user.email ?? "",id: UUID(),password: self?.getEmailPassword().1)
                if let cdUser = self?.manager.createUser(user: usermodel){
                    completion(.success(cdUser))
                }
        })
    }
    
}
//Fetch
extension LogInViewModel{
    func getEmailPassword()->EmailPassword{
        if let email = self.dictionarySignIn[Key.email],let password = dictionarySignIn[Key.password]{
            return(("\(email)","\(password)"))
        }else{
            return ("","")
        }
    }
    func getCurrentUserFromDB()->CDUser?{
        
        if let currentEmail = kUserDefault.value(forKey: kUserEmail){
            return manager.fetchUser(byEmail: "\(currentEmail)")
        }else{
            return nil
        }
    }
    func getAllUserRecord()->[UserModel]?{
        return manager.getAllUser()
    }
    func logInRequest()->SignInRequest{
        SignInRequest.init(username:self.getEmailPassword().0, password: self.getEmailPassword().1)
    }
}
//Update
extension LogInViewModel{
    func updateCurrentState(completion:@escaping (_ isSingIn:Bool)->Void){
        if self.currentState == .signUp{
            self.currentState = .signIn
            completion(true)
        }else{
            self.currentState = .signUp
            completion(false)
        }
    }
    func updateEmail(txtEmail:String?){
        if let emailText = txtEmail{
            self.dictionarySignIn[Key.email] = emailText
        } else {
            self.dictionarySignIn[Key.email] = ""
        }
    }
    func updatePassword(txtPassword:String?){
        if let passwordText = txtPassword{
            self.dictionarySignIn[Key.password] = passwordText
        } else {
            self.dictionarySignIn[Key.password] = ""
        }
    }
    func updateConfirmPassword(txtConfirmPassword:String?){
        if let emailText = txtConfirmPassword{
            self.dictionarySignIn[Key.confirmpassword] = emailText
        } else {
            self.dictionarySignIn[Key.confirmpassword] = ""
        }
    }
}
//validation
extension LogInViewModel{

    func validateSingIn()->Bool{
        guard let email = dictionarySignIn[Key.email] else {return false }
        guard let password = dictionarySignIn[Key.password] else {return false }
        guard self.isValidEmail("\(email)") else {return false}
        
        debugPrint(email)
        debugPrint(password)
        
        return true
    }
    func validateSingUp()->Bool{
        guard let email = dictionarySignIn[Key.email] else {return false }
        guard let password = dictionarySignIn[Key.password] else {return false }
        guard let confirmpassword = dictionarySignIn[Key.confirmpassword] else {return false }
        guard self.isValidEmail("\(email)") else {return false}
        guard "\(password)" == "\(confirmpassword)" else {return false}
        
        debugPrint(email)
        debugPrint(password)
        debugPrint(confirmpassword)
        
        return true
    }
     func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
//Custom Sign In button 
class SignInButton:UIButton{

    override var isEnabled: Bool{
        didSet{
            self.setup()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setup(){
        self.backgroundColor = isEnabled ? .tintColor : .gray
    }
}
