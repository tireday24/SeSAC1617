//
//  SubscribeViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/26.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    //lazy var?
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { dataSource, tableView, IndexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    })
    
    
    func textRxAlamofire() {
        //Success Error => <Single>
        let url = APIKey.searchURL + "god"
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe { value in
                print(value.results[0].likes)
            }
            .disposed(by: disposeBag)
    }
    
    func testRxDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3])
        ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textRxAlamofire()
        testRxDataSource()
        
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3)//4부터 전달
            .filter { $0 % 2 == 0} // 4, 6, 8, 10
            .map { $0 * 2 } // 8, 12, 16, 20
            .subscribe { value in
                
            }
            .disposed(by: disposeBag)
        
        //탭 > 레이블: "안녕 반가워"
        
        //1.
        let sample = button.rx.tap //reactive한 형태로 타입이 변함, ControlEvent<Void>형태로 변함
        sample
            .subscribe { [weak self] _ in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        //2.
        button.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        //3. 네트워크 통신이나 파일 다운로드 등 백그라운드 작업?
        
        //백그라운드
        button.rx.tap
            //.map {}
            //.map {} // ->글로벌
            //.map {}
            .observe(on: MainScheduler.instance) //메인스레드로 바꿔달라는 코드, GCD 역할
            //.map {}
            //.map {} // -> 메인
            //.map {}
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        //4. bind : subscribe, mainSchedular, error X
        button.rx.tap
            .withUnretained(self)
        //무조건 메인쓰레드에서 동작 만약 에러가 발생한다면 런타임에러가 발생한다
            .bind { vc, _ in
                DispatchQueue.main.async {
                    vc.label.text = "안녕 반가워" // -> 3번이랑 동일
                }
                
            }
            .disposed(by: disposeBag)
        
        //5. operator로 데이터의 stream 조작
        button.rx.tap.map { "안녕 반가워" } // 스트링 타입 변경, debug() -> //print+
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        //6. driver traits: bind + stream 공유(리소스 낭비 방지, share())
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "ERROR") //다른 타입으로 변경 에러 발생시 어떻게 대체할래?
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        
    }
    
}
