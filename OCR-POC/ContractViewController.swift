//
//  ContractViewController.swift
//  OCR-POC
//
//  Created by Mauro Taroco on 4/16/18.
//  Copyright © 2018 ThinkUp. All rights reserved.
//

import UIKit

class ContractViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var insertSignatureBtn: UIButton!
    @IBOutlet var signatureImg: UIImageView!
    
    var name: String = ""
    var lastname: String = ""
    var documentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up Agreement"
        loadContract()
    }

    func loadContract() {
        let result = NSMutableAttributedString()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "( dd / MM / yyyy )"
        let todayDate = formatter.string(from: date)
        
        var contractStr = """
        In Montevideo, this Service agreement made on \(todayDate), between the company ThinkUp
        with address at Mario Cassinoni 1011, and the affiliate \(name + " " + lastname) with identity document \(documentId). The Service agreement is compromised on following underneath terms and conditions;:\n\n
        """
        
        let string1Clause = """
Article I – ACCEPTANCE OF TERMS. \nLorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce in imperdiet mi. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In consequat feugiat augue. Cras efficitur sapien velit, at dignissim magna facilisis vitae. Praesent ut ipsum vel enim iaculis volutpat. Nulla odio ipsum, lobortis ullamcorper magna et, viverra fermentum enim. In et ultricies tellus. In at erat vitae nisi aliquam pretium ut sed massa. Duis volutpat tincidunt mi, in imperdiet lorem molestie eget.\n\n
"""
        
        let string2Clause = """
Article II - DESCRIPTION OF SERVICE. \nMaecenas vulputate ut purus scelerisque blandit. Praesent ut pulvinar diam. Nullam id massa tristique lectus posuere ornare quis sed ligula. Cras quis urna eget velit egestas eleifend id eget eros. Phasellus volutpat nunc ex. Vivamus nulla lectus, vulputate in neque at, posuere pretium nulla. Etiam in orci sit amet magna molestie ultricies. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque eu feugiat orci. Pellentesque et urna fringilla, pharetra diam at, facilisis mauris. Praesent fermentum consectetur sapien.\n\n
"""
        
        let string3Clause = """
Article III - REGISTRATION INFORMATION. \nCurabitur aliquet eget arcu id dignissim. Phasellus pharetra tincidunt tellus eget hendrerit. Phasellus non ex id purus placerat dictum. Morbi mollis felis quis arcu cursus consectetur. Vestibulum suscipit lectus massa, nec consectetur nibh venenatis a. Etiam sit amet laoreet elit. Suspendisse nisi lectus, ultricies ac condimentum et, posuere nec diam. Nulla lacinia lobortis semper. Etiam quis turpis velit. Nullam sodales ac felis eu facilisis. Aenean tempor, dui id rhoncus rutrum, elit nisl placerat diam, quis aliquam erat sapien id risus. In ut magna id elit fermentum pharetra. Aenean tristique vel est eget sodales. Vivamus massa lectus, dapibus a faucibus ac, vestibulum quis lorem. Donec eros dui, interdum ac viverra et, dignissim non magna. Curabitur sit amet arcu velit.\n
"""
        
        contractStr = contractStr + string1Clause + string2Clause + string3Clause
        
        let attributedString = NSMutableAttributedString(string: contractStr)
        
        
        
        let attributes0: [NSAttributedStringKey : Any] = [
            .font: UIFont(name: "HelveticaNeue-Bold", size: 13)!
        ]
        
        let attributes1: [NSAttributedStringKey : Any] = [
            .font: UIFont(name: "HelveticaNeue-Bold", size: 13)!,
            .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ]
        
        let nsRange0 = NSString(string: contractStr).range(of: todayDate, options: String.CompareOptions.caseInsensitive)
        attributedString.addAttributes(attributes1, range: nsRange0)
        
        let nsRange1 = NSString(string: contractStr).range(of: name + " " + lastname, options: String.CompareOptions.caseInsensitive)
        attributedString.addAttributes(attributes0, range: nsRange1)
        
        let nsRange2 = NSString(string: contractStr).range(of: documentId, options: String.CompareOptions.caseInsensitive)
        attributedString.addAttributes(attributes0, range: nsRange2)
        
        let nsRange3 = NSString(string: contractStr).range(of: "Article I – ACCEPTANCE OF TERMS.", options: String.CompareOptions.caseInsensitive)
        attributedString.addAttributes(attributes0, range: nsRange3)
        
        let nsRange4 = NSString(string: contractStr).range(of: "Article II - DESCRIPTION OF SERVICE.", options: String.CompareOptions.caseInsensitive)
        attributedString.addAttributes(attributes0, range: nsRange4)
        
        let nsRange5 = NSString(string: contractStr).range(of: "Article III - REGISTRATION INFORMATION.", options: String.CompareOptions.caseInsensitive)
        attributedString.addAttributes(attributes0, range: nsRange5)
        
        
        result.append(attributedString)
        
        textView.attributedText = result
    }
    
    @IBAction func insertSignatureBtnPressed(_ sender: Any) {
        let signatureVC = self.storyboard?.instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
        signatureVC.completion = { image in
            self.signatureImg.image = image
            self.insertSignatureBtn.isHidden = true
        }
        present(signatureVC, animated: true, completion: nil)
    
    }
    
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        
        showFullscreenLoadingView()
        perform(#selector(popToRoot), with: nil, afterDelay: 3)
        perform(#selector(hideFullscreenLoadingView), with: nil, afterDelay: 3.1)
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: false)
    }
    
}

extension ContractViewController {
    func showFullscreenLoadingView() {
        let window = UIApplication.shared.keyWindow!
        let loadingView = window.viewWithTag(kFullscreenLoadingViewTag)
        
        if loadingView != nil {
            if let tuLoadingView = loadingView as? TULoadingView {
                tuLoadingView.show()
            }
            
        }
        else {
            let loadingView = TULoadingView()
            loadingView.viewMode = .fullscreen
            window.addSubview(loadingView)
            loadingView.insetsZeroToSuperview()
            loadingView.show()
        }
    }
    
    @objc func hideFullscreenLoadingView() {
        let window = UIApplication.shared.keyWindow!
        let loadingView = window.viewWithTag(kFullscreenLoadingViewTag)
        
        if loadingView != nil {
            if let tuLoadingView = loadingView as? TULoadingView {
                tuLoadingView.hide()
            }
            
        }
    }
}
