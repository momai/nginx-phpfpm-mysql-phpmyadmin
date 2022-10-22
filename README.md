#  

### Описание
Данный репозиторий содержит в себе конфигурацию веб сервера в docker. В проект включены: nginx, phpfpm, mysql, phpmyadmin
Рабочая директория с статикой сайта находится по пути web/public/
В проекте присутствует предварительно настроенный certbot. Данный контейнер закомментирован, но может быть включен и оперативно развернут при наличии доменного имени.

### Быстрый старт

1. Склонируйте репозиторий к себе:

  ```git clone git@github.com:momai/nginx-phpfpm-mysql-phpmyadmin.git && cd nginx-phpfpm-mysql-phpmyadmin ```
  
2. Скопируйте ```.env.simple``` с новым именем ```.env```
  
  ``` cp .env.simple .env```
  
3. Откройте файл ```.env``` и внесите необходимые изменения. 
  
  Вам нужно заполнить:
  
  ```
  HOMEDIR= #путь до проекта.
  
  MYSQL_ROOT_PASSWORD= #пароль от mysql пользователя root
  
  MYSQL_PASSWORD= #пароль от mysql dev пользователя
  ```
  
  
4.  Запустите проект:
  
  ```docker-compose up -d```
  
5. Убедитесь, что проект запущен, комадной:
  
```$ docker-compose ps```

Должно отобразиться следующее:

```Name                 Command               State                                   Ports
----------------------------------------------------------------------------------------------------------------------------
mysql        docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp,:::3306->3306/tcp, 33060/tcp
nginx        /docker-entrypoint.sh /bin ...   Up      0.0.0.0:443->443/tcp,:::443->443/tcp, 0.0.0.0:80->80/tcp,:::80->80/tcp
php-fpm      docker-php-entrypoint php-fpm    Up      9000/tcp
phpmyadmin   /docker-entrypoint.sh apac ...   Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp
```


### Конфигурация

#### Включить бэкапы.

При необходимости, можно настроить бэкап базы данных. Для этого, скопируйте файл по пути etc/mysql/ ```mysql-credentials.cnf.sample``` с новым именем ```mysql-credentials.cnf```

``` cp etc/mysql/mysql-credentials.cnf.sample etc/mysql/mysql-credentials.cnf```

Отредактируйте его в соответствие с данными внесёнными в .env:
```
[client]
user=
password=
host=mysql
```

Запустите скрипт из дирректории проекта ```backupbd.sh```

Для автоматизации процесса, внесите следующие строки в crontab вашей системы
```
$ crontab -e
00 04 */7 * * sh /projectfolder/nginx-phpfpm-mysql-phpmyadmin/backupbd.sh
```
***Укажите корректный путь до файла.*** В последствие, бэкап будет происходить каждый коммит (об этом ниже) и каждое воскресенье в 4 утра.


#### Базовый CI\CD

В проекте реализован процесс доставки кода, через actions github. Каждый раз, когда вносится коммит или делается merge в ветку main, запускается скрипт [actions](https://github.com/momai/nginx-phpfpm-mysql-phpmyadmin/actions/workflows/manual.yml)
Изучите файл [manual.yml](https://github.com/momai/nginx-phpfpm-mysql-phpmyadmin/blob/main/.github/workflows/manual.yml) в исходниках проекта, для понимания процесса.

Этапы:
1. Делается коммит в проекте github
2. Запускается actions.
3. Происходит подключение к настроенному runner.
4. Идет импорт ключа от сервера где развернуто приложение.
5. Происходит подключение к серверу. Выполняется бэкап базы данных и  git pull для обновления исходного кода проекта.

***ВНИМАНИЕ*** В проекте используется свой runner сервер. Доступные бесплатные runner от github работают нестабильно.

Так же, в проекте есть простой скрипт обновления репозитория из github ```update.sh``` Если его добавить в cron, от использования actions можно отказаться. Однако, рекомендуемый способ - actions.
Actions уже на этом этапе позволяет быстро внедрить функции тестирования и проверки кода перед деплоем.

Для работы Actoins на вашем сервере, необходимо добавить следующие secrets\actions в настройках github проекта.
```
HOST
KEY
USERNAME
```

Так же, в проекте есть другой actions призванный перезапустить контейнеры. Если вы внесли изменения в инфрастуктуру и хотите перезапустить контейнеры, вы можете включить [actions restart-container](https://github.com/momai/nginx-phpfpm-mysql-phpmyadmin/blob/main/.github/workflows/restart-container.yml). И при следующем коммите, проект будет перезагружен. 




