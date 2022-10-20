//
//  CObservable.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//

import Foundation

/*
 Observable
 */

class CObservable<T> {
    private var listener: ((T) -> Void)?
//    { value in
//        print("bind == \(value)")
//        self.numberTextField.text = value
//    }
    
    var value: T {
        didSet {
            //데이터가 바뀌면 listener가 실행되게 구조화 되어 있다
            listener?(value)
        }
    }
    
    //외부 매개변수 생략(3000)) 외부에서 받은 변수 value에 올려
    init(_ value: T) {
        self.value = value
    }
    
    //closure 구문 직접 실행
    //뷰디드로드 시점에 3000찍힌 이유(클로저 구문 실행)
    //클로저 구문을 프로퍼티에 저장
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
    
}

