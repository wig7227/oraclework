--3. 권한 부여받은 후
CREATE TABLE TEST(
    TEST_1234 NUMBER,
    TEST_123 VARCHAR2(20)
);

--4. 권한 부여받은 후
INSERT INTO TEST VALUES(1,'HI');

--5. 권한 부여받은 후
SELECT *
FROM TJOEUN.EMPLOYEE;

--6.
INSERT INTO TJOEUN.EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE)
                     VALUES(302,'홍길동','210324-2323213','J2');
                     
COMMIT;

INSERT INTO TJOEUN.EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE)
                     VALUES(303,'홍길동','210324-2323213','J2');