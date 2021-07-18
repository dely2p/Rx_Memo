//
//  MemoStorageType.swift
//  Rx_Memo
//
//  Created by dely on 2021/07/18.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<[Memo]>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<[Memo]>
}