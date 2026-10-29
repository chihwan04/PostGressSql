/*
<join>
두개이상의 테이블에서 데이터를 조회하고자 할 때 사용하는 구문
조회결과는 하나의 결과물(result set)로 나옴

-관계형 데이터베이스는 최소한의 데이터로 가각 테이블에 담고 있어야 함
(중복제거를 위해)
=> 관계형 데이터베이스에서 SQL문을 이용하여 테이블간의 '관계'를 맺는 방법

				[join 용어 정리]
	1.내부조인(INNER JOIN) => JOIN ON / JOIN USING
	  자연조인(NATURAL JOIN)=> 동일한 컬럼을 자동 조인
	2.외부조인(OUTER JOIN)
	  -왼쪽 외부 조인(LEFT OUTER JOIN/LEFT JOIN)
	  -오른쪽 외부 조인(RIGHT OUTER JOIN/RIGHT JOIN)
	3.비등가 조인(NON-EQUAL JOIN) => JOIN ON (동등 '=' 비교가 아닌 조인)
	4.자체 조인(SELF JOIN)		  => JOIN ON (같은 테이블끼리 조인)
	5.교차 조인(CROSS JOIN)		  => 모든 경우의 수 / 카테시안 곱
**/

--전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회하고자 한다
select EMP_ID, EMP_NAME, DEPT_CODE
from EMPLOYEE;

select DEPT_ID, DEPT_TITLE
from department;

--=================================
/*
 1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
 	연결시키는 컬럼의 값이 "일치하는 행들만" 조인이 되어 조회
 */
------------------------------------------
--1) 연결할 두 컬럼명이 다른 경우()
--	=>오직 join on 구문만 사용가능
--	EMPLOYEE : DEPT_CODE / DEPARTMENT : DEPT_ID
select EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
from EMPLOYEE, department;
--DEPARTMENT 행당 23명씩 TOTAL 207행이 나옴
select EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
from employee
join departmenT on (DEPT_CODE = DEPT_ID);

--2) 연결할 두 컬럼명이 같은 경우()
--	=>JOIN ON 또는 JOIN USING 구문 사용 가능
--EMPLOYEE : JOB_CODE / JOB : JOB_CODE
select EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
from EMPLOYEE 
join JOB  On (EMPLOYEE.JOB_CODE =JOB.JOB_CODE);

--4) 조인과 함께 조건 제시
--직급이 대리인 사원의 사번, 이름, 직급명, 급여를 조회
--JOIN ON 사용
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE E
join JOB J on (E.JOB_CODE = J.JOB_CODE)
where JOB_NAME = '대리';

--JOIN USING 사용
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE E
join JOB USING(JOB_CODE)
where JOB_NAME = '대리';


--1. 부서가 인사관리부인 사원들의 사번, 사원명, 부서명, 보너스 조회
select DEPT_ID, EMP_NAME, D.DEPT_TITLE, BONUS
from EMPLOYEE E
join department d  on (E.DEPT_CODE = D.DEPT_ID)
where DEPT_TITLE = '인사관리부';
--2. 부서코드, 부서명, 지역코드, 지역명 조회
select DEPT_ID, LOCAL_CODE, local_NAME
from location L
join department D on (L.LOCAL_CODE = D.LOCATION_ID);
--3. 보너스를 받은 사원들의 사번, 사원명, 보너스, 부서명 조회
select EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
from employee E
join department D on (E.DEPT_CODE = D.DEPT_ID)
where BONUS is not null;
--4. 부서가 총무무가 아닌 사원들의 사원명, 급여, 부서명 조회
select EMP_NAME, SALARY, DEPT_TITLE
from employee E
join department D on (E.DEPT_CODE = D.DEPT_ID)
where DEPT_TITLE != '총무부'
order by DEPT_TITLE;

--==========================================================
/*
 2. 외부 조인 / 포괄 조인
 두 페이블간의 JOIN 시 일치하지 않는 행도 포함시켜 조회
 단, 어느 테이블을 기중으로 할지 LEFT/RIGHT/FULL 중에서 결정
 */

--사원명, 부서명, 급여, 연봉
select EMP_NAME,DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12
from employee
join department on (DEPT_CODE = DEPT_ID);
--부서배치 안되어잇는 사원 정보는 안나옴
--사원이 없는 부서도 안나옴

--1) LEFT [OUTER] JOIN
select EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12
from EMPLOYEE
left join department on (DEPT_CODE = DEPT_ID);

--2) RIGHT [OUTER] JOIN
select EMP_NAME, DEPT_CODE,DEPT_ID, DEPT_TITLE, SALARY, SALARY*12
from EMPLOYEE
RIGHT join department on (DEPT_CODE = DEPT_ID);

--2) FULL [OUTER] JOIN
select EMP_NAME, DEPT_CODE,DEPT_ID, DEPT_TITLE, SALARY, SALARY*12
from EMPLOYEE
FULL join department on (DEPT_CODE = DEPT_ID);

--=============================
/*
 3. 비등가 조인
 	매칭시킬 컬럼의 조건 작성시 '='을 사용하지않는 JOIN문
	=> JOIN ON으로만 가능
 **/
--SAL_GRADE 테이블 조인(SAL_LEVEL컬럼)
select EMP_NAME, SALARY
from EMPLOYEE;

--사원명, 급여, 급여레벨 조회
select EMP_NAME, SALARY, SAL_LEVEL
from employee
join SAL_GRADE on (SALARY >= MIN_SAL and SALARY <= MAX_SAL);

select EMP_NAME, SALARY, SAL_LEVEL
from employee
join SAL_GRADE on (SALARY between MIN_SAL and MAX_SAL);

--===================================
/*
 4.자체 조인
 	같은 테이블을 다시 조회
 */

--사수가 있는 사원만 조회
select EMP_ID, EMP_NAME, MANGER_ID;

--================
/*
 <
 
 */
select EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join JOB USING (JOB_CODE);

--사번, 사원명, 부서명, 지역명 조회
/*
 EMPLOYEE
 */

select EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
from employee
join department on (DEPT_CODE = DEPT_ID);

--전사원
select EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
from employee 
left join department on (DEPT_CODE = DEPT_ID)
left join location on (LOCATION_ID = LOCAL_CODE);

-----------실습문제-------------
--1. 사번, 사원명, 부서명, 지역명, 국가명 조회
--EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL
select EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, national_name 
from employee 
left join department on (DEPT_CODE = DEPT_ID)
left join location L on (LOCATION_ID = LOCAL_CODE)
left join national N on (N.NATIONAL_CODE = L.NATIONAL_CODE);
--2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조히ㅗ
select EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, national_name , SAL_LEVEL
from employee E
left join department on (DEPT_CODE = DEPT_ID)
left join location L on (LOCATION_ID = LOCAL_CODE)
left join national N on (N.NATIONAL_CODE = L.NATIONAL_CODE)
left JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
--모든테이블






































































