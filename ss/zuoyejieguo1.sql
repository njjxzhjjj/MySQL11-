
-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数  
select s.* ,b.s_score as 1score,c.s_score as 2score from student s join score b on s.s_id=b.s_id and b.c_id='01' left join score c on s.s_id=c.s_id and c.c_id='02' or c.c_id = NULL where b.s_score>c.s_score;
 

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
select s.* ,b.s_score as 1score,c.s_score as 2score from student s join score b on s.s_id=b.s_id and b.c_id='01' left join score c on s.s_id=c.s_id and c.c_id='02' or c.c_id = NULL where b.s_score<c.s_score;
 
  


-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select s.s_id,s.s_name,ROUND(AVG(a.s_score),2) as avg_score from 
student s join score a on s.s_id = a.s_id GROUP BY s.s_id,s.s_name HAVING ROUND(AVG(a.s_score),2)>=60;
 


-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
        -- (包括有成绩的和无成绩的)
 
select s.s_id,s.s_name,ROUND(AVG(a.s_score),2) as avg_score from  student s left join score a on s.s_id = a.s_id GROUP BY s.s_id,s.s_name HAVING ROUND(AVG(a.s_score),2)<60 union select a.s_id,a.s_name,0 as avg_score from student a where a.s_id not in (select distinct s_id from score);
 

-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
 select s.s_id,s.s_name,count(b.c_id) as sum_course,sum(b.s_score) as sum_score from 
 student s left join score b on s.s_id=b.s_id GROUP BY s.s_id,s.s_name;
 

-- 6、查询"李"姓老师的数量 
select count(t_id) from teacher where t_name like '李%';
 
-- 7、查询学过"张三"老师授课的同学的信息 
 select s.* from student s join score b on s.s_id=b.s_id where b.c_id in(select c_id from course where t_id =(select t_id from teacher where t_name = '张三'));
 

-- 8、查询没学过"张三"老师授课的同学的信息 

select * from student c where c.s_id not in(select s.s_id from student s join score b on s.s_id=b.s_id where b.c_id in(select c_id from course where t_id =(select t_id from teacher where t_name = '张三')));
 
-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select s.* from student s,score b,score c where s.s_id = b.s_id  and s.s_id = c.s_id and b.c_id='01' and c.c_id='02';
 

-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
 
select s.* from student s where s.s_id in (select s_id from score where c_id='01' ) and s.s_id not in(select s_id from score where c_id='02');

-- 11、查询没有学全所有课程的同学的信息 
select s.* from  student s where s.s_id in(select s_id from score where s_id not in(
select a.s_id from score a join score b on a.s_id = b.s_id and b.c_id='02'
join score c on a.s_id = c.s_id and c.c_id='03' where a.c_id='01'));
 

-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 
select * from student where s_id in(select distinct a.s_id from score a where a.c_id in(select a.c_id from score a where a.s_id='01'));
 

-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息
select s.* from student s where s.s_id in(select distinct s_id from score where s_id!='01' and c_id in(select c_id from score where s_id='01') group by s_id having count(1)=(select count(1) from score where s_id='01'));
 
-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名 
select s.s_name from student s where s.s_id not in (select s_id from score where c_id = (select c_id from course where t_id =(select t_id from teacher where t_name = '张三')) group by s_id);

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select s.s_id,s.s_name,ROUND(AVG(b.s_score)) from student s left join score b on s.s_id = b.s_id where s.s_id in(select s_id from score where s_score<60 GROUP BY  s_id having count(1)>=2)GROUP BY s.s_id,s.s_name;

