//
//  UIView+Creations.swift
//  Mauro Taroco
//
//  Created by Mauro Taroco on 8/17/17.
//  Copyright © 2017 Mauro Taroco. All rights reserved.
//

import UIKit

extension UIView {

    // two ways to put off the rule, should never be usedd since is all new code
    class func fromNib<T: UIView>(withName name: String, bundle: Bundle? = nil) -> T {
        // swiftlint:disable:next force_cast
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as! T
    }
    // swiftlint:disable force_cast
    class func viewFromNib(withName name: String, bundle: Bundle? = nil) -> UIView {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    // swiftlint:enable force_cast
    
    class func loadFirstViewFromNib<T: UIView>(bundle: Bundle? = nil) -> T {
        // swiftlint:disable:next force_cast
        return UINib(nibName: T.className, bundle: bundle).instantiate(withOwner: self, options: nil).first as! T
    }
    
    // Fuente: https://stackoverflow.com/a/26018312
    @discardableResult
    func loadViewFromNib<T: UIView>() -> T? {
        guard let contentView = Bundle.main.loadNibNamed(self.className, owner: self, options: nil)?.first as? T else {
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insetsZeroToSuperview()
        return contentView
    }
}
