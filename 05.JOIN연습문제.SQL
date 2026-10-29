-- 1. 모든 사원의 사번, 사원명, 부서명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고, 사번 오름차순으로 정렬하시오.
select EMP_ID, EMP_NAME, dept_title
from employee
join department on (DEPT_CODE = DEPT_ID);
-- 2. 모든 사원의 사원명, 직급명을 조회하시오.
--    직급명이 '대리'인 사원만 조회하고 사원명 오름차순으로 정렬하시오.
select EMP_NAME, JOB_NAME
from EMPLOYEE E
join JOB J on (E.JOB_CODE = J.JOB_CODE)
where JOB_NAME = '대리';
-- 3. 부서가 배정된 사원의 사원명, 부서명, 급여를 조회하시오.
--    급여가 3000000 이상인 사원만 급여 내림차순으로 정렬하시오.
select EMP_NAME, DEPT_TITLE, SALARY
from EMPLOYEE
join department on (DEPT_CODE = DEPT_ID)
where SALARY >= 3000000
order by SALARY;
-- 4. 모든 부서의 부서명과 소속 사원 수를 조회하시오.
--    사원이 한 명도 없는 부서도 0명으로 출력하고, 부서코드 오름차순으로 정렬하시오.
select COUNT(EMP_ID) as 사원수 , DEPT_TITLE
from EMPLOYEE E
join department D on (E.DEPT_CODE = D.DEPT_ID)
ORDER by DEPT_TITLE;
-- 5. 사원명, 부서명, 직급명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고 사번 오름차순으로 정렬하시오.


-- 6. 부서가 배정된 사원의 사원명, 부서명, 근무 지역명, 국가명을 조회하시오.
--    사번 오름차순으로 정렬하시오.


-- 7. 관리자 사번이 등록된 사원의 사원명과 관리자명을 조회하시오.
--    해당 관리자 사번을 가진 사원이 EMPLOYEE 테이블에 실제로 존재하는 경우만 출력하시오.


-- 8. 모든 사원의 사원명, 급여, 급여등급을 조회하시오.
--    급여등급은 급여가 최소급여와 최대급여 사이에 있는 경우 매칭하고, 사번 오름차순으로 정렬하시오.


-- 9. 부서별 부서명, 평균급여를 조회하시오.
--    소속 사원이 2명 이상인 부서만 조회하고 평균급여 내림차순으로 정렬하시오.


-- 10. 모든 국가의 국가명과 해당 국가에 위치한 부서의 소속 사원 수를 조회하시오.
--     소속 사원이 없는 국가도 0명으로 출력하고, 사원 수 내림차순, 국가명 오름차순으로 정렬하시오.