------------------------------- 종합 문제 ----------------------------------
-- 1. JOB테이블에서 모든 정보 조회
select *
from job;
-- 2. JOB 테이블에서 직급 이름 조회
select job_name
from job;
-- 3. DEPARTMENT 테이블에서 모든 정보 조회
select *
from department;
-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select emp_name, email, phone, hire_date
from employee;
-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select hire_date, emp_name, salary
from employee;
-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
select emp_name, salary*12 as 연봉 , (bonus+salary)*12 as "연봉(보너스포함)", (salary * 12) * 0.97 AS "세후실수령액(보너스미포함)"
from employee;
-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
select emp_name, salary, hire_date, phone
from employee
where job_code = 'J1';
-- 8. EMPLOYEE테이블에서 실수령액이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select emp_name, salary, (salary * 12) * 0.97 AS "세후실수령액(보너스미포함)", hire_date
from employee
where (salary * 12) * 0.97 >= 50000000;
-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select *
from employee
where salary >= 4000000 and job_code = 'J2';
-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select emp_name, dept_code, hire_date
from employee
where (dept_code = 'D9') or (dept_code = 'D5') and hire_date < '2002-01-01';
-- 11. EMPLOYEE테이블에 고용일이 1990-01-01 ~ 2001-01-01인 사원의 전체 내용을 조회
select *
from employee
where hire_date between '1990-01-01' and '2001-01-01';
-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
select emp_name
from employee
where emp_name like '%연';
-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
select emp_name, phone
from employee
where phone not like '010%';
-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--고용일이 1990-01-01 ~ 2000-12-01이고, 급여가 270만 이상인 사원의 전체를 조회
select *
from employee
where email like '____ㅗ_%' escape 'ㅗ' 
	and dept_code in ('D9','D6') 
	and hire_date between '1990-01-01' and '2000-12-01'
	and salary >= 2700000;