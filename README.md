# DOTFILES

# TERMINAL

> O uso do `zsh` é focado em ter recursos adicionais que o `bash` não trás nativamente.
> 

### ZSH

> O framework [`oh my zsh`](https://ohmyz.sh/) vai te fornecer o [guia de instalação](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) do `zsh`  caso
> 

Vou adicionar a sequencia de comandos para instalação do `zsh`, mas em caso de erro, corra para a documentação: 

 

```bash
# install zsh via apt/ubuntu
sudo apt install zsh 

# zsh como shell padrão
chsh -s $(which zsh)
```

Após isso, faça logout do OS e execute `echo $SHELL` se a saída for `/bin/zsh` deu tudo certo. 

### KITTY

> O  kitty é um front-end terminal, rápido e ficais, ele independe de uso do zsh, seja livre para usá-lo em qualquer interpretador de comandos
> 

aqui vamos usar o [`kitty`](https://sw.kovidgoyal.net/kitty/binary/)  pelo seu binario: 

```bash
#comando pra baixar o binario 
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

para executar kitty com o binário vai ser preciso passar o path no terminal, como estamos usando linux, ele vai ser encontrado em `$HOME/.local/kitty.app/bin/kitty` para que não precisemos executar ele por terminal todas as vezes, vamos criar um atalho de aplicativo no menu de aplicativos.

vamos criar uma arquivo `.desktop` no caminho `$HOME/.local/share/applications/`

```bash
# Cria o arquivo kitty.desktop
nano kitty.desktop 
```

agora cole isso no arquivo: 

```bash
[Desktop Entry]
Name=Kitty
Comment=terminal acelerado por GPU
Exec=$HOME/.local/kitty.app/bin/kitty
Icon=$HOME/.local/kitty.app/kitty-icon.png
Terminal=false
Type=Application
Categories=Utility;
```

note que temos um campo de Icon nesse arquivo, vai ser o que unico campo que vai ser preocupar, onde espera  uma imagem para servir de icone no menu de aplicativos, vou deixar um link de imagem do kitty: 

imagem 1 : https://user-images.githubusercontent.com/57691142/117370998-96523300-ae9d-11eb-8d7f-c341d6834648.png

imagem 2 : https://user-images.githubusercontent.com/53346722/117488729-5e48ff80-af32-11eb-8534-be790bae1355.png

se tudo deu certo você já deve ver o kitty no menu de aplicativos.

### FZF

*É um programa de filtro interativo para qualquer tipo de lista; arquivos, histórico de comandos, processos, nomes de host, marcadores, git commits, etc. Ele implementa um algoritmo de correspondência "fuzzy", para que você possa digitar rapidamente padrões com caracteres omitidos e ainda obter os resultados desejados.*

   ****

  **INSTALL**

a [documentação](https://github.com/junegunn/fzf) caso seu não esteja usando debian.

```bash
sudo apt install fzf
```

   **CONFIGURAÇÃO**

Como o `fzf` faz o papel de realizar filtros, vamos utilizar ele como um podereso auxiliador de algumas funções.

crie um arquivo  [`fzf.sh`](http://fzf.sh) na pasta home do seu sistema, pode utilizar esse comando: `vim fzf.sh` e cole todo o script abaixo: 

> Para  preview do conteudo é usado o [bat-linux](https://www.cyberciti.biz/open-source/bat-linux-command-a-cat-clone-with-written-in-rust/), para usuario de debian pode instalar facilmente com: `sudo apt install bat` .  Com o ubuntu ele é usando com o command `batcat`
> 

```bash
#!/bin/bash

# 1. Escolher arquivo ou pasta
TARGET=$(find . -type f -o -type d | fzf --preview='batcat --color=always {}' \  --prompt="Escolha um arquivo ou pasta: " \  --border --padding=1,2 \  --border-label='Filtro de Arquivo e Pasta' \  --color='border:#aaaaaa,label:#cccccc' \)

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
```

esse script vai te fazer selecionar uma pasta ou arquivo e escolher onde quer abrir. As escolhas são: `vscode` , `vim` ( mude para nano caso desejar ), `explorador de arquivos` , `terminal (cd)` espefico para pastas. 

após a criação do arquivo vamos definir um atalho no kitty para executar o `FF`: 

```bash
map ctrl+shift+p launch --type=overlay sh -c "$HOME/fzf.sh"
```

# DOCKER

> vou deixar a sequencia de comandos para instalação do docker no ubuntu, mas se você  não sabe o que está fazendo recomendo ir para a [documentação](https://docs.docker.com/engine/install/ubuntu/) e antes de executar qualquer comando.
> 

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

#install
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#verify docker is installed
sudo docker run hello-world

```


# LAZYVIM

Arquivo de configuração do tema:
```bash
vim ~/.config/nvim/lua/plugins/colorscheme.lua


// cole o seguinte script
 return {
  -- Instala o tema Oxocarbon
  { "nyoom-engineering/oxocarbon.nvim" },

  -- Configura o LazyVim para usar o Oxocarbon
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oxocarbon",
    },
  },
}       
```
