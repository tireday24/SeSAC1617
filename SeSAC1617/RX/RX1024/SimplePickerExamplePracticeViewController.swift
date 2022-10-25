//
//  SimplePickerExamplePracticeViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class SimplePickerExamplePracticeViewController: UIViewController {
    
    @IBOutlet weak var simplePickerView1: UIPickerView!
    @IBOutlet weak var simplePickerView2: UIPickerView!
    @IBOutlet weak var simplePickerView3: UIPickerView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just([1, 2, 3]).bind(to: simplePickerView1.rx.itemTitles) { _, item in
            return "\(item)"
        }
        .disposed(by: disposeBag)
        
        simplePickerView1.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selcted 1: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: simplePickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                          ])
            }
            .disposed(by: disposeBag)
        
        simplePickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 2: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: simplePickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        simplePickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                print("models selected 3: \(models)")
            })
            .disposed(by: disposeBag)
    }
}
        
        
     
