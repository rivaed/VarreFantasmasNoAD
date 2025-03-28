<#
.SYNOPSIS
  Identifica usuários ATIVOS no Active Directory que não realizam logon há mais de X dias.

.DESCRIPTION
  O script consulta o atributo lastLogonDate de contas ativas e permite exibir ou exportar o relatório.
  Atenção: lastLogonDate pode variar conforme o controlador de domínio consultado.

.NOTAS
  Autor: rivaed
  Compatível com: Windows Server 2016/2019/2022 com módulo ActiveDirectory
  Requer: Permissões de leitura no AD
#>

# Verifica se o módulo ActiveDirectory está disponível e o importa
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Warning "O módulo ActiveDirectory não foi encontrado. Instale o RSAT ou o módulo apropriado."
    exit
}
Import-Module ActiveDirectory

# Solicita número de dias de inatividade
$dias = Read-Host "Informe o número de dias de inatividade (ex: 90)"

if (-not [int]::TryParse($dias, [ref]$null) -or [int]$dias -le 0) {
    Write-Warning "Valor inválido. Insira um número inteiro maior que zero."
    exit
}

# Converte e armazena o valor como inteiro
$diasInt = [int]$dias

$dataLimite = (Get-Date).AddDays(-$diasInt)

Write-Host ""
Write-Host "Procurando usuários ATIVOS que não logam há mais de $diasInt dias..."
Write-Host ""

# Busca usuários ativos com lastLogonDate inferior à data limite
try {
    $usuariosInativos = Get-ADUser -Filter {Enabled -eq $true -and lastLogonDate -lt $dataLimite} -Properties lastLogonDate |
        Select-Object Name, SamAccountName, Enabled, LastLogonDate
} catch {
    Write-Warning "Erro ao consultar o Active Directory: $_"
    exit
}

if ($usuariosInativos.Count -eq 0) {
    Write-Host "Nenhum usuário ativo inativo encontrado com mais de $diasInt dias."
    exit
}

# Menu de ação
Write-Host "Total encontrado: $($usuariosInativos.Count) usuários."
Write-Host ""
Write-Host "O que você deseja fazer?"
Write-Host "[1] Exibir no PowerShell"
Write-Host "[2] Exportar para CSV (em C:\AD_Relatorios)"
$escolha = Read-Host "Digite 1 ou 2"

switch ($escolha) {
    "1" {
        Write-Host ""
        $usuariosInativos | Format-Table Name, SamAccountName, LastLogonDate -AutoSize
    }
    "2" {
        $pastaRelatorio = "C:\AD_Relatorios"
        if (-not (Test-Path -Path $pastaRelatorio)) {
            New-Item -Path $pastaRelatorio -ItemType Directory | Out-Null
        }

        $nomeArquivo = "UsuariosInativos_ativos_${diasInt}dias.csv"
        $caminhoArquivo = Join-Path -Path $pastaRelatorio -ChildPath $nomeArquivo

        try {
            $usuariosInativos | Export-Csv -Path $caminhoArquivo -NoTypeInformation -Encoding UTF8
            Write-Host ""
            Write-Host "Arquivo exportado com sucesso:"
            Write-Host $caminhoArquivo
        } catch {
            Write-Warning "Erro ao exportar o arquivo: $_"
        }
    }
    default {
        Write-Warning "Opção inválida. Nenhuma ação realizada."
    }
}

Write-Host ""
Write-Host "Execução concluída."
