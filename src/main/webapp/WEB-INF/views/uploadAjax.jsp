<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload with Ajax</title>
<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li a {
		text-decoration: none;
		color: white;
	}	
	
	.uploadResult ul li img {
		width: 100px;
	}
	
	.bigPictureWrapper {
		display:none;
		position: absolute;
		/* border: 1px solid red; */
		top: 0%;
		width: 100%;
		height: 100%;
		/* background-color: gray; */
		z-index: 100;
		background: rgba(255,255,255, 0.5);
		justify-content: center;
	}
	
	.bigPicture {
		/* border: 1px solid blue; */
		positon: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicutre img {
		width: 600px;
	}
</style>
</head>
<body>
	<h1>Upload With Ajax</h1>
	
	<div class='bigPictureWrapper'>
	  <div class='bigPicture'>
	  </div>
	</div>

	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
		
	<div class="uploadResult">
		<ul>
		
		</ul>
	</div>
	
	<button id="uploadBtn">Upload</button>
	
	<script
  	src="https://code.jquery.com/jquery-3.4.1.min.js"
  	integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  	crossorigin="anonymous">
	</script>
  
  <script>
	  var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; //5MB
	
		function checkExtension(fileName, fileSize) {
	
			if (fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
	
			if (regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		function showImage(imagePath) {
			console.log(imagePath);
//			alert(imagePath);

			$(".bigPictureWrapper").css("display", "flex").show();
			
			$(".bigPicture")
				.html("<img src='/displayFile?fileName=" + encodeURI(imagePath) + "'>")
				.animate({width: '100%', height: '100%'}, 1000);
		}

  	$(document).ready(function() {
  		
  		var cloneObj = $(".uploadDiv").clone();
  		var uploadResult = $(".uploadResult ul");
  		
			function showUploadedFile(uploadResultArr) {
				var str = "";
				
				$(uploadResultArr).each(function(i, obj) {
					if (obj.image) {
						var imagePath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
						
						var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
						console.log("before replace: " + originPath);
						
						// 생성된 문자열은 '\' 기호 때문에 일반 문자열과는 다르게 처리되므로, '/'로 변환한 뒤에, showImage()에 파라미터로 전달합니다.
						originPath = originPath.replace(new RegExp(/\\/g), "/");
						console.log("after replace: " + originPath);
						
						str += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\">"
						     + "<img src='/displayFile?fileName=" + imagePath + "'></a>"
						     + "<span data-file='" + imagePath + "' data-type='image'> x </span>"
						     + "</li>";
						
					} else {
						var filePath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						str += "<li><a href='downloadFile?fileName=" + filePath + "'>"
							   + "<img src='/resources/img/attach.png'>" + obj.fileName + "</a>"
							   + "<span data-file='" + filePath + "' data-type='file'> x </span>" 
							   + "</li>";
					}
				});
				
				uploadResult.append(str);
			}
			
  		$("#uploadBtn").on("click", function(e) {
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				
				console.log(files);
				
				for (var i = 0; i < files.length; i++) {
					if (!checkExtension(files[i].name, files[i].size)) {
						return false;
					}
					
					formData.append("uploadFile", files[i]);
				}
				
				$.ajax({
					type: "post",
					url: "/uploadAjax",
					data: formData,
					dataType: "json",
					processData: false,
					contentType: false,
					success: function(result) {
						console.log(result);
						
						showUploadedFile(result);

						$(".uploadDiv").html(cloneObj.html());
					}
				});
			});
  		
  		$(".bigPictureWrapper").on("click", function(e) {
				$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
				
				setTimeout(() => {
					$(this).hide();
				}, 1000);
				
				// ES6의 화살표 함수는 Chrome에서는 정상 작동하지만, IE11에서는 제대로 동작하지 않으므로 다음의 내용으로 테스트한다.
				/* setTimeout(function() {
					$(".bigPictureWrapper").hide();
				}, 1000); */
			});
  		
  		$(".uploadResult").on("click", "span", function(e) {
  			var that = $(this);
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				
				$.ajax({
					type: "post",
					url: "/deleteFile",
					data: {fileName: targetFile, type:type},
					dataType: "text",
					success: function(result) {
						alert(result);
						that.parent().remove();
					}
				});
				
			});
			
		});
  </script>
</body>
</html>