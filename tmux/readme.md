## Tmux
Use Windows Terminal like shortcuts


### 
Создать новую сессию: tmux new-session -s session_name   
Список сессий: tmux ls   
Присоединиться к существующей сессии: tmux attach-session -t session_name   
Отсоединиться от текущей сессии: Ctrl-b d   
Удалить сессию: tmux kill-session -t session_name   
Также в Tmux есть возможность сохранять и загружать сессии в файлы для дальнейшего использования:

Сохранить текущую сессию: tmux save-session -t session_name -f file_name   
Загрузить сессию из файла: tmux load-session -t session_name -f file_name

### conf path
$HOME/.tmux.conf
