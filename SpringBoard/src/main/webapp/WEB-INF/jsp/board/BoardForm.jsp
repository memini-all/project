<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    
    <script src="//code.jquery.com/jquery-2.2.3.min.js"></script>
    
    <!-- Bootstrap Core CSS -->
    <link href="/resources/sb-admin/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/sb-admin/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/sb-admin/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/sb-admin/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- jQuery -->
    <script src="/resources/sb-admin/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/sb-admin/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/sb-admin/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/resources/sb-admin/dist/js/sb-admin-2.js"></script>
    
    <script src="/resources/ckeditor/ckeditor.js"></script>
    
  
    <script>
 
	
	$(document).ready(function() {		
		CKEDITOR.replace( 'content', { 'filebrowserUploadUrl': '/uploadckedit'});
	});

	</script>
    

</head>
<body>

	<div id="wrapper">

		<!-- 네비게이션 부분 -->
		<jsp:include page="../common/navigation.jsp" />

		<div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header"><i class="fa fa-files-o fa-fw"></i> </h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            						<!-- enctype="multipart/form-data"을 form 태그에 적용시 자동적으로 VO와 바인딩이 안됨, 
            							pom.xml과 설정파일(main-servlet.xml)에 파일업로드 관련 부분을 모두 추가해야함 -->
            <!-- /.row -->
            <div class="row">
            	<form id="registerForm"  name="registerForm" role="form" enctype="multipart/form-data" >
					<div class="panel panel-default">
	                    <div class="panel-body">
	                    	<div class="row form-group">
	                            <label class="col-lg-1">제목</label>
	                            <div class="col-lg-9">
	                            	<input type="text" class="form-control" id="title" name="title" size="70" maxlength="250" placeholder="Enter Title">
	                            	
	                            	<!-- 공지사항 -->
	                            	<c:if test="${sessionScope.login.authority == 'AD'}">
									 	<label>
				                        	<input type="checkbox" name="notice" id="notice" value="Y" />
				                        	공지사항
				                        </label>
	                            	</c:if>
	                            	
	                            </div>
	                        </div>
	                        <!-- 글 내용 -->
	                    	<div class="row form-group">
	                            <label class="col-lg-1">내용</label>
	                            <div class="col-lg-9">
	                            	<textarea id="content" class="form-control" name="content" rows="10" cols="60"></textarea>
	                            </div>
	                        </div>  
	                        
	                         <!-- 파일첨부 -->		
	                        <div class="row form-group">
	                        	<label class="col-lg-1">파일</label>						
		                     	<div class="col-lg-9">	
		                     			
									<div class="fileUploadWrapper">				
										<div id="fileWrapper" class="fileWrapper" style="position:relative; width:85px;height:45px;">				 								
											<%-- input의 id명 뒤의 숫자를 변경하지 말것(인덱스 번호로 사용됨) --%>				
											<input id="file0" onchange="fn_makeUploadElem(this)" class='file' type="file" name="uploadFile0" style="width:119px;height:40px; position: absolute;right:0px;top:0px; opacity:0; filter: alpha(opacity=0); cursor: pointer; outline:none;"/>					 				
											<span class="btn btn-outline btn-default">파일첨부</span>
										 </div>
										 <!-- 파일목록 부분   -->
										<div class="attachFileList">
										</div>
												
									</div>

								</div>	
							</div>
	                        <!-- 파일첨부 끝 -->		        
	                    </div>
	                </div>
					

					<input type="hidden" name="userno" value="${sessionScope.login.userno}" />
				</form>
				
				<button type="submit" id="registBtn" class="btn btn-outline btn-primary">작성</button>
				<button id="cancelBtn" class="btn btn-outline btn-primary">취소</button>
                
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->
    
    
    <script type="text/javascript">

    
	var formObj = $("form[role='form']");
	

	/*
	 * 글 등록
	 */
	$("#registBtn").on("click", function(){
		
		CKEDITOR.instances["content"].updateElement();
		
		if ( ! fn_chkInputValue("#title", "제목")) return false;
		if ( ! fn_chkInputValue("#content", "내용")) return false;
		if ( ! fn_allFileSizeChk()) return false;
		
		formObj.attr("action", "/board/regist");
		formObj.attr("method", "post");	
		formObj.submit();
	});
	
	
	/*
	 * 글등록 취소
	 */
	$("#cancelBtn").on("click", function(){
	  	self.location = "/board/list";	  
	});
	
	
    // 파일 인덱스값
    var fileIndex = 0;	
    
    
	/*
	 * 파일첨부
	 */
    var fn_makeUploadElem = function(fileElemObj){

    	// 파일 용량체크
    	if ( !fn_fileSizeChk(fileElemObj) ) return false;
    	
    	fileIndex++;
    	
    	var attachFileListElem = $("div").filter(".attachFileList");
    
    	var targetElem = $("div#fileWrapper");
    	var fileElem = $("<input id='file"+fileIndex+"' class='file' type='file' name='uploadFile"+ fileIndex 
    					+ "' style='width:119px;height:40px; position: absolute;right:0px;top:0px; opacity:0; filter: alpha(opacity=0);cursor: pointer;outline:none;'/>");

    	
    	$(fileElem).change(function(){
    		fn_makeUploadElem(this);	//recursive				
    	});
    	

    	$(targetElem).append(fileElem);	
    	
    	var fileValues = $(fileElemObj).val().split("\\");
    	var fileName = fileValues[fileValues.length-1]; 				// 파일명
    	var fileSize = fn_sizeCalculator(fileElemObj.files[0].size); 	// 파일용량
    	
    	var delBtn = "  &nbsp;<button class='btn btn-outline btn-default btn-sm'>삭제</button>";
    	
    	// 파일 이름을 <div class="attachFileList">에 붙인다.
    	$(attachFileListElem).append(
    			"<li class='list-group-item' style=' margin:3px 0;>" +
    			"<span class='attachFileName'>"+fileName+" &nbsp;("+fileSize+")</span>" +
    			"<span class='removeAttach' onClick='fn_deleteFileList(this,"+fileIndex+");'>"+delBtn+"</span>" +
    		"</li>"
    	);			
    }
    

  	/*
	 * 업로드 파일 리스트 삭제
	 */
    var fn_deleteFileList = function(fileListElem,fileIndex){
	  
    	//기본으로 마크업된 input:file의 인덱스 번호가 0으로 시작되는데
    	//전역변수로 증가 시킨 상태이므로 -1을 시켜서 인덱스 번호를 맞춰준다.
    	var fileElemIdx = fileIndex - 1;
    	var fileWrapperElem = $("div").filter("#fileWrapper");
    	
    	$(fileWrapperElem).find("input:file").filter("#file"+fileElemIdx).remove();	
    	$(fileListElem).parent().remove();
    };
	

	/*
	 * 파일 용량단위 계산
	 */
	function fn_sizeCalculator(fileSize){
		
		var kb_Size = (fileSize / 1024);
		
		if ( kb_Size > 1) {  // 계산된 kb값이 1보다 큰지 체크 - 크다면 kb 또는 mb, 작다면 byte
			
			if ( ( kb_Size / 1024) > 1 ) { 
				
				fileSize = (Math.round( ( kb_Size / 1024 ) * 100) / 100);  
				return fileSize + " Mb";
				
			}else{ 
				fileSize = (Math.round( kb_Size * 100 ) / 100);
				return fileSize + " Kb";
			} 
		}else{
			fileSize = (Math.round(fileSize * 100) / 100);
			return fileSize  + " Byte";
		}
	}
	
	
	/*
	 * 개별 파일 사이즈 체크 
	 */
	function fn_fileSizeChk(fileObj){
		
		var maxSize = 1024 * 1024 * 10; // 10mb까지
		var fileSize = fileObj.files[0].size;	// 파일 사이즈
		
		if(fileSize > maxSize){
             alert("파일은 최대 10MB까지 첨부 가능합니다.");
             $(fileObj).val("");
             return false;
         }
		return true;
	}
	
	
	/*
	 * 전체 파일 사이즈 체크
	 */
	function fn_allFileSizeChk(){
		
		var fileSizeSum = 0;
		var maxFilesizeAll = 1024 * 1024 * 10;

		// 전체 파일용량을 가져온다.
		// 등록화면에 <input id="file0" ~~ /> 이 생성되어 있으므로 전체 input:file의 개수는 -1 해줘야함
		for(var i = 0 ; i < $("input:file").length - 1 ; i++){
			var addFile = $("input:file")[i].files[0];
			fileSizeSum += addFile.size;
		}
		
		if( fileSizeSum > maxFilesizeAll ){
			alert("현재용량 : "+fn_sizeCalculator(fileSizeSum)+", 전체 파일용량 10Mb를 초과하였습니다.");
			fileSizeSum = 0;
			return false;
		} 
		return true;
	}


	/*
	 * 입력값 체크
	 */
	function fn_chkInputValue(id, msg){

		if ( $.trim($(id).val()) == "") {
			alert(msg+"을(를) 입력해주세요.");
			$(id).focus();
			return false;
		}
		return true;
	}

    </script>
    
</body>

</html>
