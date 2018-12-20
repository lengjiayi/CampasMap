//
//  curLocView.swift
//  CampusMap
//
//  Created by 闫雨呼 on 2018/12/2.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit
import MapKit

class curLocView: MKAnnotationView{

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let g = UIGraphicsGetCurrentContext()!
        UIColor(red: 66.0/255, green: 84.0/255, blue: 213.0/255, alpha: 1.0).setFill()
        g.fillEllipse(in: frame)
    }
    

}
