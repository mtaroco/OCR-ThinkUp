//
//  OCRAPI.swift
//  OCR-POC
//
//  Created by Mauro Taroco on 4/3/18.
//  Copyright © 2018 ThinkUp. All rights reserved.
//

import Foundation

final class OCRAPI {
    
    /// The url to perform the requests on
    static let url = "https://westcentralus.api.cognitive.microsoft.com/vision/v1.0"
    
    /// Your private API key. If you havn't changed it yet, go ahead!
    static let key = "INSERT YOUR KEY HERE!"
    
    /// Detectable Languages
    enum Languages: String {
        case Automatic = "unk"
        case ChineseSimplified = "zh-Hans"
        case ChineseTraditional = "zh-Hant"
        case Czech = "cs"
        case Danish = "da"
        case Dutch = "nl"
        case English = "en"
        case Finnish = "fi"
        case French = "fr"
        case German = "de"
        case Greek = "el"
        case Hungarian = "hu"
        case Italian = "it"
        case Japanese = "Ja"
        case Korean = "ko"
        case Norwegian = "nb"
        case Polish = "pl"
        case Portuguese = "pt"
        case Russian = "ru"
        case Spanish = "es"
        case Swedish = "sv"
        case Turkish = "tr"
    }
    
    enum RecognizeCharactersErrors: Error {
        case unknownError
        case imageUrlWrongFormatted
        case emptyDictionary
    }
    
    /**
     Optical Character Recognition (OCR) detects text in an image and extracts the recognized characters into a machine-usable character stream.
     - parameter requestObject: The required information required to perform a request
     - parameter language: The languange
     - parameter completion: Once the request has been performed the response is returend in the completion block.
     */
    
    static func recognizeCharactersWithRequestImage(_ requestImage: Any, completion: @escaping (_ response: OCRResult?, _ errorStr: String? ) -> Void) throws {
        
        let requestUrlString = url + "/ocr?language=es&detectOrientation=true"
        let requestUrl = URL(string: requestUrlString)
        
        var request = URLRequest(url: requestUrl!)
        request.setValue(key, forHTTPHeaderField: "ocp-apim-subscription-key")
        
        // Request Parameter
        
        if let path = requestImage as? String {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"url\":\"\(path)\"}".data(using: String.Encoding.utf8)
        }
        else if let imageData = requestImage as? Data {
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.httpBody = imageData
        }
 
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    completion(nil, error?.localizedDescription)
                    return
                }else{
                    guard let httpResponse = response as? HTTPURLResponse else { return completion(nil, "status code error")}
                    print("statusCode: \(httpResponse.statusCode)")
                    
                    switch httpResponse.statusCode {
                    case 200..<300:
                        do {
                            let oCRResult = try JSONDecoder().decode(OCRResult.self, from: data!)
                            completion(oCRResult, "")
                        }catch let err{
                            print("Error -> \(err)")
                            completion(nil, error?.localizedDescription)
                        }
                    default:
                        let results = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        completion(nil, results!["message"] as? String)
                    }
                }
            }
        }
        task.resume()
        
    }
}
