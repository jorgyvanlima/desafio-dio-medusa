
## 📄 README.md — Documentação Completa do Projeto

```markdown
# 🔐 Desafio DIO - Medusa: Infraestrutura como Código e Auditoria de Segurança com Kali Linux

Este repositório documenta a execução prática do **Desafio de Segurança da DIO**, focado em **Infraestrutura como Código (IaC)** e **auditoria de segurança ofensiva** com ferramentas como **Medusa** e **Hydra**. O objetivo foi criar um ambiente automatizado de testes para simular ataques de força bruta em serviços vulneráveis.

---

## 🎯 Objetivos do Projeto

- **Automatizar a criação de um laboratório de segurança** com VMs usando Vagrant e VirtualBox.
- **Executar ataques de força bruta** em serviços como FTP, Web (DVWA) e SMB.
- **Documentar os processos, comandos e evidências** dos testes realizados.
- **Propor medidas de mitigação** para os problemas identificados.

---

## 🛠️ Etapa 1: Criação do Ambiente com Vagrant (IaC)

O ambiente foi provisionado automaticamente via **Vagrant**, utilizando boxes públicas do Kali Linux e Metasploitable 2. A rede foi configurada como **Host-Only**, garantindo isolamento e comunicação entre as VMs.

### 🔧 Configuração das VMs

| VM               | Box                          | IP Fixo         | Função         |
|------------------|------------------------------|------------------|----------------|
| Host             | macOS 10.15.7                | N/A              | Máquina do desenvolvedor |
| Kali Linux       | kalilinux/kali-linux-rolling | 192.168.56.10    | Máquina atacante |
| Metasploitable 2 | r3p3nt/metasploitable2       | 192.168.56.20    | Máquina vulnerável |

### 📦 Comandos Utilizados

```bash
# Inicialização do ambiente
cd iac/
vagrant up

# Verificação de status e conectividade
vagrant status
vagrant ssh kali --command "ping -c 3 192.168.56.20"
```

📸 **Evidência:** `images/iac_setup.png` — Print do `vagrant up` e teste de ping entre as VMs.

---

## 💥 Etapa 2: Execução dos Ataques de Força Bruta

Os ataques foram realizados a partir da VM Kali Linux contra os serviços vulneráveis da Metasploitable 2. As wordlists foram geradas com o script `scripts/setup_desafio.sh`.

### 🔓 1. Ataque FTP com Medusa

- **Serviço Alvo:** vsftpd (porta 21)
- **Wordlists:** `wordlists/usuarios_comuns.txt` e `wordlists/senhas_fracas.txt`
- **Comando:**
  ```bash
  medusa -H 192.168.56.20 -U wordlists/usuarios_comuns.txt -P wordlists/senhas_fracas.txt -M ftp -n 50
  ```
- **Credencial Encontrada:** Usuário: **[USUÁRIO FTP]** / Senha: **[SENHA FTP]**

📸 **Evidência:** `images/ftp_medusa_sucesso.png`

---

### 🌐 2. Ataque Web (DVWA) com Hydra

- **Serviço Alvo:** DVWA (Low Security)
- **Comando:**
  ```bash
  hydra -L wordlists/usuarios_comuns.txt -P wordlists/senhas_fracas.txt 192.168.56.20 http-post-form "/dvwa/login.php:username=^USER^&password=^PASS^&Login=Login:F=Location: login.php"
  ```
- **Credencial Encontrada:** Usuário: **[USUÁRIO WEB]** / Senha: **[SENHA WEB]**

📸 **Evidência:** `images/web_hydra_comando.png`

---

### 🧪 3. Password Spraying em SMB com Medusa

- **Serviço Alvo:** SMB
- **Wordlists:** `wordlists/usuarios_smb.txt` e `wordlists/senha_spray.txt`
- **Comando:**
  ```bash
  medusa -H 192.168.56.20 -U wordlists/usuarios_smb.txt -p wordlists/senha_spray.txt -M smb
  ```
- **Credencial Encontrada:** Usuário: **[USUÁRIO SMB]** / Senha: **[SENHA SMB]**

📸 **Evidência:** `images/smb_medusa_sucesso.png`

---

## ✅ Etapa 3: Recomendações de Mitigação

Com base nos testes realizados, foram identificadas vulnerabilidades críticas que podem ser mitigadas com as seguintes ações:

1. **Política de Senhas Fortes e MFA**
   - Exigir senhas complexas e únicas.
   - Implementar autenticação multifator (MFA/2FA).

2. **Controle de Acesso**
   - Limitar tentativas de login (rate limiting).
   - Adicionar CAPTCHA/reCAPTCHA em formulários web.

3. **Segurança de Rede**
   - Utilizar firewalls para restringir acesso a serviços críticos.
   - Implementar sistemas de detecção/prevenção de intrusão (IDS/IPS).

---

## 📁 Estrutura do Repositório

| Caminho             | Descrição |
|---------------------|-----------|
| `README.md`         | Documentação principal do projeto. |
| `iac/`              | Contém o `Vagrantfile` para provisionamento das VMs. |
| `wordlists/`        | Listas de usuários e senhas utilizadas nos ataques. |
| `scripts/`          | Scripts de automação para setup e execução dos testes. |
| `images/`           | Prints de tela dos testes e configurações realizadas. |

---

## 🧠 Autor

**JORGYVAN BRAGA LIMA**  
Especialista em Infraestrutura e Segurança da Informação  
LinkedIn • GitHub

---

## 📜 Licença

Este projeto está sob a licença MIT. Sinta-se livre para estudar, modificar e compartilhar.
 