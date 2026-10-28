/*
 <함수 FUNCTION>
  전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
  
  -단일행 함수 : N개의 값을 읽어들여 N개의 결과값 반환(매 행마다 함수 실행)
  -그룹 함수 : N개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
  
  >>SELECT절에 단행함수와 그룹함수를 함께 사용할 수 없음
  >>함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
 */
-------------------단일행함수------------------------------------------------


--==============================================================================
--           <문자처리 함수>
/*
 LENGTH / OCTET_LENGTH => INEGER로 반환
 
 LENGTH(컬럼명 | '문자열') : 해당 글자수 반환
 OCTET_LENGTH(컬럼명 | '문자열') : 해당 문자열의 BYTE수 반환
 	-한글 : 1글자당 3BYTE / 영문, 숫자, 공백 : 1글자당 1BYTE
 */    
select LENGTH('데이터베이스'), OCTET_LENGTH('데이터베이스');
select LENGTH('POSTGRESQL'), OCTET_LENGTH('POSTGRESQL');

select EMP_NAME, LENGTH(EMP_NAME), OCTET_LENGTH(EMP_NAME), LENGTH(EMAIL), OCTET_LENGTH(EMAIL)
from employee;

---------------------------------------------------------------------------
/*
 LEFT / RIGHT('문자열', 글자수): 오른쪽 끝에서 부터 지정한 개수만큼 문자열반환
 	>글자수에 음수를 넣으면 맨 앞/뒤의 글자수만큼 제외하고 나머지 전부
 */
select LEFT('databasepostgresql', 4);
select right('databasepostgresql', 3);
select right('서울특별시', 3);

select LEFT('DATABASESQL', -3); --맨 뒤의 글자 3개를 제외하고
select RIGHT('DATABASEPOSTGRESQL', -8); --맨 앞의 글자 8개를 제외하고

select RIGHT('DATA', 100000); --커도 상관없음
select RIGHT('DATA', 0); --빈 문자열 반환

----------------------------------------------------------------------------
/*
 POSITION / STRPOS : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(1부터 시작, 없으면 0)
 */

select position('A' in 'DATABASE');
select STRPOS('DATABASE', 'A'); --결과동일
select position('A' in REVERSE('DATABASE')); --결과 3: ESABATAD

select EMAIL,
	   position('_'in EMAIL)as "_위치"
	   ,POSITION('@'in EMAIL)as "@위치"
from EMPLOYEE;
------------------------------------------------------------------------------------
/*
 SUBSTR / SUBSTRING : 문자열에서 특정 문자열을 추출
 
 -SUBSTR('문자열' : POSITION, [LENGTH])
 	>POSITION : 문자열을 추출할 시작위치 INDEX
 	>LENGTH : 추출할 문자 갯수(생략시 맨 끝까지 추출)
 	-SUBSTRING('문자열',FROM POSITION [FOR LENGTH])
 */

select SUBSTR('DATABASESQL', 5); --5번부터
select SUBSTRING('DATABASESQL' from 5);--5번부터

select SUBSTR('DATABASESQL', 5, 2);
select SUBSTRING('DATABASESQL' from 5 for 4);

select SUBSTR('DATABASESQL', 3, 6);
select SUBSTRING('DATABASESQL' from 3 for 6);

--EMPLOYEE테이블에서 주민번호에 성별만 추출하여 주민번호, 사원명, 성별 조회
select EMP_NO,EMP_NAME, SUBSTR(EMP_NO, 8, 1)as "성별(홀수면 남자, 짝수면 여자)"
from EMPLOYEE;


--여자만
select EMP_NO,EMP_NAME, SUBSTR(EMP_NO, 8, 1)as "여자"
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1)= '2' or SUBSTR(EMP_NO, 8, 1)='4';
SE
--남자만
select EMP_NO,EMP_NAME, SUBSTR(EMP_NO, 8, 1)as "남자"
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1)= '1' or SUBSTR(EMP_NO, 8, 1)='3';

--이메일에 아이디만
select SUBSTR(EMAIL, 1, position('@' in EMAIL)-1)
from EMPLOYEE;

---------------------------------------------------------------
/*
 LPAD / RPAD : 문자열 조회할 때 길이를 맞춰 통일감 있게 조회하고자할때
 
 LPAD/RPAD('문자열', 최종반환할 문자의 길이, [덧붙이고자하는 문자])
 
 */
--25길이에 맞춰 EMAIL을 오른쪽 정렬로 출력
select EMP_NAME, LPAD(EMAIL, 25)
from EMPLOYEE;

select EMP_NAME, LPAD(EMAIL,25, '#')
from EMPLOYEE;

select EMAIL, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
from EMPLOYEE;

select EMAIL, SUBSTR(EMP_NO, 1, 8)|| '*******'as 주민번호
from EMPLOYEE;

----------------------------------------
/*
 LTRIM / PTRIM : 문자열에서 공백제거
 TRIM : 문자의 앞/뒤 양쪽에서 있는 특정 문자들을 제거한 나머지 반환
 
 LTRIM/RTRIM('문자열', [제거하고자 하는 문자]) -> 제거하고자하는 문자를 생략지 공백제거
 TRIM([LEADING|TRAILING|BOTH] 제거하고자 하는 문자 FROM '문자열')


 * */
select LTRIM('         TJOEUN              ')|| '컴퓨터 아카데미';
select RTRIM('         TJOEUN              ')|| '컴퓨터 아카데미';

select LTRIM('DATADATABASE', 'DATA');
select LTRIM('ABCABACABCABCBASBABSBBCVVBASBBABCABC', 'ABC');
select LTRIM('12319872KJLHFJKAHSLSIUFHSADIF123123123123', '0123456789');

select RTRIM('12319872KJLHFJKAHSLSIUFHSADIF123123123123', '0123456789');

select TRIM('    TJOEUN       ') || '컴퓨터아카데미';

--방향 지정
select TRIM(leading 'A' from 'AAABSGS12CCSA');
select TRIM(trailing 'A' from 'AAAAAAWEFAFAAAA');
select TRIM(both 'A' from 'AAAFSFWEFEFAAAAA');
select TRIM('A' from 'AAAAFSFEFSAAAA');

-----------------------------------------------------------------
/*
LOWER/UPPER/INITCAP : 문자열을 대소문자로 반환 및 단어의 앞글자만 대문자로 변환
 */

select lower ('DATABASE PostgreSQL');
select upper('DATABASE PostgreSQL');
select initcap('database PostgreSQL');

------------------------------------------------------
/*
 CONCAT : 문자열 두개를 하나로 합친 결과 반환
 
 CONCAT('문자열','문자열'........)
 */
select CONCAT('SQL','포토그레');

select CONCAT('SQL','포토그레','아 존나 졸리다 쉬바아알');

select 'SQL' || '포토그레';

------------------------------------------------------------------------------
/*
 REPLACE : 기존문자열을 새로운 문자열로 변경
 
 [표현법]
 REPLACE('문자열','기존문자열','바꿀문자열')
 */
select EMP_NAME, EMAIL, REPLACE(EMAIL, 'google.com','naver.com')
from employee;




--==============================================================================
--           <문자처리 함수>
/*
 * ABS : 숫자의 절댓값을 구해주느 ㄴ함수
 */
select ABS(-19);

------------------------------
/*
 MOD / % : 나머지 값 변환
 */

select mod(10, 3);
select 10 % 3; --포스트그레에서만 사용


/*
ROUND : 반올림한 결과 반환
[표현법]
ROUND(NUMBER, [위치])
 */

select ROUND(1234.56)

select ROUND(1234.5678, 2);
select ROUND(1234.56, 4);

select ROUND(1234.56, -2);

-----------------------------
/*
 CEIL : 올림한 결과 반환
 FLOOR : 내림한 결과 반환
 */

select CEIL(123.234);
select CEIL(-123.234);

select FLOOR(123.234);
select FLOOR(-123.234);

----------------------------------------------
/*
  TRUNC : 버림
  TRUNC(NUMBER, [위치])
*/
select TRUNC(123.789);
select TRUNC(123.789, 1);

select TRUNC(-123.789);

select TRUNC(123.456, -1);

--------------------------------
--날짜 처리 함수
/*
 CURRENT_DATE : 시스템 날짜
 NOW() : 시스템날짜와 시간
 */
select CURRENT_DATE;
select NOW();

select EMP_NAME, HIRE_DATE, CURRENT_DATE - HIRE_DATE 근무일수
from EMPLOYEE;

----------------------------------------------------------
/*
 INTERVAL 'n MONTH' : 특정 날짜에 해당 숫자만큼 개월수를 더해 날짜를 리턴
 */
select CURRENT_DATE + INTERVAL '1 MONTH' as 다음달;
select (CURRENT_DATE + INTERVAL '1 MONTH')::DATE as 다음달;

--EMPLOYEE에서 사원명, 입사일, 입사후 정직원된 날짜(6개월 후) 조회
select EMP_NAME, HIRE_DATE,(HIRE_DATE + interval '6 MONTH') "정직원된 날짜"
from EMPLOYEE;

-------------------------------------------------------------------------
/*
 EXTRACT : 특정날짜로부터 년 월 일 값을 추출하여 반환
 
 EXTRACT(YEAR FROM DATE) : 년도만 추출
 EXTRACT(MONTH FROM DATE) : 월만 추출
 EXTRACT(DAY FROM DATE) : 일만 추출
 */

--EMPLOYEE에서 사원명, 입사년도, 입사월, 입사일 조회
select EMP_NAME
	  ,extract(year from HIRE_DATE) as 입사년도
--	  ,extract(year from HIRE_DATE)::TEXT as 입사년도 --> 문자열로 변환
	  ,EXTRACT(month from HIRE_DATE) as 입사월
	  ,extract(day from HIRE_DATE) as 입사일
from EMPLOYEE;

--================================
--자료형 변환
--=======================================
/*
 TO_CHAR : 숫자 또는 날짜를 문자로 변환
 
 -특정형식에 맞게 출력 가능
 TO_CHAR(숫자|날짜, [포맷])
 
 */
--------------------------숫자타입 => 문자타입
/*
9:해당 자리의 숫자를 의미
	-값이 없을 경우 소수점은 이상은 공백, 소수샘 이하는 0표시
0:해당 자리의 숫자를 의미
	-값이 없을 경우 0으로 표시
FM:해당자리에 값이 없을 경우 자리차지하지 않음 
 */
select TO_CHAR(123, '999'), TO_CHAR(1234,'0000000000000000000000000000');
select TO_CHAR(123.45, '999.99999'), TO_CHAR(1234.45,'0000.000000000000000000000000');
select to_CHAR(0.12, '9.99'), TO_CHAR(0.12, '0.00');

select '\' || to_CHAR(1234, '99,999');

select EMP_NAME
	  ,'₩' || to_CHAR(SALARY, '999,999,999') as 급여
	  ,'₩' || to_CHAR(SALARY*12, '999,999,999') as 연봉
from EMPLOYEE;

select TO_CHAR(0.1000, '999,990.999');

select TO_CHAR(123.456, 'FM99990.999')
	  ,TO_CHAR(1234.56, 'FM9990.99')
	  ,TO_CHAR(0.1000, 'FM9990.999')
	  ,TO_CHAR(0.1000, 'FM9999.999');

--POSTGRE에서만 사용
--FML : L(LOCAL의 설정에 따라 통화(돈)기호 나타냄
select TO_CHAR(1234, 'FML999,999');
	  

select EMP_NAME
	  ,to_CHAR(SALARY, 'FML999,999,999') as 급여
	  ,to_CHAR(SALARY*12, 'FML999,999,999') as 연봉
from EMPLOYEE;

-------------------------날짜타입 -> 문자타입
select TO_CHAR(NOW(), 'YYYY')as 년도4자리
	  ,TO_CHAR(NOW(), 'YY') as 년도2자리
	  ,TO_CHAR(NOW(), 'MM')as 월
	  ,TO_CHAR(NOW(), 'DD')as 일
	  ,TO_CHAR(NOW(), 'DAY')as 요일
	  ,TO_CHAR(NOW(), 'HH')as 시
	  ,TO_CHAR(NOW(), 'MI')as 분
	  ,TO_CHAR(NOW(), 'SS')as 초;

--시간
select TO_CHAR(NOW(), 'AM HH:MISS');
select TO_CHAR(NOW(), 'HH12:MI:SS');
select TO_CHAR(NOW(), 'HH24:MI:SS');

--날짜
select TO_CHAR(NOW(), 'YYYY-MM-DD day');
select TO_CHAR(NOW(), 'YYYY"년" MM"월" DD"일" DAY');

--EMPLOYEE에서 사원명, 입사일(형식 25-10-28)조회
select EMP_NAME, TO_CHAR(HIRE_DATE, ('YYYY-MM-DD'))as  입사일
from employee;

--사원명 입사년도4자리 입사월 입사일 조회
select EMP_NAME
	  ,TO_CHAR(HIRE_DATE, ('YYYY'))as 입사년
	  ,TO_CHAR(HIRE_DATE, ('MM'))as 입사월
	  ,TO_CHAR(HIRE_DATE, ('DD'))as 입사일
from employee;

--------------------------------------
/*
 TO_DATE : 문자열을 날짜로 변경
 	:숫자를 바로 넣는것은 허용하지 않음. 반드시 문자열로 넣어야함
 	
 TO_DATE('문자열', '포맷')
 */
select to_DATE('261028', 'YYMMDD');
select to_DATE('261028 152820', 'YYMMDD HH24MISS' );
	--TO_DATE()함수 특성장 시간정보는 버려짐
select to_DATE(20261028::TEXT, 'YYYYMMDD');
 
---------------------------------------------------------------
/*
  TO_TIMESTAMP() : 문자열로 표현된 날짜와 시간을 포맷으로 변환
  TO_TIMESTAMP('문자열','포맷')
 */

select to_TIMESTAMP('2026-10-28 15:12:30','YYYY-MM-DD HH24:MI:SS');
select to_TIMESTAMP('20261028151230','YYYYMMDDHH24MISS');

---------------------------------------------문자타입 => 숫자타입
/*
 TO_NUMBER : 문자열을 숫자로 변환
 */
select TO_NUMBER('01234123', '9999999999999999999999');
select TO_NUMBER('01234123', '9999999999999999999999')+TO_NUMBER('55000', '999,999,999');

select '100000'::INT + '550000'::INT;

--=================
--<NULL 처리 함수>
--==========================
/*
 COALESCE(컬럼, 해당컬럼값이 NULL일때 반환할 값)
 */
--EMPLOYEE 에서 사원명, 보너스(NULL이면 0으로 출력)
select EMP_NAME, coalesce(BONUS,0)
from EMPLOYEE;

--사원병 보너스포함 연봉 조회
select EMP_NAME, TO_CHAR((SALARY+ SALARY*coalesce(BONUS, 0))*12, 'FML9999999999999999') as 연봉
from EMPLOYEE;

--EMPLOYEE에서 사원명, 부서코드(NULL이면 '부서없음'), 입사일 조회
select EMP_NAME, coalesce(DEPT_CODE, '부서없음'), HIRE_DATE
from EMPLOYEE;

--------------------------------------------------------
--선택함수
/*
 CASE WHEN THEN
 ...
 END
 
 EX)
 CASE WHEN 조건식1 THEN 결과값1
 	  WHEN 조건식2 THEN 결과값2
 	  ...
 	  ELSE 결과값N
 END
 
 IF-ELSE와 같음
 */
--급여가 350만원 미만이면 '초급' 350만원 이상 500만원 미만이면 '중급', 500만원 이상이면 '고급'
select EMP_NAME, SALARY
	  ,case when SALARY >= 5000000 then '고급'
	   		when SALARY >= 3500000 then '중급'
			else '초급'
		end as 급수
from EMPLOYEE;

--============
--<그룹함수>
/*
 *  SUM(숫자타입의 컬럼) : 컬럼들의 총 합계를 반환
 */
 
--전사원 월급의 합
select SUM(SALARY) "급여의 합계" from EMPLOYEE;

--남자사원의 급여의 합
select SUM(SALARY)
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) in('1', '3');
 
 
 --여자사원의 급여의 합
select SUM(SALARY)
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) in('2', '4');
 
--D5인 사원들의 총 연봉(보너스 포함)
select SUM((SALARY+ 1*coalesce(BONUS, 0))*12) as 총연봉
from employee
where DEPT_CODE = 'D5';
 
 /*
  AVG(숫자타입의 컬럼) : 평균반환
  */ 
 select AVG(SALARY)from EMPLOYEE;
 select ROUND(AVG(SALARY), -1)from EMPLOYEE;
 
/*
 * MIN/MAX(모든타입의 컬럼) : 최솟값과 최대값
 */ 
 select MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE) from employee;
 select MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE) from employee;

/*
  COUNT(* | 컬럼 | DISTINCT 컬럼) : 행 갯수 반환
  
  COUNT(*) : 조회된 결과의 모든 행의 갯수 반환
  COUNT(컬럼) : 컬럼의 값이 NULL인것을 제외한 행의 갯수 반환
  COUNT(DISTINCT 컬럼) : 중복을 제거한 행의 갯수반환
 */ 
 --전체 사원의 수
select COUNT(*) from EMPLOYEE;

--보너스를 받는 사원의 수
select COUNT(BONUS) from EMPLOYEE;

--부서 배치를 받은 사원의 수
select COUNT(DEPT_CODE) from EMPLOYEE;

--중복제거한 부서의 수
select COUNT(distinct DEPT_CODE) from EMPLOYEE;


--여성
select COUNT(*)
from employee
where SUBSTR(EMP_NO, 8, 1) in ('2', '4');

--숫자 자료형
::INT or ::INTEGER => 정수 4BYTE
::NUMBERIC		   => 소수(정수)
::real			   => 실수 4BYTE

--문자 자료형
::TEXT			=> 길이제한이 없는 문자열
::VARCHAR		=> 가변길이 문자열
::VARCHAR(n)	=> 가변길이이지만 최대 n글자 까지만 넣을 수 있음
::CHAR(n)		=> 고정길이(n길이만큼)

--날짜 시간
::date			=> 날짜만 표시
::TIME			=> 시간만 표시
::TIMESTAMP		=> 날짜와 시간표시
::interval		=> '1 MONTH' ::interval

--기타 자료형
::BOOLEAN		=> 참, 거짓
::JSON			=> JSON자료형 '{"AGE" : 25}'::JSON

 
 
 
 








