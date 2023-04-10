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


final class LogInViewModel{
        
    static let shared:LogInViewModel = LogInViewModel()
    private init(){}
    
    var currentUser:User? = {
        FirebaseAuth.Auth.auth().currentUser
    }()
    
    //General Property
    var strSignIn = {
        "Sign In"
    }()
    var strSignUp = {
        "Sign Up"
    }()
  
    var dictionarySingIn:[String:Any] = [:]
    var currentState:State = .signIn
    
    typealias FirebaseLogIn = (Result<User,Error>) -> Void
    
    typealias EmailPassword = (String,String)
    
    func getEmailPassword()->EmailPassword{
        if let email = dictionarySingIn[Key.email],let password = dictionarySingIn[Key.password]{
            return(("\(email)","\(password)"))
        }else{
            return ("","")
        }
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
        //Sign In User
         FirebaseAuth.Auth.auth().signIn(withEmail: self.getEmailPassword().0, password: self.getEmailPassword().1,completion:
            {result, error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let user:User = result?.user else {return}
                completion(.success(user))
         })
    }
    
    func userRegisterRequest(_ completion:@escaping FirebaseLogIn){
        //Register In User
        FirebaseAuth.Auth.auth().createUser(withEmail: self.getEmailPassword().0, password:  self.getEmailPassword().1,completion:
           {result, error in
               guard error == nil else {
                   completion(.failure(error!))
                   return
               }
               guard let user:User = result?.user else {return}
               completion(.success(user))
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
