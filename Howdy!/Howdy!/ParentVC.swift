//
//  ParentVC.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/3/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//
import UIKit

class ParentVC: UIViewController {
    @IBOutlet weak var topConstraintToHeaderView: NSLayoutConstraint?
    let headerView = UIView()
    let leftBtn = UIButton()
    let rightBtn = UIButton()
    let headTitle = UILabel()
    
    var tapGes: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGes)
        setHeaderView(title: "main")
        self.navigationController?.navigationBar.barStyle = .black
        // Do any additional setup after loading the view.
    }
    
    func setHeaderView(title: String,frame:CGRect = CGRect(x: 0, y: 0, width: screenSize.width, height: 70)){
        self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(headerView)
//        self.view.backgroundColor = UIColor.Inbook.backgroundColor
        headerView.frame = frame
        headerView.frame.size.height = suitableHeightForHeaderView()
        headerView.backgroundColor = UIColor.Heyyo3.fifthColor
        headTitle.text = title
        headTitle.textAlignment = .center
        headTitle.frame = CGRect(x: (screenSize.width - 150)/2, y: headerView.frame.maxY-20-(25/2), width: 150, height: 25)
        headTitle.adjustsFontSizeToFitWidth = true
        headTitle.textColor = UIColor.Heyyo3.thirdColor.lighter(by: 15)
        headTitle.font = UIFont(name: "Gill Sans", size: 20)
        leftBtn.addTarget(self, action: #selector(headerViewleftBtnPressed), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(headerViewRightBtnPressed), for: .touchUpInside)
        headerView.addSubview(leftBtn)
        headerView.addSubview(rightBtn)
        headerView.addSubview(headTitle)
        leftBtn.frame = CGRect(x: 20 - 12, y: headerView.frame.maxY-20-(50/2), width: 50, height: 50)
        leftBtn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        rightBtn.frame = CGRect(x: screenSize.width - 50 - 20 + 12, y: headerView.frame.maxY-20-(50/2), width: 50, height: 50)
        rightBtn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        let img = UIImage(named: "left-arrow")!.withRenderingMode(.alwaysTemplate)
        leftBtn.setImage(img, for: .normal)
        leftBtn.tintColor = UIColor.Heyyo3.thirdColor.lighter(by: 15)
        rightBtn.tintColor = UIColor.Heyyo3.thirdColor.lighter(by: 15)
        setTopConstraint()
    }
    
    private func setTopConstraint(){
        if let topConstraintToHeaderView = topConstraintToHeaderView {
            topConstraintToHeaderView.constant = headerView.frame.height
        }
    }
    
    private func suitableHeightForHeaderView() -> CGFloat{
        var height:CGFloat = 0
        switch UIDevice().type {
        case .iPhone5C,.iPhone5S,.iPhone5:
            height = 60
        case .iPhoneX,.iPhone6plus, .iPhone6Splus,.iPhone7plus,.iPhone8plus:
            height = 75
        default:
            height = 70
        }
        return height
    }
    
    @objc func headerViewleftBtnPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func headerViewRightBtnPressed(){}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func removeTapGesture(){
        self.view.removeGestureRecognizer(tapGes)
    }
    func addTapGesture(){
        self.view.addGestureRecognizer(tapGes)
    }
    func configurePopOver (nv : UIViewController , size:CGSize ) {
        nv.modalPresentationStyle = .popover
        nv.popoverPresentationController?.sourceView = self.view
        nv.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX + 60, y: self.view.bounds.minY + 100, width: 0, height: 0)
        nv.preferredContentSize = CGSize(width: size.width, height: size.height)
        nv.popoverPresentationController?.delegate = self
        nv.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
}

extension ParentVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
//        popoverPresentationController.containerView?.deBlurTheView()
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        // self.tableView.superview?.blurTheView()
//        popoverPresentationController.containerView?.blurTheView()
    }
}
