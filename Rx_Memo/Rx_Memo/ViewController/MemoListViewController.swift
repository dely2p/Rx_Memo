//
//  MemoListViewController.swift
//  Rx_Memo
//
//  Created by dely on 2021/07/19.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var listTableView: UITableView!
    
    var viewModel: MemoListViewModel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "Cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
                
            }
            .disposed(by: rx.disposeBag)
    }
}
