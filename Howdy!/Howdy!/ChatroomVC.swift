//
//  ChatroomVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/3/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit
import SocketIO
class ChatroomVC: ParentVC {
    var messages = [Message]()
    var samePersonSections = [Int]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputTextView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    var isFooterHidden = false
    var chatroom: Chatroom!
//    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
//    var socket: SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let message1 = Message(text: "سلام بچه ها", isMe: false, sender: "jahan")
//        let message2 = Message(text: "بازیه بعدیه تیم کیه؟", isMe: false, sender: "jahan")
//        let message3 = Message(text: "salam\nnemidunam haghighat!!", isMe: false, sender: "sardar")
//        let message4 = Message(text: "فرداس", isMe: true, sender: "danoosh")
//        let message5 = Message(text: "نه بابا فردا نیس. بازی بعدیمون ۲۱امه. سردار چرا فینگلیش تایپ می‌کنی؟ فارسی تایپ کن!", isMe: false, sender: "dejagah")
//        messages.append(contentsOf: [message1,message2,message3,message4,message5])
        
        makeSamePersonsSections()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        setupWindow()
        headTitle.text = chatroom.name
//        self.socket = manager.defaultSocket
        self.setSocketEvents()
//        AppDelegate.socket.connect()
    }
    
    func setupWindow(){
        let nib = UINib(nibName: "ChatCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.delegate = self
        collectionView.dataSource = self
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.keyboardAppearance = .dark
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Text...",attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.8, alpha: 1)])
        textField.textColor = UIColor.white
        textField.backgroundColor = UIColor.Heyyo3.secondColor
        sendBtn.backgroundColor = UIColor.Heyyo3.secondColor
        sendBtn.setTitleColor(UIColor.Heyyo3.thirdColor, for: .normal)
        collectionView.backgroundColor = UIColor.Heyyo3.firstColor
        self.view.backgroundColor = UIColor.Heyyo3.firstColor
        let img = UIImage(named: "curve-arrow")?.withRenderingMode(.alwaysTemplate)
        let invFriendImg = UIImage(named: "add-user")?.withRenderingMode(.alwaysTemplate)
        rightBtn.setImage(invFriendImg!, for: .normal)
        sendBtn.setImage(img, for: .normal)
        sendBtn.tintColor = UIColor.Heyyo3.thirdColor.lighter(by: 15)
        textField.roundCorners(corners: [.topLeft], radius: 17)
        sendBtn.roundCorners(corners: [.topRight], radius: 17)
//        UIApplication.shared.statusBarStyle = .default
    }
    
    override func headerViewRightBtnPressed() {
        let vc = FriendListVC(nibName: "FriendListVC", bundle: nil)
        vc.inInviteMode = true
        nvc.pushViewController(vc, animated: true)
    }
    
    func makeSamePersonsSections(){
        samePersonSections.removeAll()
        var lastMessage:Message!
        for (index, element) in messages.enumerated() {
            if index != 0 && index != messages.count-1{
                if lastMessage.sender != element.sender {
                    samePersonSections.append(index-1)
                }
            }
            if index == messages.count-1 {
                if index != 0 && lastMessage.sender != element.sender {
                    samePersonSections.append(index-1)
                }
                samePersonSections.append(index)
            }
            lastMessage = element
        }
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = (notification.name == UIResponder.keyboardWillShowNotification)
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing {
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    @IBAction func sendBtnPressed(_ sender:UIButton){
        var data = [String:Any]()
        data["message"] = textField.text!
        data["chatroomID"] = chatroom.id!
        data["senderName"] = myProfile.nickName!
        data["senderID"] = myProfile.id!
        AppDelegate.socket.emit("message", data)
//        let pvc = PopoverNotificationVC(nibName: "PopoverNotificationVC", bundle: nil)
//        self.configurePopOver(nv: pvc, size: CGSize(width: 80, height: 80))
//        self.present(pvc, animated: true, completion: nil)
    }
    
    
    private func setSocketEvents(){
        AppDelegate.socket.on("message") { (data, ack) in
            if let data = data[0] as? [String:Any] {
                if data["chatroomID"] as? Int == self.chatroom.id {
                    self.textField.text = ""
                    let newMessage = Message(json: data)
                    var indexPath = IndexPath(row: 0, section: 0)
                    if self.messages.isEmpty {
                        self.messages.append(newMessage)
                    }else{
                        for x in (0 ..< self.messages.count).reversed() {
                            if self.messages[x].timeStamp <= newMessage.timeStamp {
                                self.messages.insert(newMessage, at: x+1)
                                indexPath = IndexPath(row: x+1, section: 0)
                                break
                            }
                        }
                    }
                    self.makeSamePersonsSections()
//                    self.collectionView.insertItems(at: [indexPath])
                    self.collectionView.reloadData()
                    let lastIndexPath = IndexPath(row: self.messages.count-1, section: 0)
                    self.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}


extension ChatroomVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChatCell {
            let message = messages[indexPath.row]
            cell.configure(message: message)
            if !samePersonSections.contains(indexPath.row){
                cell.setForSameSender()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if var messageText = messages[indexPath.row].text {
            let const = (messages[indexPath.row].isMe) ? 6 : 20
            messageText = messageText + "\n"
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: UIScreen.main.bounds.width, height: estimatedFrame.height + CGFloat(const))
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
            return footer
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isFooterHidden {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionView.frame.width - 20, height: 5)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
}
