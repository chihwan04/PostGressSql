create table TB_CLASS_TYPE(
	no VARCHAR(5) primary key,
	NAME VARCHAR(10)
);

INSERT into TB_CLASS_TYPE VALUES('01','전공필수');
INSERT into TB_CLASS_TYPE VALUES('02','전공선택');
INSERT into TB_CLASS_TYPE VALUES('03','교양필수');
insert into TB_CLASS_TYPE VALUES('04','교양선택');
INSERT into TB_CLASS_TYPE VALUES('05','논문지도');

--2.
create table TB_학생일반정보(학번, 학생이름, 주소)
as select STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
	from TB_STUDENT;

--3.
create table TB_국어국문학과(학번, 학생이름, 출생년도, 교수이름)
as select S.STUDENT_NO, S.STUDENT_NAME
		,EXTRACT(year from TO_DATE(SUBSTR(S.STUDENT_SSN, 1, 2),'YY'))
		,PROFESSOR_NAME
	from TB_STUDENT S
	left join tb_professor P on (P.professor_no = S.COACH_PROFESSOR_NO)
	left join TB_DEPARTMENT D ON(D.DEPARTMENT_NO = S.DEPARTMENT_NO)
	where DEPARTMENT_NAME ='국어국문학과';

--4
update tb_department
set CAPACITY = ROUND(capacity * 1.1);

select *
from tb_department

--5.
update tb_student
set student_address = '서울시 종로구 숭인동 181-21'
where student_no = 'A413042';

--6
update tb_student
set STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

--7
select STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME, point, CLASS_NAME
from tb_student 
join TB_DEPARTMENT using (DEPARTMENT_NO)
join TB_CLASS USING(DEPARTMENT_NO)
join TB_GRADE USING(STUDENT_NO)
where STUDENT_NAME = '김명훈'
	and department_name = '의학과'
	and CLASS_NAME = '피부생리학'
	and TERM_NO = '200501';

UPDATE TB_GRADE
set POINT = 3.5
where STUDENT_NO=(select student_no
					from tb_student
					join TB_DEPARTMENT using (DEPARTMENT_NO)
					where STUDENT_NAME = '김명훈'
					and department_name = '의학과'
	and TERM_NO = '200501'
	and CLASS_NO = (select class_no
					from TB_CLASS
					where CLASS_NAME = '피부생리학')
);

--8
delete from TB_GRADE
where STUDENT_NO in (select STUDENT_NO
						from TB_STUDENT
						where ABSENCE_YN = 'Y');

select COUNT(*)
from TB_STUDENT 
join TB_GRADE USING(STUDENT_NO)
group by ABSENCE_YN
having ABSENCE_YN = 'Y';




