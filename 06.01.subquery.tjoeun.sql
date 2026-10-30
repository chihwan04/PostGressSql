/*
<SUBQUERY>
- 하나의 SQL문안에 포함된 또 다른 SELECT문
- 메인 SQL문을 위해 보조 역할을 하는 쿼리문
*/

--박서준과 같은 부서에 속한 사원들 조회
--1. 박서준의 부서코드 조회
select DEPT_CODE
from employee
where EMP_NAME = '박서준'; -- D9

--2. 붘서코드가 D9 인 사우너조회
select EMP_NAME
from employee
where DEPT_CODE = 'D9'; -- D9

select EMP_NAME
from employee
where DEPT_CODE = (select DEPT_CODE
					from employee
					where EMP_NAME = '박서준');

--전 직원의 평균급여보다 더 많은 급여를 받는 사원들의 사번, 사원명, 급여 조회
--1. 평균 급여
select avg(salary)
from employee; --3047662

--2. 급여가 3047662보다많은 사람
select emp_id, emp_name, salary
from employee
where salary > 3047662;

select emp_id, emp_name, salary
from employee
where salary > (select avg(salary)
				from employee);

----------------------------------------------------
/*
 서브쿼리의 구분
 	: 서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라구분
 	
 	-단일행 서브쿼리 : 서브쿼리의 결과값이 오로지 1개일때(한행 한열)
 	-다중행 서브쿼리 : 서브쿼리의 결과값이 여려행 일때(여러행 한열)
 	-다중열 서브쿼리 : 서브쿼리의 결과값이 여러열 일때(한행 여러행)
 	-다중행 다중열 서브쿼리 : 서브쿼리의 결과값이 여러행 일 때(여러행 여러열)
 	
 	>> 서브쿼리의 종류에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
 */

/*
 1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
 	: 서브쿼리의 결과값이 오로지 1개일때
 	일반 비교연산자 사용가능
 	=, !=, <=, >=, ......
 */
--1)전 직원의 평균급여보다 급여를 적게 받는 사원ㄷ들의사원명 직급ㅋ드 , 급여
select EMP_NAME, EMP_ID, SALARY
from EMPLOYEE
where SALARY < (select AVG(salary)
				from EMPLOYEE)
order by SALARY;

--2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
select EMP_ID, EMP_NAME, SALARY, HIRE_DATE
from EMPLOYEE
where SALARY = (select MIN(SALARY)
				from EMPLOYEE);

--3) 조정연 사원의 급여보다 더 많이 받는 사번 이름 
select EMP_ID, EMP_NAME, salary 
from EMPLOYEE
where SALARY > (select salary
				from EMPLOYEE
				where EMP_NAME = '조정연');

--JOIN
--4) 조정연 사원의 급여보다 더 많이 받는 사번, 사원명, 부서명, 급여
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
from EMPLOYEE
join department on (DEPT_CODE = DEPT_ID)
where SALARY > (select salary
				from EMPLOYEE
				where EMP_NAME = '조정연');

--5)왕건우 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회
select EMP_ID, EMP_NAME,PHONE, HIRE_DATE, DEPT_TITLE
from EMPLOYEE
join department on (DEPT_CODE = DEPT_ID)
where DEPT_CODE = (select DEPT_CODE
					from EMPLOYEE
					where EMP_NAME = '왕건우')
	and EMP_NAME != '왕건우';

--GROUP BY
--6) 부서별 급여 합계가 가장 큰 부서의 부서코드, 급여합 조회
--6.1부서별 급여합 중에서 가장 큰값 하나만 조회
/*
select MAX(SUM(SALARY))
from employee
group by DEPT_CODE;
*/ --안됌이건

select SUM(SALARY)
from EMPLOYEE
group by dept_code 
order by SUM(SALARY) desc
limit 1;

select MAX(총급여)
from (select DEPT_CODE, SUM(SALARY) as 총급여
		from EMPLOYEE
		group by DEPT_CODE);

--6.2
select DEPT_CODE, SUM(SALARY)
from EMPLOYEE
group by dept_code
having SUM(SALARY)= 17700000;

select DEPT_CODE, SUM(SALARY)
from EMPLOYEE
group by dept_code
having SUM(SALARY)= (select SUM(SALARY)
						from EMPLOYEE
						group by dept_code 
						order by SUM(SALARY) desc
						limit 1);


--------------------------
/*
 2. 다중행 서브쿼리
 	: 서브ㅜ커리의 결과값이 여러행 일 때(여러행 한열)
 	
 		IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
 		>ANY 서브쿼리 : 여러개의 겨로가값 중에서 "한개라도" 클 경우
 				(여러개의 결과값 중에서 작은값 보다 작을 경우
 		<ANY 서브쿼리 : 여러개의 겨로가값 중에서 "한개라도" 작을 경우
 				(여러개의 결과값 중에서 큰값 보다 작을 경우

 *	비교대상 > ANY (ARRAY[값1, 값2, 값3 ...])
 *	비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
 *  */

--1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
--1.1 조정연 또는 전지연 사원의 직급
select JOB_CODE
from employee
where EMP_NAME in ('조정연','전지연');

--1.2 J3, J7인 사원들 조회
select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where JOB_CODE in ('J3', 'J7')

select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where JOB_CODE in (select JOB_CODE
			from employee
			where EMP_NAME in ('조정연','전지연'));

--2) 대리 직급임에도 불구하고 과장 직급 급여들 중 최소급여보다 많이 받는
--직원의 사번 사원명 직급 급여 조회
select EMP_ID, SALARY
from employee
join JOB using(JOB_CODE)
where JOB_NAME = '과장'; 2,200,000 ~ 3,760,000

--2.2 대리이면서 급여값이 위에 값보다 큰 값을 받는 대리
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from employee
join JOB using(JOB_CODE)
where JOB_NAME = '대리' 
	and SALARY > ANY(array[2200000,2500000,3760000]);
--위의 쿼리를 하나로

select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from employee
join JOB using(JOB_CODE)
where JOB_NAME = '대리' 
	and SALARY > ANY(select SALARY
				from employee
				join JOB using(JOB_CODE)
				where JOB_NAME = '과장');

select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from employee
join JOB using(JOB_CODE)
where JOB_NAME = '대리' 
	and SALARY > (select MIN(SALARY)
				from employee
				join JOB using(JOB_CODE)
				where JOB_NAME = '과장');
-->단일행 쿼리로로도 가능

--3) 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급, 급여 조회
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from employee
join JOB using(JOB_CODE)
where JOB_NAME = '차장' 
	and SALARY < ANY(select SALARY
				from employee
				join JOB using(JOB_CODE)
				where JOB_NAME = '과장');

--4) 과장 직급임에도 차장 직급인 사원들의
--	모든 급여보다 더 많이 바든ㄴ 사원의 사번, 사원명, 직급명, 급여 조회
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
JOIN JOB using(JOB_CODE)
where JOB_NAME='과장'
	and SALARY > ANY(select SALARY
				from EMPLOYEE
				join JOB using(JOB_CODE)
				where JOB_NAME = '차장');
					
--차장중에 제일 많이 받는 사람보다 더 많이 받는 과장
-- > ANY : 비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
	-- 가장 작은값보다 큰값은 모두
--ALL : 비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
	--- 가장 큰 값보다 큰값을 모두
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
JOIN JOB using(JOB_CODE)
where JOB_NAME='과장'
	and SALARY > ALL(select SALARY
				from EMPLOYEE
				join JOB using(JOB_CODE)
				where JOB_NAME = '차장');
					
----------------------------------------------
/*
 3. 다중열 서브쿼리
 	:한행 여러열
 */
--1 장예은과 같은 부서코드, 같은 직급코드에 해당하는 직원들의
--	사원명, 부서코드, 직급코드, 입사일 조회
select EMP_NAME, DEPT_CODE, JOB_CDOE, HIRE_DATE
from EMPLOYEE
where DEPT_CODE = 장예은의 부서코드,
	and JOB_CODE = 장예은의 직급코드

select EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
from EMPLOYEE
where DEPT_CODE = (select dept_code
				from EMPLOYEE
				where EMP_NAME ='장예은')
	and JOB_CODE = (select JOB_code
				from EMPLOYEE
				where EMP_NAME ='장예은');

select EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
from EMPLOYEE
where (DEPT_CODE, JOB_CODE) = (select  DEPT_CODE, JOB_code
								from EMPLOYEE
								where EMP_NAME ='장예은');

--지민재 사원과 같은 직급코드, 같은 사수를 가지고있는 사원들의
--사번, 사원명, 직급코드, 사수번호 조회
select EMP_NAME, DEPT_CODE, JOB_CODE, manager_id 
from EMPLOYEE
where (JOB_CODE, manager_id ) = (select JOB_code,manager_id 
								from EMPLOYEE
								where EMP_NAME ='지민재');
-----------------------------------------
/*
 4. 다중행 다중열 서브쿼리
 	:여러행 여러열
 */
--1) 각 직급별 최소급여 금액을 받는 사원들의 사번, 사원명, 직급코드, 급여 조회
--	1.1 각 직급별 최소급여 금액과 직급코드 조회
select JOB_CODE, MIN(SALARY)
from employee
group by JOB_CODE
order by 1;

select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from employee 
group by JOB_CODE = 'J2' and SALARY = 8000000
	  or JOB_CODE = 'J2' and SALARY = 3700000;


select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from employee 
where (JOB_CODE, SALARY) = ('J1', 8000000)
	or (JOB_CODE, SALARY) = ('J2', 3700000);

select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from employee 
where (JOB_CODE, SALARY) in (('J1', 8000000), ('J2', 3700000))

select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from employee 
where (JOB_CODE, SALARY) in (select JOB_CODE, MIN(SALARY)
							from EMPLOYEE
							group by JOB_CODE)--JOBCODE별로 가장 작은 값
					order by 3;

--2) 각 부서별 최고 급여를 받는 사원들의 사번, 사원명, 부서코드, 급여조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from employee
where (DEPT_CODE, SALARY) in (select DEPT_CODE, MAX(SALARY)
							from employee
							group by DEPT_CODE)
order by 3;

-------------------------------------------
/*
 5. INLINE VIEW
 	FROM절에 서브쿼리 작성
 	서브쿼리를 수행할 결과를 마치 테이블처럼 사용
 	
 	*PostgreSQL 16 버전 이상은 인라인뷰에 별칭을 안붙여도 알아서 매칭
 	*PostgreSQL 16 버전 미만 이거나 다른 DBMS
 	*			(My SQL등)반드시 인라인뷰에 별칭을 붙여줘야함
 */


--사원들의 사번, 이름, 보너스포함한 연봉(별칭부여), 부서코드 조회
--단, 보너스포함 연봉이 3000만원 이상인 사원들만 조회
select emp_ID, EMP_NAME, SALARY * coalesce(1+BONUS, 1)*12
from employee
where salary * coalesce(1+BONUS, 1) * 12 >= 40000000;

--WHERE절에 별칭을 사용하려면 INLICE VIEW사용
select EMP_NAME, 연봉 --FROM 안에 있는 컬럼만 사용가능
from (select emp_ID, EMP_NAME, SALARY * coalesce(1+BONUS, 1)*12 연봉
		from employee)
where 연봉 >= 40000000;

------------------------------
/*
  6.WITH
  서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의
  이름으로 FROM 절에 기술 가능
  
  WITH  이름(마음대로) AS (서브쿼리)
  최종실행메인쿼리;
  
  WITH  이름(마음대로) AS (서브쿼리),
  		이름(마음대로) AS (서브쿼리)
  최종실행메인쿼리;
 */
with TOPN_SAL1 as (select DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
					from employee
					group by DEPT_CODE
					order by 2 DESC)
select *
from TOPN_SAL1
limit 2;



with TOPN_SAL1 as (select DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
					from employee
					group by DEPT_CODE
					order by 2 DESC)
select * from TOPN_SAL1;

/*
 * SELECT 절에서만 사용가능
 7. 순위 매기는 함수(WINDOW FUNCTION)
 	RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
 	- RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너띄고 순위
 							예) 공동 1위가 2명이면 그 다음 순위는 3위
 	-DENSE_RANK() OVER(정렬기준) : 동일한 순위가 있어도 다음 등수는 무조건 1씩증가
 							예) 공동 1위가 2명이면 그 다음 순위는 2위
 */						
--급여가 높은 순서대로 순위를 매기시오
select EMP_NAME, SALARY, DENSE_rank()over(order by SALARY DESC) 순위
from EMPLOYEE;

--급여가 상위 5위인 사원의 사원명, 급여, 순위 조회
select EMP_NAME, SALARY, RANK() OVER(order by SALARY desc) 순위
from EMPLOYEE
where RANK() over(order by SALARY DESC) <= 5;
--SELECT 절에서만 사용가능

select *
FROM (select EMP_NAME, SALARY, RANK() OVER(order by SALARY desc) 순위
		from employee)
where 순위 <= 5;

--> WITH 사용
with TOPN_SAL as (select EMP_NAME, SALARY, RANK() OVER(order by SALARY desc) 순위
		from employee)
select *
from TOPN_SAL
where 순위 <= 5;

--> TOP-N 분석
/*
  원하는 기능
  ------------------------------
  상위 5개 		LIMIT 5
  상위 3개 		LIMIT 3
  상위 6~10위		LIMIT 5 OFFSET 5 --1위부터 5위까지 갖오지말고 이후부터 갖고와
  결과에 순번 출력 ROW_NUMBER() OVER(정렬기준)
  표준 SQL 상위 5개	FETCH FIRST 5 ROWS ONLY
 **/

select EMP_NAME, SALARY
from employee
order by SALARY desc
limit 5;

--순번까지 출력
select ROW_NUMBER() OVER(order by SALARY DESC) 순위, EMP_NAME, SALARY
from employee
order by SALARY desc
limit 5;

--가장 ㅚ근에 입사한 사원 5명의 사원명, 급여ㅡ 입사일 조회
select ROW_NUMBER() OVER(order by HIRE_DATE) 입사일,
	EMP_NAME, HIRE_DATE
from employee
order by hire_date DESC
limit 5;
--부서별 평균 급여가 높은 상위 3개 부서 조회						
select ROW_NUMBER() over(order by AVG(SALARY)) 순위, DEPT_CODE, AVG(SALARY)
from EMPLOYEE
group by DEPT_CODE
order by 순위 DESC
limit 3;

--급여가 높은 상위 6~8위 조회
select EMP_NAME, SALARY
from employee 
order by SALARY desc
limit 5 OFFSET 5 

--급여가 높은 상위 5행 조회
select EMP_NAME, SALARY
from employee 
order by SALARY desc
limit 6;

--정확히 5위까지 가져오려면 INLINE VIEW 사용
select *
from (select EMP_NAME, SALARY, dense_rank() OVER(order by SALARY DESC)순위
		from EMPLOYEE)
where 순위 <= 5;

--2) 집계(GROUP BY)후 다른 테이블과 조인(JOIN 할때)
--	부서별 평균급여를 구한 뒤에 부서 정보와 조인:
select *
from (select DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
		from EMPLOYEE
		group by DEPT_CODE)
join department on (DEPT_CODE = DEPT_ID);

--3) 급여 구간별 인원수
select 급여구간, COUNT(*)인원수
from(select EMP_NAME,
		case when SALARY >= 5000000 then '고급급여'
				when SALARY >= 3000000 then '중급급여'
				else '초급급여'
			end 급여구간
		from EMPLOYEE)
group by 급여구간;

--4) 사원명, 급여, 부서평균
select EMP_NAME, SALARY, 부서평균

from employee E
join(select DEPT_CODE, ROUND(AVG(SALARY))부서평균
		from employee
		group by DEPT_CODE
		)USING (DEPT_CODE)
where E.SALARY > 부서평균;



 











































