//
//  popupView.swift
//  CampusMap
//
//  Created by 冷嘉怿 on 2018/12/2.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit

class popupView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let tohere = UIButton()
    var Map:CampusViewController? = nil
    override var frame: CGRect{
        didSet{
            fixLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        tohere.backgroundColor = UIColor.blue
        tohere.addTarget(self, action: #selector(goToHere), for: .touchUpInside)
        addSubview(tohere)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fixLayout(){
        tohere.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        tohere.setImage(UIImage(named: "tohere"), for: .normal)
        tohere.center = CGPoint(x: frame.width/2, y: frame.height/2)
    }
    @objc func goToHere(){
            Map?.Navigate()
    }
}
