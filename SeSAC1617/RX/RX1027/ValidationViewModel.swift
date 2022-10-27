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
    
    
    
}
