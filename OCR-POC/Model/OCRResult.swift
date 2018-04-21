//
//  OCRResult.swift
//  OCR-POC
//
//  Created by Mauro Taroco on 4/3/18.
//  Copyright © 2018 ThinkUp. All rights reserved.
//

import Foundation

class OCRResult: Codable {
    let language: String?
    let orientation: String?
    let textAngle: Int?
    let regions: [Region]?
    
//    enum CodingKeys: String, CodingKey {
//        case language = "language"
//        case orientation = "orientation"
//        case textAngle = "textAngle"
//        case regions = "regions"
//    }
    
    func getTextForLineAfter(_ referenceStr: String, linesAfter: Int = 1) -> String {
        var lineText : String = ""
        guard let line = getLineAfter(referenceStr, linesAfter: linesAfter) else { return "" }
        if let words = line.words {
            for word in words {
                let text = word.text ?? ""
                lineText += text + " "
            }
        }
        
        if lineText.hasSuffix(" ") {
            lineText = String(lineText.dropLast())
        }
        
        return lineText
    }
    
    func getLineAfter(_ referenceStr: String, linesAfter: Int = 1) -> Line? {
        if let regionsz = self.regions {
            for reigons1 in regionsz {
                if let lines = reigons1.lines {
                    for (lindex,line) in lines.enumerated(){
                        if let words = line.words {
                            for (_, word) in words.enumerated() {
                                let text = word.text ?? "\n"
                                if text.lowercased().contains(referenceStr.lowercased()) {
                                    return reigons1.lines![lindex+linesAfter]
                                }
                            }
                        }
                    }
                }
            }
            
        }
        return nil
    }
}

class Region: Codable {
    let boundingBox: String?
    let lines: [Line]?
    
//    enum CodingKeys: String, CodingKey {
//        case boundingBox = "boundingBox"
//        case lines = "lines"
//    }
}

class Line: Codable {
    let boundingBox: String?
    let words: [Word]?
    
//    enum CodingKeys: String, CodingKey {
//        case boundingBox = "boundingBox"
//        case words = "words"
//    }
}

class Word: Codable {
    let boundingBox: String?
    let text: String?
    
//    enum CodingKeys: String, CodingKey {
//        case boundingBox = "boundingBox"
//        case text = "text"
//    }
}
