<%--<jsp:forward page="/emps"></jsp:forward>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
    pageContext.setAttribute("APP_PATH",request.getContextPath());
%>
<!--jQuery-->
<script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.2.1.min.js"></script>
<!-- Bootstrap -->
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<body>

<%--员工修改页面--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     data-remote="${APP_PATH}/empUpdate">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

        </div>
    </div>
</div>

<!-- 员工添加页面 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     data-remote="${APP_PATH}/empAdd">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

        </div>
    </div>
</div>

<%--搭建页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <%--显示数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--分页--%>
    <div class="row">
        <%--分页信息--%>
        <div class="col-md-6" id="page_info_area"></div>
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>
<script type="text/javascript">
    var pages;
    var pageNum;
    <%--分页ajax请求--%>
    $(function(){
        //首页
        to_page(1);
    });

    //跳转页面
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"GET",
            success:function (result) {
                build_emps_table(result);
                build_page_info(result);
                build_page_nav(result);
            }
        });
    }

    //解析员工数据
    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender=='M'?'男':'女');
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            editBtn.attr("edit-id",item.empId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_bn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(empIdTd).append(empNameTd).append(genderTd)
                .append(emailTd).append(deptNameTd).append(btnTd)
                .appendTo("#emps_table tbody");
        })
    }
    
    //解析分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        pageNum = result.extend.pageInfo.pageNum;
        pages = result.extend.pageInfo.pages;
        var total = result.extend.pageInfo.total;
        $("#page_info_area").append("当前"+pageNum+"页，总"+pages+"页数，总"+total+"条目数");
    }
    
    //解析分页条
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var navigatepageNums = result.extend.pageInfo.navigatepageNums;
        pageNum = result.extend.pageInfo.pageNum;
        var hasPreviousPage = result.extend.pageInfo.hasPreviousPage;
        var hasNextPage = result.extend.pageInfo.hasNextPage;
        pages = result.extend.pageInfo.pages;
        //page_nav_area
        var ul = $("<ul></ul>").addClass("pagination");
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var perPageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            perPageLi.addClass("disabled");
        }else{
            firstPageLi.click(function () {
                to_page(1);
            });
            perPageLi.click(function () {
                to_page(pageNum-1);
            });
        }
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            nextPageLi.click(function () {
                to_page(pageNum+1);
            });
            lastPageLi.click(function () {
                to_page(pages);
            });
        }
        //添加首页前一页
        ul.append(firstPageLi).append(perPageLi);
        $.each(navigatepageNums,function (index,item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            //添加页码
            ul.append(numLi);
        })
        //添加后一页末页
        ul.append(nextPageLi).append(lastPageLi);
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //点击弹出添加窗口
    $("#emp_add_modal_btn").click(function () {
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });

    var empEditId;
    //绑定编辑按钮事件
    $(document).on("click",".edit_btn",function () {
        empEditId = $(this).attr("edit-id");
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });



</script>
</body>
</html>

