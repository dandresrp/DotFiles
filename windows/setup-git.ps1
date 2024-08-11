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

ssh-keygen -t ed25519

Get-Content "$sshDir\id_ed25519.pub"
Write-Host "Add this SSH key to your GitHub Account"
$opt = Read-Host "Done? (Y,N)"

if ($opt -eq 'Y') {
    ssh -T git@github.com
} else {
    Write-Host "Remember to run ssh -T git@github.com later."
}
