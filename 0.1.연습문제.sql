--insert into Employee_copy Values(300, '더조은',
--'031103-3123456', 'tjoeun@gmail.com', '01012341234',
--'D1', 'J1,'10,000,000','0.5')
UPDATE employee_copy 
SET job_code = 'J7' 
WHERE job_code IS NULL;

ALTER TABLE employee_copy 
ALTER COLUMN job_code SET NOT NULL;

insert into employee_copy(emp_id,emp_name, emp_no,job_code, hire_date)
values(301, '이티어','051111-456654','J5', current_date);

--순서는 틀려도 상관없는데 제시한 컬럼의 순서와는 동일해야함
insert into employee_copy(hire_date,emp_name, job_code,emp_id,emp_no )
values( current_date, '이티어', 'J5', 303, '051111-456654');

insert into employee_copy(emp_id,emp_name, emp_no, hire_date)
values(302, '아윽으','011111-456677', current_date);
--오류 NOT NULL인 JOB_CODE를 안 넣어서

/*
 3)INSERT INTO 테이블명 (서브쿼리);
 	VALUES로 값을 직접 명시하는 대신에 서브쿼리로 조회된 결과값을 모두 INSERT함
 	여러행도 가능
 */
--EMP01 테이블 생성
create table EMP_01(
	EMP_ID VARCHAR(3),
	EMP_NAME VARCHAR(20),
	DEPT_NAME VARCHAR(35)
);

--전체 사원들의 사번, 이름, 부서명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE
	from EMPLOYEE
	join DEPARTMENT on (DEPT_CODE = DEPT_ID);

--EMP_01 테이블에 테이터 삽입
insert into EMP_01
	select EMP_ID, EMP_NAME, DEPT_TITLE
	from EMPLOYEE
	join DEPARTMENT on (DEPT_CODE = DEPT_ID);

----------------------------------------------
/*
 4)WITH절로 두개 이상의 테이블에 한꺼번애 INSERT
 	WITH절 안에서 INSERT, UPDATE, DELETE 같은 데이터 변경 작업도 수행가능
 	이를 CTE(DATA-MODIFYING)라고 부름
 */
--테이트할 테이블 2개 생성
create table EMP_DEPT
as select EMP_ID,EMP_NAME, DEPT_CODE, HIRE_DATE
	from EMPLOYEE
	where 1=0;

create table EMP_MANAGER
as select EMP_ID, EMP_NAME, MANAGER_ID
	from EMPLOYEE
	where 1=0;

--부서코드가 D1인 사원들의 사번 이름 부서코드 입사일 사수사번 조회
select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
from employee
where DEPT_CODE = 'D1';

WITH DATA_INFO as (
	select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
	from employee
	where DEPT_CODE = 'D1'
),
INFO1 as (
	insert into EMP_DEPT(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
	select EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
		from DATA_INFO
)
/* 테이블이 더 있으면 아래와 같이 계속 넣어주면됌
 INFO2 as (
	insert into EMP_ETC(EMP_ID, EMP_NAME, DEPT_CODE)
	select EMP_ID, EMP_NAME, DEPT_CODE
		from DATA_INFO
)
 */
insert into EMP_MANAGER(EMP_ID, EMP_NAME, MANAGER_ID)
select EMP_ID, EMP_NAME, MANAGER_ID from DATA_INFO;


--=================================================
/*
 2.UPDATE
 	테이블에 기록되어 있는 기존 데이터를 수정하는 구문
 	
 	[표현식]
 	UPDATE 테이블명
 	SET 컬럼명 = 바꿀값,
 		컬럼명 = 바꿀값,
 		....
 	[WHERE 조건]; --> 주의 : 생략하면 전체 모든 행의 데이터가 변경됨
 */

--테이블 생성
create table DEPT_COPY
as select * from DEPARTMENT;

-- D9 부서의 부서명을 '전략기획팀'으로 수정
update dept_copy
set DEPT_TITLE = '전락기획팀';

select * from DEPT_COPY;

rollback;

select * from DEPT_COPY;

update dept_copy
set DEPT_TITLE = '전락기획팀'
where DEPT_ID = 'D9';
commit;

select * from DEPT_COPY;

--복사본 테이블 생성
create table EMP_SALARY
as select EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
	from EMPLOYEE;
commit;

--지민재 사원의 급여를 200만원으로 변경
update EMP_SALARY
set SALARY = 2000000
where EMP_NAME = '지민재';

select *
from EMP_SALARY
where EMP_NAME = '지민재';

--이정하 사원의 급여를 700만원으로 변경하고 BONUS를 0.2로 변경
update emp_salary
set SALARY = 7000000,
	BONUS = 0.2
where EMP_NAME = '이정하';

select *
from emp_salary

--전체 사원의 급여를 10% 인상
update EMP_SALARY
set SALARY = SALARY * 1.1;
commit;

--박서준의 보너스로 0.5
update EMP_SALARY
set BONUS = 0.5
where EMP_NAME = '박서준';

---------------------------------------------------------------
--UPDATE시 서브쿼리 사용가능
/*
 - UPDATE시 서브쿼리 사용 가능
 [표현법]
 UPDATE 테이블명
 SET 컬럼명 = (서브쿼리)
 WHERE 조건; 
 */

--정훈 사원의 급여와 보너스를 조정연사원의 급여와 보너스값으로 변경
--단일 컬럼 서브쿼리
update EMP_SALARY
set SALARY = (select SALARY from EMP_SALARY where EMP_NAME = '조정연'),
	BONUS = (select BONUS from EMP_SALARY where EMP_NAME = '조정연')
where EMP_NAME = '정훈';
select * from EMP_SALARY;

--다중열 서브쿼리
update EMP_SALARY
set (SALARY,BONUS) = (select SALARY, BONUS from EMP_SALARY where EMP_NAME = '조정연')
where EMP_NAME = '황승승'

-- 전지연, 선우진, 현준혁, 배윤서, 전재민사원들의 보너스와 급여를 홍지유 사원과 같은 금액으로 변경
update EMP_SALARY
set (SALARY, BONUS) = (select SALARY, BONUS from EMP_SALARY where EMP_NAME = '홍지유')
where EMP_NAME in ('전지연','선우진','현준혁','배윤서','전재민');

select * from EMP_SALARY;

--ASIA 지역에 근무하는 사원들의 보너스를 0.6으로 변경
--ASIA 지역에서 근무하는 사원
select EMP_ID, EMP_NAME
from EMPLOYEE
join department on (DEPT_CODE = DEPT_ID)
join location on (location_ID = LOCAL_CODE)
where LOCAL_NAME like 'ASIA2';

update EMP_SALARY
set BONUS = 0.6
where EMP_ID in (select EMP_ID
			from EMPLOYEE
			join department on (DEPT_CODE = DEPT_ID)
			join location on (location_ID = LOCAL_CODE)
			where LOCAL_NAME like 'ASIA2'
);
commit;

-----------------------------------------------------------
--UPDATE시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨
--사번이 200번인 사원의 이름을 NULL로 변경

--NULL 안됌
update employee
set EMP_NAME = null
where EMP_ID = '200';

--PRIMARY KEY 오류
update employee
set EMP_ID = 200
where EMP_NAME = '이정하';

--외래키 오류
update employee
set DEPT_CODE = 'D0'
where EMP_NAME = '이정하';

--==============================================
/*
 * 3. DELETE
  	테이브르이 데이터를 행단위로 삭제하는 구문
  	
  	[표현식]
  	DELETE FROM 테이블명
  	[WHERE 조건]; --조건을 안 넣으면 테이블 전체 행이 삭제됨
 */
delete from EMPLOYEE_COPY;

delete from EMPLOYEE_COPY
where EMP_ID = '201';

rollback;
select * from employee_copy;

--외래키 때문에 삭제 거부도ㅓㅣㅁ
delete from department
where DEPT_ID = 'D1';

/*
  TRUNCATE : 테이블 전체 행을 삭제할 때 사용하는 구문
  DELETE보다 수행속도가 빠름
  ROLLBACK이 불가
  
  [표현식]
  TRUNCATE TABLE 테이블명;
 */

truncate table EMP_SALARY;
rollback;
select * from EMP_SALARY;



















