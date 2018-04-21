//
//  UIView+SnapKit.swift
//  Mauro Taroco
//
//  Created by Mauro Taroco on 8/18/17.
//  Copyright © 2017 Mauro Taroco. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
        
    func insetsZeroToSuperview() {
        
        self.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.superview!).inset(UIEdgeInsets.zero)
        }
    }
}
