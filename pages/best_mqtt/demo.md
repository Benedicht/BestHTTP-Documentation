---
title: WebGL Demo
sidebar: best_mqtt_sidebar
---

<link rel="stylesheet" type="text/css" href="{{demo_folder}}{{ "demo/TemplateData/style.css" }}">
<link rel="stylesheet" type="text/css" href="{{demo_folder}}{{ "demo/TemplateData/main.css"}}">

<div class="flex-container" >
	<div class="webgl-content">
		<div id="gameContainer" class="gameContainer" >
			<canvas id="unity-canvas" style="width:100%; height:100%;"></canvas>
			<div id="unity-loading-bar">
				<div id="unity-progress-bar-empty">
				  <div id="unity-progress-bar-full"></div>
				</div>
			</div>
			<div class="footer">
				<div class="webgl-logo"></div>
				<div class="fullscreen" id="unity-fullscreen-button" ></div>
			</div>
		</div>
	</div>
</div>
	
<script>
  var buildUrl = "{{ "/pages/best_mqtt/demo/Build" | relative_url }}";
  var loaderUrl = buildUrl + "/demo.loader.js";
  var config = {
	dataUrl: buildUrl + "/demo.data.unityweb",
	frameworkUrl: buildUrl + "/demo.framework.js.unityweb",
	codeUrl: buildUrl + "/demo.wasm.unityweb",
	streamingAssetsUrl: "StreamingAssets",
	companyName: "Best MQTT",
	productName: "Best MQTT WebGL Demo",
	productVersion: "1.0.0",
  };
  
  var canvas = document.querySelector("#unity-canvas");
  var loadingBar = document.querySelector("#unity-loading-bar");
  var progressBarFull = document.querySelector("#unity-progress-bar-full");
  var fullscreenButton = document.querySelector("#unity-fullscreen-button");
  
  var script = document.createElement("script");
  script.src = loaderUrl;
  script.onload = () => {
	createUnityInstance(canvas, config, (progress) => {
	  progressBarFull.style.width = 100 * progress + "%";
	}).then((unityInstance) => {
	  loadingBar.style.display = "none";
	  fullscreenButton.onclick = () => {
		unityInstance.SetFullscreen(1);
	  };
	}).catch((message) => {
	  alert(message);
	});
  };
  document.body.appendChild(script);
</script>