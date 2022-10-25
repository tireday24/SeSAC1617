//
//  RXCocoaViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RXCocoaViewController: UIViewController {
    
    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLable: UILabel!
    @IBOutlet weak var setSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    //메모리 관리를 도와주는 객체
    var disposeBag = DisposeBag()
    
    //문자열 보내는 중
    var nickname = Observable.just("Jack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        //subject -> Observable + Observer subscribe + next 가능
        //Publish
        //Behavior
        //Replay
        //Async
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //Observable emit만 가능(전달만) 새롭게 값을 넣어주는 것 불가능
            //이미 존재하는 객체에 대해서만 보여줄 수 있다
            //self.nickname = "HELLO"
        //}

        setTableView()
        setPickerView()
        setUISwitch()
        setSign()
        setOperator()
        
    }
    
    //viewController가 deinit이 되면 알아서 dispose도 동작한다
    //또는 DisposeBag() 객체를 새롭게 넣어주거나, nil 할당 => 예외 케이스!(rootVC에 interval이 있다면?)
    //rootViewController면 deinit 호출 안됨 -> 특정 시점에 dispose 해주어야한다
    deinit {
        print("RXCocoaExampleViewController")
    }
    
    func setOperator() {
        
        //넥스트 이벤트 무한 방출
        //왜 필요하나 5번만 반복해라 이런 경우 사용
        Observable.repeatElement("Jack") //Infinite Observable Sequence
        .take(5) // Finite Observable Sequence
        //옵저버에 대한 요소
        //emit(결과) 끝나고 난 뒤 메모리 올라 갈 필요 없음 리소스 정리 필요 확인 -> dispose(리소스 정리하는 객체) deinite에 print에 넣는 것과 유사
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("error")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
        //by? 매개변수 여부
        //2가지 역할은 동일하다
            .disposed(by: disposeBag)
        
        //1초마다 숫자 1씩 증가 무한한 시퀀스가 동작하는구나
        //화면 전환이 되더라도 deinit 되지 않고 계속 실행된다
         Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("error")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
//        let intervalObservable2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//           .subscribe { value in
//               print("interval - \(value)")
//           } onError: { error in
//               print("error")
//           } onCompleted: {
//               print("interval completed")
//           } onDisposed: {
//               print("interval disposed")
//           }
//           .disposed(by: disposeBag)
//
//        let intervalObservable3 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//           .subscribe { value in
//               print("interval - \(value)")
//           } onError: { error in
//               print("error")
//           } onCompleted: {
//               print("interval completed")
//           } onDisposed: {
//               print("interval disposed")
//           }
//           .disposed(by: disposeBag)
        
        //DisposeBag: 리소스 해제 관리 -
            // 1. 시퀀스 끝날 때 but bind는 OnNext만 전달해서 끝나는게 없지 않나?
            // 2. class deinit이 잘 된다면 자동 해제 (bind) -> deinit이 되지 않으면 리소스 정리 안됨 반대로 deinit이 안되면 dispose 의미x
            // 3. dispose 직접 호출 -> dispose() 구독하는 것 마다 별도로 관리해주어야 한다 하나라도 빠지면 무한 호출 될 수 있다
            // 4. DisposeBag을 새롭게 할당하거나 nil 전달.
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //클래스가 교체가 되면서 기존에 있던 리소스는 정리가 되더라
            //갯수에 대한 걱정은 하지 않아도 됨
            //self.disposeBag = DisposeBag() // 한번에 리소스 정리 할 때 사용됨 리소스에 대한 참조 유지 역할
//            intervalObservable.dispose()
//            intervalObservable2.dispose()
//            intervalObservable3.dispose()
        //}
        
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.7]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("\(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("\(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)

        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("\(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)

    }
    
    func setSign() {
      
        //ex. 텍1(Observable) , 텍2(Observable) > 레이블(Observer,bind)
        //등록된 객체가 바뀌어서 신호 하나만 보내도 바로 반응
        //.orEmpty 옵셔널 해제
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            "name은 \(value1)이고, 이메일은 \(value2)입니다"
        }
        .bind(to: simpleLable.rx.text)
        .disposed(by: disposeBag)
        //텍1 옵져버블 반환을 해줘서 카운트를 변경해줌 카운트를 기반으로 히든 반환
        signName.rx.text.orEmpty
        //데이터는 스트링으로 받았지만 변경하고 싶다
        //데이터의 흐름 Stream
        //signName텍필이 있는데 rx 네임스페이스를 만나니까 리엑티브 형태 text를 만나니까 string?으로 되고 orEmpty만나니까 String
        //계속 바뀌니까 dataStream이 계속 바뀐다 count로 만나니까 Int
        //구독하기 전까지 바뀐다
            .map { $0.count } // Int
            .map { $0 < 4} // Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)//isHidden은 bool 타입이기 때문에
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map{ $0.count > 4}
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //tap = touchupinside
        //tap에 대한 기능이 반응형으로 바뀌지 않기 때문에 subscribe
        
        //참조 중이라 deinit 안됨 -> ARC 카운트 못하게 막음
        signButton.rx.tap
            .withUnretained(self) //weak self 대신 쓰면 연산자 안써도 됨
            .subscribe(onNext: { vc, _ in
                vc.showAlert() //vc가 weak self가 되는거다
            })
            .disposed(by: disposeBag)
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setUISwitch() {
        //just 요소를 보내주는 것이 아닐까? 정도로 이해
        Observable.of(false) //just? of?
            .bind(to: setSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //이 데이터를 전달했는데
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        //이 옵저버블을 누가 구독하고 있냐
        //cellforrowat 과 비슷한 코드
        //테이블 뷰에서 받고 보여줌
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        //disposeBag = 변수
        .disposed(by: disposeBag)
        
        //model - data, item - indexPath
        //error, completed 절대 발생 불가능
        simpleTableView.rx.modelSelected(String.self)
            //성공한 케이스(onNext)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLable.rx.text)
            .disposed(by: disposeBag)

        
    }
    
    func setPickerView() {
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
        //row pickerView row
        //element 요소
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            //맵으로 string 변화를 주겠다
            .map { $0.description }
            .bind(to: simpleLable.rx.text)
        //배열 형태로 전달 되기 때문에 타입이 안맞아서 오류가 나옴
//            .subscribe(onNext: { value in
//                print(value)
//            })
            .disposed(by: disposeBag)
    }

}
