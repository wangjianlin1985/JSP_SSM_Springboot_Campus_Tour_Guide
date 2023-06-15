<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.Route" %>
<%@ page import="com.chengxusheji.po.Scenic" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    List<Route> routeList = (List<Route>)request.getAttribute("routeList");
    //获取所有的startScenic信息
    List<Scenic> scenicList = (List<Scenic>)request.getAttribute("scenicList");
    int currentPage =  (Integer)request.getAttribute("currentPage"); //当前页
    int totalPage =   (Integer)request.getAttribute("totalPage");  //一共多少页
    int recordNumber =   (Integer)request.getAttribute("recordNumber");  //一共多少记录
    Scenic startScenic = (Scenic)request.getAttribute("startScenic");
    Scenic endScenic = (Scenic)request.getAttribute("endScenic");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>路径查询</title>
<link href="<%=basePath %>plugins/bootstrap.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-dashen.css" rel="stylesheet">
<link href="<%=basePath %>plugins/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>plugins/animate.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
</head>
<body style="margin-top:70px;">
<div class="container">
<jsp:include page="../header.jsp"></jsp:include>
	<div class="row"> 
		<div class="col-md-9 wow fadeInDown" data-wow-duration="0.5s">
			<div>
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
			    	<li><a href="<%=basePath %>index.jsp">首页</a></li>
			    	<li role="presentation" class="active"><a href="#routeListPanel" aria-controls="routeListPanel" role="tab" data-toggle="tab">路径列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>Route/route_frontAdd.jsp" style="display:none;">添加路径</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="routeListPanel">
				    		<div class="row">
				    			<div class="col-md-12 top5">
				    				<div class="table-responsive">
				    				<table class="table table-condensed table-hover">
				    					<tr class="success bold"><td>序号</td><td>起始景点</td><td>结束景点</td><td>操作</td></tr>
				    					<% 
				    						/*计算起始序号*/
				    	            		int startIndex = (currentPage -1) * 5;
				    	            		/*遍历记录*/
				    	            		for(int i=0;i<routeList.size();i++) {
					    	            		int currentIndex = startIndex + i + 1; //当前记录的序号
					    	            		Route route = routeList.get(i); //获取到路径对象
 										%>
 										<tr>
 											<td><%=currentIndex %></td>
 											<td><%=route.getStartScenic().getScenicName() %></td>
 											<td><%=route.getEndScenic().getScenicName() %></td>
 											<td>
 												<a href="<%=basePath  %>Route/<%=route.getRouteId() %>/frontshow"><i class="fa fa-info"></i>&nbsp;查看</a>&nbsp;
 												<a href="#" onclick="routeEdit('<%=route.getRouteId() %>');" style="display:none;"><i class="fa fa-pencil fa-fw"></i>编辑</a>&nbsp;
 												<a href="#" onclick="routeDelete('<%=route.getRouteId() %>');" style="display:none;"><i class="fa fa-trash-o fa-fw"></i>删除</a>
 											</td> 
 										</tr>
 										<%}%>
				    				</table>
				    				</div>
				    			</div>
				    		</div>

				    		<div class="row">
					            <div class="col-md-12">
						            <nav class="pull-left">
						                <ul class="pagination">
						                    <li><a href="#" onclick="GoToPage(<%=currentPage-1 %>,<%=totalPage %>);" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
						                     <%
						                    	int startPage = currentPage - 5;
						                    	int endPage = currentPage + 5;
						                    	if(startPage < 1) startPage=1;
						                    	if(endPage > totalPage) endPage = totalPage;
						                    	for(int i=startPage;i<=endPage;i++) {
						                    %>
						                    <li class="<%= currentPage==i?"active":"" %>"><a href="#"  onclick="GoToPage(<%=i %>,<%=totalPage %>);"><%=i %></a></li>
						                    <%  } %> 
						                    <li><a href="#" onclick="GoToPage(<%=currentPage+1 %>,<%=totalPage %>);"><span aria-hidden="true">&raquo;</span></a></li>
						                </ul>
						            </nav>
						            <div class="pull-right" style="line-height:75px;" >共有<%=recordNumber %>条记录，当前第 <%=currentPage %>/<%=totalPage %> 页</div>
					            </div>
				            </div> 
				    </div>
				</div>
			</div>
		</div>
	<div class="col-md-3 wow fadeInRight">
		<div class="page-header">
    		<h1>路径查询</h1>
		</div>
		<form name="routeQueryForm" id="routeQueryForm" action="<%=basePath %>Route/frontlist" class="mar_t15">
            <div class="form-group">
            	<label for="startScenic_scenicId">起始景点：</label>
                <select id="startScenic_scenicId" name="startScenic.scenicId" class="form-control">
                	<option value="0">不限制</option>
	 				<%
	 				for(Scenic scenicTemp:scenicList) {
	 					String selected = "";
 					if(startScenic!=null && startScenic.getScenicId()!=null && startScenic.getScenicId().intValue()==scenicTemp.getScenicId().intValue())
 						selected = "selected";
	 				%>
 				 <option value="<%=scenicTemp.getScenicId() %>" <%=selected %>><%=scenicTemp.getScenicName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
            <div class="form-group">
            	<label for="endScenic_scenicId">结束景点：</label>
                <select id="endScenic_scenicId" name="endScenic.scenicId" class="form-control">
                	<option value="0">不限制</option>
	 				<%
	 				for(Scenic scenicTemp:scenicList) {
	 					String selected = "";
 					if(endScenic!=null && endScenic.getScenicId()!=null && endScenic.getScenicId().intValue()==scenicTemp.getScenicId().intValue())
 						selected = "selected";
	 				%>
 				 <option value="<%=scenicTemp.getScenicId() %>" <%=selected %>><%=scenicTemp.getScenicName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
            <input type=hidden name=currentPage value="<%=currentPage %>" />
            <button type="submit" class="btn btn-primary">查询</button>
        </form>
	</div>

		</div>
	</div> 
<div id="routeEditDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-edit"></i>&nbsp;路径信息编辑</h4>
      </div>
      <div class="modal-body" style="height:450px; overflow: scroll;">
      	<form class="form-horizontal" name="routeEditForm" id="routeEditForm" enctype="multipart/form-data" method="post"  class="mar_t15">
		  <div class="form-group">
			 <label for="route_routeId_edit" class="col-md-3 text-right">路径id:</label>
			 <div class="col-md-9"> 
			 	<input type="text" id="route_routeId_edit" name="route.routeId" class="form-control" placeholder="请输入路径id" readOnly>
			 </div>
		  </div> 
		  <div class="form-group">
		  	 <label for="route_startScenic_scenicId_edit" class="col-md-3 text-right">起始景点:</label>
		  	 <div class="col-md-9">
			    <select id="route_startScenic_scenicId_edit" name="route.startScenic.scenicId" class="form-control">
			    </select>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="route_endScenic_scenicId_edit" class="col-md-3 text-right">结束景点:</label>
		  	 <div class="col-md-9">
			    <select id="route_endScenic_scenicId_edit" name="route.endScenic.scenicId" class="form-control">
			    </select>
		  	 </div>
		  </div>
		</form> 
	    <style>#routeEditForm .form-group {margin-bottom:5px;}  </style>
      </div>
      <div class="modal-footer"> 
      	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      	<button type="button" class="btn btn-primary" onclick="ajaxRouteModify();">提交</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<jsp:include page="../footer.jsp"></jsp:include> 
<script src="<%=basePath %>plugins/jquery.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap.js"></script>
<script src="<%=basePath %>plugins/wow.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap-datetimepicker.min.js"></script>
<script src="<%=basePath %>plugins/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=basePath %>js/jsdate.js"></script>
<script>
var basePath = "<%=basePath%>";
/*跳转到查询结果的某页*/
function GoToPage(currentPage,totalPage) {
    if(currentPage==0) return;
    if(currentPage>totalPage) return;
    document.routeQueryForm.currentPage.value = currentPage;
    document.routeQueryForm.submit();
}

/*可以直接跳转到某页*/
function changepage(totalPage)
{
    var pageValue=document.routeQueryForm.pageValue.value;
    if(pageValue>totalPage) {
        alert('你输入的页码超出了总页数!');
        return ;
    }
    document.routeQueryForm.currentPage.value = pageValue;
    documentrouteQueryForm.submit();
}

/*弹出修改路径界面并初始化数据*/
function routeEdit(routeId) {
	$.ajax({
		url :  basePath + "Route/" + routeId + "/update",
		type : "get",
		dataType: "json",
		success : function (route, response, status) {
			if (route) {
				$("#route_routeId_edit").val(route.routeId);
				$.ajax({
					url: basePath + "Scenic/listAll",
					type: "get",
					success: function(scenics,response,status) { 
						$("#route_startScenic_scenicId_edit").empty();
						var html="";
		        		$(scenics).each(function(i,scenic){
		        			html += "<option value='" + scenic.scenicId + "'>" + scenic.scenicName + "</option>";
		        		});
		        		$("#route_startScenic_scenicId_edit").html(html);
		        		$("#route_startScenic_scenicId_edit").val(route.startScenicPri);
					}
				});
				$.ajax({
					url: basePath + "Scenic/listAll",
					type: "get",
					success: function(scenics,response,status) { 
						$("#route_endScenic_scenicId_edit").empty();
						var html="";
		        		$(scenics).each(function(i,scenic){
		        			html += "<option value='" + scenic.scenicId + "'>" + scenic.scenicName + "</option>";
		        		});
		        		$("#route_endScenic_scenicId_edit").html(html);
		        		$("#route_endScenic_scenicId_edit").val(route.endScenicPri);
					}
				});
				$('#routeEditDialog').modal('show');
			} else {
				alert("获取信息失败！");
			}
		}
	});
}

/*删除路径信息*/
function routeDelete(routeId) {
	if(confirm("确认删除这个记录")) {
		$.ajax({
			type : "POST",
			url : basePath + "Route/deletes",
			data : {
				routeIds : routeId,
			},
			success : function (obj) {
				if (obj.success) {
					alert("删除成功");
					$("#routeQueryForm").submit();
					//location.href= basePath + "Route/frontlist";
				}
				else 
					alert(data.message);
			},
		});
	}
}

/*ajax方式提交路径信息表单给服务器端修改*/
function ajaxRouteModify() {
	$.ajax({
		url :  basePath + "Route/" + $("#route_routeId_edit").val() + "/update",
		type : "post",
		dataType: "json",
		data: new FormData($("#routeEditForm")[0]),
		success : function (obj, response, status) {
            if(obj.success){
                alert("信息修改成功！");
                $("#routeQueryForm").submit();
            }else{
                alert(obj.message);
            } 
		},
		processData: false,
		contentType: false,
	});
}

$(function(){
	/*小屏幕导航点击关闭菜单*/
    $('.navbar-collapse a').click(function(){
        $('.navbar-collapse').collapse('hide');
    });
    new WOW().init();

})
</script>
</body>
</html>

