//
//  ViewController.swift
//  CombineLatest
//
//  Created by Darshan on 05/04/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak private var lblTitle:UILabel!
    @IBOutlet weak private var containerView:UIView!

    @IBOutlet weak private var txtEmail:UITextField!
    @IBOutlet weak private var txtPassword:PassWordTextField!
    @IBOutlet weak private var txtConfirmPassword:PassWordTextField!
    
    @IBOutlet weak private  var buttonSingIn:SignInButton!
    @IBOutlet weak private var containerbuttonSingIn:UIView!
    
    @IBOutlet weak private var confirmPasswordContainer:UIView!
    @IBOutlet weak private var emptyContainer:UIView!
    
    @IBOutlet weak private var buttonSignInSingUp:UIButton!

    @IBOutlet weak private var buttonTerms:UIButton!
    @IBOutlet weak private var switchvalue:UISwitch!
    
    
    var viewModel = LogInViewModel.shared
    
    
    
    @Published private var isTnAccepted:Bool = false
    @Published private var username:String = ""
    @Published private var password:String = ""
    @Published private var confirmpassword :String = ""
    
    var singInValidationPublisher:AnyPublisher<Bool,Never>{
        return Publishers.CombineLatest4($isTnAccepted, $username, $password,$confirmpassword)
        .map{[weak self] isTnAccepted, username , password,confirmpassword in
//            self?.enableSingInSingUp() ?? true
            if self?.viewModel.currentState == .signIn{
                return isTnAccepted && username.count > 0 && password.count > 0
            }else{
                return isTnAccepted && username.count > 0 && password.count > 0 && password == confirmpassword
            }
            
        }.eraseToAnyPublisher()
    }
    
    private var subcscriptions:Set<AnyCancellable> = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }
    
    private var titleAttributted:NSAttributedString = {
        NSAttributedString(string:"Terms and Conditions",attributes:
        [NSAttributedString.Key.foregroundColor: UIColor.tintColor,
         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setup()
        //Subscriber
        singInValidationPublisher
        .receive(on: RunLoop.main)
        .assign(to: \.isEnabled, on: self.buttonSingIn)
        .store(in: &subcscriptions)
        
       
    }
}

//Setup
extension ViewController {
    private func setup(){
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.clipsToBounds = true
        
        self.txtEmail.addTarget(self, action: #selector(emailFieldIsEditingChanged(_:)), for: .editingChanged)
        self.txtPassword.addTarget(self, action: #selector(passwordFieldIsEditingChanged(_:)), for: .editingChanged)
        self.txtConfirmPassword.addTarget(self, action: #selector(confirmPasswordFieldIsEditingChanged(_:)), for: .editingChanged)
        
        self.buttonTerms.addTarget(self, action: #selector(buttonTerms(_:)), for: .touchUpInside)
    
        self.buttonTerms.setAttributedTitle(titleAttributted, for: .normal)
        self.switchvalue.addTarget(self, action: #selector(buttonSwitch(_:)), for: .valueChanged)
        
        self.buttonSingIn.addTarget(self, action: #selector(buttonSignIn(_:)), for: .touchUpInside)
        
        self.buttonSignInSingUp.addTarget(self, action: #selector(buttonSignUpSignInSelector(_:)), for: .touchUpInside)
    }
    private func configureSignIn(){
        self.emptyContainer.isHidden = false
        self.confirmPasswordContainer.isHidden = true
        self.lblTitle.text = viewModel.strSignIn
        self.buttonSingIn.setTitle(viewModel.strSignIn, for: .normal)
        self.buttonSignInSingUp.setTitle(viewModel.strSignUp, for: .normal)
    }
    private func configureSignUp(){
        self.emptyContainer.isHidden = true
        self.confirmPasswordContainer.isHidden = false
        self.lblTitle.text = viewModel.strSignUp
        self.buttonSingIn.setTitle(viewModel.strSignUp, for: .normal)
        self.buttonSignInSingUp.setTitle(viewModel.strSignIn, for: .normal)
    }
}
//Observer
extension ViewController{
    func enableSingInSingUp()->Bool{
        print(isTnAccepted)
        print(username.count > 0)
        print(password.count > 0)
        if self.viewModel.currentState == .signIn{
            return isTnAccepted && username.count > 0 && password.count > 0
        }else{
            return isTnAccepted && username.count > 0 && password.count > 0 && password == confirmpassword
        }
    }
}
//DataSource
extension ViewController{
    private func performSingInRequest(){
        
    }
    private func performSingUpRequest(){
        
    }
    private func vanishData(){
        self.txtPassword.text = ""
        self.txtConfirmPassword.text = ""
        self.password = ""
        self.confirmpassword = ""
    }
}
//Selectors Methods
extension ViewController{
    @objc func buttonSignIn(_ sender:UIButton){
        if viewModel.currentState == .signIn{
            if self.viewModel.validateSingIn(){
                self.performSingInRequest()
            }
        }else{
            if self.viewModel.validateSingUp(){
                self.performSingUpRequest()
            }
        }
    }

    @objc func buttonSignUpSignInSelector(_ sender:UIButton){
        self.vanishData()
        UIView.transition(with: self.containerView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        self.viewModel.updateCurrentState { [weak self] isSingIn in
            if isSingIn{
                self?.configureSignIn()
            }else{
                self?.configureSignUp()
            }
        }
    }
    @objc func buttonTerms(_ sender:UIButton){
        self.presentTermsAndCondition()
    }
    @objc func buttonSwitch(_ sender:UISwitch){
        
        self.isTnAccepted =  self.switchvalue.isOn
        self.presentTermsAndCondition()
    }
    @objc func emailFieldIsEditingChanged(_ emailField: UITextField) {
        self.viewModel.updateEmail(txtEmail: emailField.text)
        self.username = emailField.text ?? ""
     }
    @objc func passwordFieldIsEditingChanged(_ passwordField: UITextField) {
        self.viewModel.updatePassword(txtPassword: passwordField.text)
        self.password = passwordField.text ?? ""
     }
    @objc func confirmPasswordFieldIsEditingChanged(_ passwordField: UITextField) {
        self.viewModel.updateConfirmPassword(txtConfirmPassword: passwordField.text)
        self.confirmpassword = passwordField.text ?? ""
        
     }
}
//Navigation
extension ViewController{
    private func presentTermsAndCondition(){
        if self.switchvalue.isOn{
            
        }
    }
}
