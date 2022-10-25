//
//  NumbersPracticeViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class NumbersPracticeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var simpleNumberTextField1: UITextField!
    @IBOutlet weak var simpleNumberTextField2: UITextField!
    @IBOutlet weak var simpleNumberTextField3: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberExample()
        
    }
    
    func numberExample() {
        Observable.combineLatest(simpleNumberTextField1.rx.text.orEmpty, simpleNumberTextField2.rx.text.orEmpty, simpleNumberTextField3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    
    

    

}
