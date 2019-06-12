//
//  FormerChatroomCell.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/6/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class FormerChatroomCell: UITableViewCell {
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var picImgView:UIImageView!
    @IBOutlet weak var statusImgView:UIImageView!
    @IBOutlet weak var populationLbl:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(chatroom:Chatroom){
        statusImgView.backgroundColor = (chatroom.status) ? UIColor.Heyyo3.thirdColor.lighter() : UIColor.gray.lighter()
        populationLbl.text = "\(chatroom.population!)"
        picImgView.image = UIImage(named: chatroom.category)
        nameLbl.text = chatroom.name
    }
    
}
