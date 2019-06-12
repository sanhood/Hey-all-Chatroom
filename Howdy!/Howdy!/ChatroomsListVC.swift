//
//  ChatroomsListVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/8/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit

class ChatroomsListVC: ParentVC {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    var chatroomsList = [Chatroom]()
    var timer = Timer()
    var nameToSearch = ""
    private var _waitingView = WaitingView()
    private var _taskCount = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeTapGesture()
        searchBar.delegate = self
        let nib = UINib(nibName: "ChatroomsListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.Heyyo3.firstColor.lighter(by: 0.8)
        self.tableView.backgroundColor = UIColor.clear
        headTitle.text = "Chatrooms"
        self.run()
    }
    
    @objc func searchChatroomByName(){
        nameToSearch = searchBar.text!
        searchBar.isUserInteractionEnabled = false
        self.run()
    }

}

extension ChatroomsListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatroomsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ChatroomsListCell {
            cell.configure(chatroom: chatroomsList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Alert", message: "Do you want to join to this chatroom ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yep!", style: .default, handler: { _ in
            let vc = ChatroomVC(nibName: "ChatroomVC", bundle: nil)
            vc.chatroom = self.chatroomsList[indexPath.row]
            var tmp = [Int]()
            if let arr = UserDefaults.standard.value(forKey: "formerChatroomsIDs") as? [Int] {
                tmp = arr
            }
            tmp.append(self.chatroomsList[indexPath.row].id)
            UserDefaults.standard.setValue(tmp, forKey: "formerChatroomsIDs")
            nvc.pushViewController(vc, animated: true)
        }))
//        alert.addAction(UIAlertAction(title: "Invite other people", style: .default, handler: { _ in
//            //user a global var called whoToInvite
//        }))
        alert.addAction(UIAlertAction(title: "Nope!", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

extension ChatroomsListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(searchChatroomByName), userInfo: nil, repeats: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        timer.invalidate()
        searchChatroomByName()
    }
}


extension ChatroomsListVC: WaitingProtocol {
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
        self.taskCount = 1
        self.chatroomsList.removeAll()
        self.view.addSubview(waitingView)
        waitingView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        Network.request(serverMethod: .getChatroomsByName(name: nameToSearch)) { (response) in
            if response.status == 200 {
                for value in response.data {
                    let chatroom = Chatroom(name: value.1["name"].string!, status: value.1["status"].bool!, id: value.1["id"].int!, population: value.1["population"].int!, category: value.1["category"].string!)
                    self.chatroomsList.append(chatroom)
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
        searchBar.isUserInteractionEnabled = true
        tableView.reloadData()
        waitingView.removeFromSuperview()
    }
}
