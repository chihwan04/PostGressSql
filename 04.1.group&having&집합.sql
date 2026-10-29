/*
<GROUP BY절>
그룹기준을 제시할 수 있는 구문(그룹기준별로 여러 그룹으로 묶을수잇음)
여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/

select SUM(SALARY)
from EMPLOYEE;

--각 부서별 총 급여 합
select DEPT_CODE, SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE;

--각 부서별 사원수
select DEPT_CODE, COUNT(*)
from EMPLOYEE
group by DEPT_CODE;

--각 부서별 급여의 합과 사원수
select DEPT_CODE, SUM(SALARY), COUNT(*)
from EMPLOYEE
order by DEPT_CODE;

--직급별 인원수와 급여의 합
select JOB_CODE, COUNT(*), SUM(SALARY)
from employee
group by JOB_CODE;

--각 직급별 총사원수, 보너스를 받는 사원수, 급여합, 급여평균, 최저급여, 최고습여
select JOB_CODE
	,COUNT(*)
	,SUM(SALARY)as 급여합
	,COUNT(BONUS) as "보너스를 받는 사원수"
	,ROUND(AVG(SALARY), -1) as 급여평균
	,MIN(SALARY) AS 최저급여
	,MAX(SALARY) as 최고급여
from EMPLOYEE
group by JOB_CODE
order by 1;

--남성, 여성별 사원수
select case when (SUBSTR(EMP_NO, 8, 1) in ('2', '4')) THEN '여'
			  when (SUBSTR(EMP_NO, 8, 1) in ('1', '3')) THEN '남'
			  end as "성별 사원수"
			  ,COUNT(*)
from EMPLOYEE
group by case when (SUBSTR(EMP_NO, 8, 1) in ('2', '4')) then '여'
			  when (SUBSTR(EMP_NO, 8, 1) in ('1', '3')) then '남'
		end;

select case when (SUBSTR(EMP_NO, 8, 1) in ('2', '4')) THEN '여'
			  when (SUBSTR(EMP_NO, 8, 1) in ('1', '3')) THEN '남'
			  end as "성별"
			  ,COUNT(*) as 사원수
from employee
group by 성별;

SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE, JOB_CODE;

--입사년도별 급여의 합계
--select case when (SUBSTR(HIRE_DATE, 1, 4) in ('2001')) THEN '2001'
--			when (SUBSTR(HIRE_DATE, 1, 4) in ('2002')) THEN '2002'
--			when (SUBSTR(HIRE_DATE, 1, 4) in ('2003')) THEN '2003'
--			when (SUBSTR(HIRE_DATE, 1, 4) in ('2004')) THEN '2004'
--			when (SUBSTR(HIRE_DATE, 1, 4) in ('2005')) THEN '2005'
--			when (SUBSTR(HIRE_DATE, 1, 4) in ('2006')) THEN '2006'
--			when (SUBSTR(HIRE_DATE, 1, 4) in ('2007')) THEN '2007'
--		end as "입사년도"
--from EMPLOYEE
--group by 입사년도; 븅신임?

select EXTRACT(year from HIRE_DATE)as 입사년도
		,SUM(SALARY)as 급여합계
from employee
group by 입사년도
order by 1;

select TO_CHAR(HIRE_DATE,'YYYY')as 입사년도
		,SUM(SALARY)as 급여합계
from employee
group by 입사년도
order by 1;

--------------------------------------------------------------------------
/*
 <HAVING 절>
 그룹에 대한 조건을 제시할 때 내용
 */
--각 부서별 급여 평균 조회
select DEPT_CODE, AVG(SALARY)
from employee
group by DEPT_CODE;

--각 부서별 평균급여가 평균 300만원 이상인 부서들만
--select DEPT_CODE, AVG(SALARY)
--from EMPLOYEE
--where AVG(SALARY)>=3000000  --그룹에 대한 조건은 WHERE절 안됌
--group by DEPT_CODE;

select DEPT_CODE, ROUND(AVG(SALARY))
from employee
group by dept_code
having AVG(SALARY) >= 3000000;

/*
 *실행순서
 FROM
 WHERE
 GROUP BY(SELECT에서 별칭을 사용할 수 있도록 예외로 둠)
 HAVING
 SELECT
 DISTINCT
 ORDER BY
 * 
 */

---------------------실습문제-------------------------------
--1. 직급별 급여합(조건 : 직급별 급여의 합이 1000만원 이상인 직급만 조회), 직급코드,급여합 조회

--2. 부서별 보너스를 받는 사원이 없는 부서코드 조회

----------------------------------------------
/*
 <집계함수>
 그룹별 산출된 결과값에 중간집계를 계산해주는 함수
 
 ROLLUP, CUBE
 => GROUP BY 절에 기술하는 함수
 
 =ROLLUP(컬럼1, 컬럼2): 컬럼1을 가지고 중간집계를 내는 함수
 -CUBE(컬럼1, 컬럼2): 컬럼1을 가지고 중간집계내고, 컬럼2를 가지고도 중간집계를 냄
 */

--각 직급별 급여합
select JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by JOB_CODE;

select JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by rollup(JOB_CODE);
--그룹기준이 하나의 컬럼일 때는 ROLLUP, CUBE 차이가 없음

select DEPT_CODE, JOB_CODE, SUM(SALARY)
from employee
group by DEPT_CODE, JOB_CODE;

--ROLLUP(컬럼1, 컬럼2) : 컬럼1만 중간집계
select DEPT_CODE, JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by rollup(DEPT_CODE, JOB_CODE)
order by DEPT_CODE, JOB_CODE nulls last;

--CUBE(컬럼1, 컬럼2) : 컬럼1 중간집계, 컬럼2 중간집계
select DEPT_CODE, JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by CUBE(DEPT_CODE, JOB_CODE)
order by DEPT_CODE, JOB_CODE nulls last;

--------------------------------------------------------------------
/*
 <집합 연산자>
 여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 여산자
 -UNION : 합집합
 -INTERSECT : 교집합
 -UNION ALL : 합집합 + 교집합
 -EXCEPT : 차집합
 */
--1. UNION
--부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원의 사번, 사원명, 부서코드, 급여조회
--부서코드가 D5인 사원
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'; --6명
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY >= 3000000; --8명

select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
union
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY >= 3000000; --12

select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5' or SALARY >= 3000000; --12

--------------------------------2. INTERSECT
--D5이면서 급여가 300만원초과
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
INTERSECT
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY >= 3000000;

--AND로도 가능
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5' and  SALARY >= 3000000;

--집합연산자 사용시 유의사항
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
intersect
select EMP_ID, EMP_NAME, DEPT_CODE
from EMPLOYEE
where SALARY >= 3000000;
--각 쿼리문에 셀렉트절에 작성되는 컬럼의 개수가 같아야함

select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
intersect
select EMP_ID, EMP_NAME, DEPT_CODE, BONUS
from EMPLOYEE
where SALARY >= 3000000;
--컬럼의 갯수뿐만 아니라 동일한 타입이어야 한다
--타입과 갯수가 동일해도 같은 컬럼이 아니면 오류나지 않지만 결과SET이 안나옴


----------------------3. UNION ALL
--D5이면서 급여가 300만원 초과인 사람들
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
union ALL
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY >= 3000000
order by 1;

------------------------4.EXCEPT
--D5이면서 급여가 300만원 이하인 사람들
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
EXCEPT
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY >= 3000000
order by 1;

select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5' and SALARY <= 3000000;















































