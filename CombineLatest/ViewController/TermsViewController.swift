//
//  TermsViewController.swift
//  CombineLatest
//
//  Created by Darshan on 10/04/23.
//

import UIKit
import WebKit

class TermsViewController: UIViewController {

    @IBOutlet private weak var webview:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            DispatchQueue.main.async {
                guard let url = URL.init(string: Constant.termsURL) else{return}
                let request = URLRequest.init(url: url)
                self.webview.load(request)
            }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    @IBAction func buttonCloseSelector(sender:UIButton){
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
