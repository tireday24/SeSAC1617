//
//  SubjectViewModel.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/25.
//

import Foundation
import RxSwift


struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "Jack", age: 21, number: "01012341234"),
        Contact(name: "Metaverse Jack", age: 23, number: "01045678912"),
        Contact(name: "Real Jack", age: 25, number: "01034567891")
    ]
    
    var list = PublishSubject<[Contact]>() //구독 전에 이벤트를 전달한다면? -> 무시된다
    
    
    func fetchData() {
        //리스트에 컨텍트 데이터 추가하겠다
        list.onNext(contactData)
    }
    
    func restData() {
        //값 초기화 하겠다 빈배열 넣어 주겠다
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
        //배열에 요소를 추가하고 배열을 추가해준다
        contactData.append(new)
        list.onNext(contactData)
        
        //이벤트의 요소만 들어옴 덮어쓰여진다 onNext? = 의미
        //list.onNext([new])
        
    }
    
    func filterData(query: String) {
        
        let result = query != "" ? contactData.filter { $0.name.contains(query)} : contactData
        list.onNext(result)
        
    }
    
    
}
