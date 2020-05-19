<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>APP审核列表</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	 <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layuiadmin/layui/css/layui.css" media="all">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/layuiadmin/style/admin.css" media="all">
    <script src="${pageContext.request.contextPath}/statics/layuiadmin/layui/layui.js"></script>  
  <script type="text/javascript" src="${pageContext.request.contextPath}/statics/js/jquery-1.8.3.js">
  
  </script>
  	<style type="text/css">
  	
  	/* 
	layui table 填写数据内容过多，自动换行完美解决
 */
  		.layui-table-cell {
    font-size:14px;
    padding:0 5px;
    height:auto;
    overflow:visible;
    text-overflow:inherit;
    white-space:normal;
    word-break: break-all;
}
  	</style>
</head>
  
  <body>
     <form class="layui-form"   id="zq_search">
  <div class="layui-fluid">
    <div class="layui-card">
      <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item">
          <div style="margin-bottom: 5%;padding-top: 5%;margin-left: 5%" class="layui-inline">
            <div class="layui-input-inlxvine">
              <input type="text"  name="softwareName" placeholder="软件名称" autocomplete="off" class="layui-input">
            </div>
          </div>
          
          <input type="hidden"   name="status" value="1" /><!-- app状态 -->
         
          
          <div class="layui-inline">
            <label class="layui-form-label">所属平台</label>
            <div class="layui-input-inline">
              <select name="flatformId">
              	<option value="">全部</option>
              </select>
            </div>
          </div>
          <div class="layui-inline">
            <label class="layui-form-label">一级分类</label>
            <div class="layui-input-inline">
              <select  lay-filter="c1" id="1"  name="categoryLevel1">
              </select>
            </div>
          </div><div class="layui-inline">
            <label class="layui-form-label">二级分类</label>
            <div class="layui-input-inline">
              <select   lay-filter="c1" id="2" name="categoryLevel2">
                
              </select>
            </div>
          </div><div class="layui-inline">
            <label class="layui-form-label">三级分类</label>
            <div class="layui-input-inline">
              <select  name="categoryLevel3"  id="3">
                
              </select>
            </div>
          </div>
         
          
          
          <div class="layui-inline">
            <button id="search" class="layui-btn layuiadmin-btn-list" lay-submit="" lay-filter="search">
              <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
            </button>
          </div>
        </div>
      </div> 
      
      
     
  </form>

        <table class="layui-hide" id="info" lay-filter="info"  ></table>
        
        <script type="text/html" id="barDemo">
<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="sel">审核</a>
</script>

  	
  	 
  <script>
  var  form;
  layui.config({
    base: '${pageContext.request.contextPath}/statics/layuiadmin/' //静态资源所在路径
  }).extend({
    index: 'lib/index' //主入口模块
  }).use(['index', 'table','form'], function(){
    var table = layui.table;
       form = layui.form;
       
       
       
     //获取下拉框
	  		$.getJSON("sys/datedictionlist.html",function(datas){
	  				 for(var i=0;i<datas.length;i++){
	                    var item=datas[i];
	                    if(item.typeCode=="APP_STATUS"){
	                    	 $("[name=status]").append("<option value="+item.valueId+">"+item.valueName+"</option>");
	                    }else if(item.typeCode=="APP_FLATFORM"){
	                    	 $("[name=flatformId]").append("<option value="+item.valueId+">"+item.valueName+"</option>");
	                    }
	                }
	  				form.render('select');//select是固定写法 不是选择器   渲染 下拉框   否则不会刷新数据
	  			})
	  			$("[name=categoryLevel1]").append("<option value=''>全部</option>");
	  			$.getJSON("sys/categoryList.html",function(data){
	  				for(var i=0;i<data.length;i++){
	  					$("[name=categoryLevel1]").append("<option value="+data[i].id+">"+data[i].categoryName+"</option>");
	  				}
	  				form.render('select');//select是固定写法 不是选择器   渲染 下拉框   否则不会刷新数据
	  			})

    //分类
    form.on('select(c1)', function(data){


      var id = data.elem.getAttribute("id");
      var val = data.value;
      if (id != 3) {
        id++;
        if (val != '') {
          if (id == 2) {
            /*清空第三级信息*/
            $("#3").html("");
            $("#3").append("<option value=''>请先选择父级分类</option>");
          }

          /*123联动*/
          $.getJSON("sys/categoryList.html?parentId=" + val, function (data) {
            $("#" + id + "").html("");
            if (data.length != 0) {
              $("#" + id + "").append(" <option value=''>全部</option>");
              for (var o = 0; o < data.length; o++) {
                $("#" + id + "").append("<option value='" + data[o].id + "'>'" + data[o].categoryName + "'</option>");
              }
            } else {
              $("#" + id + "").append(" <option value=''>暂无</option>");
            }
            form.render('select');//select是固定写法 不是选择器   渲染 下拉框   否则不会刷新数据
          })
        }
      }
			});


  
    table.render({
      elem: '#info'
      ,url: 'sys/list.html?status=1'//数据接口
      ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
       ,page: true //开启分页
       ,limits: [3,4,5]
       ,limit:3
      ,cols: [[
        {field:'softwareName', width:100, title: '软件名称'}
        ,{field:'aPKName', width:100, title: 'APK名称'}
        ,{field:'softwareSize', width:100, title: '软件大小/M'}
        ,{field:'flatformName', width:100, title: '所属平台'}
        ,{field:'categoryContext', title: '所属分类(一级分类、二级分类、三级分类)', width: '20%', minWidth: 100} //minWidth：局部定义当前单元格的最小宽度，layui 2.2.1 新增
        ,{field:'statusName',  width:100,title: '状态'}
        ,{field:'downloads', width:80, title: '下载次数'}
        ,{field:'versionNo', width:80, title: '最新版本号'}
        ,{field: 'versionId', title: 'vid', width: 50,hide:true}
        ,{field: 'id', title: 'id', width: 50,hide:true}
        ,{title:'操作', align:'center', toolbar: '#barDemo'}
      ]]
    });
      //监听提交 lay-filter="search"
        form.on('submit(search)', function(data){
            var formData = data.field;
            var softwareName = formData.softwareName,
            
                url=formData.url,
                icon=formData.icon,
                parent_id=formData.parent_id;
            //执行重载
            table.reload('info', {
                page: {
                    curr: 1 //重新从第 1 页开始
                }
                , where: {//这里传参  向后台
                    softwareName: softwareName,
                    status:formData.status,
                    flatformId:formData.flatformId,
                    categoryLevel1:formData.categoryLevel1,
                    categoryLevel2:formData.categoryLevel2,
                    categoryLevel3:formData.categoryLevel3,
                    i:"1"
                    //可传多个参数到后台...  ，分隔
                }
                , url: 'sys/list.html'//后台做模糊搜索接口路径
                , method: 'post'
            });
            return false;//false：阻止表单跳转  true：表单跳转
        });
        
        
          //监听行工具事件
  table.on('tool(info)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
    var data = obj.data //获得当前行数据
    ,layEvent = obj.event; //获得 lay-event 对应的值
    if(layEvent === 'sel'){
    	if(data.versionNo==null){
    		layer.alert("该APP下没有上传最新版本,不能进行审核操作！");
    	}else{
    	//查看
    		 location.href="sys/findbyid.html?id="+data.id+"&versionId="+data.versionId;
    	}
   
   /*   */
    }
  });
        
  
        
        
 })
  </script>


  
</body>
</html>
