<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title></title>
		<script type="text/javascript" src="jquery.min.js"></script>
		<script src="recorder.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body>
		<input type="button" id="" value="开始录音" onclick="start()" />

		<input type="button" id="" value="结束" onclick="stop()" />

		<ul id="recordingslist"></ul>
		<script>
			var audio_context;
			var recorder;
			function init() {
				try {
					// webkit shim
					window.AudioContext = window.AudioContext || window.webkitAudioContext;
					navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia;
					window.URL = window.URL || window.webkitURL;

					audio_context = new AudioContext;
					console.log('Audio context set up.');
					console.log('navigator.getUserMedia ' + (navigator.getUserMedia ? 'available.' : 'not present!'));
				} catch(e) {
					alert('No web audio support in this browser!');
				}

				navigator.getUserMedia({
					audio: true
				}, startUserMedia, function(e) {
					console.log('No live audio input: ' + e);
				});
			}

			function startUserMedia(stream) {
				var input = audio_context.createMediaStreamSource(stream);
				console.log('Media stream created.');

				// Uncomment if you want the audio to feedback directly
				//input.connect(audio_context.destination);
				//console.log('Input connected to audio context destination.');

				recorder = new Recorder(input);
				console.log('Recorder initialised.');
			}
			

			function start() {
				if(!recorder) init();
				recorder && recorder.record();
				console.log('Recording...');
			}

			function stop() {
				recorder && recorder.stop();
				recorder && recorder.exportWAV(function(blob) {
					var url = URL.createObjectURL(blob);
					var li = document.createElement('li');
					var au = document.createElement('audio');
					var hf = document.createElement('a');
					au.controls = true;
					au.src = url;
					hf.href = url;
					hf.download = new Date().toISOString() + '.wav';
					hf.innerHTML = hf.download;
					li.appendChild(au);
					li.appendChild(hf);
					document.getElementById('recordingslist').appendChild(li);
					
				  	 var formData = new FormData();
				     formData.set('file',blob);//blob即为要发送的数据				   				        
				        $.ajax({
							url : '/SpeAbility/getVoice',
							type : 'POST',
							async : true,	//	使用异步导入
							dataType: "json",
							data : formData,
							processData : false,  // 告诉jQuery不要去处理发送的数据
							contentType : false,  // 告诉jQuery不要去设置Content-Type请求头
							xhrFields:{
			   					 withCredentials:true
							},
							success : function(data) {
								 console.log("data:" + data.voiceStr);
							},error:function (data,status,headers,config) {
			                    console.log(data);
			                }
						});

				});
				recorder.clear();
				
			}
		</script>
	</body>

</html>