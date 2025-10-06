#!/bin/bash
# setup_desafio.sh: Cria as wordlists simples no ambiente do Kali Linux.
echo "Criando wordlists simples para o desafio..."

cat > wordlists/usuarios_comuns.txt << EOS
msfadmin
admin
user
ftpuser
test
EOS

cat > wordlists/senhas_fracas.txt << EOS
msfadmin
password
123456
toor
teste
EOS

cp wordlists/usuarios_comuns.txt wordlists/usuarios_smb.txt
echo "password" > wordlists/senha_spray.txt

echo "Wordlists criadas com sucesso na pasta wordlists/!"
