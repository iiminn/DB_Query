use scott;

-- 1. emp 와 dept Table 을 JOIN 하여 이름 , 급여 , 부서명을 검색하세요
select e.ENAME, e.SAL, d.DNAME
from emp e inner join dept d
on e.DEPTNO=d.DEPTNO;

-- 2. 이름이 KING’ 인 사원의 부서명을 검색하세요
select d.DNAME
from emp e inner join dept d
on e.DEPTNO=d.DEPTNO
where e.ename like 'king';

-- 3. dept Table 에 있는 모든 부서를 출력하고 , emp Table 에 있는 DATA 와 JOIN 하여 모든 사원의 이름 , 부서번호 , 부서명 , 급여를 출력 하라
select d.DNAME,e.ENAME, e.DEPTNO,d.DNAME, e.sal
from emp e right outer join dept d
on e.DEPTNO=d.DEPTNO;

-- 4. emp Table 에 있는 empno 와 mgr 을 이용하여 서로의 관계를 다음과 같이 출력되도록 쿼리를 작성하세요 . ‘SCOTT 의 매니저는 JONES 이다’ >> 혼자힘으로 해보기!!
select concat(e.ename, ' 의 매니저는 ', m.ename, ' 이다')
from emp e inner join emp m
on e.mgr = m.empno;
-- where e.ename = 'SCOTT';

-- 5.'scott' 의 직무와 같은 사람의 이름 , 부서명 , 급여 , 직무를 검색하세요
select e.ENAME, d.DNAME, e.sal, e.JOB 
from emp e inner join dept d
on e.DEPTNO = d.DEPTNO
where job like (select job
from emp e1
where ENAME like 'scott') and e.ENAME not like 'scott';

-- 6.'scott' 가 속해 있는 부서의 모든 사람의 사원번호 , 이름 , 입사일 , 급여를 검색하세요


select e.EMPNO, e.ENAME, e.HIREDATE, e.SAL
from emp e 
where deptno =(select DEPTNO
from emp
where ename like 'scott');

-- 7. 전체 사원의 평균급여보다 급여가 많은 사원의 사원번호 , 이름 부서명 , 입사일 , 지역 , 급여를 검색하세요
select *
from emp;

select e.EMPNO, e.ENAME, d.DNAME, e.HIREDATE, d.LOC,e.SAL
from emp e inner join dept d
on e.DEPTNO=d.DEPTNO
where e.SAL >=(select avg(sal) from emp);

-- 8. 30 번 부서와 같은 일을 하는 사원의 사원번호 , 이름 , 부서명 지역 , 급여를 급여가 많은 순으로 검색하세요
select * 
from dept;
select *
from emp
where deptNo=30;

select e.DEPTNO, e.ENAME, d.DNAME ,d.LOC, e.sal 
from emp e inner join dept d
on e.DEPTNO=d.DEPTNO
where e.job in (select job from emp where DEPTNO=30)
order by e.sal desc;

-- 9. 10 번 부서 중에서 30 번 부서에는 없는 업무를 하는 사원의 사원번호 , 이름 , 부서명 ,입사일 , 지역을 검색하세요
select *
from emp;

select e.EMPNO, e.ENAME, d.DNAME ,e.HIREDATE,d.LOC
from emp e inner join dept d
on e.DEPTNO=d.DEPTNO
where e.DEPTNO=10 and e.job not in(select job from emp where DEPTNO=30);

-- 10. KING’ 이나 JAMES' 의 급여와 같은 사원의 사원번호 , 이름 급여를 검색하세요
select *
from emp;

select e.EMPNO,e.ENAME,e.sal
from emp e
where e.sal in (select sal from emp where ENAME like 'king' or ENAME like 'james') and ENAME not in('king','james');

-- 11. 급여가 30 번 부서의 최고 급여보다 높은 사원의 사원번호 이름 , 급여를 검색하세요


select EMPNO, ENAME,SAL
from emp
where sal> (select max(sal)
from emp
group by deptno
having deptno=30);
-- 12. 이름 검색을 보다 빠르게 수행하기 위해 emp 테이블 ename 에 인덱스를 생성하시오 (x)
-- 13.이름이 'allen' 인 사원의 입사연도가 같은 사원들의 이름과 급여를 출력하세요

select ENAME, sal
from emp
where HIREDATE = (select hiredate from emp where ENAME like 'allen') 
and ENAME not like 'allen'; 

