<img src = "https://user-images.githubusercontent.com/46108770/158010258-799f730b-ad48-4372-9c5e-724f710b4925.png" width="400">

> *본 프로젝트는 **빗썸 iOS 코스 테크 캠프 1기** 과제로 진행되었습니다.*

> **프로젝트 기간** : 2022.02.21~2022.03.13 (3주)

<br>

## 😎 목차

[스크린샷 및 영상](#스크린샷-및-영상)

[기술 스택](#기술-스택)

[플로우 차트](#플로우-차트)

[트러블 슈팅](#트러블-슈팅)

[만든 사람들](#만든-사람들)

[커뮤니케이션 방식](#커뮤니케이션-방식)

[참고 자료](#참고-자료)

<br>

## 스크린샷 및 영상

https://user-images.githubusercontent.com/94916868/158063272-958429f9-4f21-42ff-950a-615d66b097a8.mp4

<img width="600" src="https://user-images.githubusercontent.com/46108770/158057480-6a332ae9-d42e-4ef2-9a09-07d6353516a0.png">


<br>

## 기술 스택
<img width="77" src="https://img.shields.io/badge/iOS-15.2+-silver"> <img width="95" src="https://img.shields.io/badge/Xcode-13.2.1-blue">

<img width="77" src="https://img.shields.io/badge/URLSession-pink"> <img width="77" src="https://img.shields.io/badge/Websocket-yellow"> <img width="95" src="https://img.shields.io/badge/Github Actions-green"> <img width="60" src="https://img.shields.io/badge/Coredata-blue">

<img width="50" src="https://img.shields.io/badge/iPhone-red"> <img width="35" src="https://img.shields.io/badge/iPad-orange">

<img width="77" src="https://img.shields.io/badge/Accessibility-cyan">

<br>

## 플로우 차트

<img width="700" src="https://user-images.githubusercontent.com/46108770/158055594-5eaace50-7e37-4d4f-b3d4-4e40ef29e3d2.png">

<br>

## 트러블 슈팅
<details>
<summary>콩이</summary>
    
> 프로젝트 세팅(REST API, Github Action)
    
 1) URL Session
    
  : async/await을 경험해보기 위해 별도의 네트워크 라이브러리를 사용하지 않기로 결정했다.
  → await를 쓰는 이유는 completionhandler를 사용하지 않음으로써 오류 처리의 복잡성을 줄이고, 클로저를 사용하지 않음으로써 코드 가독성을 향상함으로써 한 줄로 비동기 코드를 마치 동기 코드처럼 보이게 하기 위한 것.
    
 ![스크린샷 2022-02-24 오후 6 50 19](https://user-images.githubusercontent.com/46108770/158013071-1d8bce9b-23bf-4950-ac1a-30a75ea5889b.png)
    
  await/async는 iOS 13.0부터 지원하지만, async를 지원하는 URLSession API는 iOS 15.0이 필요하다.
    
 ![스크린샷 2022-02-24 오후 6 53 31](https://user-images.githubusercontent.com/46108770/158013081-aa030cdd-4fd9-4c74-b665-fd12eea7fb37.png)

  → 그런데 이전 버전 부터 대응하게 되면 코드 가독성의 장점이 사라져서 try await을 사용하는 의미가 없어지게 된다.

  → 따라서 Global 코드는 다른 코드에서 재사용되는 코드들을 모아놓은 폴더인 만큼, 간결하고 깔끔하게 작성하고 싶기에 iOS 15부터 대응하도록 설정했다.
    
 2) CI
    
  : 사전에 빌드 오류를 발견하지 못한 채 main 브랜치에 merge하는 상황을 방지하기 위해 CI 툴을 채택하기로 했다.
    
  → Github Action과 Jenkins가 가장 일반적으로 사용된다.
    
  → Jenkins의 경우 별도의 서버에 호스팅해야하는 오버헤드가 발생하므로, Github에서 서버를 제공하는 Github Action을 사용
    
  ```YAML
    name: FakethumbBuildTest

    on:
    push:
    branches: [ main ]
    pull_request:
    branches: [ main ]

    jobs:
    build:

    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v2
    - name: Run tests
      run: |
        pod install --repo-update --clean-install --project-directory=FakeBithumbAssignment/
        xcodebuild test -workspace ./FakeBithumbAssignment/FakeBithumbAssignment.xcworkspace -scheme FakeBithumbAssignment -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=15.2'
  ```
    
> CoinView 및 호가 정보창 구현
    
1) CoinView - UIPageViewController

 : 뷰 컨트롤러 내에서 또 다른 뷰 컨트롤러를 보여주기 위해 pageViewController를 사용했다.
    
 →  부모 뷰 컨트롤러 내에 pageViewController가 존재하고, pageViewController 위에 원하는 child View Controller를 표시하는 방식으로 동작한다.
    
 → pageViewController는 childViewController들을 가지고 있으며, delegate와 dataSource를 통해 페이지를 관리한다.
    
 ```swift
    // pageViewController를 설정
    private func setPageView() {
    self.pageViewController = CoinPagingViewController()
    
    if let pageViewController = pageViewController {
        self.addChild(pageViewController)
        self.pageView.addSubview(pageViewController.view)
        self.pageViewController?.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.pageView)
        }
        pageViewController.didMove(toParent: self)
    }
}
 ```
    
 → 부모 뷰 컨트롤러에 addChild를 이용해 pageViewController를 붙여준 후, 보여질 pageView에도 pageViewController의 view를 addSubView한다.
    
 → 부모 뷰 컨트롤러에 새로운 컨트롤러가 추가되었으므로 didMove()를 호출해준다.
    
 ```swift
    // 페이지를 전환하는 코드
    func setTabViewController(to type: TabView) {
      guard let page = pages[type] else { return }
      self.setViewControllers([page], direction: .forward, animated: false, completion: nil)
    }
 ```
    
 → 이후 pageViewController 내부에서 setViewController 메서드를 이용해 화면 전환하는 코드를 구현한다.

2) 호가 정보창 - 웹소켓 (모모 리팩토링 이전)
	
 2-1. 변경된 호가의 quantity가 0인 경우, 현재 리스트에서 해당 price를 찾아 삭제해줘야 한다.
    
    ```swift
    if Double(quote.quantity) == 0 {
        self.removeQuantityIsZero(type: .ask, data: quote)
        continue
    }
    
    private func removeQuantityIsZero(type: BTSocketAPIResponse.OrderBookResponse.Content.OrderBook.OrderType,
                                      data: Quote) {
        switch type {
        case .ask:
            var count = self.asksList.count
            var index = 0
            while(index < count) {
                if Int(asksList[index].price) == Int(data.price) {
                    self.asksList.remove(at: index)
                    count -= 1
                }
                index += 1
            }
        case .bid:
            var count = self.bidsList.count
            var index = 0
            while(index < count) {
                if Int(bidsList[index].price) == Int(data.price) {
                    self.bidsList.remove(at: index)
                    count -= 1
                }
                index += 1
            }
        }
    }
    ```
    
2-2. 단순히 호가 정보 30개씩 받아서 표시해줄 경우, (1) 처럼 remove된 경우에 표시해줄 데이터가 없다.
	
	-> 그러나 빗썸에서 받아올 수 있는 최대 데이터는 30개이므로, 그 이상의 데이터를 로컬에서 관리하고 그 중에서 30개만 표시하도록 해야한다.
	
	-> 그리고 리스트 중 asks(매도)는 하위 30개, bids(매수)는 상위 30개를 표시한다. 물론 price 순으로 정렬해서.
    
    ```swift
    private func sortQuoteList(type: BTSocketAPIResponse.OrderBookResponse.Content.OrderBook.OrderType) {
      switch type {
      case .ask:
          self.asksList = asksList.sorted(by: {$0.price > $1.price})
      case .bid:
          self.bidsList = bidsList.sorted(by: {$0.price > $1.price})
      }
    }
    ```
    
2-3. 변경된 호가가 로컬 리스트에 있는 호가와 같은 경우, 해당 호가를 찾아 quantity를 업데이트 해준다.
    
    ```swift
    if !self.replaceQuote(type: .ask, data: quote) {
        self.asksList.append(quote)
    }
    
    private func replaceQuote(type: BTSocketAPIResponse.OrderBookResponse.Content.OrderBook.OrderType,
                              data: Quote) -> Bool {
        switch type {
        case .ask:
            let count = self.asksList.count
            var index = 0
            while(index < count) {
                if Int(asksList[index].price) == Int(data.price) {
                    self.asksList[index] = data
                    return true
                }
                index += 1
            }
        case .bid:
            let count = self.bidsList.count
            for index in 0..<count {
                if Int(self.bidsList[index].price) == Int(data.price) {
                    self.bidsList[index] = data
                    return true
                }
            }
        }
        return false
    }
    ```
    
2-4. 로컬에 있는 list에서 찾아 remove하는 작업을 수행하는 도중, websocket api에서 데이터를 받아와 list가 업데이트 되면 반복문의 범위가 조정되어 index out of range 오류가 발생한다.
	
	-> 따라서 remove 작업을 시행하는 동안에는 동기적으로 처리하기 위해 sempaphore를 활용한다.
    
    ```swift
    private func updateTransactionData(coin: Coin,
                                       data: BTSocketAPIResponse.TransactionResponse) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .background).async {
            for transaction in data.content.list {
                switch transaction.buySellGb {
                case .sell:
                    var count = self.asksList.count
                    var index = 0
                    while(index < count) {
                        if Double(self.asksList[index].price) == Double(transaction.contPrice) {
                            guard let quantity = Double(self.asksList[index].quantity) else { return }
                            if quantity - transaction.contQty <= 0 {
                                self.asksList.remove(at: index)
                                count -= 1
                            } else {
                                self.asksList[index].quantity = "\(quantity - transaction.contQty)"
                            }
                        }
                        index += 1
                    }
                case .buy:
                    var count = self.bidsList.count
                    var index = 0
                    while(index < count) {
                        if Double(self.bidsList[index].price) == Double(transaction.contPrice) {
                            guard let quantity = Double(self.bidsList[index].quantity) else { return }
                            if Double(self.bidsList[index].quantity)! - transaction.contQty <= 0 {
                                self.bidsList.remove(at: index)
                                count -= 1
                            } else {
                                self.bidsList[index].quantity = "\(quantity - transaction.contQty)"
                            }
                        }
                        index += 1
                    }
                }
            }
            DispatchQueue.main.async {
                self.patchOrderbookData()
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
    ```
    
2-5. 마지막으로, 가끔 매도/매수의 경계선이 아니라 아주 낮은 가격에 매도를 하거나, 아주 높은 가격에 매수를 하는 케이스가 존재한다.
	
	-> 이런 경우는 대개 체결이 되지만, 아주 극단적으로 생각해서 매도하는 사람만 있고 매수하는 사람은 없는 경우, 매수하는 사람만 있고 매도하는 사람만 있는 경우도 존재할 수 있다. (예를 들어.. 주식에서 상한가, 하한가 쳤을 때)
	
	-> 체결 시 로컬 list에 있는 quantity - 체결 quanity = 0인 경우만 호가창에서 삭제하도록 한다.

    
</details>

<details>
<summary>추니</summary>
	
메인화면의 헤더뷰를 구현할 때, 원화, 관심 버튼은 터치되면 아래의 바가 생기게 됩니다. 이를 컬렉션 뷰셀로 깔끔하게 처리하기 위해 원화, 관심 버튼을 컬렉션 뷰를 활용해서 구현하였습니다. 또한 모든 셀에 대해 자동적으로 간격, 크기 등을 지정할 수 있고, 추후에 버튼이 추가될 수도 있기 때문에 컬렉션 뷰를 활용하였습니다.
하지만 컬렉션 뷰는 테이블 뷰와 마찬가지로 많은 양의 데이터를 보여주기 위해 존재한다고 생각이 들었습니다. 현재의 2개의 버튼을 컬렉션 뷰로 구현하기에는 데이터가 적다고 판단되었고, UIButton으로 구현하게 되었습니다.

UI 객체들을 레이아웃할 때, 객체를 하나하나 다 설정해주는 방법이 예전에 오토레이아웃 공부하며 익숙해졌습니다. 하지만 스택뷰를 사용하게 되면 UI 객체들의 레이아웃을 각각 걸어주지 않아도 되고, 코드가 간결해지며 가독성이 좋아보인다 생각해 스택뷰를 사용하게 되었습니다.

검색창을 이용하게 되면 키보드가 자동으로 올라오고, 가상 화폐 목록을 가리게 됩니다. 검색창이 아닌 다른 부분을 터치하게 되면 키보드가 내려가는 방식을 상식적으로 생각하게 되었습니다. 하지만 이는 테이블 뷰 셀을 터치하는 것도 포함이 되어 터치된 가상 화폐의 호가정보 창으로 진입하게 됩니다. 이를 해결하기 위해 검색창을 dismiss 하는 것과 뷰컨트롤러의 push 진입은 동시에 동작할 수 없음을 이용하여 검색 도중 셀이 터치되었을 때 키보드를 내리고, 뷰컨트롤러의 전환이 될 수 없도록 하였습니다.
하지만 이는 꼼수에 불과하며, 계속해서 경고메세지가 뜨게 됩니다. 그래서 다른 방식으로 키보드를 내리는 방법을 생각했고, 검색 도중 테이블 뷰를 스크롤하면 키보드가 내려가는 방식으로 구현하게 되었습니다.

실시간 가상 화폐의 데이터를 받아 테이블 뷰에 나타내기 위해 단순히 데이터를 받을 때, 테이블 뷰를 reload시키자는 생각을 하였습니다. 제 생각과 다르게 기본적인 테이블뷰를 사용하였을 경우 많은 양의 데이터가 연속적으로 들어와 앱이 멈추는 현상이 발생하였습니다. 이를 해결하기 위해 UITableViewDiffableDataSource를 사용하게 되었고, iOS 15부터 도입된 reconfigureItems 메소드를 통해 화면의 끊김 없이 테이블 뷰를 업데이트할 수 있었습니다.

모든 가상 화폐의 목록 테이블뷰와 관심 목록 테이블뷰를 구분해서 나타내야하는데 이를 하나의 뷰컨트롤러가 하나의 테이블 뷰를 관리하고, 원화, 관심 탭이 눌릴 때마다 그에 맞는 데이터를 보여주자는 생각을 하였습니다. 각각의 테이블 뷰를 보여주는 로직은 비슷하다 생각했기 때문입니다.
하지만 이는 하나의 파일에 너무 많은 양의 코드를 작성하게 하고, 테이블 뷰를 제어하는 로직을많이 복잡하게 하였으며, 구현하다보니 두 개의 테이블뷰가 조금은 다른 로직을 통해 보여준 다는 것을 깨달았습니다.
이를 해결하기 위해 먼저 테이블 뷰를 2개의 뷰로 분리하였습니다. 컨트롤러는 해당 탭에 대한 뷰를 보여주고, 데이터를 받으면 업데이트하라는 명령을 내리게 하였습니다. 사실 두개의 뷰는 비슷한 로직도 분명 존재합니다. 이를 클래스 상속을 통해 기본 구현하고, 조금 다른 로직을 가진 뷰는 오버라이딩하여 구현하면 코드가 더 깔끔해질 것 같습니다.

</details>

<details>
<summary>모모</summary>

## 캐들스틱 차트 과부화 문제
- 현상
    - 캔들스틱 차트에서 스크롤이나 핀치 제스처가 있을 경우, 화면 안에 들어온 캔들스틱을 대상으로 y축 스케일링이 되도록 하고 싶었으나, 이러한 상태 변화가 있었을 경우 앱이 꺼지지 않고 멈춘 상태로 지속되거나, 화면 전환이 끊기는 현상이 있었습니다. (CPU 사용률 100%)
- 원인 
    - 캔들스틱 차트는 CALayer들의 조합으로 구성 되었습니다. 길이 조정 등이 필요할 경우에 이 전체 Layer들을 다 지워 준 뒤에 다시 추가해 화면을 그려주는 연산이 필요합니다. 매 이벤트(스크롤, 핀치) 마다 모든 캔들스틱에 대해 이러한 처음부터 다시 그려주는 연산이 반복되고 있어 이러한 방대한 연산이 원인이였습니다.
- 해결 
    - 그리기 연산을 최소화 해 CPU 부하를 더는 방법으로 해결 했습니다. 모든 메소드가 O(N)의 시간 복잡도를 갖고 있어 2차원의 레이어 연산은 큰 부담이 되지 않을 것이라 생각했지만 이벤트마다 5000개정도의 레이어 삭제 후 추가는 상당한 부담이 되었던 것 같습니다. 기존에는 캔들스틱 처음부터 끝까지 각각의 레이어를 다 추가해주고 지워주는 방식으로 개발이 되어있었으나, 꼭 그려줘야 하는 캔들스틱만 대상으로 레이어를 추가 해주도록 수정 했습니다. 꼭 그려줘야 하는 캔들스틱의 영역은 스크롤 뷰의 contentOffset으로 계산을 해 주었습니다. 반복적으로 필요한 값들은 computed property를 통하지 않고 stored property에 한번만 계산 해서 넣어주는 방법으로도 연산을 최소화 했습니다. 또한 레이어 작업에 자동으로 애니메이션 효과가 들어가 있어 레이어 전체를 CATransaction으로 묶어 애니메이션 효과도 제거 해 주었습니다.
- 결과
    -  원하던 대로 스크롤, 핀치 제스처 시 적절한 스케일의 캔들스틱 차트가 화면에 가득 차도록 작동 했습니다.

## Core Data 사용 시 앱 크래시 문제
- 현상
    -  캔들스틱 차트에서 코어데이터를 사용하게 되는데, 간간히 앱 크래시가 발생 `[error] error: Serious application error. Exception was caught during Core Data change processing.`
- 원인 
    - `NSManagedObjectContext`는 쓰레드 하나에서만 동작하도록 정책이 정해 져 있습니다. 이는 쓰레드 안전하지 않은 객체이기 때문입니다. 메인 쓰레드에서만 동작하도록 정해져 있는 `persistentContainer.viewContext` 를 네트워크 요청 등으로 인해 메인 쓰레드가 아닌 곳에서 코어 데이터에 접근을 하게 되면 에러가 발생했습니다. 따라서 MOC에 접근할 때에는 항상 같은 쓰레드가 되도록 신경을 써주어야 합니다.
- 해결 
    - concurrencyType을 지정할 수 있는 `NSManagedObjectContext` 생성자를 이용해 생성해 주었습니다. `NSPrivateQueueConcurrencyType` **은 자신만의 큐를 갖고 있어 **`NSManagedObjectContext` 의 연산들을 해당 큐에서 동작하도록 관리 해 줍니다. 따라서 쓰레드 하나에서만 동작하도록 정해진 정책을 위반하지 않고, 앱 크래시가 발생하지 않습니다.
- 결과
    -  Core Data를 앱 크래시 없이 잘 사용할 수 있게 되었습니다.
</details>

<br>

## Ground Rules
<details>
<summary>Git branch</summary>
    
* git flow를 따른다.
* main 브랜치를 default 브랜치로 설정합니다.
* 기능 별로 feaure 브랜치를 생성하고, main 브랜치에 merge합니다.
* feature 브랜치의 네이밍은 feature/이슈번호-기능이름 으로 사용합니다.

</details>

<details>
<summary>코드 컨벤션</summary>
    
* [Swift API Design GuideLine](https://www.swift.org/documentation/api-design-guidelines/) 따릅니다.
* 이외의 룰에 대해서는 [StyleShare](https://github.com/StyleShare/swift-style-guide)의 Swift-Style-GuideLine을 따릅니다.

    -> 단, 다음의 룰은 추가합니다.
    ```HTML
    1)  들여쓰기에는 탭(tab) 대신 2개의 space를 사용합니다.
    2)  타입 첫 줄 띄어쓰기 없이 붙여쓰기
    ```
* **MARK 주석**을 활용합니다.

    ```Swift
    // MARK: - @IBOutlets Action
    // MARK: - @IBOutlet Outlets
    // MARK: - Life Cycle func
    // MARK: - custom func
    // MARK: - extension으로 빼고 어떤 기능을 사용하는지 적기
    // MARK: - @objc
    // MARK: - Type Property
    // MARK: - Instance Property
    // MARK: - Initializer
    ```

</details>

<details>
<summary>커밋 컨벤션</summary>
    
```HTML
# [타입] : 제목 (#이슈번호)

##### 제목은 최대 50 글자까지만 입력 ############## -> |

# 본문은 위에 작성
######## 본문은 한 줄에 최대 72 글자까지만 입력 ########################### -> |

# --- COMMIT END ---
# [타입] 리스트
#   FEAT    : 기능 (새로운 기능) -> 기능적인 수정
#   FIX     : 버그 (버그 수정)
#   REFACTOR: 리팩토링 -> 코드 재배치와 같은, 기능적인 수정
#   STYLE   : 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
#   DOCS    : 문서 (문서 추가, 수정, 삭제)
#   TEST    : 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)
#   CHORE   : 기타 변경사항 (빌드 스크립트 수정 등)
# ------------------
#     타입은 대문자로
#     제목은 명령문으로
#     제목 끝에 마침표(.) 금지
#     제목과 본문을 한 줄 띄워 분리하기
#     본문은 "어떻게" 보다 "무엇을", "왜"를 설명한다.
#     본문에 여러줄의 메시지를 작성할 땐 "-"로 구분
# ------------------
```

</details>

<details>
<summary>폴더링 컨벤션</summary>
    
```HTML
FakethumbAssignment
  |
  └── FakethumbAssignment
		   |── Global
		   │   │── Literal 
		   │   │── Base 
		   │   │── Protocol
		   │   │── Supports
		   │   │      │── AppDelegate
                   │   │      │── SceneDelegate
		   │   │      └── Info.plist
		   │   │── Utils
		   │   │── Extension
		   │   │── UIComponent
		   │   └── Resource
		   │          └── Assets.xcassets
		   │
  	           |── Network
		   │   │── APIService 
		   │   │── API  
	           │   │── Model
		   │   └── Foundation
		   │
		   └── Screens 
		       └── Main
		            └── View
```
</details>

<details>
<summary>코드 리뷰 규칙</summary>

```HTML
 1) merge 기준
   : 2명 모두 approve하면 merge한다.
 2) 리뷰 시간
   : 마지막 comment로부터 하루가 지나면 approve한다.
   : 작업 지연을 방지하기 위해 24시간이 지나면 본인이 merge한다.
```
</details>

<br>

## 만든 사람들 
| <img src="https://user-images.githubusercontent.com/46108770/158012511-c97175f3-8419-4277-a582-dc4233a6d10f.png" width="200"> | <img src="https://user-images.githubusercontent.com/46108770/158012604-2c427495-c539-4425-80ae-a5e4691e499e.png" width="200"> |   <img src="https://user-images.githubusercontent.com/46108770/158012540-5ead852b-f1f1-4e04-bb14-2dc14603c637.png" width="200">    |
| :-----------------: | :-----: | :-----: |
| **콩이**(beansbin)   | **추니**(chuuny)   | **모모**(momo-youngg) |
| 프로젝트 기간 동안 웹소켓과 비동기 데이터를 처리하는 법, 그리고 스택뷰를 사용하는 방법을 알게되었습니다. 협업하는 기간 동안 여러 작은 트러블이 있었지만, 결국엔 함께 해결해나가는 모습이 멋진 팀원들이었어요! 3주 전보다 한 발 성장한 우리의 모습이 꽤나 자랑스럽습니다 😎 고생많으셨습니다! 다들 행복하세요! | 협업하기 좋은 팀원들을 만나 프로젝트를 진행하며 소통하고 협업할 수 있어 정말 값진 경험이었습니다. 큰 트러블 없이 프로젝트를 완성하게 되어서 기쁩니다. 부족한 저와 함께 해주셔서 고생많으셨고 너무 감사했습니다! 다들 정말 수고많으셨습니다.   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| 저의 첫 아이가 드디어 완성이 되었습니다.  99.9% 완벽도를 자랑하고 있으니 이쁘게 봐주세요~! (캔들스틱 차트가 아주 기똥찹니다) 멋진 팀원들 고생 많으셨어요~!  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;|

<br>

## 커뮤니케이션 방식
* 프로젝트 일정 관리 : [Notion](https://beansbin.notion.site/2-21-3-13-5c018673116a4ed7a65ced2dffb65c97)
* 스크럼 미팅 및 소통 : Discord
* Webhook : Discord

<br>

## 참고 자료
* API : [빗썸 API](https://apidocs.bithumb.com/docs/api_info)
* 참고자료 : [Apple Human Interface Guideline](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/)
* Library

| 라이브러리        | Version |       |
| ----------------- | :-----: | ----- |
| Starscream        | `4.0.0` | `CocoaPods` |
| SnapKit           | `5.0.0` | `CocoaPods` |
| Then              | `2.7.0` | `CocoaPods` |
