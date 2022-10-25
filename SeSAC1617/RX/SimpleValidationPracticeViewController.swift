//
//  SimpleValidationPracticeViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

private let idLength = 5
private let pwLength = 5

class SimpleValidationPracticeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var simpleIdTextField: UITextField!
    @IBOutlet weak var simpleIdLabel: UILabel!
    @IBOutlet weak var simplePwTextField: UITextField!
    @IBOutlet weak var simplePwLabel: UILabel!
    @IBOutlet weak var simpleResultButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lengthConstraints()
     
    }
    
    func lengthConstraints() {
        simpleIdLabel.text = "ID는 \(idLength)자로 입렵해주세요"
        simplePwLabel.text = "PW는 \(pwLength)자로 입력해주세요"
    }
    
    func validate() {
        
        let idValidate =
        simpleIdTextField.rx.text.orEmpty.map{ $0.count >= idLength}
            .share(replay: 1)
        
        let pwValidate =
        simplePwTextField.rx.text.orEmpty
            .map { $0.count >= pwLength }
            .share(replay: 1)
        
        let idAndPwValidate =
        Observable.combineLatest(idValidate, pwValidate) {$0 && $1}
            .share(replay: 1)
        
        idValidate
            .bind(to: simplePwTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        idValidate
            .bind(to: simpleIdTextField.rx.isHidden)
            .disposed(by: disposeBag)
        
        pwValidate
            .bind(to: simplePwTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        simpleResultButton.rx.tap.subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag
            )
            
        }
    
    func showAlert() {
        let alert = UIAlertController(title: "ValidateRxExample", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }

    

}
