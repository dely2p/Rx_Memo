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

> PublishSubject

- Subject로 전달되는 event를 Observer에게 전달하는 가장 기본적인 형태의 Subject
- Subject가 생성되는 시점에는 내부에 아무런 event가 저장되어 있지 않음
- 그래서 생성직후 Observer가 구독을 시작하면 아무런 event도 전달되지 않음
- Subject는 Observable인 동시에 Observer임
- 다른 소스로부터 event를 전달받을 수 있고 다른 Observer로 event를 전달할 수 있음

	```swift
	let disposeBag = DisposeBag()
	enum MyError: Error {
		case error
	}
	let subject = PublishSubject<String>()
	subject.onNext("Hello")
	
	let o1 = subject.subscribe { print(">> 1", $0) }
	o1.disposed(by: disposeBag)
	subject.onNext("RxSwift")
	
	let o2 = subject.subscribe { print(">> 2", $0) }
	o2.disposed(by: disposedBag)
	
	subject.onNext("Subject")
	
	subject.onCompleted()
	
	let o3 = subject.subscribe { print(">> 3", $0) }
	o3.disposed(by: disposeBag)
	```
	
> Observable을 생성하는 연산자(just, of, from)

- just: 하나의 항목을 방출하는 Observable을 생성

	```swift
		let disposeBag = DisposeBag()
		let element = "a"
		Observable.just()
			.subscribe { event in print(event) }
			.disposed(by: disposeBag)
			
		Observable.just([1, 2, 3])
			.subscribe { event in print(event) }
			.disposed(by: disposeBag)
	```

- of: 두개이상의 항목을 방출하는 Observable을 생성

	```swift
		let disposeBag = DisposeBag()
		let apple = "a"
		let orange = "o"
		let kiwi = "k"
		Observable.of(apple, orange, kiwi)
			.subscribe { event in print(event) }
			.disposed(by: disposeBag)
			
		Observable.of([1, 2], [3, 4], [5, 6])
			.subscribe { event in print(event) }
			.disposed(by: disposeBag)
	```
	
- from: 배열에 포함된 요소를 하나씩 순서대로 방출하는 Observable을 생성

	```swift
		let disposeBag = DisposeBag()
		let fruits = ["a", "b", "c", "d", "e"]
		Observable.just(fruits)
			.subscribe { event in print(event) }
			.disposed(by: disposeBag)
	```
	
> filter 연산자

- Observable이 방출하는 요소를 필터링 함

	```swift
		let disposeBag = DisposeBag()
		let numbers = [1, 2, 3, 4, 5, 6, 7]
		Observable.from(numbers)
			.filter { $0.isMultiple(of: 2) }
			.subscribe { event in print(event) }
			.disposed(by: disposeBag)
	```
	
> flatMap 연산자

- 원본 Observable이 항목을 방출하면 flatMap 연산자가 변환함수를 실행함
- 변환함수는 방출된 항목을 Observable로 변환
- 방출된 항목의 값이 바뀌면 flatMap 연산자가 변환한 Observable이 새로운 항목을 방출
- 이런 특징때문에 원본 Observable이 방출하는 항목을 지속적으로 감시하고 최신값을 확인할 수 있음
- flatMap은 모든 Observable이 방출하는 항목을 모아서 최종적으로 하나의 Observable을 리턴함

	```swift
		let disposeBag = DisposeBag()
		let a = BehaviorSubject(value: 1)
		let b = BehaviorSubject(value: 2)
		let subject = PublishSubject<BehaviorSubject<Int>>()
		
		subject
			.flatMap { $0.asObservable() }
			.subscribe { print($0) }
			.disposed(by: disposeBag)
		subject.onNext(a)
		subject.onNext(b)
		
		a.onNext(11)
	```
	
> CombineLatest Operator

- 연산자가 return 한 Observable이 언제 이벤트를 방출하는지 이해하는 것이 핵심
- 여러 Observable 중에서 하나라도 바뀌게 되면 combine 된 그 값이 구독자에게 전달됨	
	```swift
		let disposeBag = DisposeBag()
		let greetings = PublishSubject<String>()
		let languages = PublishSubject<String>()
		
		Observable.combineLatest(greetings, languages) { lhs, rhs -> String in
			return "\(lhs) \(rhs)"
		}
		.subscribe { print($0) }
		.disposed(by: bag)
		
		greetings.onNext("Hi")
	```