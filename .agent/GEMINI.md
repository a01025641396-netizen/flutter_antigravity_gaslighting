# GEMINI.md: AI 개발자 어시스턴트를 위한 프로젝트 가이드

# GEMINI.md: AI 개발자 어시스턴트를 위한 프로젝트 가이드

이 문서는 AI 개발자 어시스턴트가 "날씨앱" 프로젝트를 이해하고 효과적으로 지원하기 위한 가이드입니다. 프로젝트의 구조, 기술 스택, 주요 설정 및 개발 워크플로우에 대한 정보를 제공합니다.

## 1. 프로젝트 개요

- **프로젝트명:** 날씨앱
- **설명:** Flutter 기반의 모바일 애플리케이션으로, 현재 위도 경도의 날씨 정보를 가져오는 등의 기능을 포함합니다.
- **주요 기술:** Flutter 3.38.4, http, MVVM, Riverpod

## 2. 기술 스택 및 주요 라이브러리

- **프레임워크:** Flutter (`3.38.4`)
- **언어:** Dart 3.10.3
- **상태관리:** flutter_riverpod ^3.2.0
- **http통신:** http ^1.6.0
- **GPS:** geolocator: ^14.0.2

## 3. 디렉토리 구조

- **`lib/`**: 애플리케이션의 주요 소스 코드가 위치합니다.
- **`lib/data/model/`**: MVVM의 모델 클래스가 위치합니다.
- **`lib/data/repository/`**: MVVM의 Repository 클래스가 위치합니다.
- **`lib/ui/`**: 위젯들이 위치합니다.
- **`lib/ui/각페이지/`**: 각페이지 위젯과 뷰모델이 위치합니다.
- **`lib/ui/각페이지/widgets/`**: 각페이지 내에서 사용되는 로컬 위젯들이 위치합니다.
- **`lib/ui/widgets/`**: 앱 내에서 전역적으로 사용되는 위젯들이 위치합니다.


## 5. 코딩 스타일 및 규칙

* **언어:** Dart 3.0+의 **Strong Typing** 및 **Sound Null Safety**를 엄격히 준수합니다. [Effective Dart](https://dart.dev/guides/language/effective-dart) 스타일 가이드에 따라 모든 공용 API에 타입을 명시하고 `var` 보다는 구체적인 타입을 사용합니다.
* **아키텍처 패턴:** **MVVM (Model-View-ViewModel)** 패턴을 따릅니다.
* **View:** UI 레이아웃 및 사용자 인터랙션 담당 (`lib/ui/`)
* **ViewModel:** 비즈니스 로직 및 상태 관리 (`lib/ui/각페이지/` 내 Riverpod Notifier 활용)
* **Repository:** API 통신 및 데이터 로드 추상화 (`lib/data/repository/`)
* **Model:** 순수 데이터 객체 (`lib/data/model/`)


* **의존성 관리 (DI):**
* **Riverpod**을 의존성 주입(DI) 도구로 사용합니다.
* ViewModel은 구체적인 Repository 클래스가 아닌 추상 인터페이스에 의존하여 결합도를 낮춥니다(DIP).


* **에러 처리:**
* Data 레이어에서는 예외를 던지는 대신 에러 메시지를 포함한 결과 객체를 반환하거나, `try-catch`를 통해 상위 레이어로 에러를 전파합니다.
* UI에서는 `AsyncValue`를 사용하여 Loading, Error, Data 상태를 명확히 구분하여 렌더링합니다.



## 6. 데이터 및 외부 서비스 연동

* **데이터 모델 (Pure Dart):**
* 외부 라이브러리(`freezed` 등) 없이 **순수 Dart 클래스**를 사용합니다.
* 모든 필드는 `final`로 선언하여 불변성을 유지하고, JSON 변환은 `factory Model.fromJson` 및 `Map<String, dynamic> toJson()` 메서드를 직접 구현합니다.


* **네트워크:** `http` 패키지를 사용하며, 날씨 API 응답에 대한 `statusCode` 체크 및 JSON 파싱 에러 처리를 철저히 수행합니다.
* **위치 정보:** `geolocator`를 사용하여 사용자 권한 확인 및 현재 위도/경도 획득 로직을 처리합니다.

## 7. 핵심 개발 철학 및 방향성

* **Maintainability First:** 복잡한 기교보다는 명확하고 읽기 쉬운 코드를 지향합니다. 위젯은 쪼개고, 로직은 뷰모델로 옮깁니다.
* **Performance:** 리빌드 최적화를 위해 위젯 생성자에 `const`를 붙이고, Riverpod의 `select`를 활용해 필요한 상태 변화만 구독합니다.
* **Testability:** Repository와 ViewModel은 UI 없이 독립적으로 단위 테스트가 가능해야 하며, `test/` 디렉토리에 테스트 코드를 작성합니다.
* **Defensive Programming:** API 응답의 Null 값 가능성을 항상 고려하며, `?.` 연산자와 기본값(`??`) 설정을 꼼꼼하게 수행합니다.

## 8. AI 어시스턴트 활용 가이드

* **코드 생성/수정:** 반드시 MVVM 구조를 유지하세요. 로직은 ViewModel에, 데이터 접근은 Repository에 위치시켜야 합니다.
* **데이터 모델 생성:** 모델 요청 시 코드 생성기 없이 순수 Dart 클래스로 작성하세요. `copyWith` 메서드를 포함하여 불변 객체 복사가 용이하도록 만드세요.
* **리팩토링:** 위젯 내부에서 `http` 호출이나 직접적인 비즈니스 로직이 발견되면 즉시 Repository나 ViewModel로 분리할 것을 제안하세요.
* **테스트 코드:** 기능을 추가할 때마다 `test/` 폴더에 관련 Unit Test를 작성하고, `mocktail`을 사용해 네트워크 요청을 모킹(Mocking)하세요.