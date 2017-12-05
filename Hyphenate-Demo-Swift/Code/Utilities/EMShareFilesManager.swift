//
//  EMShareFilesManager.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/5.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

class EMShareFilesManager {
    static let sharedInstance = EMShareFilesManager()

    init() {
        let ud = UserDefaults.standard
        if  ud.object(forKey: "creatShareFiles") == nil{
            creatShareFiles()
            ud.set("Saved", forKey: "creatShareFiles")
        }
    }
    
    func creatShareFiles() {
        for _ in 0...5 {
            let rendom = Int(arc4random()%10000) + 1
            let filePath = fileDocPath() + "ShareFile_" + String(rendom) + ".txt"
            let info = "FileName " + "ShareFile" + String(rendom) + ".txt"
            try! info.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }
    }
    
    func localFiles() -> Array<EMShareFileModel>? {
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        let contentsOfURL = try? manager.contentsOfDirectory(at: url.appendingPathComponent("ShareFiles"),includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        var retAry = Array<EMShareFileModel>()
        if contentsOfURL != nil {
            for fileURL in contentsOfURL! {
                let model = EMShareFileModel.init(fileURL.lastPathComponent, fileURL)
                retAry.append(model)
            }
        }

        return retAry
    }
    
    func downLoadPathWith(filename: String) -> String{
        return fileDocPath() + filename
    }
    
    func fileDocPath() -> String {
        let shareFileDoc:String = NSHomeDirectory() + "/Documents/ShareFiles/"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: shareFileDoc) {
            try! fileManager.createDirectory(atPath: shareFileDoc,
                                             withIntermediateDirectories: true, attributes: nil)
        }
        
        return shareFileDoc
    }
}

class EMShareFileModel {
    var fileName: String
    var fileURL: URL
    
    init(_ name:String, _ url: URL) {
        fileName = name
        fileURL = url
    }
}
