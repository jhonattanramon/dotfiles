#!/bin/bash

# 1. Escolher arquivo ou pasta

TARGET=$(find . -type f -o -type d | fzf    --preview='batcat --color=always {}' \
  --prompt="Escolha um arquivo ou pasta: " \
  --border --padding=1,2 \
  --border-label='Filtro de Arquivo e Pasta' \
  --color='border:#aaaaaa,label:#cccccc' \
)

# Cancelar se não selecionado
[ -z "$TARGET" ] && echo "Nada selecionado." && exit 1

# 2. Escolher como abrir
CHOICE=$(echo -e "Abrir com Vim\nAbrir no VSCode\nAbrir no terminal (cd)\nAbrir no explorador\nCancelar" | fzf --prompt="Escolha como abrir: ")

case "$CHOICE" in
  "Abrir com Vim")
    if [ -f "$TARGET" ]; then
      vim "$TARGET"
    elif [ -d "$TARGET" ]; then
      cd "$TARGET" || exit
      exec $SHELL
    else
      echo "Caminho inválido."
    fi
    ;;
  "Abrir no VSCode")
    code "$TARGET"
    ;;
  "Abrir no explorador")
     if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      if [ -d "$TARGET" ]; then
        xdg-open "$(realpath "$TARGET")"
      elif [ -f "$TARGET" ]; then
        # Tenta abrir o gerenciador com o arquivo selecionado (caso do Nautilus)
        if command -v nautilus &> /dev/null; then
          nautilus --select "$(realpath "$TARGET")"
        elif command -v nemo &> /dev/null; then
          nemo --no-desktop --browser "$(dirname "$(realpath "$TARGET")")"
        else
          xdg-open "$(dirname "$(realpath "$TARGET")")"
        fi
      fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      open -R "$TARGET"  # no macOS, -R revela o arquivo no Finder
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
      explorer.exe "$(realpath "$TARGET")"
    fi
    ;;
  "Abrir no terminal (cd)")
    if [ -d "$TARGET" ]; then
      cd "$TARGET" || exit
      exec $SHELL  # abre um novo shell na pasta
    else
      echo "O caminho não é um diretório."
    fi
    ;;
  
  *)
    echo "Cancelado."
    ;;
esac
exit 0
