//
//  POIAnnotationView.swift
//  CampusMap
//
//  Created by Chun on 2018/11/27.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit
import MapKit

class POIAnnotationView: MKAnnotationView {
    
    var fatherView:CampusViewController? = nil
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let poiAnnotation = self.annotation as? POIAnnotation else { return }
        
        image = poiAnnotation.type.image()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if(self.isSelected == selected){
            return
        }
        if annotation?.title == "我的位置"{
            return
        }
        if selected {
            fatherView?.showGoto((annotation?.coordinate)!)
        }else{
            fatherView?.removeGoto()
        }
    }
    
}
