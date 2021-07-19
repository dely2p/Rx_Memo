//
//  Memo.swift
//  Rx_Memo
//
//  Created by dely on 2021/07/18.
//

import Foundation

struct Memo: Equatable {
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(origin: Memo, updatedContent: String) {
        self = origin
        self.content = updatedContent
    }
}
