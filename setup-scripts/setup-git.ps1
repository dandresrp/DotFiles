$sshDir = "$HOME\.ssh"
if (-Not (Test-Path -Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir
}

$configContent = @"
Host github.com
    Hostname ssh.github.com
    Port 443
"@
$configFile = "$sshDir\config"
$configContent | Out-File -FilePath $configFile -Encoding UTF8

$gitConfigFile = "$HOME\.gitconfig"
if (Test-Path -Path $gitConfigFile) {
    Remove-Item -Path $gitConfigFile
}

Write-Host "Setting up Git for you..."
$name = Read-Host "Enter your name"
$email = Read-Host "Enter your email"
$editor = Read-Host "Enter your text editor"

git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.editor "$editor"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

$sshAgentService = Get-Service ssh-agent -ErrorAction SilentlyContinue

if ($sshAgentService -eq $null -or $sshAgentService.Status -ne 'Running') {
    Write-Host "ssh-agent is not running. Setting it to start automatically and starting it now..."
    
    Set-Service -Name ssh-agent -StartupType Automatic
    Start-Service ssh-agent
} else {
    Write-Host "ssh-agent is already running."
}

if (-Not (Test-Path -Path "$sshDir\id_ed25519")) {
    ssh-keygen -t ed25519 -C "$email" -f "$sshDir\id_ed25519" -N ""
    ssh-add "$sshDir\id_ed25519"
} else {
    Write-Host "SSH key already exists, skipping key generation."
}

Get-Content "$sshDir\id_ed25519.pub"
Write-Host "Add this SSH key to your GitHub Account: https://github.com/settings/keys"

$opt = Read-Host "Have you added the SSH key to your GitHub account? (Y/N)"

if ($opt -eq 'Y') {
    ssh -T git@github.com
} else {
    Write-Host "Remember to run 'ssh -T git@github.com' later once you've added the SSH key."
}