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
	
	.uploadResult ul li img {
		width: 20px;
	}
</style>
</head>
<body>
	<h1>Upload With Ajax</h1>
	
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
		
  	$(document).ready(function() {
  		
  		var cloneObj = $(".uploadDiv").clone();
  		var uploadResult = $(".uploadResult ul");
  		
			function showUploadedFile(uploadResultArr) {
				var str = "";
				
				$(uploadResultArr).each(function(i, obj) {
					if (!obj.image) {
						str += "<li><img src='/resources/img/attach.png'>" + obj.fileName + "</li>";
					} else {
						str += "<li>" + obj.fileName + "</li>";
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
			
		});
  </script>
</body>
</html>