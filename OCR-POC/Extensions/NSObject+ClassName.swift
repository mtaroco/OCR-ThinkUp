//
//  NSObject+ClassName.swift
//  Mauro Taroco
//
//  Created by Mauro Taroco on 8/17/17.
//  Copyright © 2017 Mauro Taroco. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
