//
//  ChatCell.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/3/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    @IBOutlet weak var noBubbleView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTxtViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var abbNameLbl: UILabel!
    static var colorsForPeople = [Int:UIColor]()
    let grayBubbleImage = UIImage(named: "bubble_left")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    let blueBubbleImage = UIImage(named: "bubble_right")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    var leftConstraint:NSLayoutConstraint!
    var rightConstraint:NSLayoutConstraint!
    
    var message:Message!
    override func awakeFromNib() {
        super.awakeFromNib()
        leftConstraint = NSLayoutConstraint(item: bubbleImageView!, attribute: .trailing, relatedBy: .equal, toItem: profileImageView, attribute: .leading, multiplier: 1, constant: 8)
        rightConstraint = NSLayoutConstraint(item: bubbleImageView!, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 8)
    }
    

    func configure(message:Message){
        removeConstraint(leftConstraint)
        removeConstraint(rightConstraint)
        leftConstraint.isActive = false
        rightConstraint.isActive = false
        self.message = message
        messageTextView.text = message.text
        let messageText = message.text! + "\n"
        if let val = ChatCell.colorsForPeople[message.senderID] {
            profileImageView.backgroundColor = val
        }else{
            ChatCell.colorsForPeople[message.senderID] = UIColor().randomValue
            profileImageView.backgroundColor = ChatCell.colorsForPeople[message.senderID]
        }
        
        
        abbNameLbl.text = message.sender[0..<2].uppercased()
//        profileImageView.image = UIImage(named: message.sender)
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "Gill Sans", size: 19)!], context: nil)
        if !message.isMe {
            nameLbl.text = message.sender
            leftConstraint = NSLayoutConstraint(item: bubbleImageView!, attribute: .leading, relatedBy: .equal, toItem: profileImageView, attribute: .trailing, multiplier: 1, constant: 5)
            addConstraint(leftConstraint)
            profileImageView.isHidden = false
            bubbleImageView.image = grayBubbleImage
            bubbleImageView.tintColor = UIColor.Heyyo3.secondColor
            noBubbleView.backgroundColor = UIColor.Heyyo3.secondColor
            messageTextView.textColor = UIColor.init(white: 0.85, alpha: 1)
            heightConstraint.constant = estimatedFrame.height + 20
            topTxtViewConstraint.constant = 17
        }else{
            nameLbl.text = ""
            rightConstraint = NSLayoutConstraint(item: bubbleImageView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -5)
            addConstraint(rightConstraint)
            profileImageView.isHidden = true
            bubbleImageView.image = blueBubbleImage
            bubbleImageView.tintColor = UIColor.Heyyo3.thirdColor
            noBubbleView.backgroundColor = UIColor.Heyyo3.thirdColor
            messageTextView.textColor = UIColor.white
            heightConstraint.constant = estimatedFrame.height + 6
            topTxtViewConstraint.constant = 5
        }
        let estimatedFrameForName = NSString(string: message.sender).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "Gill Sans", size: 17)!], context: nil)
        noBubbleView.isHidden = true
        bubbleImageView.isHidden = false
        abbNameLbl.isHidden = false
        widthConstraint.constant = estimatedFrame.width + 36
        if widthConstraint.constant < estimatedFrameForName.width + 10 && !message.isMe{
            widthConstraint.constant = estimatedFrameForName.width + 10
        }
        self.bubbleImageView.layoutIfNeeded()
        
    }
    
    func setForSameSender(){
        profileImageView.isHidden = true
        noBubbleView.isHidden = false
        bubbleImageView.isHidden = true
        abbNameLbl.isHidden = true
    }
    
    
    @IBAction func goToProfile(_ sender:UIButton){
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        vc.isMyProfile = false
        vc.userProfileID = message.senderID
        nvc.pushViewController(vc, animated: true)
    }
}
