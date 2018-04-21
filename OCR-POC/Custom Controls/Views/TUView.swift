//
//  TUView.swift
//  Mauro Taroco
//
//  Created by Mauro Taroco on 9/27/17.
//  Copyright © 2017 Mauro Taroco. All rights reserved.
//

import UIKit

class TUView: UIView {

    // MARK: - Initializers
    
    override init(frame: CGRect) { //For using CustomView in code
        super.init(frame: CGRect.zero)
        loadViewFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) { //For using CustomView in IB
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupView()
    }
    
    // MARK: CustomView methods
    
    func setupView() {}

}
