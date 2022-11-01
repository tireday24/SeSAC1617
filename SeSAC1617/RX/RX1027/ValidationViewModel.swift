//
//  ValidationViewModel.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa

class ValidationViewModel {
    
    //Validation 문구
    //실시간으로 쓸 때 RX 활용
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요")
    
    struct Input {
        let text: ControlProperty<String?> // VC의 nameTextField.rx.text의 타입
        let tap: ControlEvent<Void> // VC의 stepButton.rx.tap
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void> //별도의 연산 내용이 없기 때문에 같음
        let text: Driver<String> //VC의 validText를 asDriver했기에
    }

    //데이터가 여러개면 매개변수가 여러개이다
    func transform(input: Input) -> Output {
        let valid = input.text
            .orEmpty //String
            .map { $0.count >= 8 } //Bool
            .share() //Subject, Relay
        
        let text = validText.asDriver()
        
        return Output.init(validation: valid, tap: input.tap, text: text)
    }
    
    
    
}
