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
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setPickerView()
        setUISwitch()
        setSign()
        setOperator()
        
    }
    
    func setOperator() {
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.7]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("error")
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
                print("error")
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
                print("error")
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
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
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
