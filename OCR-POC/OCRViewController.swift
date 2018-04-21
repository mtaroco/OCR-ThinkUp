//
//  OCRViewController.swift
//  OCR-POC
//
//  Created by Mauro Taroco on 4/3/18.
//  Copyright © 2018 ThinkUp. All rights reserved.
//

import UIKit

class OCRViewController: UIViewController {
    
    var imageToRead: UIImage?
    var imageDataToRead: Data?
    @IBOutlet weak var resultTextView: UITextView!
    
    var name: String = ""
    var lastname: String = ""
    var documentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        showFullscreenLoadingView()
        imageDataToRead = compressImage(imageToRead!)
        recognizeImage()
    }
    
    func compressImage(_ image: UIImage) -> Data {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 600.0
        let maxWidth: Float = 800.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: CGFloat = 1
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext() as UIImage!
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext()
        return imageData!
    }
    
    func recognizeImage() {
        guard let imgData = imageDataToRead else { return }
        
        do {
            try OCRAPI.recognizeCharactersWithRequestImage(imgData) { (response, errorStr) in
                self.hideFullscreenLoadingView()
                
                if let errorMsg = errorStr, errorMsg.count > 0 {
                    let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                else {
                    if let ocrResult = response {
                        var resultStr = "Name: \n"
                        let auxName = ocrResult.getTextForLineAfter("nombre")
                        resultStr += auxName + "\n\n"
                        resultStr += "Lastname: \n"
                        let auxLastName = ocrResult.getTextForLineAfter("apellido")
                        resultStr += auxLastName + "\n\n"
                        
                        
                        resultStr += "Document Id: \n"
                        let auxDocumentId = ocrResult.getTextForLineAfter("documento", linesAfter: 2)
                        resultStr += auxDocumentId + "\n"
                        
                        self.name = auxName
                        self.lastname = auxLastName
                        self.documentId = auxDocumentId
                        
                        self.resultTextView.text = resultStr
                        self.printExtractedText(ocrResult)
                        
                        if !(auxName.count > 0) || !(auxLastName.count > 0) || !(auxDocumentId.count > 0) {
                            let alert = UIAlertController(title: "Error", message: "Some of the required fields wasn't detected", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                    else {
                        let alert = UIAlertController(title: "Error", message: "No data detected", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        } catch {
            hideFullscreenLoadingView()
        }
    }
    
    func printExtractedText(_ ocrResult: OCRResult) {
        let extractedText = extractText(ocrResult)
        print(extractedText)
    }
    
    func extractText(_ ocrResult: OCRResult) -> String {
        var extractedText : String = ""
        if let regionsz = ocrResult.regions {
            for reigons1 in regionsz {
                if let lines = reigons1.lines {
                    for line in lines{
                        if let words = line.words {
                                for word in words {
                                        let text = word.text ?? "\n"
                                        //print(text)
                                        extractedText += text + " "
                                }
                        }
                    }
                }
            }
            
        }
        return extractedText
    }
    @IBAction func createContractBtnPressed(_ sender: Any) {
        let contractVC = self.storyboard?.instantiateViewController(withIdentifier: "ContractViewController") as! ContractViewController
        contractVC.name = name
        contractVC.lastname = lastname
        contractVC.documentId = documentId
        self.navigationController?.pushViewController(contractVC, animated: true)
    }
}

extension OCRViewController {
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
    
    func hideFullscreenLoadingView() {
        let window = UIApplication.shared.keyWindow!
        let loadingView = window.viewWithTag(kFullscreenLoadingViewTag)
        
        if loadingView != nil {
            if let tuLoadingView = loadingView as? TULoadingView {
                tuLoadingView.hide()
            }
            
        }
    }
}
