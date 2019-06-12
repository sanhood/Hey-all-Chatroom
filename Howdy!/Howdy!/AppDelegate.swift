//
//  AppDelegate.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/3/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import UIKit
import SocketIO
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var initialViewController :UIViewController?
    var loggedIn = false
    static let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
    static let socket =  manager.defaultSocket
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UserDefaults.standard.setValue([1], forKey: "formerChatroomsIDs")
        if let li = UserDefaults.standard.value(forKey: "loggedIn") as? Bool {
            self.loggedIn = li
        }
        setupWindow()
        connectSocket()
        checkForInvites()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Network.request(serverMethod: .editProfile(dictionary: ["status":0])) { (_) in}
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Network.request(serverMethod: .editProfile(dictionary: ["status":1])) { (_) in}
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }


    func setupWindow(){
        if !loggedIn {
            initialViewController = SignUPVC(nibName: "SignUPVC", bundle: nil)
        }else{
//            initialViewController = FriendListVC(nibName: "FriendListVC", bundle: nil)
//             initialViewController = ProfileVC(nibName: "ProfileVC", bundle: nil)
//            (initialViewController as! ProfileVC).isMyProfile = false
//            (initialViewController as! ProfileVC).userProfileID = 2
            initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
//            initialViewController = ChatroomsListVC(nibName: "ChatroomsListVC", bundle: nil)
            myProfile = Profile()
            myProfile.load()
//            initialViewController = SignUPVC(nibName: "SignUPVC", bundle: nil)
//            initialViewController = ChatroomVC(nibName: "ChatroomVC", bundle: nil)
//            (initialViewController as! ChatroomVC).chatroom = Chatroom(name: "ali", status: true, id: 1, population: 1000, category: "sport")
        }
//        initialViewController = ChatroomVC(nibName: "ChatroomVC", bundle: nil)
        
//        initialViewController = HomeVC(nibName: "HomeVC", bundle: nil)
//        initialViewController = FriendListVC(nibName: "FriendListVC", bundle: nil)
//        initialViewController = ChatroomsListVC(nibName: "ChatroomsListVC", bundle: nil)
//        initialViewController = ProfileVC(nibName: "ProfileVC", bundle: nil)
        nvc = UINavigationController(rootViewController: initialViewController!)
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window!.rootViewController = nvc
        window!.makeKeyAndVisible()
    }
    
    func connectSocket(){
        AppDelegate.socket.on(clientEvent: .connect) { (_, _) in
            print("connected!")
        }
        AppDelegate.socket.connect()
        checkForInvites()
    }
    
    func checkForInvites(){
        AppDelegate.socket.on("invite") { (data, ack) in
            if let data = data[0] as? [String:Any] {
                if let id = data["id"] as? Int {
                    if id == myProfile.id {
                        let chatroomID = data["chatroomID"] as! Int
                        let chatroomName = data["chatroomName"] as! String
                        let chatroomCat = data["chatroomCat"] as! String
                        let chatroomPop = data["chatroomPop"] as! Int
                        let chatroom = Chatroom(name: chatroomName, status: true, id: chatroomID, population: chatroomPop, category: chatroomCat)
                        if let vc = nvc.topViewController as? ParentVC {
                            let pvc = PopoverNotificationVC(nibName: "PopoverNotificationVC", bundle: nil)
                            pvc.chatroom = chatroom
                            vc.configurePopOver(nv: pvc, size: CGSize(width: 80, height: 80))
                            vc.present(pvc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    

}

