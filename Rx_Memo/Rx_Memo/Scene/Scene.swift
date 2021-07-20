//
//  Scene.swift
//  Rx_Memo
//
//  Created by dely on 2021/07/20.
//

import UIKit

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self {
        case .list(let viewModel):
            guard let nav = storyboard.instantiateViewController(identifier: "ListNav") as? UINavigationController else { fatalError() }
            guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError() }
            listVC.bind(viewModel: viewModel)
            return nav
        case .detail(let viewModel):
            guard var detailVC = storyboard.instantiateViewController(identifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
            detailVC.bind(viewModel: viewModel)
            return detailVC
        case .compose(let viewModel):
            guard let nav = storyboard.instantiateViewController(identifier: "ComposeNav") as? UINavigationController else { fatalError() }
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else { fatalError() }
            composeVC.bind(viewModel: viewModel)
            return nav
        }
    }
}
