//
//  TULoadingView.swift
//  Smartway
//
//  Created by Mauro Taroco on 11/5/17.
//  Copyright © 2017 ThinkUp. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let kLoadingViewTag = 10461
let kFullscreenLoadingViewTag = 10462

let darkBlueTUColor = UIColor(hex: 0x20262C)
let greenTUColor = UIColor(hex: 0x3EFFDE)

class TULoadingView: TUView {

    enum Mode {
        case normal
        case fullscreen
    }
    
    var viewMode: Mode = .normal {
        didSet { self.updateMode() }
    }
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var activityIndicatorView: NVActivityIndicatorView!
    
    override func setupView() {
        self.tag = kLoadingViewTag
        backgroundView.backgroundColor = .black
        
        activityIndicatorView.color = greenTUColor
        self.alpha = 0
    }
    
    private func updateMode() {
        switch viewMode {
        case .normal:
            backgroundView.backgroundColor = .black
            backgroundView.alpha = 1
            self.tag = kLoadingViewTag
            
        case .fullscreen:
            backgroundView.backgroundColor = darkBlueTUColor
            backgroundView.alpha = 1//0.5
            self.tag = kFullscreenLoadingViewTag
        }
    }
    
    func show() {
        startAnimating()
        
        UIView.animate(withDuration: 0.01, animations: {
            self.alpha = 1
        })// { [weak self] finished in
        //}
    }
    
    func hide() {
        stopAnimating()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { [weak self] finished in
            self?.removeFromSuperview()
        }
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
