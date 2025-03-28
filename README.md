# VarreFantasmasNoAD – Usuários ativos que sumiram do domínio

Script em PowerShell para identificar **contas ativas no Active Directory** que **não realizam logon há mais de X dias**. Ideal para auditoria, manutenção e organização do domínio.

---

## ⚠️ Aviso

Este script deve ser executado apenas por administradores de domínio ou profissionais autorizados.  
Utilize com responsabilidade em ambientes sob sua gestão.

---

## 🎯 Objetivo

Localizar usuários que:
- Estão com a conta ativa (`Enabled = True`)
- Não realizam logon há um número definido de dias

---

## 🛠️ Como usar

1. **Abra o PowerShell como Administrador**

2. Execute o script:

```powershell
.\VarreFantasmasNoAD.ps1
```

3. Informe a quantidade de dias de inatividade quando solicitado.

4. Escolha:
   - `[1]` Ver a lista diretamente no PowerShell
   - `[2]` Exportar para um arquivo CSV em `C:\AD_Relatorios`

---

## 📁 Exportação

Se optar por exportar, o script criará (se necessário) a pasta:

```
C:\AD_Relatorios
```

E salvará o relatório no arquivo:

```
UsuariosInativos_ativos_[Xdias].csv
```

---

## 🔍 O que ele verifica

- Atributo `lastLogonDate`
- Usuários com a conta ativa
- Inatividade superior ao número de dias informado

---

## 🧠 Exemplos de uso

- Identificar contas “fantasmas” em ambientes grandes
- Antecipar políticas de desativação de contas
- Manter a base do AD limpa e atualizada

---

## 💡 Requisitos

- Windows Server com módulo `ActiveDirectory` habilitado
- Permissões de leitura no domínio

---

## 🛡️ Ética e responsabilidade

Este script não altera nada no AD – apenas lê e gera relatório.  
Ideal para inventário e auditorias regulares.  
**Não utilize em ambientes críticos sem testes prévios.**

---

## 📄 Licença

Distribuído sob a licença [MIT](LICENSE).  
Livre para uso, modificação e redistribuição com os devidos créditos.

---

**Feito por [rivaed](https://github.com/rivaed) – onde há fantasma, há comando.**
