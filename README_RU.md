# docker-babelfishpg-python3
[ENG](https://github.com/ArchaicLier/docker-babelfishpg-python3/blob/main/README.md) | RUS

[Docker](https://www.docker.com/) image for [Babelfish for PostgreSQL](https://babelfishpg.org/).

Форк репозитория [jonathanpotts/docker-babelfishpg](https://github.com/jonathanpotts/docker-babelfishpg)


Babelfish для PostgreSQL это набор [расширений](https://github.com/babelfish-for-postgresql/babelfish_extensions) для [PostgreSQL](https://www.postgresql.org/), которые позволяют ему использовать протокол  [Tabular Data Stream (TDS) protocol](https://docs.microsoft.com/openspecs/windows_protocols/ms-tds) и [Transact-SQL (T-SQL)](https://docs.microsoft.com/sql/t-sql/language-reference), позволяя приложениям, разработанным для [Microsoft SQL Server](https://docs.microsoft.com/sql/sql-server) использовать PostgreSQL в качестве своей базы данных. Дополнительные сведения см. в статье ["Goodbye Microsoft SQL Server, Hello Babelfish"](https://aws.amazon.com/blogs/aws/goodbye-microsoft-sql-server-hello-babelfish/) в новостном блоге AWS.

## Быстрый старт

**ПРЕДУПРЕЖДЕНИЕ. Обязательно создайте дамп базы данных для резервного копирования ваших данных перед установкой нового образа, чтобы предотвратить риск потери данных при смене образов.**

Чтобы создать новый контейнер, запустите:

`docker run -d -p 1433:1433 -p 5000:5432 1i3r/babelfishpg-python3`

или

`docker run -d -p 1433:1433 -p 5000:5432 ghcr.io/archaiclier/docker-babelfishpg-python3:main`

Чтобы создать новый контейнер с multi-db:

`docker run -d -p 1433:1433 -p 5000:5432 1i3r/babelfishpg-python3 -m multi-db`

или

`docker run -d -p 1433:1433 -p 5000:5432 ghcr.io/archaiclier/docker-babelfishpg-python3:main -m multi-db`

### Пример данных

Запустите [example_data.sql](https://github.com/ArchaicLier/docker-babelfishpg-python3/blob/main/example_data.sql) скрипт для заполнения базы данных примерами данных.

Затем вы сможете получить данные с помощью следующих запросов:

```sql
SELECT * FROM example_db.authors;
```

```sql
SELECT * FROM example_db.books;
```

### Пример Python

Запустите [example_python.sql](https://github.com/ArchaicLier/docker-babelfishpg-python3/blob/main/example_python.sql) скрипт для создания "Hello world!" функции предварительно подключившись к PostgreSQL порту

Теперь вы можете вызвать функцию hello_python():

```sql
SELECT * FROM hello_python();
```

Для использования функции в T-SQL запустите скрипт [example_python.sql](https://github.com/ArchaicLier/docker-babelfishpg-python3/blob/main/example_python.sql) подключившись babelfish_db базе данных и master_dbo (или любой другой %database%_dbo) схеме на PostgreSQL порту

Затем вы можете вызвать его из-под T-SQL как:
```sql
SELECT * FROM master.dbo.hello_python();
```

### Установка pip

Для подключения как root к docker контейнеру используйте следующею команду:

```cmd
docker exec -it -u 0 %container_name% bash
```

Затем установите pip :

```sh
apt update && apt install python3-pip
```

Теперь вы можете установить библиотеки для Python и использовать их в plpython3u функциях:

```sh
python3.9 -m pip install numpy
```

### Обновление ca-certificates

Для корректной работы сетевых модулей в python может потребоваться обновление ca-certificates

Подключитесь к Docker как root:

```cmd
docker exec -it -u 0 %container_name% bash
```

Обновите сертификаты:

```sh
update-ca-certificates
```

### Дополнительные настройки

Для инициализации с пользовательским именем пользователя, добавьте `-u my_username` к `docker run` команде, где `my_username` желаемое имя пользователя.

Для инициализации с пользовательским паролем, добавьте `-p my_password` к `docker run` команде где `my_password` желаемый пароль.

Для инициализации с пользовательским наименование базы данных, добавьте `-d my_database` к `docker run` команде, где `my_database` желаемое наименование базы данных. **Это имя базы данных, которую Babelfish для PostgreSQL использует для внутреннего хранения данных и недоступна через TDS.**

#### Режим миграции

По умолчанию используется режим миграции с `single-db`.
Чтобы использовать другой режим миграции, добавьте `-m migration_mode` к `docker run` команде, где `migration_mode` желаемое значение режима миграции.

Дополнительные сведения о режимах миграции см. [Single vs. multiple instances](https://babelfishpg.org/docs/installation/single-multiple/).

## Подключение

Если вы размещаете контейнер на локальном компьютере, имя сервера — `localhost`. В противном случае используйте IP-адрес или полное доменное имя (FQDN) на основе DNS для сервера, на котором вы размещаете контейнер.

Используйте режим проверки подлинности SQL Server для входа в систему.

Логин по умолчанию для Babelfish и PostgreSQL:

* **Username:** `babelfish_user`
* **Password:** `12345678`

Если вы указали собственное имя пользователя и/или пароль, используйте их.

Многие функции SQL Server Management Studio (SSMS) в настоящее время не поддерживаются.

### Строка подключения

Предполагая, что Babelfish размещен на локальном компьютере с использованием настроек по умолчанию, и вы пытаетесь подключиться к базе данных с именем `example_db`, строка подключения будет следующей:

`Data Source=localhost;Initial Catalog=example_db;Persist Security Info=true;User ID=babelfish_user;Password=12345678`

## Том данных 

Данные базы данных хранятся в томе `/data`.

## Создание образа Docker

**ПРИМЕЧАНИЕ. Поскольку Git в Windows по умолчанию изменяет окончания строк с LF на CRLF, перед сборкой убедитесь, что `start.sh` имеет окончания строк LF, иначе при запуске контейнера из образа возникнет ошибка.**

**ПРИМЕЧАНИЕ. В Linux (и, возможно, в Unix/macOS) перед сборкой может потребоваться `chmod +x start.sh`. (Благодарность: [calmitchell617](https://github.com/calmitchell617))**

Чтобы собрать образ Docker, клонируйте репозиторий, а затем запустите `docker build .`

Чтобы использовать другую версию Babelfish, вы можете:
  * Измените `ARG BABELFISH_VERSION=<BABELFISH_VERSION_TAG>` в `Dockerfile`
  * **-или-**
  * Запустите `docker build. --build-arg BABELFISH_VERSION=<BABELFISH_VERSION_TAG>`

Теги версий Babelfish перечислены по адресу https://github.com/babelfish-for-postgresql/babelfish-for-postgresql/tags.
