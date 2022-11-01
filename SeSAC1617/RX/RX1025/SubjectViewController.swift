//
//  SubjectViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/25.
//

import UIKit
import RxCocoa
import RxSwift

class SubjectViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var newButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //안에 Int가 있어
    let publish = PublishSubject<Int>() //초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) //초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3) //bufferSize 작성된 이벤트 갯수만큼 이벤트를 가지고 있다가, subscribe 직후에 한번에 이벤트를 전달
        //최근 검색어 몇개만 나오는거
    let async = AsyncSubject<Int>()
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        let input = SubjectViewModel.Input(addTap: addButton.rx.tap, resetTap: resetButton.rx.tap, newTap: newButton.rx.tap, searchText: searchBar.rx.text)
        let output = viewModel.transform(input: input)
        
        

//        viewModel.list //VM -> VC (Output)
//            .asDriver(onErrorJustReturn: [])
        
        output.list
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) {(row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 \(element.number)"
            }
            .disposed(by: disposeBag)
        
//        addButton.rx.tap
        output.addTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
//        resetButton.rx.tap
        output.resetTap
            .withUnretained(self)
            .subscribe {(vc, _) in
                vc.viewModel.restData()
            }
            .disposed(by: disposeBag)
        
        //newButton.rx.tap //VC -> VM(Input) tap
        output.newTap
            .withUnretained(self)
            .subscribe {(vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
//        searchBar.rx.text.orEmpty //VC -> VM(Input) tap
//            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)//wait 서버에서 콜수를 줄인다
//            .distinctUntilChanged() //같은 값을 받지 않는다
        output.searchText
            .withUnretained(self)
        //입력 끝나고 1초
            .subscribe {(vc, value) in
                print("=====\(value)")
                vc.viewModel.filterData(query: value!)
            }
            .disposed(by: disposeBag)
    }
}

extension SubjectViewController {
    
    func asyncSubject() {
    
        
//        async.onNext(1)
//        async.onNext(2)
//        async.onNext(3)
//        async.onNext(4)
//        async.onNext(5)
//
//        async
//            .subscribe { value in
//                print("async - \(value)")
//            } onError: { error in
//                print("async - \(error)")
//            } onCompleted: {
//                print("async completed")
//            } onDisposed: {
//                print("async disposed")
//            }
//            .disposed(by: disposeBag)
//
//
//        async.onNext(6)
//        async.onNext(7)
//        async.on(.next(8))
//        //completeEvent가 전달 될 때 완료전 호출
//        async.onCompleted()
//
//        async.onNext(9)
    }
    
    func replaySubject() {
        //BufferSize 메모리, array, 이미지
        
        replay.onNext(1)
        replay.onNext(2)
        replay.onNext(3)
        replay.onNext(4)
        replay.onNext(5)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)
        
        //구독 전이라 1,2는 안나옴
        replay.onNext(6)
        replay.onNext(7)
        replay.on(.next(8))
        //완료 호출 안되면 completed 호출 안됨
        replay.onCompleted()
        //구독 안해서 안됨
        replay.onNext(9)
    }
    
    func behaviorSubject() {
        //구독전에 가장 최근 값을 같이 emit
        //바로 이전 것만 의미가 있다
        
        behavior.onNext(1)
        behavior.onNext(2)
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)
        
        //구독 전이라 1,2는 안나옴
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        //완료 호출 안되면 completed 호출 안됨
        behavior.onCompleted()
        //구독 안해서 안됨
        behavior.onNext(6)

    }
    
    func publishSubject() {
        //초기값이 없는 빈 상태, subscribe 전/error/completed notification 이후 이벤트 무시
        //subscribe 후에 대한 이벤트는 다 처리
        
        //int에 대한 내용 바뀌면 print
        //끝나면 dispose
        
        //Publish에 값을 넣어주는 느낌
        publish.onNext(1)
        publish.onNext(2)
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)
        
        //구독 전이라 1,2는 안나옴
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5))
        //완료 호출 안되면 completed 호출 안됨
        publish.onCompleted()
        //구독 안해서 안됨
        publish.onNext(6)

        
    }
    
}
