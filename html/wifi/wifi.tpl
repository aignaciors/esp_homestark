<html><head><title>HomeStark Device</title>
<link rel="icon" type="image/jpeg" href="favicon.jpg"/>
<link rel="stylesheet" type="text/css" href="style.css">
<script type="text/javascript" src="140medley.min.js"></script>
<script type="text/javascript">

var xhr=j();
var currAp="%currSsid%";

function createInputForAp(ap) {
	if (ap.essid=="" && ap.rssi==0) return;
	var div=document.createElement("div");
	div.id="apdiv";
	var rssi=document.createElement("div");
	var rssiVal=-Math.floor(ap.rssi/51)*32;
	rssi.className="icon";
	rssi.style.backgroundPosition="0px "+rssiVal+"px";
	var encrypt=document.createElement("div");
	var encVal="-64"; //assume wpa/wpa2
	if (ap.enc=="0") encVal="0"; //open
	if (ap.enc=="1") encVal="-32"; //wep
	encrypt.className="icon";
	encrypt.style.backgroundPosition="-32px "+encVal+"px";
	var input=document.createElement("input");
	input.type="radio";
	input.name="essid";
	input.value=ap.essid;
	if (currAp==ap.essid) input.checked="1";
	input.id="opt-"+ap.essid;
	var label=document.createElement("label");
	label.htmlFor="opt-"+ap.essid;
	label.textContent=ap.essid;
	div.appendChild(input);
	div.appendChild(rssi);
	div.appendChild(encrypt);
	div.appendChild(label);
	return div;
}

function getSelectedEssid() {
	var e=document.forms.wifiform.elements;
	for (var i=0; i<e.length; i++) {
		if (e[i].type=="radio" && e[i].checked) return e[i].value;
	}
	return currAp;
}


function scanAPs() {
	xhr.open("GET", "wifiscan.cgi");
	xhr.onreadystatechange=function() {
		if (xhr.readyState==4 && xhr.status>=200 && xhr.status<300) {
			var data=JSON.parse(xhr.responseText);
			currAp=getSelectedEssid();
			if (data.result.inProgress=="0" && data.result.APs.length>1) {
				$("#aps").innerHTML="";
				for (var i=0; i<data.result.APs.length; i++) {
					if (data.result.APs[i].essid=="" && data.result.APs[i].rssi==0) continue;
					$("#aps").appendChild(createInputForAp(data.result.APs[i]));
				}
				window.setTimeout(scanAPs, 20000);
			} else {
				window.setTimeout(scanAPs, 1000);
			}
		}
	}
	xhr.send();
}


window.onload=function(e) {
	scanAPs();
};
</script>
</head>
<body>
<div id="main">
<div id ="logo_scr">
</div>
<p>
<b><h4>
Desenvolvido por:<br>
Anderson Ignacio da Silva<br>
Armando Leopoldo Keller<br>
Guilherme Eduardo Cavalheiro<br>
</h4>
<div id="creators"></div>
</b>
</p>
<form name="wifiform" action="connect.cgi" method="post">
<p>
Para conectar selecione uma das redes listadas abaixo:<br>
<div id="aps">Procurando redes...</div>
<br>
Senha Wi-fi, se aplicavel: <br />
<input type="password" name="passwd" val="%WiFiPasswd%"> <br />
<br>
<input type="submit" name="connect" value="Connect!" style="width:100px; height:50px;">
</p>
</div>
</body>
</html>
