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


final class LogInViewModel{
        
    static let shared:LogInViewModel = LogInViewModel()
    private init(){}
    
    var manager:UserManager = UserManager()
    
    //General Property
    var strSignIn = {
        "Sign In"
    }()
    var strSignUp = {
        "Sign Up"
    }()
  
    var dictionarySingIn:[String:Any] = [:]
    var currentState:State = .signIn
    
    typealias FirebaseLogIn = (Result<CDUser,Error>) -> Void
    
    typealias EmailPassword = (String,String)
    
    func getEmailPassword()->EmailPassword{
        if let email = dictionarySingIn[Key.email],let password = dictionarySingIn[Key.password]{
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
    enum State{
        case signIn
        case signUp
    }
     enum Key {
        static let email = "email"
        static let password = "password"
        static let confirmpassword = "confirmpassword"
    }
    
}
//API
extension LogInViewModel{
    
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
            self.dictionarySingIn[Key.email] = emailText
        } else {
            self.dictionarySingIn[Key.email] = ""
        }
    }
    func updatePassword(txtPassword:String?){
        if let passwordText = txtPassword{
            self.dictionarySingIn[Key.password] = passwordText
        } else {
            self.dictionarySingIn[Key.password] = ""
        }
    }
    func updateConfirmPassword(txtConfirmPassword:String?){
        if let emailText = txtConfirmPassword{
            self.dictionarySingIn[Key.confirmpassword] = emailText
        } else {
            self.dictionarySingIn[Key.confirmpassword] = ""
        }
    }
}
//validation
extension LogInViewModel{
 
    func validateSingIn()->Bool{
        guard let email = dictionarySingIn[Key.email] else {return false }
        guard let password = dictionarySingIn[Key.password] else {return false }
        guard self.isValidEmail("\(email)") else {return false}
        
        debugPrint(email)
        debugPrint(password)
        
        return true
    }
    func validateSingUp()->Bool{
        guard let email = dictionarySingIn[Key.email] else {return false }
        guard let password = dictionarySingIn[Key.password] else {return false }
        guard let confirmpassword = dictionarySingIn[Key.confirmpassword] else {return false }
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
