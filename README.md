# ShopApp

Демо-приложение для тестового задания.

## Стек
- Swift 5.10+, iOS 15.0+
- UIKit для главного экрана, SwiftUI для регистрации
- Архитектура: MVP + Coordinator, принципы SOLID, Clean Architecture-слои
- Сеть: URLSession через `ClientType`
- Хранилище: `UserDefaults` через `SessionStoreType`
- Тесты: XCTest

## Скриншоты
| Регистрация | Каталог | Приветствие |
|---|---|---|
| ![registration](Docs/registration.png) | ![catalog](Docs/catalog.png) | ![greeting](Docs/greeting.png) |

## Возможности
- Регистрация: имя, фамилия, дата рождения, пароль и подтверждение  
- Валидации: фамилия ≥ 2 символов, пароль содержит цифру и заглавную букву  
- Кнопка «Регистрация» активна только при заполнении всех полей  
- Переход на главный экран после успешной регистрации  
- Имя кэшируется локально, сессия сохраняется между запусками  
- Главный экран: список товаров с названием и ценой, кнопка «Приветствие» с именем пользователя

## API
`GET https://fakestoreapi.com/products`  
Используются поля `id`, `title`, `price`.

## Архитектура
- **Coordinator** создаёт окно, выбирает стартовый экран по `SessionStoreType.isRegistered`.
- **Registration (SwiftUI)**: вся логика в `RegistrationViewModel`. По успеху — запись имени и флага регистрации, навигация в координаторе.
- **Main (UIKit, MVP)**:  
  Presenter → Interactor(API) → Presenter мапит в `CellViewModel` → ViewController рендерит.

## Тесты
- `ValidatorTests` проверяют валидаторы полей.
- `RegistrationViewModelTests` проверяет успешную регистрацию и запись сессии.

## Примечания
- Главный экран недоступен без регистрации.
- Сброс сессии: удалить приложение из симулятора.

