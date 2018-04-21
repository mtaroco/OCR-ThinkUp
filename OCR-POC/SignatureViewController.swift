//
//  SignatureViewController.swift
//  OCR-POC
//
//  Created by Mauro Taroco on 4/16/18.
//  Copyright © 2018 ThinkUp. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController, SignatureDrawingViewControllerDelegate {

    // MARK: Private
    
    private let signatureViewController = SignatureDrawingViewController()
    
    @IBOutlet var signatureView: UIView!
    
    var completion: ((UIImage)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signatureViewController.delegate = self
        
        addChildViewController(signatureViewController)
        signatureView.addSubview(signatureViewController.view)
        signatureViewController.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: SignatureDrawingViewControllerDelegate
    
    func signatureDrawingViewControllerIsEmptyDidChange(controller: SignatureDrawingViewController, isEmpty: Bool) {
        //resetButton.isHidden = isEmpty
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        signatureViewController.reset()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if let sigImage = signatureViewController.fullSignatureImage {
            completion?(sigImage)
        }
        
        dismiss(animated: true)
    }
    
}
