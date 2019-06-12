//
//  FriendListCell.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/7/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var statusLbl:UILabel!
    @IBOutlet weak var friendImgView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        statusLbl.textColor = UIColor.Heyyo3.thirdColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(friend:Profile){
        nameLbl.text = friend.nickName
        statusLbl.text = (friend.status) ? "Online" : "Offline"
    }

}
