//
//  ViewController.swift
//  OCR-POC
//
//  Created by Mauro Taroco on 4/3/18.
//  Copyright © 2018 ThinkUp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Contract"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func takePhotoBtnPressed(_ sender: Any) {
        takePhoto()
    }
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    //MARK: - Take image
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            self.showAlert(title: "Warning", message: "Oops, It seems that Camera is not available in this device. We are going to pick a photo from the bundle :) ", actionTitles: ["Ok"], actions:[{action1 in
                let image = UIImage(named: "cedula-identidad")
                    self.goToOCRVC(withImage: image)
                }, nil])
        }
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
            self.goToOCRVC(withImage: image)
        })
    }
    
    func goToOCRVC(withImage image: UIImage?) {
        let ocrVC = self.storyboard?.instantiateViewController(withIdentifier: "OCRViewController") as! OCRViewController
        ocrVC.imageToRead = image
        self.navigationController?.pushViewController(ocrVC, animated: true)
    }
    
    func showAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
