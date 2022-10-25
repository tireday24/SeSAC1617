//
//  RxCocoaPracticeViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class RxCocoaPracticeViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doOnExample()
    }
    
    //아무것도 emit 하지 않고 무한한 상태
    //항목을 저장하지 않고 종료되지 않음
    func neverExample() {
        let neverSequence = Observable<String>.never()
        
        let neverSequenceSubscription = neverSequence
            .subscribe { _ in
                print("This will never be printed")
            }
        neverSequenceSubscription.disposed(by: disposeBag)
    }
    
    //아무것도 emit 하지 않는 Observble 생성하고 종료도 한다
    func emptyExample() {
        
        Observable<Int>.empty()
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }
    
    //무조건 emit 아무것도 방출하지 않으려면 empty와 같이 사용해야 한다
    //특정 항목을 방출하는 Observable을 생성한다
    // <-> from 단일이 아닌 복수 항목 방출 가능
    // 수업에서 단일 항목을 emit 할때는 just, from이 동일해 보였지만 from은 복수 항목 방출 가능
    func justExample() {
        
        Observable.just("🔴")
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }
    
    //just는 당일 항목 from은 복수 항목 방출 가능
    func fromExample() {
        
        Observable.from(["🐶", "🐱", "🐭", "🐹"])
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //배열째로 출력이 되는 것이 아니라 배열의 요소 하나하나가 출력되는 것을 알 수 있다
    func ofExample() {
       
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .subscribe(onNext: { element in
                print(element)
            })
            .disposed(by: disposeBag)
    }
    
    func createExample() {
        
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }
        myJust("🔴")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    //범위를 지정하고 범위내의 숫자만큼 올라감
    func rangeExample() {
        
        Observable.range(start: 1, count: 10)
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
    
    //.take를 하지 않으면 무한 반복이 된다
    func repeatElementExample() {
        Observable.repeatElement("🔴")
            .take(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //for 문 0에서 시작해서 범위 정해주고 생성한다
    //initialState는 초기값
    func generateExample() {
        Observable.generate(
                initialState: 0,
                condition: { $0 < 3 },
                iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //순차적으로 들어온다
    //defer 어원: 미루다 observer가 subscribe 할때까지 기다리다가 subscribe 하면 Observable 생성
    //observer가 subscribe 할 때 까지 미룸
    func deferExample() {
        var count = 1
        
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    func errorExample() {
//
//        Observable<Int>.error(TestError.test)
//            .subscribe { print($0) }
//            .disposed(by: disposeBag)
//    }
    
    //Observer Subscribe전에 헨들링 할 수 있다
    func doOnExample() {
        
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { print("Intercepted:", $0) }, afterNext: { print("Intercepted after:", $0) }, onError: { print("Intercepted error:", $0) }, afterError: { print("Intercepted after error:", $0) }, onCompleted: { print("Completed")  }, afterCompleted: { print("After completed")  })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    
    
}
