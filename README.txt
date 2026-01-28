А1

root@l-test:~# mkdir -p /root/yandex
root@l-test:~# cd /root/yandex

root@l-test:~/yandex# cat index.html
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>test quest</title>
</head>
<body>
Hello yandex
</body>
</html>

root@l-test:~/yandex# cat Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html

root@l-test:~/yandex# docker build -t my-web-app:latest .
root@l-test:~/yandex# docker rm -f my-web-app 2>/dev/null || true
root@l-test:~/yandex# docker run -d --name my-web-app -p 8080:80 my-web-app:latest
root@l-test:~/yandex# curl -sS http://localhost:8080 | head
<!doctype html>

root@l-test:~/yandex# cat docker-compose.yml
services:
  web:
    build: .
    image: my-web-app:latest
    container_name: my-web-app
    ports:
      - "8080:80"

root@l-test:~/yandex# docker rm -f my-web-app 2>/dev/null || true
root@l-test:~/yandex# docker compose up -d --build
root@l-test:~/yandex# curl -sS http://localhost:8080 | head
<!doctype html>

root@l-test:~/yandex# docker compose down
root@l-test:~/yandex# docker rm -f my-web-app 2>/dev/null || true
root@l-test:~/yandex# docker run -d --name my-web-app -p 8080:80 -v /root/yandex/index.html:/usr/share/nginx/html/index.html:ro nginx:alpine
root@l-test:~/yandex# sed -i 's/Hello yandex/Hello yandex (updated without rebuild)/' /root/yandex/index.html
root@l-test:~/yandex# curl -sS http://localhost:8080 | grep Hello
Hello yandex (updated without rebuild)


В1
root@l-test:~# cat /root/clean_old_logs.sh
#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 /path/to/logs DAYS"
  exit 1
fi

DIR="$1"
DAYS="$2"

FILES=$(find "$DIR" -type f -name "*.log" -mtime +"$DAYS")

if [ -z "$FILES" ]; then
  echo "No old log files found"
  exit 0
fi

echo "$FILES"
read -p "Удалить эти файлы? y/n " ANSWER

if [ "$ANSWER" = "y" ]; then
  find "$DIR" -type f -name "*.log" -mtime +"$DAYS" -delete
fi

root@l-test:~# rm -rf /root/logs-test
root@l-test:~# mkdir -p /root/logs-test
root@l-test:~# touch /root/logs-test/new.log
root@l-test:~# touch -d "40 days ago" /root/logs-test/old.log
root@l-test:~# /root/clean_old_logs.sh /root/logs-test 30
/root/logs-test/old.log
Удалить эти файлы? (y/n) y
root@l-test:~# ls -la /root/logs-test
total 8
drwxr-xr-x 2 root root 4096 ... .
drwx------ 1 root root 4096 ... ..
-rw-r--r-- 1 root root    0 ... new.log


root@l-test:~# rm -rf /root/git-demo
root@l-test:~# mkdir -p /root/git-demo
root@l-test:~# cd /root/git-demo

root@l-test:~/git-demo# git init
root@l-test:~/git-demo# git branch -M main
root@l-test:~/git-demo# echo "base" > app.txt
root@l-test:~/git-demo# git add app.txt
root@l-test:~/git-demo# git commit -m "init"

root@l-test:~/git-demo# git switch -c feature/junior-task
root@l-test:~/git-demo# echo "feature commit" >> app.txt
root@l-test:~/git-demo# git add app.txt
root@l-test:~/git-demo# git commit -m "feat: junior task"

root@l-test:~/git-demo# echo "wip not ready" >> app.txt
root@l-test:~/git-demo# git status

root@l-test:~/git-demo# git stash push -u -m "wip: junior-task"
root@l-test:~/git-demo# git switch main
root@l-test:~/git-demo# echo "hotfix" >> app.txt
root@l-test:~/git-demo# git add app.txt
root@l-test:~/git-demo# git commit -m "fix: urgent bug"

root@l-test:~/git-demo# git switch feature/junior-task
root@l-test:~/git-demo# git stash pop

root@l-test:~/git-demo# git commit --amend -m "feat: junior task (rename)"
root@l-test:~/git-demo# git --no-pager log --oneline --decorate -5


Push в main => старт CI pipeline
1 tests
запуск тестов
при fail: pipeline failed

2 build
docker build
теги: commit_sha и latest

3 push
docker login
docker push 

4 notify
отправка уведомления в telegram
уведомление должно выполняться всегда

