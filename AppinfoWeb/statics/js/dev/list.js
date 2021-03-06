layui.config({
    base: '../../statics/layuiadmin/' //静态资源所在路径
}).extend({
    index: 'lib/index' //主入口模块
}).use(['index', 'table', 'form','jquery'], function () {
     var table = layui.table,
    form = layui.form,
    $=layui.$;





    table.render({
        elem: '#info'
        , url: serverUrl + '/sys/list'//数据接口
        , cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
        , page: true //开启分页
        , limits: [3, 4, 5]
        , limit: 3
        , cols: [[
            {field: 'softwareName', width: 100, title: '软件名称'}
            , {field: 'aPKName', width: 100, title: 'APK名称'}
            , {field: 'softwareSize', width: 100, title: '软件大小/M'}
            , {field: 'flatformName', width: 100, title: '所属平台'}
            , {field: 'categoryContext', title: '所属分类(一级分类、二级分类、三级分类)', width: '20%', minWidth: 100} //minWidth：局部定义当前单元格的最小宽度，layui 2.2.1 新增
            , {field: 'statusName', width: 100, title: '状态'}
            , {field: 'downloads', width: 80, title: '下载次数'}
            , {field: 'versionNo', width: 80, title: '最新版本号'}
            , {field: 'versionId', title: 'vid', width: 50, hide: true}
            , {field: 'id', title: 'id', width: 50, hide: true}
            , {title: '操作',width: 200, align: 'center', toolbar: '#barDemo'}
        ]]
    });
    //监听提交 lay-filter="search"
    form.on('submit(search)', function (data) {

        var formData = data.field;
        console.log(formData);

            url = formData.url;
            icon = formData.icon;
            parent_id = formData.parent_id;
        //执行重载
        table.reload('info', {
            where: { //设定异步数据接口的额外参数，任意设
                softwareName: formData.softwareName,
                status: formData.status,
                flatformId: formData.flatformId,
                categoryLevel1: formData.categoryLevel1,
                categoryLevel2: formData.categoryLevel2,
                categoryLevel3: formData.categoryLevel3,
            }
            ,page: {
                curr: 1 //重新从第 1 页开始
            }
            , url: serverUrl + '/sys/list'//后台做模糊搜索接口路径
        });
        return false;//false：阻止表单跳转  true：表单跳转
    });


    //监听行工具事件
    table.on('tool(info)', function (obj) { //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
        var data = obj.data //获得当前行数据
            , layEvent = obj.event; //获得 lay-event 对应的值
        if (layEvent === 'sel') {
            sessionStorage.setItem("id", data.id)
            location.href = "appdesc.html";
        } else if (layEvent === 'del') {
            layer.confirm('确认删除该APP吗?', function (index) {
                $.getJSON(serverUrl + "/sys/deleteAppinfo", "appId=" + data.id, function (data) {
                    if (data.data.result == "success") {
                        obj.del(); //删除对应行（tr）的DOM结构
                        layer.close(index);

                        //重载表格
                        table.reload('info', {
                            url: serverUrl + '/sys/list'
                        });
                    } else {
                        layer.alert("程序繁忙,请联系管理员！", {icon: 2});
                    }
                })
            });
        } else if (layEvent === 'addb') {
            sessionStorage.setItem("appId", data.id);
            location.href = "appversionadd.html";

        } else if (layEvent === 'upd') {
            if (data.statusName == ("审核未通过") || data.statusName == "待审核") {
                /*进入修改页面*/
                sessionStorage.setItem("appid", data.id);
                location.href = "appupdate.html";
            } else {
                layer.msg("该APP应用的状态为：[" + data.statusName + "],不能修改！");
            }

        } else if (layEvent === 'updb') {
            if (data.versionNo != null) {
                if (data.statusName == ("审核未通过") || data.statusName == "待审核") {
                    sessionStorage.setItem("versionId", data.versionId);
                    sessionStorage.setItem("appId", data.id);
                    location.href = "appversionupdate.html";
                } else {
                    layer.msg("该APP应用的状态为：[" + data.statusName + "],不能修改其版本信息，只可进行[新增版本]操作!");
                }
            } else {
                layer.msg("该应用下无版本信息，请先添加版本信息！");
            }
        } else {
            var status = 5;
            if (layEvent === 'shang') {
                status = 4;
            }
            $.ajax({
                type: "GET",
                url:serverUrl + "/sys/setStatus?id=" + data.id + "&status=" + status,
                success: function (data) {
                    register_dev(data.code);
                    if (data.data.result = "success") {
                        //重载表格
                        table.reload('info', {
                            url: serverUrl + '/sys/list'
                        });
                    } else {
                        layer.msg("系统繁忙,请联系管理员");
                    }
                }
            });
        }
    });
})