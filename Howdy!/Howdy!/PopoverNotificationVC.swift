//
//  PopoverNotificationVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/16/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class PopoverNotificationVC: UIViewController {
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var catLbl:UILabel!
    @IBOutlet weak var popLbl:UILabel!
    var chatroom:Chatroom!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func configure(chatroom:Chatroom){
        self.chatroom = chatroom
        nameLbl.text = chatroom.name
        catLbl.text = chatroom.category
        popLbl.text = "\(chatroom.population!)"
    }
    @IBAction func btnPressed(_ sender:UIButton){
        let vc = ChatroomVC(nibName: "ChatroomVC", bundle: nil)
        vc.chatroom = chatroom
        nvc.pushViewController(vc, animated: true)
    }
}
