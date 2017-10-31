# 1C Database copier (cpdb)

Набор скриптов oscript для копирования баз данных 1C / MS SQL и развертывания на целевой системе.
Типичный сценарий работы:
1. Сформировать резервную копию базы
2. Передать резервную копию на целевую систему
    - Через общую папку / С использованием Yandex-Диск 
    - Возможно разбиение больших файлов на части (используется 7-zip)
5. Восстановить резервную копию в новую или существующую базу
6. Подключить базу к хранилищу конфигурации

Требуются следующие библиотеки и инструменты:
- [cmdline](https://github.com/oscript-library/cmdline)
- [1commands](https://github.com/artbear/1commands)
- [logos](https://github.com/oscript-library/logos)
- [v8runner](https://github.com/oscript-library/v8runner)
- [ReadParams](https://github.com/Stepa86/ReadParams)
- [yadisk](https://github.com/kuntashov/oscript-yadisk)
- [7-zip](http://www.7-zip.org/)


| Возможные команды ||
|-|-|
| **help** | - Вывод справки по параметрам |
| **backup** | - Создание резервной копии базы MS SQL |
| **restore** | - Восстановление базы MS SQL из резервной копии |
| **compress** | - Выполнить компрессию страниц таблиц и индекстов в базе MS SQL |
| **dumpib** | - Выгрузить информационную базу в файл |
| **restoreib** | - Загрузить информационную базу из файла |
| **putyadisk** | - Помещение файла на Yandex-Диск |
| **getyadisk** | - Получение файла из Yandex-Диска |
| **mapdrive** | - подключить сетевой диск |
| **umapdrive** | - отключить сетевой диск |
| **copy** | - копировать/переместить файлы |
| **split** | - Архивировать файл с разбиением на части указанного размера (используется 7-Zip) |
| **merge** | - Разархивировать файл (используется 7-Zip) |
| **uconstorage** | - Отключить информационную базу от хранилища конфигураций |
| **constorage** | - Подключить информационную базу к хранилищу конфигураций |

Для подсказки по конкретной команде наберите help <команда>


## backup - Создание резервной копии базы MS SQL

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-sql-srvr** | - Адрес сервера MS SQL |
| **-sql-db** | - Имя базы для восстановления |
| **-sql-user** | - Пользователь сервера |
| **-sql-pwd** | - Пароль пользователя сервера |
| **-bak-path** | - Путь к резервной копии |

#### Пример:
```
cpdb backup -sql-srvr MySQLName MyDatabase -sql-user sa -sql-pwd 12345 -bak-path "d:\MSSQL\Backup\MyDatabase_copy.bak"
```


## restore - Восстановление базы MS SQL из резервной копии

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-sql-srvr** | - Адрес сервера MS SQL |
| **-sql-db** | - Имя базы для восстановления |
| **-sql-user** | - Пользователь сервера |
| **-sql-pwd** | - Пароль пользователя сервера |
| **-bak-path** | - Путь к резервной копии |
| **-create-db** | - Создать базу в случае отсутствия |
| **-db-owner** | - Имя владельца базы после восстановления |
| **-compress-db** | - Включить компрессию страниц таблиц и индексов после восстановления |
| **-shrink-db** | - Сжать базу после восстановления |
| **-db-path** | - Путь к каталогу файлов данных базы после восстановления |
| **-db-logpath** | - Путь к каталогу файлов журнала после восстановления |
| **-db-recovery** | - Установить модель восстановления (RECOVERY MODEL), возможные значения "FULL", "SIMPLE", "BULK_LOGGED" |
| **-db-changelfn** | - Изменить логические имена файлов (LFN) базы, в соответствии с именем базы |
| **-delsrc** | - Удалить файл резервной копии после восстановления | 

#### Пример:
```
cpdb restore -sql-srvr MyNewSQLServer -sql-db MyDatabase_copy -sql-user SQLUser -sql-pwd 123456 -bak-path "d:\data\MyBackUpfile.bak" -create-db -shrink-db -db-owner SQLdbo -db-path "d:\MSSQL\data" -db-logpath "e:\MSSQL\logs" -db-recovery SIMPLE -delsrc
```


## compress - Выполнить компрессию страниц таблиц и индекстов в базе MS SQL

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-sql-srvr** | - Адрес сервера MS SQL |
| **-sql-db** | - Имя базы для восстановления |
| **-sql-user** | - Пользователь сервера |
| **-sql-pwd** | - Пароль пользователя сервера |
| **-shrink-db** | - Сжать базу после выполнения компрессии |

#### Пример:
```
cpdb compress -sql-srvr MyNewSQLServer -sql-db MyDatabase_copy -sql-user SQLUser -sql-pwd 123456 -shrink-db
```


## dumpib - Выгрузить информационную базу в файл

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-ib-path** | - Строка подключения к ИБ |
| **-ib-user** | - Пользователь ИБ |
| **-ib-pwd** | - Пароль пользователя ИБ |
| **-dt-path** | - Путь к файлу для выгрузки ИБ |
| **-uccode** | - Ключ разрешения запуска ИБ |
| **-v8version** | - Версия платформы 1С |

#### Пример:
```
cpdb dumpib -ib-path "/FD:/data/MyDatabase" -dt-path "d:\data\1Cv8.dt" -ib-user Администратор -ib-pwd 123456 -v8version 8.3.8 -uccode 1234
```


## restoreib - Загрузить информационную базу из файла

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-ib-path** | - Строка подключения к ИБ |
| **-ib-user** | - Пользователь ИБ |
| **-ib-pwd** | - Пароль пользователя ИБ |
| **-dt-path** | - Путь к файлу для загрузки в ИБ |
| **-delsrc** | - Удалить файл после загрузки |
| **-uccode** | - Ключ разрешения запуска ИБ |
| **-v8version** | - Версия платформы 1С |

#### Пример:
```
cpdb restoreib -ib-path "/FD:/data/MyDatabase" -dt-path "d:\data\1Cv8.dt" -ib-user Администратор -ib-pwd 123456 -v8version 8.3.8 -uccode 1234 -delsrc
```


## putyadisk - Помещение файла на Yandex-Диск

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-file** | - Путь к локальному файлу для помещения на Yandex-Диск |
| **-list** | - Путь к локальному файлу со списком файлов, которые будут помещены на Yandex-Диск (параметр -file игнорируется) |
| **-ya-token** | - Token авторизации |
| **-ya-path** | - Путь к каталогу на Yandex-Диск, куда помещать загружаемые файлы |
| **-check-hash** | - (TBE) Проверять соответствие хешей скопированных файлов. Работает только в том случае, когда имеется файл <имяархива>.hash с MD5-хешами частей файлов (формируется командой split) |
| **-delsrc** | - Удалить исходные файлы после отправки |

#### Пример:
```
cpdb putyadisk -file "d:\MSSQL\Backup\MyDatabase_copy.bak" -ya-token XXXXXXXXXXXXXXXXXXXXXXXXXXXXX -ya-path "/transfer/MyDatabase_copy.bak" -delsrc
```
```
cpdb putyadisk -list "d:\MSSQL\Backup\MyDatabase_copy.split" -ya-token XXXXXXXXXXXXXXXXXXXXXXXXXXXXX -ya-path "/transfer/MyDatabase_copy.bak" -delsrc

```


## getyadisk  - Получение файла из Yandex-Диска

### Параметры:

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-path** | - Путь к локальному каталогу для сохранения загруженных файлов|
| **-ya-token** | - Token авторизации |
| **-ya-file** | - Путь к файлу на Yandex-Диск для загрузки |
| **-ya-list** | - Путь к файлу на Yandex-Диск со списком файлов, которые будут загружены (параметр -ya-file игнорируется) |
| **-delsrc** | - Удалить файлы из Yandex-Диск после получения |

#### Пример:
```
cpdb getyadisk -path "d:\MSSQL\Backup\MyDatabase_copy.bak" -ya-token XXXXXXXXXXXXXXXXXXXXXXXXXXXXX -ya-file "/transfer/MyDatabase_copy.bak" -delsrc
```
```
cpdb getyadisk -path "d:\MSSQL\Backup\MyDatabase_copy.bak" -ya-token XXXXXXXXXXXXXXXXXXXXXXXXXXXXX -ya-list "/transfer/MyDatabase_copy.split" -delsrc
```


## mapdrive - Подключить сетевой диск

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет) |
| **-map-drive** | - Имя устройства (буква диска) |
| **-map-res** | - Путь к подключаемому ресурсу |
| **-map-user** | - Пользователь для подключения |
| **-map-pwd** | - Пароль для подключения |

#### Пример:
```
cpdb mapdrive -map-drive N -map-res "\\MyServer\MyFolder" -map-user superuser -map-pwd P@$$w0rd
``` 


## umapdrive - Отключить сетевой диск

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет) |
| **-map-drive** | - Имя устройства (буква диска) |

#### Пример:
```
cpdb umapdrive -map-drive N
``` 


## copy - скопировать/переместить файлы

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-src** | - Файл источник |
| **-dst** | - Файл/каталог приемник (если оканчивается на "\", то каталог) |
| **-replace** | - Перезаписывать существующие файлы |
| **-delsrc** | - Выполнить перемещение файлов (удалить источник после копирования) |

#### Пример:
```
cpdb copy -src "d:\MSSQL\Backup\MyDatabase_copy.bak" -dst "N:\NewDestination\" -replace -delsrc
```


## split - Архивировать файл с разбиением на части указанного размера
Используется 7-zip

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет) |
| **-src** | - Путь к исходному локальному файлу для разбиения |
| **-arc** | - Имя файла архива (не обязательный, по умолчанию <имя исходного файла>.7z) |
| **-list** | - Имя файла, списка томов архива (не обязательный, по умолчанию <имя исходного файла>.split) |
| **-vol** | - Размер части {\<g>, \<m>, \<b>} (по умолчанию 50m) |
| **-hash** | - Рассчитывать MD5-хеши файлов частей |
| **-hash-file** | - Имя файла, списка хэшей томов архива  (не обязательный, по умолчанию <имя исходного файла>.hash) |
| **-delsrc** | - Удалить исходный файл после выполнения операции |

#### Пример:
```
cpdb split "d:\MSSQL\Backup\MyDatabase_copy.bak" -list "d:\MSSQL\Backup\MyDatabase_copy.split" -vol 40m -delsrc
```


## merge - Разархивировать файл
Используется 7-zip

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-file** | - Имя первого файла архива |
| **-list** | - Имя файла, списка файлов архива (параметр -file игнорируется) |
| **-delsrc** | - Удалить исходные файлы после выполнения операции |

#### Пример:
```
cpdb merge -file "d:\MSSQL\Backup\MyDatabase_copy.7z.001" -delsrc
```
```
cpdb merge -list "d:\MSSQL\Backup\MyDatabase_copy.split" -delsrc
```


## uconstorage - Отключить информационную базу от хранилища конфигурации

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-ib-path** | - Строка подключения к ИБ");
| **-ib-user** | - Пользователь ИБ");
| **-ib-pwd** | - Пароль пользователя ИБ");
| **-v8version** | - Маска версии платформы 1С");
| **-uccode** | - Ключ разрешения запуска ИБ");

```
cpdb uconstorage -ib-path "/FD:/data/MyDatabase" -ib-user Администратор -ib-pwd 123456 -v8version 8.3.8 -uccode 1234
```

## constorage - Подключить информационую базу к хранилищу конфигурации

| Параметры: ||
|-|-|
| **-params** | - Файлы JSON содержащие значения параметров, могут быть указаны несколько файлов разделенные ";" (параметры командной строки имеют более высокий приоритет)|
| **-ib-path** | - Строка подключения к ИБ |
| **-ib-user** | - Пользователь ИБ |
| **-ib-pwd** | - Пароль пользователя ИБ |
| **-storage-path** | - Адрес хранилища конфигурации |
| **-storage-user** | - Пользователь хранилища конфигурации |
| **-storage-pwd** | - Пароль пользователя хранилища конфигурации |
| **-v8version** | - Маска версии платформы 1С |
| **-uccode** | - Ключ разрешения запуска ИБ |

```
cpdb constorage -ib-path "/FD:/data/MyDatabase" -ib-user Администратор -ib-pwd 123456 -storage-path "tcp://MyServer/MyRepository" -storage-user MyDatabase_usr1 -storage-pwd 123456 -v8version 8.3.8 -uccode 1234
```

## Использование c Jenkins
В jenkinsfile описан конвейер, выполняющий следующий сценарий:
* Создание резервной копии указанной базы на системе-источнике
* Разбиение резервной копии на части (используется 7-Zip)
* Копирование частей файла на Yandex-Диск (в указанный каталог)
* Получение файла резервной копии из Yandex-Диск на системе-приемнике
* Восстановление указанной базы из резервной копии
* Подключает базу к хранилищу конфигурации

| Переменные окружения конвейера ||
|-|-|
| **src_db_cred** | - Идентификатор credentials для доступа к MS SQL в системе, где расположена база-источник |
| **src_agent_label** | - Метка агента Jenkins в системе, где расположена база-источник |
| **src_server_name** | - Имя сервера MS SQL в системе-источнике |
| **src_db_name** | - Имя базы-источника |
| **src_bak_path** | - Путь к каталогу резервной копии в системе-источнике |
|||
| **bak_file_name** | - Имя файла резервной копии |
| **list_file_name** | - Имя файла списка томов архива |
|||
| **storage_token** | - Token для доступа к Yandex-Диску |
| **storage_path** | - Путь к каталогу на Yandex-Диск для передачи файлов в систему-приемник |
|||
| **dst_db_cred** | - Идентификатор credentials для доступа к MS SQL в системе-приемнике |
| **dst_agent_label** | - Метка агента Jenkins в системе, где расположена база-приемник |
| **dst_bak_path** | - Путь к каталогу резервной копии в системе-приемнике, в который будут загружены файлы из Yandex-Диска |
| **dst_server_name** | - Имя сервера MS SQL в системе-приемнике |
| **dst_db_name** | - Имя базы-приемника |
| **dst_dbo** | - Имя пользователя-владельца базы в системе-приемнике (dbowner) |
| **dst_db_path** | - Путь к каталогу размещения файлов данных базы-приемника
| **dst_log_path** | - Путь к каталогу размещения файлов журнала базы-приемника |
| **dst_ib_agent_label** | - Метка агента Jenkins в системе, где выполняется подключение к хранилищу конфигурации |
| **dst_ib_con_string** | - Строка подключения к информационной базе, подключаемой к хранилищу |
| **dst_ib_cred** | - Идентификатор credentials для доступа к информационной базе |
| **dst_ib_storage_adr** | - Адрес хранилища конфигурации |
| **dst_ib_storage_cred** | - Идентификатор credentials для подключения к хранилищу конфигурации |
