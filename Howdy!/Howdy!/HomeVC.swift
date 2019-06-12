//
//  HomeVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/6/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class HomeVC: ParentVC {
    @IBOutlet weak var friendListBtn:UIButton!
    @IBOutlet weak var chatListBtn:UIButton!
    @IBOutlet weak var profileBtn:UIButton!
    @IBOutlet weak var tableView:UITableView!
    let profileImg = UIImage(named: "user-2")!.withRenderingMode(.alwaysTemplate)
    let friendListImg = UIImage(named: "team-leader")!.withRenderingMode(.alwaysTemplate)
    let chatListImg = UIImage(named: "bubble-speak")!.withRenderingMode(.alwaysTemplate)
    var formerChatroomsList = [Chatroom]()
    private var _waitingView = WaitingView()
    private var _taskCount = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        friendListBtn.setImage(friendListImg, for: .normal)
        chatListBtn.setImage(chatListImg, for: .normal)
        profileBtn.setImage(profileImg, for: .normal)
        friendListBtn.tintColor = UIColor.Heyyo3.thirdColor.lighter(by: 15)
        chatListBtn.tintColor = UIColor.Heyyo3.thirdColor.lighter(by: 15)
        profileBtn.tintColor = UIColor.Heyyo3.thirdColor.lighter(by: 15)
        let nib = UINib(nibName: "FormerChatroomCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        removeTapGesture()
//        tableView.delegate = self
//        tableView.dataSource = self
//        let c1 = Chatroom(name: "Footballllia", status: true, id: 352351, population: 800283, category: "sport")
//        let c2 = Chatroom(name: "Sportmen", status: false, id: 52351, population: 902, category: "sport")
//        formerChatroomsList.append(contentsOf: [c1,c2])
        leftBtn.isHidden = true
        headTitle.text = "Hey'all"
        tableView.tableFooterView = UIView()
    }
    
    func checkForFormerChatrooms(){
        formerChatroomsList.removeAll()
        if let arr = UserDefaults.standard.value(forKey: "formerChatroomsIDs") as? [Int] {
            for value in arr {
                let chatroom = Chatroom(name: nil, status: nil, id: value, population: nil, category: nil)
                formerChatroomsList.append(chatroom)
            }
            
        }
        _taskCount = 2
        self.run()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkForFormerChatrooms()
    }
    
    @IBAction func friendListBtnPressed(_ sender: Any) {
        let vc = FriendListVC(nibName: "FriendListVC", bundle: nil)
        nvc.pushViewController(vc, animated: true)
    }
    @IBAction func chatListBtnPressed(_ sender: Any) {
        let vc = ChatroomsListVC(nibName: "ChatroomsListVC", bundle: nil)
        nvc.pushViewController(vc, animated: true)
    }
    @IBAction func profileBtnPressed(_ sender: Any) {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        nvc.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formerChatroomsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FormerChatroomCell {
            cell.configure(chatroom: formerChatroomsList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatroom = formerChatroomsList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if chatroom.status {
            let alert = UIAlertController(title: "Alert", message: "Do you want to join to this chatroom again?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yep!", style: .default, handler: { _ in
                let vc = ChatroomVC(nibName: "ChatroomVC", bundle: nil)
                vc.chatroom = chatroom
                nvc.pushViewController(vc, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Nope!", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


extension HomeVC:WaitingProtocol {
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
        var IDs = ""
        for c in formerChatroomsList {
            IDs += "\(c.id!)-"
        }
        if IDs.length != 0 {
            IDs.removeLast()
        }
        
        Network.request(serverMethod: .getChatroomsByIDs(IDs: IDs)) { (response) in
            if response.status == 200 {
                for value in response.data {
                    let chatroom = Chatroom(name: value.1["name"].string!, status: value.1["status"].bool!, id: value.1["id"].int!, population: value.1["population"].int!, category: value.1["category"].string!)
                    self.formerChatroomsList[Int(value.0)!] = chatroom
                }
                self.taskCount -= 1
            }else{
                //alert
            }
        }
        
        Network.request(serverMethod: .editProfile(dictionary: ["status":1])) { (response) in
            if response.status == 200 {
                self.taskCount -= 1
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
