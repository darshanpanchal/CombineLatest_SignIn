
import UIKit
import Foundation

 class PassWordTextField:UITextField{
       //Update your custom Image  Names Here
        var hideEye:String = "visibility_show"
        var showEye:String = "visibility"
           
       static let eyeContainerBounds = CGSize.init(width: 50, height: 50)
       static let eyeSelectorBounds = CGSize.init(width: 30, height: 30)
       static let eyeSelectorOrigin = CGPoint.init(x: 10, y: 10)
    
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           self.setup()
       }
       override var isSecureTextEntry: Bool{
           didSet{
               DispatchQueue.main.async {
                   self.eyeSelector.setImage(self.eyeImage?.withRenderingMode(.alwaysTemplate), for: .normal)
               }
           }
       }
       private var eyeImage:UIImage?{
           self.isSecureTextEntry ? UIImage(named: hideEye) : UIImage(named: showEye)
       }
       private var eyeContainer = {
           let view  = UIView.init(frame: CGRect.init(origin: .zero, size: eyeContainerBounds))
           return view
       }()
       private var eyeSelector = {
           let button  = UIButton.init(frame: CGRect.init(origin: eyeSelectorOrigin, size: eyeSelectorBounds))
           return button
       }()
       private func setup(){
           self.eyeSelector.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
           self.eyeSelector.tintColor = self.tintColor
           self.eyeContainer.addSubview(eyeSelector)
           self.rightView = eyeContainer
           self.rightViewMode = .always
       }
        @objc private func showHidePassword(){
           self.isSecureTextEntry = !self.isSecureTextEntry
       }
}
