//
//  HomeViewController.swift
//  CombineLatest
//
//  Created by Darshan on 10/04/23.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    
    var currentUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = self.currentUser{
            DispatchQueue.main.async {
                self.title = "\(user.email ?? "")"
            }

        }
    }
    @IBAction func buttonSingOutSelector(sender:UIButton){
        self.showLogOutAlert()
    }
    private func showLogOutAlert(){
            let logOutAlert = UIAlertController(title: "LogOut", message: "Are you sure you want to LogOut?", preferredStyle: .alert)
            let yesAction = UIAlertAction.init(title: "Yes", style: .default){[weak self] _ in
                do{
                    let _ = try FirebaseAuth.Auth.auth().signOut()
                    self?.popToRootViewController()
                }catch{
                }
            }
            yesAction.setValue(UIColor.red, forKey: "titleTextColor")
            logOutAlert.addAction(yesAction)
            logOutAlert.addAction(UIAlertAction.init(title: "No", style: .cancel))
            self.present(logOutAlert, animated: true)
        }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    func popToRootViewController(){
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
