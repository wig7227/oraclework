/*
    *서브쿼리
     하나의 SQL문 안에 포함된 또다른 SELECT문
     메인 SQL문을보조 역할을 하는 쿼리문
*/
--간단한 서브쿼리 예1
--박정보 사원과 같은 부서에 속한 사원들 조회
--1.박정보 사원의 보서
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '박정보';

--2.부서코드가 D9인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--위의 2개의 쿼리문을 합치면
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '박정보');
                    
--전 직원의 평균급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 직급코드, 급여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

--2. 평균급여보다 급여를 많이 받는 사원
SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > 3047662;

SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE);
                
---------------------------------------------------------------------------
/*
    *서브쿼리의 구분
     서브쿼리를 수행한 결과값이 몇행 몇 열이냐에 따라 분류
     -단일행 서브쿼리: 서브쿼리를 실행한 결과 오로지 1개일 때 (한행 한열)
     -다중행 서브쿼리: 서브쿼리를 실행한 결과 여러행 일떄 (여러행 한열)
     -다중열 서브쿼리: 서브쿼리를 실행한 결과 여러열 일떄 (한행 여러열)
     -다중행 다중열 서브쿼리: 서브쿼리를 실행한 결과 여러행, 여러열 일떄 (여러행 여러열)
     
     >>서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/

/*
    1.단일행 서브쿼리(SINGLE ROW SUBQUERY)
    -비교연산자 사용가능
    =, !=, >, <, ...
*/
--전 직원의 평균 급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY;

--최저 급여를 받는 사원의 사번,사원명,급여,입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
        FROM EMPLOYEE);

--박정보 사원의 급여보다 더 많이 받는 사원들의 사번,사원명,직급코드,급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');

--JOIN
--박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서이름, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND SALARY > (SELECT SALARY
                                        FROM EMPLOYEE
                                        WHERE EMP_NAME = '박정보');
                                        
-->>ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
                
-- 서브쿼리에 나온 결과는 제외하여 조회하고 싶을때
-- 지정보사원과 같은 부서원들의 사번,사원명,부서명 조회 단,지정보는 제외
-->>오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
  AND DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '지정보')
    AND EMP_NAME != '지정보';
    
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '지정보')
    AND EMP_NAME != '지정보';
    
--GROUP BY
--부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
-- 1.부서별 급여 합 중에서 가장 큰 값 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE , SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

---------------------------------------------------------------------------
/*
    *다중행 서브쿼리
    -IN 서브쿼리: 여러개의 결과값 중 한개라도 일치하는 값이 있다면 (그나마 쓰는거)
    
    -> ANY 서브쿼리: 여러개의 결과값 중 "한개라도" 클 경우
                    즉, 결과값 중 가장 작은값 보다 클 경우
    -> ANY 서브쿼리: 여러개의 결과값 중 "한개라도" 작은 경우
                    즉, 결과값 중 가장 큰값 보다 작을 경우
    -ALL: 서브쿼리의 값들 중 가장 큰값보다 더 큰값을 얻어올 때
*/

--조정연 또는 지정보 사원과 같은 직급을 가진 사원들의 사번, 사원명, 직급코드, 급여 조회
--1.조정연 또는 지정보 사원의 직급
SELECT JOB_CODE
FROM EMPLOYEE
--WHERE EMP_NAME = '조정연' OR EMP_NAME = '지정보';
WHERE EMP_NAME IN('조정연','지정보');

--2. J3, J7인 직원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN('J3','J7');

--위의 커리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN(SELECT JOB_CODE
                  FROM EMPLOYEE
                  WHERE EMP_NAME IN('조정연' ,'지정보'));
                  
--대리 직급임에도 과장의 급여의 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여
--1.과장들의 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

--2. 대리직급의 급여 중 22
SELECT EMP_ID, EMP_NAME, JOB_NAME SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY (2200000, 2500000, 3760000);

--위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_NAME SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY (SELECT SALARY
                  FROM EMPLOYEE
                  JOIN JOB USING(JOB_CODE)
                  WHERE JOB_NAME = '과장');
                  
--차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번,사원명,직급명,급여 조회
--과장의 가장 큰 금액보다 적게 받는 차장
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장'
    AND SALARY < ANY(SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');
                    
--ALL: 서브쿼리의 값들 중 가장 큰값보다 더 큰값을 얻어올 때
--차장의 가장 큰 급여보다 더 많이 받는 과장 사번,사원명,직급명,급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
    AND SALARY > ALL(SELECT SALARY
                  FROM EMPLOYEE
                  JOIN JOB USING(JOB_CODE)
                  WHERE JOB_NAME = '차장');
                  
----------------------------------------------------------------------------
/*
    *다중열 서브쿼리
     :서브쿼리의 결과값이 행은 하나 열은 여러개
*/
-- 구정하 사원과 같은 부서코드, 직급코드에 해당하는 사원들의 사번, 사원명,부서코드,직급코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '구정하')
    AND JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '구정하');
                    
-->>다중행 서브쿼리
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '구정하');
                                
--하정연 사원의 직급코드와 사수가 같은 사원의 사번, 사원명,직급코드,사수ID조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하정연');
                    
-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE,JOB_NAME
FROM EMPLOYEE E, DEPARTMENT,JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE
AND (SUBSTR(EMP_NO,8,1) ='2' OR SUBSTR(EMP_NO,8,1) ='4')
AND SUBSTR(EMP_NO,1,2) BETWEEN '70' AND '79'
AND SUBSTR(EMP_NAME,1,1) = '전';

-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, 100-SUBSTR(EMP_NO,1,2)+25 나이, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT,JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE
AND SUBSTR(EMP_NO,1,2) = (SELECT MAX(SUBSTR(EMP_NO,1,2))
                          FROM EMPLOYEE);

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND EMP_NAME LIKE '%하%';

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT,JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE
AND (DEPT_ID = 'D5' OR  DEPT_ID = 'D6');

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE DEPT_CODE = DEPT_ID AND LOCAL_CODE = LOCATION_ID
AND BONUS IS NOT NULL;

-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT,JOB J, LOCATION L
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE AND LOCAL_CODE = LOCATION_ID;

-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D,JOB J, LOCATION L , NATIONAL N
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE AND LOCAL_CODE = LOCATION_ID
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND (NATIONAL_NAME = '한국' OR NATIONAL_NAME = '일본');

-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하정연');
                    
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND BONUS IS NULL
AND (E.JOB_CODE = 'J4' OR E.JOB_CODE = 'J7');

-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT COUNT(ENT_YN)
FROM EMPLOYEE
GROUP BY ENT_YN;
-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
SELECT  *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 
RANK() OVER(ORDER BY SALARY DESC) 순위 
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE) A
WHERE 순위 <= 5;

-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--12-1. JOIN과 HAVING 사용
SELECT DEPT_TITLE, SUM(SALARY)부서별합계
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE;

-- 12-2. 인라인 뷰 사용      
-- 12-3. WITH 사용
WITH AAA AS (SELECT DEPT_TITLE, SUM(SALARY)부서별합계
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE)
SELECT DEPT_TITLE, 부서별합계
FROM AAA;

-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE;

-- 14. WITH를 이용하여 급여합과 급여평균 조회
WITH SA_SAL AS (SELECT SUM(SALARY)급여합, ROUND(AVG(SALARY)) 급여평균
                FROM EMPLOYEE)
SELECT 급여합, 급여평균
FROM SA_SAL;



--각 직급별 최소급여를 받는 사원의 사번,사원명,직급코드, 급여 조회
--1.직급별 최소급여 금액과 직급코드 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J5' AND SALARY = 2200000
      OR JOB_CODE = 'J6' AND SALARY = 2000000;
      
      
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J5',2200000)
   OR (JOB_CODE, SALARY) = ('J6',2000000);
   
--서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);
                             
--각 부서별 최고급여를 받는 사람들의 사번,사원명,부서코드,급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                             FROM EMPLOYEE
                             GROUP BY DEPT_CODE);
                             
-------------------------------------------------------------------------------
/*
    *인라인 뷰(INLINE VIEW)
    FROM절에 서브쿼리 작성
    
    서버쿼리 결과를 마치 테이블처럼 사용
*/
--사원들의 사번, 사원명,보너스포함 연봉( 별칭부여), 부서코드 조회
--NULL값이 나오지 않게 NVL
--단, 보너스포함 연봉이 3000만원 이상인 사원들만 조회
SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS,1)*12 연봉 , DEPT_CODE
FROM EMPLOYEE
WHERE SALARY*NVL(1+BONUS,1)*12 >= 30000000;

--WHERE절에 연봉이라는 별칭을 쓰고 싶으면
--FROM 절의 서브쿼리에 있는 커럶들만 사용가능
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS,1)*12 연봉 , DEPT_CODE
       FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

------------->> 인라인 뷰를 주로 사용하는 예) TOP-N분석(상위 몇위까지만 가져오기)
--전 직원들중 급여가 가장 많이받는 사원의 상위 5위까지 가져오기
-----> * ROWNUM: 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;

--우선 SELECT의 이름과 급여를 가져와서 그 결과에 번호 매긴 후 급여의 내림차순 정렬
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

--테이블 서브쿼리외의 다른컬럼을 사용할때는 서브쿼리에 별칭을 부여한 후 별칭,* 으로만 사용가능 
SELECT ROWNUM, E.*
FROM( SELECT EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

--가장 최근에 입사한 사원 3명의 사원명, 급여, 입사일 조회
SELECT ROWNUM, E.*
FROM(SELECT EMP_NAME, SALARY, HIRE_DATE
     FROM EMPLOYEE
     ORDER BY HIRE_DATE DESC) E
WHERE ROWNUM <= 3;
     
--각 부서별 평균급여가 높은 3개의 부서의 부서코드,평균급여 조회
SELECT ROWNUM, E.*
FROM (SELECT DEPT_CODE, ROUND(AVG(SALARY))
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY ROUND(AVG(SALARY)) DESC) E
WHERE ROWNUM <=3;

---------------------------------------------------------------------------
/*
    *WITH
    서브쿼리에 이름 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름을 FROM절에 기술
    
    -장점
    같은 서브쿼리가 여러 번 사용될 경우 중복 작성을 피할 수 있다
    실행속도도 빠르다
*/

WITH TOP_SAL AS(SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
            FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY ROUND(AVG(SALARY)) DESC)
            
SELECT DEPT_CODE, 평균급여
FROM TOP_SAL
WHERE ROWNUM <= 3;
--MINUS, UNION 을 쓸 때 유용

------------------------------------------------------------------------------
/*
    *순위 매기는 함수
    RANK()OVER(정렬기준) | DENSE_RANK()OVER(정렬기준)
    - RANK()OVER(정렬기준): 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰어 순위 계산
                           EX)공동 1위가 2명이면 다음 순위는 3위
    - DENSE RANK()OVER(정렬기준): 동일한 순위 이후의 등수를 무조건 1증가 시킴
                           EX)공동 1위가 2명이면 다음 순위는 2위
    >> SELECT절에서만 사용 가능
*/

--급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
--공동 19위가 2명 -> 그 다음 순위는 21위

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
--공동 19위가 2명 -> 그 다음 순위는 20위

--급여가 상위 5위인 사원들의 사원명, 급여,순위 조회
SELECT *
FROM(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
     FROM EMPLOYEE)
WHERE 순위 <= 5;

--WITH와 함께 사용
WITH TOPN_SAL AS (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
                   FROM EMPLOYEE)
SELECT 순위, EMP_NAME, SALARY
FROM TOPN_SAL
WHERE 순위 <= 5;
