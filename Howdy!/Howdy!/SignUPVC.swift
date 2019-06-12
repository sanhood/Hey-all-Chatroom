//
//  SignUPVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/4/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class SignUPVC: ParentVC {
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondTextFiendTopConstraint: NSLayoutConstraint!
    let logoImg = UIImage(named: "salute")!.withRenderingMode(.alwaysTemplate)
    var letsGo = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.isHidden = true
        logoImageView.image = logoImg
        logoImageView.tintColor = UIColor.init(white: 0.90, alpha: 1)
        textField1.attributedPlaceholder = NSAttributedString(string: "Enter your email here",attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.3, alpha: 1)])
        textField1.delegate = self
        textField1.keyboardAppearance = .dark
        textField2.attributedPlaceholder = NSAttributedString(string: "Enter your name here",attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.3, alpha: 1)])
        textField2.delegate = self
        textField2.keyboardAppearance = .dark
        continueButton.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = (notification.name == UIResponder.keyboardWillShowNotification)
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
            })
        }
    }
    
    func emailValidation(email:String) -> Bool {
        return true
    }
    
    @IBAction func continueDidPressed(_ sender: UIButton) {
        if !letsGo {
            let email = textField1.text!
            if emailValidation(email: email) {
                Network.request(serverMethod: .signup(email: email)) { (response) in
                    if response.status == 200 {
                        sender.setTitle("Let's GO", for: .normal)
                        self.secondTextFiendTopConstraint.constant = 10
                        self.textField2.isHidden = false
                        self.lineView2.isHidden = false
                        self.textField1.isUserInteractionEnabled = false
                        self.textField1.alpha = 0.6
                        self.lineView1.alpha = 0.6
                        self.letsGo = true
                        myProfile = Profile(id: response.data["id"].int!, email: response.data["email"].string!, nickName: nil, token: response.data["token"].string!, firstName: nil, lastName: nil, bio: nil, friendList: nil,status: true)
                        myProfile.save()
                        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                            self.view.layoutIfNeeded()
                        })
                    }else{
                        //alert
                    }
                }
            }
        }else{
            let name = textField2.text!
            if name != "" {
                Network.request(serverMethod: .editProfile(dictionary: ["nickName":name])) { (response) in
                    if response.status == 200{
                        myProfile.nickName = name
                        myProfile.save()
                        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
                        nvc.pushViewController(vc, animated: true)
                        UserDefaults.standard.setValue(true, forKey: "loggedIn")
                    }else{
                        //alert
                    }
                }
            }
        }
    }
    
}

extension SignUPVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.2) {
            if textField.tag != 2 {
                self.lineView1.alpha = 1
            }else{
                self.lineView2.alpha = 1
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            if textField.tag != 2 {
                self.lineView1.alpha = 0.5
            }else{
                self.lineView2.alpha = 0.5
            }
        }
    }
}
