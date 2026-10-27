/*
여러줄 주석 
컨트롤 + 쉬프트 + /
*/
--한줄주석

/*
DML(Data Manipulation Language): 데이터 조작 언어
	:테이블에 값을 검색(select), 삽입(insert), 수정(update), 삭제(delete)하는 구문	
*/
--===============================================================================================================
/*
(')홀따옴표 : 문자열을 감싸주는 기호
(")쌍따옴표 : 컬럼명 등을 감싸주는 기호
*/

/*
 <select>
 데이터 조회할 때 사용
 
 >>Result set : 행들의 집합
 
 
 [표현법]
 SELECT 조회하고자하는 컬럼, 컬럼, .....
 FROM 테이블명;
 */

--EMPLOYEE테이블에 있는 모든 컬럼 (*)조회
select *
from EMPLOYEE;

--EMPLOYEE테이블에서 사번, 이름, 급여 조회
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE;

--JOB테이블의 모든 컬럼 조회
select *
from JOB;

----------------실습문제-----------------------
--1. JOB테이블에서 직급명만 조회
select job_name
from JOB;

--2. DEPARTMENT테이블에서 모든 컬럼 조회
select *
from DEPARTMENT;

--3. DEPARTMENT테이블에서 테이블의 부서코드, 부서명 조회
select dept_id, dept_title
from DEPARTMENT;

--4. EMPLOYEE테이블에서 사번, 사원명, 이메일, 전화번호, 입사일, 급여 조회
select emp_id, emp_name, email, phone, hire_date, salary
from EMPLOYEE;

/*
 <컬럼값을 통한 산술연산>
 SELECT절 컬럼명 작성부분에 산수연산 쓸수 있다
 * 
 */
--EMPLOYEE테이블에서 사원병, 연봉조회
select EMP_NAME, SALARY*12
from EMPLOYEE;

--EMPLOYEE에서 사원명, 보너스, 급여조회
select EMP_NAME, BONUS, salary
from EMPLOYEE;

--EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스가 포함된연봉조회
select EMP_NAME, SALARY, BONUS, SALARY*12, (BONUS*SALARY + SALARY)*12
from EMPLOYEE;

--EMPLOYEE에서 사원명, 입사일, 근무일수
--DATE형식끼리 연산 가능 :+, -
--오늘 날짜 CURRENT_DATE
select EMP_NAME, HIRE_DATE, CURRENT_DATE
from EMPLOYEE;

--=====================================
/*
 <컬럼명에 별칭 지정하기>
 산술연산시 컬럼명이 ?COLUMN?으로 나옴, 이때 별칭을 부여하여 처리
 
 [표현법]
 컬럼명 별칭 / 컬럼명 as 별칭 /  컬럼명 "별칭" / 컬럼명 as "별칭"
 
 --반드시 별칭에 쌍따옴표("")가 들어가야 할 때
 	->별칭에 띄어쓰기ㅏ가 들어있던지, 특수문자가 포함되어 있는경우
 */


select EMP_NAME, 
	SALARY, BONUS, SALARY*12 "연봉(원)" , (BONUS*SALARY + SALARY)*12 "총 소득"
from EMPLOYEE;

select 
EMP_NAME, SALARY, BONUS, SALARY*12 연봉 , (BONUS*SALARY + SALARY)*12 총소득
from 
EMPLOYEE;

------------------------------------------------------
/*
  <리터럴>
  임의로 지정한 문자열(')
  
  select절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터처럼 조회가능
  조회된 result set의 모든 행에 반복적으로 같이 출력
 */

--employee에 사번, 사원명, 급여 조회
select emp_id, emp_name, salary, '원'as 단위
from EMPLOYEE;

----------------------------------------------------------
/*
 <연결 연산자 : ||>
 여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
 *숫자를 그냥 결합하면 타입에러
  숫자형을 문자로 명시적 변환(::text)
*/

--employee에서 사번 이름 급여를 하나의 컬럼으로 조회
select emp_id || emp_name || salary as id_name
from employee;

--컬럼값과 리터럴을 연결
select emp_name || '의 월급은' || salary || '원 입니다' as enp_salary
from employee;
---------------------------------------------------------------------
/*
 	<DISTINCT>
 	컬럼에 중복된 값들을 한번씩만 표시하고자 할 때
 	
 * 
 */
--employee에서 직급코드 조회
select job_code from employee;

--위에서 중복 제거
select distinct job_code from employee;

--부서코드도 중복제거
select distinct dept_code from employee;

--distinct는 select절에 딱 한번만 기술할 수 있음
--dept_code, job_code가 쌍으로 되어있는 값의 중복제거
select distinct dept_code, job_code from employee;

------------------------------------------------------------------------------------
/*
 <WHERE 절>
 조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
 where절에 조건식을 씀
 조건식에는 다양한 연산자 사용 가능
 
 [표현법]
 select 컬럼, 컬럼, ....
 from 테이블명
 where 조건식;
 
 *비교연산자
 >, <, <=, >=    ->> 대소 비교
 =   (여기서는 한번만 씀) >>같은지 비교
 !=, <>          >> 같지 않은지 비교
*/
--컬럼명이나 테이블명이 아니라 그 안에 있는데 데이터는 무조건 대소문자 구분해야함
--employee에서 부서코드가 'D9'인 사원의 모든 컬럼 조회 
select * 
from employee
where dept_code = 'D9';

--EMPLOYEE에서 부서코드가 'D1'인 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from employee
where dept_code = 'D1';

--empoyee 에서 부커코드가 'D1이 아닌사람'
select EMP_NAME, SALARY, DEPT_CODE
from employee
where dept_code != 'D1';

--employee에서 급여가 400만원 이상인 사원명, 급여, 입사일
select EMP_NAME, SALARY, hire_date
from employee
where salary >= 4000000;

--employee에서 재직중인 사원들의 사번, 사원명, 입사일 퇴적여부 조회
select emp_id, emp_name, hire_date, ent_yn as 퇴직여부
from employee
where ent_yn = 'N';

----------------------------실습문제------------------------------------------
--1. 급여가 300만원 이상인 사람들의 사원명, 급여, 입사일, 연봉조회
select EMP_NAME, SALARY, hire_date , salary*12 as 연봉
from employee
where salary >= 3000000;
--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
select EMP_NAME, SALARY, salary*12 as 연봉, emp_id 
from employee
where salary >= 4166667;
--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
select EMP_NAME, SALARY, DEPT_CODE, ent_yn as 퇴직여부
from employee
where dept_code != 'j3' and ent_yn = 'N';

-----------------------------------------------------------------------------------
/*
 <논리 연산자>
 여러개의 조건을 제시하고자 할 때
 
 AND (~이면서 , 그리고)
 OR(~이거나, 또는)
 
 * 
 */

--부서코드가 d9이면서 급여가 500만원이상인 놈
select emp_name, dept_code, salary
from employee
where dept_code = 'D9' and salary >= 5000000;

--부서코드가 'D6'이거나 급여가 300만원 이상인 놈
select emp_name, dept_code, salary
from employee
where dept_code = 'D6' or salary >= 3000000;

--급여가 350만원 이상, 600만원 이하인 놈
select emp_name, dept_code, salary
from employee
where salary >= 3500000 and salary <= 6000000;

---------------------------------------------------------------
/*
<BETWEEN AND>
조건식에서 사요되는 구문으로
~이상 ~이하인 범위에 대한 조건을 제시할 때 사용되는 연산자

[표현법]
비교대상컬럼 BETWEEN 하한값 AND 상한값
*/
--급여가 350만원 이상, 600만원 이하인 놈
select emp_name, dept_code, salary
from employee
where salary between 3500000 and 6000000;

--급여가 350만원 이상, 600만원 이하가 아닌놈
select emp_name, dept_code, salary
from employee
where not salary between 3500000 and 6000000;

--입사일이 '1990-01-01 ~ 2004-12-31'
select *
from employee
where hire_date between '1990-01-01' and '2004-12-31'

------------------------------------------------------------------
/*
 <LIKE>
 비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우 조회
 
 	[표현법]
 	비교대상컬럼 LIKE '특정패턴'
 	: '특정패턴'에는 와일드카드 (%, _ ) 로 쓸수 있음
 	
 	* % : 0글자 이상
 		ex) 비교대상컬럼 LIKE '문자%' => 비교대상의 컬럼값이 '문자'로 시작되는 것 조회
 			비교대상컬럼 LIKE '%문자' =>비교대상의 컬럼값이 '문자'로 끝나는것 조회
 			비교대상컬럼 LIKE '%문자%' =>비교대상의 컬럼값이 '문자'가 포함되어 있는 것 조회
 			
 	* _ : 1글자
		ex) 비교대상컬럼 LIKE '_문자'=> 비교대상의 컬럼값이 '문자'앞에 무조건 한글자만 있을때
			비교대상컬럼 LIKE '__문자'=> 비교대상의 컬럼값이 '문자'앞에 무조건 두글자만 있을때
			비교대상컬럼 LIKE '_문자_'=> 비교대상의 컬럼값이 '문자'앞과 뒤에 무조건 한글자만 있을때
*/ 
select emp_name, salary, hire_date
from employee
where emp_name like '전%';

--사원들 이름중에 '하'가 포함되어잇는놈
select emp_name, salary, phone
from employee
where emp_name like '%하%';

--사원들중이름의 가운데에 '하' 포함
select emp_Id,emp_name
from employee
where emp_name like '_하_';

--사원의 전화번호의 3번째 자리가 1인 사원의 사번, 사원명, 전화번호 , 이메일
select emp_id, emp_name, phone, email
from employee
where phone like '__1%';

--이메일 중 _(언더바)앞에 글자가 3글자인 사원
select emp_id, emp_name, email
from employee
where email like '___ㅗ_%' escape 'ㅗ';
	--어떤게 와일드 카드인지 몰라서 조회가 안됌
	--구분을 시켜줘야한다 뭐가 데이터인지 뭐가 와일드카드인지
	-->>데이터 값으로 취급하고자 하는 값 앞에 나만의 와일드 카드(아무거나, 숫자, 문자, 특문)

select emp_id, emp_name, email
from employee
where not email like '___ㅗ_%' escape 'ㅗ';

------------------------------실습문제-------------------------------
--1 employee에서 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 입사이 ㄹㅈ회
select emp_id, emp_name, hire_date
from employee
where emp_name like '%연';
--2 employee에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
select emp_name, phone
from employee
where not phone like '010%';
--3 employee에서 이름이 '하'가 포함되어 있고 급여가 240만원이상인 사원의 사번 사원명 월급 조회
select emp_id, emp_name, salary
from employee
where emp_name like '%하%' and salary >= 2400000;
--4 department 에서 해외 영업부가 아닌 부서들의 부서코드 부서명조회
select dept_id, dept_title
from department
where dept_title like '해외영업%';

-----------------------------------------------------------------
/*
 <IS NULL / IS NOT NULL>
 컬럼값에 NULL이 있을 경우 NULL값 비교에 이용하는 연산자
 */
-- EMPLOYEE에서 보너스를 받지 않는 사번 이름 급여 보너스
select EMP_ID, EMP_NAME, SALARY, BONUS
from employee
where BONUS isnull;

-- EMPLOYEE에서 보너스를 받는 사번 이름 급여 보너스
select EMP_ID, EMP_NAME, SALARY, BONUS
from employee
where BONUS is not null;

-- EMPLOYEE에서 사수가 없는 사원의 사원명 부서코드
select EMP_ID, dept_code, manager_id 
from employee
where manager_id is null;

--employee에서 부서배치를 받지 않앗지만 보너스를 바든 이름 보너스 부서코드,
select emp_name, bonus, dept_code
from employee
where bonus is not null and dept_code is null;

--------------------------------------------------------------------
/*
 <IN / NOT IN>
 IN : 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는것만 조회
 NOT IN : 컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지 조회

	[표현법]
	비교대상컬럼  IN ('값1','값2','값3',......)
	  
 */
--EMPLOYEE에서 부서코드 D6이거나 D8이거나 D5인 이름 부서코드 급여
select emp_name, dept_code, salary
from employee 
where dept_code in ('D6','D8','D5');

--반대
select emp_name, dept_code, salary
from employee 
where dept_code not in ('D6','D8','D5');
---------------------------------------------------------------------
/*
 <연산자 우선순위>
 1. ()
 2. 산술 연산자
 3. 연결 연산자
 4. 비교 연산자
 5. is null/ like '패턴'/ in
 6. between and
 7. not(논리연산자)
 8. and(논리연산자)
 9. or(논리연산자)
 */

--직급코드가 J7이거나 J2인 사원들 중 급여가 200만워 ㄴ이상안 모든 칼르\ㅓㅁ조회
select *
from employee
where (job_code = 'J7' or job_code = 'J2') and salary >=2000000;

-------------------------- 실습문제------------------------
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
select emp_name, manager_id, dept_code
from employee
where manager_id is null and  dept_code is null;
-- 2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 
--		사번, 사원명, 연봉, 보너스 조회
select emp_id, emp_name, salary*12 , bonus
from employee
where salary*12 >= 30000000 and bonus is null;
-- 3. 입사일이 1995-01-01 이상이고 부서배치를 받은 사원들의 
--		사번, 사원명, 입사일, 부서코드 조회
select emp_id, emp_name, hire_date, dept_code
from employee
where hire_date >= '1995-01-01';
-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 2001-01-01 이상이고 
--		보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
select emp_id, emp_name, salary, hire_date, bonus
from employee
where (salary between 2000000 and 5000000) and hire_date >= '1995-01-01' and bonus is null;
-- 5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 
--		사번, 사원명, 급여, 보너스포함연봉 조회 (별칭부여)
select emp_id, emp_name, salary, (BONUS*SALARY + SALARY)*12 as 보너스포함연봉
from employee
where (BONUS*SALARY + SALARY)*12 is not null and emp_name like '%하%';

----------------------------------------------------------------------------------------------
/*
 <order by 절>
 SELECT문 가장 마지막줄에 작성함, 실행순섣 매난에실행
 
 [표현법]
 SELECT 조회할 칼럼, 칼럼 .....
 FROM  테이블명
 WHERE 조건식
 ORDER BY 정렬 기준의 컬럼명 | 별칭 |컬럼순서 [ASC | DESC] [NULLS FIRST ] 
 -ASC : 오름차순 ㅈ정렬(생략시 기본값)
 -DESC : 내림차순 정렬
 
 -NULLS  FIRST  : NULL 데이터를 맨 앞에 배치( 생략시 DESC 기본값)
 -NULLS LAST :  NULL데이터를 맨 끝에에 배치(생략시 ASC 기본값)
 */

select *
from EMPLOYEE
--order by BONUS;
--order by BONUS asc;
--order by BONUS nullS FIRST;
--order by BONUS desc;
--order by BONUS desc, SALARY; --기준 정렬 여러개 사용가능
--order by BONUS ASC, SALARY;

--전사원의 사원명 연봉조회(내림차순 연봉)
select EMP_NAME, SALARY*12 as 연봉
from EMPLOYEE
--order by SALARY*12 desc;
--order by SALARY*12 desc;
order by 2 desc;























