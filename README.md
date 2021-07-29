# Rx_Memo


- 따라 만들며 RxSwift를 공부하기 위함
-  프로젝트 폴더 분류 및 코드 정리 방법도 참고중..

> Why?

- RxSwift를 사용하면 단순하고 직관적인 코드를 사용 가능.

> RxSwift / RxCocoa

-  `RxSwift` : RxSwift 구현에 필요한 라이브러리
-  `RxCocoa` : 코코아터치 프레임워크에 Rx 기능을 추가하는 라이브러리

> Observable

-  Observable은 event를 전달한다.
-  Observer는 Observable을 감시(구독)하고 있다가 전달되는 이벤트를 처리함
-  Observable에서 발생한 event는 `Next` event를 통해 전달된다. (RxSwift에서는 이것을 Emission(방출)이라고 표현함)
-  Observable에서 에러가 발생하면 `Error event`, 완료 event가 발생하면 `Completed event`가 발생(Observable의 life cycle에서 가장 마지막에 전달됨)
-  `Error event`, `Completed event` 이후에는 모든 event가 종료되고, 리소스가 정리되기 때문에 이후 event는 전달되지 않음
-  `Error event`, `Completed event`는 emission이라고 부르지 않고 Notification이라고 부름

> Observable을 생성하는 방법

- Create 연산자를 통해 Observable의 동작을 직접 구현
	- create 연산자: Observable type 프로토콜에 선언되어 있는 타입 메소드
	
		```swift
		Observable<Int>.create { (observer) -> Disposable in
			observer.on(.next(0))
			observer.onNext(1)
			observer.onCompleted()
			return Disposables.create()
		``` 
- From 연산자를 통해 Observable 생성
	- from 연산자: 파라미터에 있는 요소들을 순서대로 방출, completed 이벤트를 전달
	
		```swift
		Observable.from([0, 1])
		```
