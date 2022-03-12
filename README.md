<img src = "https://user-images.githubusercontent.com/46108770/158010258-799f730b-ad48-4372-9c5e-724f710b4925.png" width="400">

> *본 프로젝트는 **빗썸 iOS 코스 테크 캠프 1기** 과제로 진행되었습니다.*

> **프로젝트 기간** : 2022.02.21~2022.03.13 (3주)

##

<img src = "https://user-images.githubusercontent.com/46108770/158010783-7c0e290b-c23b-4293-b64b-2bf8e626ba96.png" width="150"> <img src = "https://user-images.githubusercontent.com/46108770/158010826-047a70f6-89aa-4eee-8002-dfdbed454b12.png" width="150"> <img src = "https://user-images.githubusercontent.com/46108770/158010834-b5a6d749-8911-4080-ada3-17bd447ba812.png" width="150"> <img src = "https://user-images.githubusercontent.com/46108770/158010841-2547e804-e403-4087-a6c4-2906ab6acc43.png" width="150"> <img src = "https://user-images.githubusercontent.com/46108770/158010860-f5776c78-ed83-4ba2-9943-8ac7ca8bb962.png" width="150">


## ⚒️ 기술 스택
<img width="77" src="https://img.shields.io/badge/iOS-15.2+-silver"> <img width="95" src="https://img.shields.io/badge/Xcode-13.2.1-blue">

<img width="77" src="https://img.shields.io/badge/URLSession-pink"> <img width="77" src="https://img.shields.io/badge/Websocket-yellow"> <img width="95" src="https://img.shields.io/badge/Github Actions-green">


## ✈️ 플로우 차트


## 🎣 Trouble Shooting
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

    
</details>

<details>
<summary>추니</summary>

</details>

<details>
<summary>모모</summary>

</details>

## 🥊 Ground Rules
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


## 👨‍👧‍👦 만든 사람들 
| <img src="https://user-images.githubusercontent.com/46108770/158012511-c97175f3-8419-4277-a582-dc4233a6d10f.png" width="200"> | <img src="https://user-images.githubusercontent.com/46108770/158012604-2c427495-c539-4425-80ae-a5e4691e499e.png" width="200"> |   <img src="https://user-images.githubusercontent.com/46108770/158012540-5ead852b-f1f1-4e04-bb14-2dc14603c637.png" width="200">    |
| :-----------------: | :-----: | :-----: |
| **콩이**(beansbin)        | **추니**(choony) | **모모**(momo-youngg) |


## 📚 사용한 API, 라이브러리 및 참고자료

| 라이브러리        | Version |       |
| ----------------- | :-----: | ----- |
| Starscream        | `4.0.0` | `CocoaPods` |
| SnapKit           | `5.0.0` | `CocoaPods` |
| Then              | `2.7.0` | `CocoaPods` |
