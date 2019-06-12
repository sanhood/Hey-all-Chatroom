//
//  ChatroomsListCell.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/8/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class ChatroomsListCell: UITableViewCell {
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var categoryLbl:UILabel!
    @IBOutlet weak var populationLbl:UILabel!
    @IBOutlet weak var imageview:UIImageView!
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
        nameLbl.text = chatroom.name
        categoryLbl.text = chatroom.category
        populationLbl.text = "\(chatroom.population!)"
        imageview.image = UIImage(named: chatroom.category)
    }
}
