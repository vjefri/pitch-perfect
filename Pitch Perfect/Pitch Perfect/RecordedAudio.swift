//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jefri Vanegas on 4/2/15.
//  Copyright (c) 2015 Jefri Vanegas. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}