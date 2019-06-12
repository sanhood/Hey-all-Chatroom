//
//  ProfileVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/15/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class ProfileVC: ParentVC {

    @IBOutlet var textFieldList: [UITextField]!
    
    @IBOutlet var txtFieldsLineViewList: [UIView]!
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    private var _waitingView = WaitingView()
    private var _taskCount = 1
    var isMyProfile = true
    var userProfileID:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        topConstraintToHeaderView?.constant += 30
        headTitle.text = "My Profile"
        var tag = 0
        for txtfield in textFieldList {
            txtfield.keyboardAppearance = .dark
            txtfield.textColor = UIColor.init(white: 0.95, alpha: 1)
            var placeholder = ""
            txtfield.isEnabled = isMyProfile
            txtfield.isEnabled = tag != 3
            if isMyProfile {
                placeholder = (tag == 0) ? "e.g. John" : (tag == 1) ? "e.g. Doe" : (tag == 2) ? "e.g. JD" : "e.g. johndoe@mail.com"
            }else{
                placeholder = "Not Entered"
                txtfield.isEnabled = false
            }
            txtfield.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.3, alpha: 1)])
            txtfield.delegate = self
            txtfield.tag = tag
            tag += 1
        }
        saveBtn.setTitle((isMyProfile) ? "Save" : "Favorite", for: .normal)
        fillPageWithInfo(user: myProfile)
        for view in txtFieldsLineViewList{
            view.alpha = 0.5
            view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        }
        bioTextView.delegate = self
        bioTextView.textColor = (bioTextView.text == "Enter your bio here..." || bioTextView.text == "Not Entered") ? UIColor.init(white: 0.95, alpha: 0.5) : UIColor.init(white: 0.95, alpha: 1)
        bioTextView.isEditable = isMyProfile
        saveBtn.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        self.view.backgroundColor = UIColor.Heyyo3.firstColor
        bioTextView.backgroundColor = UIColor.Heyyo3.secondColor
        if !isMyProfile {
            self.run()
        }
    }
    
    func fillPageWithInfo(user:Profile){
        textFieldList[0].text = (user.firstName != nil) ? user.firstName! : ""
        textFieldList[1].text = (user.lastName != nil) ? user.lastName! : ""
        textFieldList[2].text = user.nickName!
        textFieldList[3].text = user.email!
        bioTextView.text = (user.bio != nil) ? user.bio! : (isMyProfile) ? "Enter your bio here..." : "Not Entered"
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        if isMyProfile {
            let profile = Profile(id: myProfile.id, email: myProfile.email, nickName: textFieldList[2].text, token: myProfile.token, firstName: textFieldList[0].text, lastName: textFieldList[1].text, bio: (bioTextView.text != "Enter your bio here...") ? bioTextView.text : "", friendList: nil,status: true)
            Network.request(serverMethod: .editProfile(dictionary: profile.toDictionary())) { (response) in
                if response.status == 200 {
                    myProfile = profile
                }else{
                    
                }
            }
        }else{
            Network.request(serverMethod: .favUser(leftID: myProfile.id, rightID: userProfileID!)) { (response) in
                if response.status == 200 {
                    
                }else{
                    
                }
            }
        }
        
    }
}

extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.2) {
            self.txtFieldsLineViewList[textField.tag].alpha = 1
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.txtFieldsLineViewList[textField.tag].alpha = 0.5
        }
    }
}

extension ProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        bioTextView.text = (bioTextView.text == "Enter your bio here...") ? "" : bioTextView.text
        bioTextView.textColor = (bioTextView.text == "Enter your bio here...") ? UIColor.init(white: 0.95, alpha: 0.5) : UIColor.init(white: 0.95, alpha: 1)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        bioTextView.text = (bioTextView.text == "") ? "Enter your bio here..." : bioTextView.text
        bioTextView.textColor = (bioTextView.text == "Enter your bio here...") ? UIColor.init(white: 0.95, alpha: 0.5) : UIColor.init(white: 0.95, alpha: 1)
    }
}


extension ProfileVC:WaitingProtocol {
    var taskCount: Int {
        get {
            return _taskCount
        }
        set {
            _taskCount = newValue
            if _taskCount == 0 {
                didFinished()
            }
        }
    }
    
    var waitingView: WaitingView {
        get {
            return _waitingView
        }
        set {
            _waitingView = newValue
        }
    }
    
    func run() {
        self.view.addSubview(waitingView)
        waitingView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        Network.request(serverMethod: .getUserInfo(id: userProfileID!)) { (response) in
            if response.status == 200 {
                let value = response.data
                let profile = Profile(id: value["id"].int!, email: value["email"].string!, nickName: value["nickName"].string!, token: "0", firstName: value["firstName"].string, lastName: value["lastName"].string, bio: value["bio"].string, friendList: nil, status: value["status"].bool!)
                self.fillPageWithInfo(user: profile)
                self.headTitle.text = profile.nickName! + "'s Profile"
                self.taskCount -= 1
            }else{
                
            }
        }
    }
    
    func didFinished() {
        waitingView.removeFromSuperview()
    }
}
