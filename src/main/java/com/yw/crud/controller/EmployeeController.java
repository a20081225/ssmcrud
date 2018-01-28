package com.yw.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.yw.crud.bean.Employee;
import com.yw.crud.bean.Msg;
import com.yw.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 处理员工CRUD
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 更新保存员工信息
     *  @param employee
     * @return
     */
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.succese();
    }

    /**
     * 查询单个员工
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.succese().add("emp",employee);
    }

    /**
     * 检测用户名是否重复
     * @param empName
     * @return
     */
    @RequestMapping("/checkUser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName){
        //表达式校验
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg","英文数字6-16位或者汉字2-5位");
        }
        //数据库校验
        boolean b = employeeService.checkUser(empName);
        if (b){
            return Msg.succese();
        }else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    /**
     * 保存员工
     * @param employee
     * @return
     */
    @RequestMapping(value = "/emps",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult bindingResult){
        if (bindingResult.hasErrors()){
            Map<String,Object> map = new HashMap<String, Object>();
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
            for (FieldError fieldError : fieldErrors) {
//                System.out.println("错误字段名"+fieldError.getField());
//                System.out.println("错误信息"+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("fieldErrors",map);
        }else{
            employeeService.saveEmp(employee);
            return Msg.succese();
        }

    }


    /**
     * 查询所有员工列表
     *  @param pn
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        //传入页码
        PageHelper.startPage(pn,5);
        //查询员工
        List<Employee> emps = employeeService.getall();
        //使用pageinfo包装list
        PageInfo page = new PageInfo(emps,5);
        return Msg.succese().add("pageInfo",page);
    }

    /**
     * 查询员工测试项
     * @return
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){

        //传入页码
        PageHelper.startPage(pn,5);
        //查询员工
        List<Employee> emps = employeeService.getall();
        //使用pageinfo包装list
        PageInfo page = new PageInfo(emps,5);
        model.addAttribute("pageInfo",page);
        return "list";
    }
}
