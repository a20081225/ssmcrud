package com.yw.crud.test;

import com.yw.crud.bean.Department;
import com.yw.crud.dao.DepartmentMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD(){
        /*//创建ioc
        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
        //获取mapper
        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);*/

        System.out.print(departmentMapper);

        departmentMapper.insertSelective(new Department(null,"开发部"));
        
    }
}
