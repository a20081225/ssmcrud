package com.yw.crud.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PageController {

    @RequestMapping("/empAdd")//相对于根目录的路径
    public String empAddModal() {
        return "empAddModal";//指定页面要跳转的view视图路径
    }

    @RequestMapping("/empUpdate")
    public String empUpdateModal() {
        return "empUpdateModal";
    }
}
