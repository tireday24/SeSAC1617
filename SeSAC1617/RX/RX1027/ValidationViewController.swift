//
//  ValidationViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        //observableVSSubject()
       
    }
    
    func bind() {
        
        //타입 자체가 다르다
        //에러 핸들링은 없지만 에러가 생길 경우 예외 처리 해주어야한다
        //rxcocoa trait s -> b -> d
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
//       Stream == Seaquence
//        버튼의 경우 에러날 확률? complete? 0
//        disposeBag의 경우 인스턴스 그대로를 반환할 경우 새로운 dispose가 덮어 씌워져서 바로 dispose 됨
//        리소스 정리가 되어서 액션의 연결이 끊어졌다 기존의 구독을 했던 요소를 바꿔버림
//
//        개념 찾아가면서 해보기 -> 클로져, 고차함수, 가변매개변수, override, ARC
//
//        각각의 시퀀스가 독립시행 간편성을 위해서 묶은거지 실행의 빈도를 낮출수는 없다 불필요한 리소스 낭비가 날 수 있다
//        메모리를 하나만 가지고 있었으면 좋겠는데 아닌 것 1:1
        let validation = nameTextField.rx.text
            .orEmpty //String
            .map { $0.count >= 8 } //Bool
            .share() //Subject, Relay

//        nameTextField.rx.text
//            .orEmpty //String
//            .map { $0.count >= 8 } //Bool
//            .subscribe(onNext: { value in
//                self.stepButton.isEnabled = value
//                self.validationLabel.isHidden = value
//            })
        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)

//        nameTextField.rx.text
//            .orEmpty
//            .map { $0.count >= 8}
        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        stepButton.rx.tap
            .bind { _ in
                print("Show Alert")
            }
            .disposed(by: disposeBag)

        
    }
    
    func observableVSSubject() {
        
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create() //비어있는 구조체 새로운 옵져버블을 만들어라
            
        }
        
        //옵져버블 1대1 대응 리소스 같이 안쓴다
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
    
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        //share을 안씀에도 불구하고 리소스를 같이 쓴다 = 스트림을 공유한다
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        let testA = stepButton.rx.tap
             .map { "안녕하세요"}
             .asDriver(onErrorJustReturn: "")
             //.share()
         
         testA
             .drive(validationLabel.rx.text)
             .disposed(by: disposeBag)
         
         testA
             .drive(nameTextField.rx.text)
             .disposed(by: disposeBag)
         
         testA
             .drive(stepButton.rx.title())
             .disposed(by: disposeBag)

        
        //이벤트 처리시 사용
        //subscribe -> next error complete
        //무한한 시퀀스는 error complete 안씀
        //bind 나옴 (Next) UI에 완전 UI는 메인스레드에서 동작해야한다
        //차이점 2 -> bind 항상 메인스레드에서 동작한다
        //Drive? => 바인드와의 차이 stream 공유 share을 안쓰더라도 바인드를 쓸 때는 share을 써도 됨 근데 드라이브에서는 쓸 필요가 없다
        //그래서 드라이브를 ui만들 때 많이 사용함(항상 그래서 드라이브가 등장한거였다 'ㅅ')
        //바인드와 드라이브를 같이 쓰면 share 키워드 필요할까? => 필요 없다
        
        //옵져버블 vs Subject
        //subject는 옵져버블에 이벤트 전달 역할 + 옵져버 역할 + 스트림 공유
        //스트림 공유는 어떻게 하는건가? => 서브젝트 안에 (퍼블리시 비헤이비어 리플레이 어싱크) 초기값 하나 비헤이비어 리플레이 vs 비헤이비어 -> 초기값 갯수(리플레이는 버퍼 갯수 만큼)
        //4가지 모두 share 메서드 가지고 있다 쉐어 키워드 굳이 쓸 필요 없다 내부적으로 이미 구현되어 있어서
        //Relay vs Subject
        //Relay는 next이벤트만 방출 error와 complete는 왜 Emit 안함? -> 다룰 필요없고 컴플릿 에러 타지 않음 릴레이는 유아이에 최적화 된 요소여서
        //next 대신 다루는 키워드 accept
        //Traits => UI 처리에 특화되어있다, 대부분 Stream 공유 키워드가 들어있음(share())
        //relay drive는 짝꿍
        //Traits UI에 적합한 Observable
        
    }
    

   

}
