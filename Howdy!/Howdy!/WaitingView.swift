//
//  WaitingView.swift
//  Inbook
//
//  Created by Danoosh Chamani on 8/12/18.
//  Copyright © 2018 Danoosh Chamani. All rights reserved.
//

import UIKit
import Alamofire
class WaitingView: UIView {
    @IBOutlet weak var activity:UIActivityIndicatorView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var lastVisualView:UIView!
    @IBOutlet weak var retryButton:UIButton!
    var delegate:WaitingViewDelegate?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(style: .white)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    init() {
        super.init(frame: CGRect.zero)
        fromNib()
    }
    
    @objc func fetchSucced(notification: Notification){
        delegate?.didFinishWaiting(self)
        delegate = nil
    }
    @objc func fetchFailed(notification: Notification){
        activity.isHidden = true
        titleLabel.isHidden = true
        retryButton.isHidden = false
    }
    @IBAction func retryBtnPressed(_ sender:UIButton){
        activity.isHidden = false
        titleLabel.isHidden = false
        retryButton.isHidden = true
        //FetchManager.instance.fetch()
    }
    
    override func layoutSubviews() {
        let size = self.frame.size
        activityIndicator.frame = CGRect(x: (size.width-50)/2, y: (size.height-50)/2, width: 50, height: 50)
        titleLabel.frame = CGRect(x: (size.width-115)/2, y: (size.height-23+28+50)/2, width: 115, height: 23)
        activityIndicator.startAnimating()
        lastVisualView.addSubview(activityIndicator)
    }
}
//
//class WaitingView: UIView {
//    @IBOutlet weak var activity:UIActivityIndicatorView!
//    @IBOutlet weak var titleLabel:UILabel!
//    @IBOutlet weak var retryButton:UIButton!
//    var delegate:WaitingViewDelegate?
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        fromNib()
//    }
//    init() {
//        super.init(frame: CGRect.zero)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.fetchSucced),
//                                               name: .fetchSucceed,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.fetchFailed),
//                                               name: .fetchFailed,
//                                               object: nil)
//        fromNib()
//    }
//    @objc func fetchSucced(notification: Notification){
//        delegate?.didFinishWaiting(self)
//        delegate = nil
//    }
//    @objc func fetchFailed(notification: Notification){
//        activity.isHidden = true
//        titleLabel.isHidden = true
//        retryButton.isHidden = false
//    }
//    @IBAction func retryBtnPressed(_ sender:UIButton){
//        activity.isHidden = false
//        titleLabel.isHidden = false
//        retryButton.isHidden = true
//        FetchManager.instance.fetch()
//    }
//}
//class WaitingView: UIView {
//    @IBOutlet weak var activity:UIActivityIndicatorView!
//    @IBOutlet weak var titleLabel:UILabel!
//    @IBOutlet weak var retryButton:UIButton!
//    var delegate:WaitingViewDelegate?
//    var tasks:[ServerMethod]
//    var taskCount:Int = 0
//    let sem = DispatchSemaphore(value: 1)
//    required init?(coder aDecoder: NSCoder) {
//        tasks = [ServerMethod]()
//        super.init(coder: aDecoder)
//        fromNib()
//    }
//    init(tasks:[ServerMethod]) {
//        self.tasks = tasks
//        taskCount = tasks.count
//        super.init(frame: CGRect.zero)
//        fromNib()
//    }
//    func startTasks(){
//        for task in tasks {
//            DispatchQueue.global().async {
//                Network.request(serverMethod: task, completion: { (response) in
//                    self.sem.wait()
//                    switch response.status {
//                    case 200:
//                        self.taskCount -= 1
//                    default:
//                        print("damn!")
//                    }
//                    self.sem.signal()
//                })
//            }
//        }
//    }
//    @objc func fetchSucced(notification: Notification){
//        delegate?.didFinishWaiting(self)
//        delegate = nil
//    }
//    @objc func fetchFailed(notification: Notification){
//        activity.isHidden = true
//        titleLabel.isHidden = true
//        retryButton.isHidden = false
//    }
//    @IBAction func retryBtnPressed(_ sender:UIButton){
//        activity.isHidden = false
//        titleLabel.isHidden = false
//        retryButton.isHidden = true
//        FetchManager.instance.fetch()
//    }
//}
//class WaitingView: UIView {
//    @IBOutlet weak var activity:UIActivityIndicatorView!
//    @IBOutlet weak var titleLabel:UILabel!
//    @IBOutlet weak var retryButton:UIButton!
//    var delegate:WaitingViewDelegate?
//    var tasks:Array<(_ success: @escaping (Bool) -> ()) -> ()>
//    var taskCount:Int = 1 {
//        didSet {
//            if taskCount == 0 {
//                self.delegate?.didFinishWaiting(self)
//            }
//        }
//    }
//    let sem = DispatchSemaphore(value: 1)
//    required init?(coder aDecoder: NSCoder) {
//        tasks = [(@escaping (Bool) -> ()) -> ()]()
//        super.init(coder: aDecoder)
//        fromNib()
//    }
//    init(tasks:[(@escaping (Bool) -> ()) -> ()]) {
//        self.tasks = tasks
//        taskCount = tasks.count
//        super.init(frame: CGRect.zero)
//        fromNib()
//    }
//    func startTasksAsync(){
//        for task in tasks {
//
////                task({ sucess in
////                    if sucess {
////                        print("ok")
////                    }
////                })
//
//                task({ success in
//                    if success {
//                        self.taskCount -= 1
//                    }else{
//                        self.taskCount = self.taskCount + 0
//                    }
//                })
//
//        }
//    }
//    func startTasksSync(){
//
//    }
//    @objc func fetchSucced(notification: Notification){
//        delegate?.didFinishWaiting(self)
//        delegate = nil
//    }
//    @objc func fetchFailed(notification: Notification){
//        activity.isHidden = true
//        titleLabel.isHidden = true
//        retryButton.isHidden = false
//    }
//    @IBAction func retryBtnPressed(_ sender:UIButton){
//        activity.isHidden = false
//        titleLabel.isHidden = false
//        retryButton.isHidden = true
//        //FetchManager.instance.fetch()
//    }
//}
//extension WaitingView: WorkerDelegate {
//    func didFinishTask(isSucceed: Bool) {
//        if isSucceed {
//            self.taskCount -= 1
//        }else{
//            self.taskCount = self.taskCount + 0
//        }
//    }
//}
protocol WaitingViewDelegate : class {
    func didFinishWaiting (_ view : UIView)
//    func gotResponse(_ view: UIView, from serverMethod:ServerMethod, response:Network.RequestResponse)
}
//
//struct Worker {
//    var args =  [AnyObject]()
//    var task: (_ args: [AnyObject]?,_ success: @escaping (Bool) -> ()) -> ()
////    var task: ([AnyObject]) -> ()
//    var delegate:WorkerDelegate?
//
//    mutating func run(){
//        let closure: (Bool)->() = {
//            success in
////            self.delegate?.didFinishTask(isSucceed: success)
//            }
//        args.append(closure as AnyObject)
//        task(args)
//    }
//}
//
//protocol WorkerDelegate {
//    func didFinishTask(isSucceed:Bool)
//}


protocol WaitingProtocol {
    var taskCount:Int {get set}
    var waitingView:WaitingView {get set}
    func run()
    func didFinished()
}
