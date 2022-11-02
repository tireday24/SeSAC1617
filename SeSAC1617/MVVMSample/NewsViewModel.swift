//
//  NewsViewModel.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/20.
//


import Foundation
import RxSwift
import RxCocoa


class NewsViewModel {
    
    //observable에서 값이 들어가되 외부 매개변수는 와일드카드 처리되어 있어서 가능
    //var pageNumber: CObservable<String> = CObservable("3000")
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    
    //뉴스 추가 변화 뷰모델에 추가
    //이 데이터 기반으로 스냅샷 만듬
    //신호만 줄 수 있다
    //var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
    //var list = BehaviorSubject(value: News.items)
    var list = BehaviorRelay(value: News.items)
    
    //변화시 바인드로 바꿈
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        //사용자가 입력한 숫자
        //후에는 text로 인식을 못함
        //쉼표 대체
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else{ return }
        let result = numberFormatter.string(for: number)!
        //pageNumber 벨류값 바뀜 -> 옵져버블 실행
        //pageNumber.value = result
        pageNumber.onNext(result)
        
    }
    
    func resetSample() {
        //list.onNext([])
        list.accept([])
    }
    
    //데이터 처리는 여기서 무조건 처리
    func loadSample() {
        //list.onNext(News.items)
        list.accept(News.items)
    }
    
    
}
