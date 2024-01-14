# 프로젝트 소개

## 개요
이 프로젝트는 검색 기능을 중심으로 한 iOS 애플리케이션입니다.
MVVM 아키텍처를 기반으로 구현되었으며, 비즈니스 로직에 대한 테스트 코드를 포함하고 있습니다.


## 주요 특징
MVVM 아키텍처: 모델, 뷰, 뷰모델을 분리하여 앱의 구조를 설계했습니다. 비즈니스 로직과 프레젠테이션 로직을 분리하여 유지보수와 테스트가 용이하도록 했습니다.
테스트 코드: 비즈니스 로직에 대한 테스트 코드를 작성하여 앱의 안정성과 신뢰성을 높였습니다.

프리뷰 사용: XIB나 스토리보드 대신 코드베이스로 작업하며 Mock을 활용하여 실시간으로 UI 변경사항을 확인하고 이를 통해 더 빠르고 효율적인 UI 개발을 할 수 있었습니다.


## Demo
![Demo](demo.gif)


## 주요 기능 소개
### 검색화면
Feature > Search > SearchViewController.swift
- SearchViewModel.swift에서 비즈니스 로직을 담당하고 키워드 검색 및 pagination 기능을 수행합니다.
- SearchResult.swift
  - 검색화면 API에서 내려주는 total, page를 숫자로 변환해서 사용, 검색 결과가 없을시 page가 안내려오는 상황 고려 변환해서 사용했습니다.

### 상세화면
Feature > Book > BookViewController.swift
- BookViewModel.swift에서 비즈니스 로직을 담당하고 빠른 실행을 위해 init에서 상세화면 정보를 받아옴니다.
- BookItem.swift
  - 상세화면 API에서 내려주는 책의 정보를 UI 요구사항에 맞춰서 맞춤형으로 변환해서 사용했습니다.

### 이미지 캐시
UI > TSImageCache > ImageCache.swift
- 메모리 / 디스크 캐시를 구성해, 이미지를 중복 다운로드하지 않도록 구현했습니다.
```swift
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> ImageSessionDataTaskProtocol? {
        let cacheKey = NSString(string: url.absoluteString)
        
        // 메모리 캐시에서 이미지를 먼저 확인
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return nil
        }
        
        // 디스크 캐시에서 이미지 확인
        if let diskCachedImage = loadImageFromDisk(withKey: url.absoluteString) {
            imageCache.setObject(diskCachedImage, forKey: cacheKey) // 메모리 캐시에도 저장
            completion(diskCachedImage)
            return nil
        }
        
        // 이미지를 네트워크에서 다운로드
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: cacheKey) // 메모리 캐시에 저장
                self.saveImageToDisk(image, withKey: url.absoluteString) // 디스크에 저장
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
        return task
    }
```

UI > TSImageCache > UIImageView+Download.swift
- UIImageView를 확장해 ImageCache를 활용해 UITableViewCell이 재사용되는 특성을 고려해 사용하기 편하게 구현했습니다.
- 같은 UIImageView에서 요청시 이전 이미지 다운을 취소 및 ImageUrl을 비교해 다른 Cell의 UIImageView에서 이미지가 나타나지 않도록 구현했습니다.
```swift
extension UIImageView {
    ...
    func setImage(with url: URL) {
        cancelImageLoad()
        currentURL = url

        task = ImageCache.shared.loadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                // 현재 이미지 뷰가 같은 URL의 이미지를 기다리고 있는지 확인
                if self?.currentURL == url, let image = image {
                    self?.image = image
                }
            }
        }
    }
}
```

### 네트워크
Core > TSNetwork > APIService.swift
- APIEndpointProtocol를 Moya의 사용법과 비슷하게 정의해 baseURL, path, method, task, headers를 확장성 있게 구현했습니다.


## 유닛 테스트
SearchViewModelTests.swift
  - 첫 페이지와 다음 페이지에 대한 검색 결과를 테스트
  - 사용자가 빠르게 스크롤하여 '다음 페이지' 검색을 거의 동시에 여러 번 요청하는 상황을 테스트
  - 검색 결과를 초기화하는 기능을 테스트
  - 검색 결과가 없는 경우의 처리를 테스트
  - 네트워크 요청 실패 시의 처리를 테스트
  - SearchClientProtocol을 토대로 테스트와 실 환경에 맞는 의존성 주입 활용

BookViewModelTests.swift
  - 책 정보 가져오기 성공을 테스트
  - 책 정보 가져오기 실패를 테스트
  - BookClientProtocol을 토대로 테스트와 실 환경에 맞는 의존성 주입 활용

ImageCacheTests.swift
  - 네트워크에서 이미지를 성공적으로 로드하고, 해당 이미지를 메모리와 파일에 저장하는지 검증하는 테스트
  - 이미지 로드 실패 시의 동작을 테스트
  - ImageFileMangerProtocol, ImageSessionProtocol, ImageSessionDataTaskProtocol을 토대로 테스트와 실 환경에 맞는 의존성 주입 활용

UIImageViewImageCacheTests.swift
  - UIImageView의 setImage(with:) 메서드가 새로운 이미지 요청을 시작할 때 이전 요청을 취소하는지 확인하는 테스트

APIServiceTests.swift
  - 서버로부터 성공적인 응답을 받았을 때의 처리를 검증
  - 네트워크 오류 시나리오 (예: 인터넷 연결 끊김)를 테스트
  - 서버로부터의 비정상적인 HTTP 상태 코드 (예: 400 Bad Request)에 대한 처리를 테스트
  - 요청이 타임아웃에 도달하는 경우의 처리를 검증
  - APISessionProtocol을 토대로 테스트와 실 환경에 맞는 의존성 주입 활용


## 프로젝트를 진행하면서
### 어려웠던 점
BookViewModel의 API 테스트
  - BookViewModel에서 책 상세 정보를 빠르게 가져오기 위해 생성자(init)에서 API 호출을 진행했습니다.
  - 그러나 이 방식은 BookViewModel의 프로퍼티들을 테스트할 때 정확한 검증이 어려웠습니다.
  - 이는 생성자에서 발생하는 비동기 작업이 테스트 케이스와 동기화되지 않아, 예상한 시점에 데이터가 준비되지 않는 문제를 야기했습니다.
  - 해결: isLoading 프로퍼티를 옵저빙할때 첫번째 값을 제외하고(초기값 false 혹은 네트워크 요청 중인 true를 제거) isLoading이 false로 바뀌는 순간 네트워크 요청이 완료된 것이라고 판단해서 처리했습니다.
  
UITableViewDataSourcePrefetching의 버그
  - 문제: 페이지가 넘어가지 않는 이슈
  - 재현: 첫 페이지에서 빠르게 스크롤을 하면 다음 페이지로 못 넘어감
  - 원인: UITableViewDataSourcePrefetching의 tableView(_:prefetchRowsAt:)를 이용해서 pagination 기능을 추가했는데  첫 페이지에서 빠르게 스크롤을 하면 indexPaths가 [[0, 4]]까지 밖에 안들어오는 버그가 있음
  - 해결: UIScrollViewDelegate의 scrollViewDidScroll(_:)에서 contentOffset을 활용하는 방법으로 수정
  - 문제의 코드
```swift
// MARL: - UITableViewDataSourcePrefetching
extension SearchViewController {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard viewModel.items.count > 0, viewModel.hasNextPage, !viewModel.isLoading else { return }
        
        // 첫 페이지에서 빠르게 스크롤시 [[0, 9]] 까지 들어오지 않음
        // indexPaths >> [[0, 0]] ... [[0, 4]] 까지 들어와 아래 조건 (4 >= 9) 성립 안됨 
        if indexPaths.contains(where: { $0.row >= viewModel.items.count - 1 }) {
            Task {
                await viewModel.searchNextPage()
            }
        }
    }
}
```

### 고려했던 점
배열 접근의 안전성
  - 배열을 다룰 때 subscript를 사용하여 out of bounds 에러를 방지했습니다.

UITableViewDiffableDataSource 적용
  - UITableViewDataSource 대신 UITableViewDiffableDataSource를 사용함으로써, indexPath 기반 대신 Hash를 이용해 데이터를 관리했습니다.
  - 섹션과 항목에 대한 고유 식별자를 사용하여 데이터의 상태를 관리하며, 이를 통해 복잡한 데이터 업데이트를 보다 쉽고 안정적으로 처리할 수 있었습니다.

실 환경과 테스트 환경 분리
  - 의존성 주입을 위해 Protocol 정의
```swift
protocol SearchClientProtocol {
    func search(keyword: String, page: Int) async throws -> SearchResult
}
```
  - 실 환경: 실제 API 통신하도록 구현
```swift
struct RealSearchClient: SearchClientProtocol {
    private let service = SearchAPIService()
    
    func search(keyword: String, page: Int) async throws -> SearchResult {
        do {
            let data = try await service.request(.search(keyword: keyword, page: page))
            let decoder = JSONDecoder()
            let searchResult = try decoder.decode(SearchResult.self, from: data)
            return searchResult
        } catch {
            throw error
        }
    }
}
```
  - 테스트 환경: 결과값을 주입 받아서 사용할 수 있게 구현
```swift
struct MockSearchClient: SearchClientProtocol {
    var searchResults: [Int: SearchResult] = [:]
    var error: Error?
    var delayInSeconds: TimeInterval = 0  // 딜레이 시간 (초 단위)
    
    func search(keyword: String, page: Int) async throws -> SearchResult {
        // 인위적인 딜레이 추가
        if delayInSeconds > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
        }
        
        if let error = error {
            throw error
        }
        return searchResults[page] ?? .mock1
    }
}
```
  - 사용
```swift
class SearchViewModel {
    ...
    // MARK: - Initialize with Client
    private let searchClient: SearchClientProtocol
    
    init(searchClient: SearchClientProtocol) {
        self.searchClient = searchClient
    }
    ...
}
```

## 개선점 및 미래 계획
이미지 로드 시점 변경
  - UITableViewDataSourcePrefetching의 tableView(_:prefetchRowsAt:)에서 이미지 다운로드 요청 미리해서 스크롤시 빠르게 이미지를 보여주게 하면 좋겠습니다.

모듈화 진행
  - 프로젝트의 확장성과 관리 효율성을 높이기 위해 모듈화를 하면 좋을거 같습니다.
  - 현재는 폴더 구조를 통해 기능별로 코드를 구분해 놓았으며, 향후 Swift Package Manager(SPM) 또는 Tuist를 활용하여 더 체계적으로 모듈을 관리하면 좋겠습니다.
  - 이를 통해 각 기능의 독립성을 높이고, 유지보수 및 협업의 효율성을 개선할 수 있을 것으로 기대합니다.
