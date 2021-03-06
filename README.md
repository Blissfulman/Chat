[![CI](https://github.com/TFS-iOS/chat-app-Blissfulman/actions/workflows/github.yml/badge.svg)](https://github.com/TFS-iOS/chat-app-Blissfulman/actions/workflows/github.yml)

# Приложение Chat

## Приложение разрабатывалось в течение практики в компании Tinkoff осенью 2021 года

**Идея приложения**: приложение для обмена сообщениями в различных каналах.

**Основные возможности**:

1. Добавление/удаление каналов.
2. Отправка сообщений, в том числе изображений.
3. Поиск изображений в сети на основе поискового запроса (для поиска используется API Pixabay).
4. Редактирование своего профиля с возможностью добавления аватара из галереи, с камеры, либо посредством поиска изображения в сети.
5. Смена темы приложения.

**Особенности реализации**:

1. **SOA**, presentation слой реализован на **Clean Swift** и **MVP**.
2. Вёрстка интерфейса выполнена кодом.
3. В качесте удалённого хранилища данных использовался **Firebase/Firestore**.
4. Полученные из Firestore данные о каналах и просмотренных сообщениях **кешируются локально в Core Data** и отображаются без доступа к сети.
5. Отображение данных о каналах и сообщениях реализовано посредством `NSFetchedResultsController`.
6. Сетевое взаимодействие с API реализовано нативными средствами.
7. Реализовано **асинхронное сохраниние и чтение данных** там, где это необходимо (с использованием `DispatchQueue` и `OperationQueue`).
8. Конфиденциальные данные сохраняются в **Keychain**, настройки проиложения сохраняются в файле.
9. Часть бизнес-логики покрыта **Unit-тестами**, есть один **UI-тест**.
10. Реализованы различные анимации и кастомизированный переход между экранами.
11. Реализован **GitHub Actions CI**.