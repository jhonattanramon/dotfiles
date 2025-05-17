# DOTFILES

# TERMINAL

> O uso do `zsh` é focado em ter recursos adicionais que o `bash` não trás nativamente.
> 

### ZSH

> O framework [`oh my zsh`](https://ohmyz.sh/) vai te fornecer o guia de instalação do `zsh`
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

 ```# dotfiles
