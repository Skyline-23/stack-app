//
//  LoginViewModel.swift
//  stack-app
//
//  Created by 김부성 on 2021/07/06.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel {
    
    // view에서 들어온 값
    let idTfChanged = PublishRelay<String>()
    let pwTfChanged = PublishRelay<String>()
    let loginBtnTouched = PublishRelay<Void>()
    
    // view로 방출할 값
    let result: Signal<Result<LoginResponse, LoginError>>
    
    // 값 전달한 모델 초기화
    init(model: LoginModel = LoginModel()) {
        
        // login 버튼이 터치된 시점에서만 withLatestFrom과 결합하여 신호 전달
        result = loginBtnTouched
            .withLatestFrom(Observable.combineLatest(idTfChanged, pwTfChanged))
            .flatMapLatest { model.requestLogin(id: $0.0, pw: $0.1) }
            .asSignal(onErrorJustReturn: .failure(.defaultError))
    }
}
