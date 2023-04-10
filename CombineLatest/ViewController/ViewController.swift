//
//  ViewController.swift
//  CombineLatest
//
//  Created by Darshan on 05/04/23.
//

import UIKit
import Combine
import FirebaseAuth

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

//DataSource
extension ViewController{
    private func performSingInRequest(){
        LogInViewModel.shared.userLoginRequest {[weak self] result in
                switch result{
                    case .success(let user):
                        self?.pushtoHomeViewController(user: user)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.showCreateAccountAlert()
                }
        }
    }
    private func showCreateAccountAlert(){
        let createAccountAlert = UIAlertController(title: "Create Account", message: "Would you like to create an account", preferredStyle: .alert)
        createAccountAlert.addAction(UIAlertAction.init(title: "Continue", style: .default)
        {[weak self] _ in
            self?.updateCurrentSignInSignUpState()
        })
        createAccountAlert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel)
        {[weak self] _ in
            self?.dismiss(animated: true)
        })
        self.present(createAccountAlert, animated: true)
    }
    private func performSingUpRequest(){
        LogInViewModel.shared.userRegisterRequest {[weak self] result in
                switch result{
                    case .success(let user):
                        self?.pushtoHomeViewController(user: user)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
        }
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
        self.updateCurrentSignInSignUpState()
    }
    private func updateCurrentSignInSignUpState(){
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
                guard let termsViewController = Utill.shared.termsViewController else {return}
                self.present(termsViewController, animated: true)
            }
    }
    private func pushtoHomeViewController(user:User){
        DispatchQueue.main.async {
            guard let homeviewcontroller = Utill.shared.homeViewController else {return}
            homeviewcontroller.currentUser = user
            self.vanishData()
            self.navigationController?.pushViewController(homeviewcontroller, animated: true)
        }
    }
}
