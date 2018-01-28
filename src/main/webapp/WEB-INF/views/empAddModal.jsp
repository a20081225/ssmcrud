<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%
    pageContext.setAttribute("APP_PATH",request.getContextPath());
%>
<!--jQuery-->
<script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.2.1.min.js"></script>
<!-- Bootstrap -->
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<body>
<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title" id="myModalLabel">员工添加</h4>
</div>
<div class="modal-body" id="empAddModalContent">
    <form class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-2 control-label">empName</label>
            <div class="col-sm-10">
                <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                <span class="help-block"></span>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">gender</label>
            <div class="col-sm-10">
                <label class="radio-inline">
                    <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                </label>
                <label class="radio-inline">
                    <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                </label>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">email</label>
            <div class="col-sm-10">
                <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@taiji.com">
                <span class="help-block"></span>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">deptName</label>
            <div class="col-sm-4">
                <select class="form-control" name="dId" id="dept_add_select"></select>
            </div>
        </div>
    </form>
</div>
<div class="modal-footer">
    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
</div>
</body>

<script type="text/javascript">

    getDepts();
    //获得部门信息
    function getDepts() {
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            success:function (result) {
                $.each(result.extend.depts,function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo("#dept_add_select");
                });
            }
        })
    }

    //校验输入
    function validate_empName_add_form() {
        var empName = $("#empName_add_input").val();

        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regName.test(empName)){
            show_validate_msg("#empName_add_input","error","英文数字6-16位或者汉字2-5位");
            return false;
        }else{
            show_validate_msg("#empName_add_input","success","")
        }
        return true;
    }
    function validate_email_add_form() {
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            show_validate_msg("#email_add_input", "error", "输入格式有误，请重新输入");
            return false;
        } else {
            show_validate_msg("#email_add_input", "success", "")
        }
        return true;
    }


    //显示校验信息
    function show_validate_msg(ele,status,msg) {
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if (status == "success"){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if (status == "error"){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }

    }

    //校验用户名是否可用
    $("#empName_add_input").change(function () {
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkUser",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if(result.code == 100){
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    $("#emp_save_btn").attr("ajax-va","success");
                }else{
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
    });

    $("#email_add_input").change(function () {
        validate_email_add_form();
    });

    //员工保存
    $("#emp_save_btn").click(function () {
        $(this).attr("data-dismiss", "modal");
        //用户名重复校验
        if($(this).attr("ajax-va") == "error"){
            return false;
        }else{
            //校验输入框
            if(!validate_empName_add_form()){
                return false;
            }else if (!validate_email_add_form()){
                return false;
            }
        }
        //发送ajax请求
        $.ajax({
            url: "${APP_PATH}/emps",
            type: "POST",
            data: $("#empAddModalContent form").serialize(),
            success: function (result) {
                if (result.code == 100) {
                    //保存成功
                    window.parent.to_page(pages+1);
                }else{
                    var err_empName = result.extend.fieldErrors.empName;
                    var err_email = result.extend.fieldErrors.email;
                    //保存有误信息
                    $(this).removeAttr("data-dismiss");
                    if (undefined !== err_empName){
                        show_validate_msg("#empName_add_input","error",err_empName);
                    }else if (undefined !== err_email){
                        show_validate_msg("#email_add_input","error",err_email);
                    }
                }
            }
        });


    });

</script>

</html>