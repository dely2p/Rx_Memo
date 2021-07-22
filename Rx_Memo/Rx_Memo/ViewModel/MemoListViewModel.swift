//
//  MemoListViewModel.swift
//  Rx_Memo
//
//  Created by dely on 2021/07/19.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
