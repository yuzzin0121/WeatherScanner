# WeatherScanner
> iOS 채용 사전 과제 - Open Weather를 이용한 날씨 앱
<img src=https://github.com/user-attachments/assets/625b0e27-9d43-4775-a296-a844836f2cba width=650>

## 🛠️ 프로젝트 개발 및 환경
- **개발 인원:** iOS 1인 개발
- **개발 기간: 3일** (2024.07.22 ~ 2024.07.24)
- **개발 환경:** 최소 버전 iOS 13.0 / 세로 모드 / 아이폰용
> 귀사의 릴리즈된 앱 target Version에 맞추어 최소 버전 설정

<br><br>


## 🔍 핵심 기능 
- **일기예보 |** 최근 날씨 정보, 시간별 2일 동안의 일기예보, 5일간의 일기예보, 습도, 구름, 바람 속도
- **도시 검색 |** 도시 검색, 검색된 도시의 일기예보 탐색 
<br><br><br>


## 📱 스크린샷
|1. 일기예보 화면|2. 도시 검색 화면|3. 선택된 도시의 일기예보|4. 네트워크 단절 상황|
|------|---|---|---|
|<img src=https://github.com/user-attachments/assets/10ea3ea9-9ffd-49e7-8344-923677f020f3 width=220>|<img src=https://github.com/user-attachments/assets/b1df100d-6141-420a-b5d9-fa8e4e7541cb width=220>|<img src=https://github.com/user-attachments/assets/1a0b9e51-9308-469c-a94e-bb53cc52d9d9 width=220>|<img src=https://github.com/user-attachments/assets/3d78c0fc-f9bc-4093-a10f-afef02642b19 width=220>|


<br><br>

## 📍 주요 기술
**Framework** - UIKit <br>
**Pattern** - Router / Delegate / Singleton / MVVM / DI / Input-Output <br>
**Network** - Alamofire / Codable <br>
**ReactiveProgramming** - RxSwift / RxDataSources <br>
**OpenSource** - SnapKit / Then / Lottie / NVActivityIndicatorView <br>
**Etc** - CompositionalLayout / MapKit
<br><br><br>



## 👩🏻‍💻 고려사항
<details>
<summary><b>RxDataSource</b>를 활용해 효율적인 및 유지보수 가능한 뷰 구성</summary>
  
```
dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfWeatherData>(configureCell: { dataSource, collectionView, indexPath, weatherData in
      switch dataSource[indexPath] {
      case .currentWeatherData(let currentWeather):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCollectionViewCell.identifier, for: indexPath) as? CurrentWeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(currentWeather: currentWeather)
                
        return cell
        ...
  }
}, configureSupplementaryView: { dataSource, collectionView, string, indexPath in
...
```
</details>
<details>
<summary><b>Lottie</b>를 활용해 스플레시 화면 구현</summary>
<img src=https://github.com/user-attachments/assets/f8bd89bc-033e-4aee-b4e7-06ee809b3a33 width=220>
</details>
<details>
<summary><b>LocalizedError</b>protocol을 채택함으로써 <b>에러에 대한 이유를 설명</b>할 수 있는 APIError 구현 (열거형으로 오류 처리)</summary>
  
```
enum WeatherAPIError: Int, LocalizedError {
    case canNotFindAPIKey = 401
    case badRequest = 404
    case tooManyRequest = 429
    case notFound = 500
    ...
    var errorDescription: String? {
      switch self {
      case .canNotFindAPIKey:
          return "인증되지 않은 요청입니다."
      case .badRequest:
          return "잘못된 요청입니다."
    ...
      }
    }
}
```
</details>
<details>
<summary><b>CompositionalLayout</b>를 활용해 <b>Self-Sizing Cell</b> 및 <b>pinnedSectionHeader</b> 구현</summary>

```
...
let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(30)),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
    )
    sectionHeader.pinToVisibleBounds = true
    sectionHeader.zIndex = 2
    section.boundarySupplement
...
```
</details>
<details>
<summary><b>Dependency Injection</b>을 통해 Testable한 코드 작성, 각 컴포넌트 간의 의존성 감소</summary>
  
```
private let viewModel: WeatherViewModel

init(viewModel: WeatherViewModel) {
    self.viewModel = viewModel
    super.init()
}
```
</details>
 <details>
<summary><b>final</b> 키워드와 <b>접근제어자</b>를 사용하여 컴파일 최적화</summary>
  
```
final class WeatherViewController: BaseViewController, SendCityDelegate {
    private let mainView = WeatherView()
    private let viewModel: WeatherViewModel
...
```
</details>
<details>
<summary><b>AnyObject</b>을 채택한 protocol 구현을 통해 protocol을 채택할 수 있는 객체의 타입을 제한하여 메모리 누수 방지</summary>
  
```
final class WeatherViewController: BaseViewController, SendCityDelegate {
protocol ViewProtocol: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}
```
</details>
<details>
<summary><b>weak self</b>키워드 사용을 통해 메모리 누수 방지</summary>
  
```
animationView.play { [weak self] completed in
    guard let self else { return }
    dispatchGroup.leave()
}
```
</details>
<details>
<summary><b>URLRequestConvertible</b> protocol을 채택한 Router를 구성하여 API 로직 캡슐화 및 효율적인 관리</summary>
  
```
protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var parameters: String? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
...
```
</details>
<details>
<summary><b>Generic</b>을 통해 네트워크 통신 메서드 추상화</summary>
  
```
func request<T: Decodable, U: TargetType>(model: T.Type, router: U) -> Single<Result<T, Error>>
```
</details>
<details>
<summary>ViewModel에 <b>ViewModelType</b>protocol을 채택함으로써 공통된 프로퍼티와 메서드 구성</summary>
  
```
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
    
}
```
</details>
<details>
<summary><b>Singleton</b> 패턴을 통해 불필요한 인스턴스 생성 방지 및 리소스 절약</summary>
  
```
final class CityManager {
    static let shared = CityManager()
    private var cityList: [City] = []
    
    private init() { }
...
```
</details>
<details>
<summary><b>BaseView</b>를 통해 일관된 View 구조 형성</summary>
  
```
class BaseView: UIView, ViewProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() {
        backgroundColor = Color.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```
</details>
<details>
<summary>API query를 <b>객체로 추상화</b>하여 query 파라미터를 효율적으로 관리</summary>
  
```
struct FetchWeatherQuery {
    let lat: String
    let lon: String
    let cnt: String?
    let lang: String
    
    init(lat: Double, lon: Double, cnt: String? = nil, lang: String = Language.korea.rawValue) {
        self.lat = String(lat)
        self.lon = String(lon)
        self.cnt = cnt
        self.lang = lang
    }
}

enum WeatherRouter {
    case fetchWeather(fetchWeatherQuery: FetchWeatherQuery)
}
...
```
</details>
<details>
<summary><b>MVVM과 Input-Output 패턴</b>을 사용한 비즈니스 로직 분리로 데이터의 흐름 명확화</summary>
  
```
final class WeatherViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    private let weatherEntityMapper = WeatherEntityMapper()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        ...
    }
    
    struct Output {
        let searchButtonTapped: Driver<Void>
        ...
    }
}
```
</details>
<details>
<summary><b>CustomView</b>를 구현하여 동일한 디자인 패턴을 가진 View 구현</summary>
  
```
final class SearchBar: UISearchBar {
    
    init(placeholder: String, backgroundColor: UIColor = Color.backgroundGray.withAlphaComponent(0.8)) {
        super.init(frame: .zero)
        configureView(placeholder: placeholder, backgroundColor: backgroundColor)
    }
    
    private func configureView(placeholder: String, backgroundColor: UIColor) {\
    ...
    }
}
```
</details>
<details>
<summary><b>private</b> 키워드 사용을 통해 외부에서 객체 속성에 대한 접근 및 잘못된 코드의 호출 방지</summary>
  
```
final class DateManager {
    static let shared = DateManager()
    
    private init() { }
    ...
}
```
</details>
<details>
<summary><b>NetworkMonitor</b>를 활용해 네크워크 실시간 모니터링 및 네트워크 단절 상황 대응</summary>
  
```
NetworkMonitorManager.shared.startMonitoring { [weak self] connectionStatus in
  guard let self else { return }
  switch connectionStatus {
  case .satisfied:
      self.removeNetworkErrorWindow()
  case .unsatisfied:
      self.showNetworkErrorWindow(on: scene)
  default:
      break
}
    }
```
</details>

<Br><br>


## 🔥 트러블슈팅
### 1️⃣ 셀마다 다양한 데이터 타입을 가지는 상황에서 RxDataSource 연동 방법에 대한 고민


<br><br>
## 📂 폴더링 구조
```
WeatherScanner
├── Resources
└── Sources
    ├── Application
    ├── Util
    │   ├── Manager
    │   ├── Enum
    │   ├── Extension
    │   └── Protocool
    ├── Base
    ├── CustomView
    ├── Network
    │   ├── Router
    │   ├── Mananger
    │   ├── Error
    │   ├── APIKey
    │   ├── Util
    │   └── Query
    ├── Model
    │   ├── Encodable
    │   └── Decodable
    ├── Data
    └── Scene
      	├── Splash
        │   └── View
      	├── Weather
        │   ├── View
        │   └── ViewModel
        └── Search
            ├── View
            └── ViewModel
```
