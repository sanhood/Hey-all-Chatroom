//
//  FriendListVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/7/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class FriendListVC: ParentVC {
    @IBOutlet weak var tableView:UITableView!
    var friendList = [Profile]()
    private var _waitingView = WaitingView()
    private var _taskCount = 1
    var inInviteMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FriendListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.Heyyo3.firstColor
        headTitle.text = "Friend List"
        self.run()
    }
}

extension FriendListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FriendListCell {
            cell.configure(friend: friendList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inInviteMode{
            let user = friendList[indexPath.row]
            if user.status {
                let alert = UIAlertController(title: "Alert", message: "Do you want to invite your friend to this chatroom?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Yep!", style: .default, handler: { _ in
                    let data = ["id":user.id]
                    AppDelegate.socket.emit("invite", data)
                    let alert = UIAlertController(title: "Alert", message: "Invite has been sent!", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        nvc.popViewController(animated: true)
                    }))
                }))
                alert.addAction(UIAlertAction(title: "Nope!", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Alert", message: "This user is offline", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension FriendListVC:WaitingProtocol {
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
        Network.request(serverMethod: .getFavList(myID: myProfile.id)) { (response) in
            if response.status == 200 {
                for value in response.data {
                    let profile = Profile(id: value.1["id"].int!, email: value.1["email"].string!, nickName: value.1["nickName"].string!, token: "0", firstName: value.1["firstName"].string, lastName: value.1["lastName"].string, bio: value.1["bio"].string, friendList: nil, status: value.1["status"].bool!)
                    self.friendList.append(profile)
                }
                self.taskCount -= 1
            }else{
                //alert
            }
        }
        
    }
    
    func didFinished() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        waitingView.removeFromSuperview()
    }
}
