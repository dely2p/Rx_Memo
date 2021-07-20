//
//  TransitionModel.swift
//  Rx_Memo
//
//  Created by dely on 2021/07/20.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
