# Rick and Morty Character Browser

Flutter-приложение для просмотра персонажей мультсериала «Рик и Морти» с поддержкой избранного и оффлайн-режима.

## Возможности

- Список персонажей с пагинацией (подгрузка при прокрутке)
- Поиск персонажей по имени
- Добавление/удаление из избранного
- Оффлайн-доступ к ранее загруженным данным
- Светлая и тёмная тема
- Анимация при добавлении в избранное

## Архитектура

**Clean Architecture** с тремя слоями:

```
lib/
├── core/           — общие утилиты, тема, обработка ошибок, сетевой статус
├── data/           — модели API, SQLite база, data sources, реализация репозитория
├── domain/         — сущности, абстрактный репозиторий, use cases
└── presentation/   — Cubit (state management), экраны, виджеты
```

### Ключевые решения

- **Repository pattern**: абстракция над remote/local data sources с `Either<Failure, T>`
- **Offline-first**: данные кэшируются в SQLite при каждом запросе; при отсутствии сети — показываются из кэша
- **Favorites**: хранятся как флаг `is_favorite` в той же таблице персонажей (upsert с сохранением)
- **DI**: `get_it` для dependency injection

## Технологии

| Назначение | Пакет |
|---|---|
| Сеть | `dio` |
| Локальное хранилище | `sqflite` |
| State Management | `flutter_bloc` (Cubit) |
| DI | `get_it` |
| Кэш изображений | `cached_network_image` |
| Сетевой статус | `connectivity_plus` |
| Функциональные типы | `dartz` |

## API

[Rick and Morty API](https://rickandmortyapi.com/documentation/) — публичный REST API, без авторизации.

## Запуск

### Требования

- [FVM](https://fvm.app/) — менеджер версий Flutter
- GNU Make

### Быстрый старт

```bash
# Полная сборка (установка FVM SDK, зависимости, lint, тесты, APK)
make all

# Или по шагам:
make setup       # Установка Flutter SDK через FVM + pub get
make analyze     # Статический анализ
make format      # Форматирование кода
make test        # Тесты
make build-apk   # Сборка debug APK
make run         # Запуск
```

### Все команды

```bash
make help
```

## Версия Flutter

Зафиксирована через FVM в `.fvmrc` — **3.41.6** (stable).

## Python-калькулятор

В корне проекта находится инженерный консольный калькулятор на Python. Он
поддерживает операции `+`, `-`, `*`, `/`, `%`, `**`, скобки, унарные знаки,
константы `pi`, `e`, `tau`, а также:

- тригонометрию: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`;
- гиперболические функции: `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh`;
- `sqrt`, `cbrt`, `ln`, `log`, `log2`, `exp`, `abs`, `factorial`;
- преобразование углов: `degrees`, `radians`.

По умолчанию углы задаются в радианах. В интерактивном режиме используйте
`mode deg` или `mode rad`, например `sin(90)` после переключения в градусы.
Вычисления выполняются через безопасный белый список AST, без `eval`.

```bash
python calculator.py
```

Для выхода введите `q`, `quit` или `exit`. Тесты запускаются стандартным
модулем Python:

```bash
python -m unittest -v test_calculator.py
```

### Portable-файл для Windows

Готовая portable-версия не требует установленного Python и запускается одним
файлом `EngineeringCalculator.exe`. [Скачать готовый файл](https://github.com/Arkghol/Flutter-test-Rick-Morty/raw/agents/python-calculator-program-upload/dist/EngineeringCalculator.exe),
положить его в любую папку и запустить двойным щелчком.

Для самостоятельной сборки на Windows установите PyInstaller и выполните:

```powershell
python -m pip install pyinstaller
.\build_portable.ps1
```

Результат появится в `dist\EngineeringCalculator.exe`.
