USE alumni;

-- To see stucture of all the table 
DESC college_a_hs;
SELECT * FROM college_a_hs;

DESC college_a_se;
SELECT * FROM college_a_se;

DESC college_a_sj;
SELECT * FROM college_a_sj;

DESC college_b_hs;
SELECT * FROM college_b_hs;

DESC college_b_se;
SELECT * FROM college_b_se;

DESC college_b_sj;
SELECT * FROM college_b_sj;


--  Data cleaning on table College_A_HS and stored cleaned data in view College_A_HS_V, Remove null values
CREATE VIEW  College_a_hs_V AS 
SELECT * FROM college_a_hs
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND
	  MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND
	  EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL ;
      

-- Data cleaning on table College_A_SE and stored cleaned data in view College_A_SE_V, Remove null values.
CREATE VIEW  College_a_se_V AS 
SELECT * FROM college_a_se
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND
	  MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND 
      Location IS NOT NULL ;
      
 
 -- Data cleaning on table College_A_SJ and stored cleaned data in view College_A_SJ_V, Remove null values.
CREATE VIEW  College_a_sj_V AS 
SELECT * FROM college_a_sj
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND
	  MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND 
	  Designation IS NOT NULL AND Location IS NOT NULL ;


--  Data cleaning on table College_B_HS and stored cleaned data in view College_B_HS_V, Remove null values
CREATE VIEW  College_b_hs_V AS 
SELECT * FROM college_b_hs
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND
	  MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND
	  EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL ;
      
      
-- Data cleaning on table College_B_SE and stored cleaned data in view College_B_SE_V, Remove null values.
CREATE VIEW  College_b_se_V AS 
SELECT * FROM college_b_se
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND
	  MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND 
      Location IS NOT NULL ;
      

 -- Data cleaning on table College_B_SJ and stored cleaned data in view College_B_SJ_V, Remove null values.
CREATE VIEW  College_b_sj_V AS 
SELECT * FROM college_b_sj
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND
	  MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND 
	  Designation IS NOT NULL AND Location IS NOT NULL ;      
      
      
      
/* Make procedure to use string function/s for converting record of Name, FatherName, MotherName into lower case for views 
(College_A_HS_V, College_A_SE_V, College_A_SJ_V, College_B_HS_V, College_B_SE_V, College_B_SJ_V)  */

DELIMITER $$
CREATE PROCEDURE convert_record_to_lowercase()
BEGIN


SELECT  LOWER(Name) AS Name, LOWER(FatherName) AS FatherName, LOWER(MotherName) AS MotherName FROM college_a_hs_v ;
 
SELECT  LOWER(Name) AS Name, LOWER(FatherName) AS FatherName, LOWER(MotherName) AS MotherName FROM college_a_se_v;
 
SELECT  LOWER(Name) AS Name, LOWER(FatherName) AS FatherName, LOWER(MotherName) AS MotherName FROM college_a_sj_v;

        

SELECT  LOWER(Name) AS Name, LOWER(FatherName) AS FatherName, LOWER(MotherName) AS MotherName FROM college_b_hs_v ;
       
SELECT  LOWER(Name) AS Name, LOWER(FatherName) AS FatherName, LOWER(MotherName) AS MotherName FROM college_b_se_v ;
       
SELECT  LOWER(Name) AS Name, LOWER(FatherName) AS FatherName, LOWER(MotherName) AS MotherName FROM college_b_sj_v ;


END $$
DELIMITER ;

CALL convert_record_to_lowercase();



-- Write a query to create procedure get_name_collegeA using the cursor to fetch names of all students from college A.
DELIMITER $$
CREATE  PROCEDURE get_name_collegeA(INOUT firstname TEXT(40000))
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE alumname VARCHAR(16000) ;
	DECLARE alumniname CURSOR FOR 
	     SELECT Name  FROM College_a_hs 
	     UNION
		 SELECT Name  FROM College_a_se
		 UNION
	     SELECT Name  FROM College_a_sj ;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
    OPEN alumniname ;
    
    read_loop: LOOP
    FETCH alumniname INTO alumname ;
    IF done THEN 
      LEAVE read_loop;
    END IF ;
       
       -- displaying the fetched name
      SET firstname = CONCAT(alumname, ";", firstname) ;
    
    END LOOP read_loop ;
    
    CLOSE alumniname ;
    
END $$
DELIMITER ;    

SET @firstn = "";
CALL get_name_collegeA(@firstn);
SELECT @firstn ;



-- Write a query to create procedure get_name_collegeB using the cursor to fetch names of all students from college B.
DELIMITER $$
CREATE  PROCEDURE get_name_collegeB(INOUT firstname TEXT(40000))
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE alumname VARCHAR(16000) ;
	DECLARE alumniname CURSOR FOR 
	     SELECT Name  FROM College_b_hs 
	     UNION
		 SELECT Name  FROM College_b_se
		 UNION
	     SELECT Name  FROM College_b_sj ;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
    OPEN alumniname ;
    
    read_loop: LOOP
    FETCH alumniname INTO alumname ;
    IF done THEN 
      LEAVE read_loop;
    END IF ;
       
       -- displaying the fetched name
      SET firstname = CONCAT(alumname, ";", firstname) ;
    
    END LOOP read_loop ;
    
    CLOSE alumniname ;
    
END $$
DELIMITER ;    

SET @firstn = "";
CALL get_name_collegeB(@firstn);
SELECT @firstn ;




/* Calculate the percentage of career choice of College A and College B Alumni
-- (w.r.t Higher Studies, Self Employed and Service/Job)
Note: Approximate percentages are considered for career choices. */

SELECT "Higher_Studies" AS Present_Status ,
((SELECT COUNT(*) FROM College_a_hs)/((SELECT COUNT(*)FROM college_a_hs) + (SELECT COUNT(*)FROM college_a_se)+ (SELECT COUNT(*) FROM college_a_sj)))*100 AS College_A_percentage ,
((SELECT COUNT(*) FROM College_b_hs)/((SELECT COUNT(*)FROM college_b_hs) + (SELECT COUNT(*)FROM college_b_se)+ (SELECT COUNT(*) FROM college_b_sj)))*100 AS College_B_percentage 

UNION

SELECT "Self_Employed" AS Present_Status ,
((SELECT COUNT(*) FROM college_a_se)/((SELECT COUNT(*)FROM college_a_hs) + (SELECT COUNT(*)FROM college_a_se)+ (SELECT COUNT(*) FROM college_a_sj)))*100 AS College_A_percentage ,
((SELECT COUNT(*) FROM college_b_se)/((SELECT COUNT(*)FROM college_b_hs) + (SELECT COUNT(*)FROM college_b_se)+ (SELECT COUNT(*) FROM college_b_sj)))*100 AS College_B_percentage 

UNION

SELECT "Service_Job" AS Present_Status ,
((SELECT COUNT(*) FROM college_a_sj)/((SELECT COUNT(*)FROM college_a_hs) + (SELECT COUNT(*)FROM college_a_se)+ (SELECT COUNT(*) FROM college_a_sj)))*100 AS College_A_percentage ,
((SELECT COUNT(*) FROM College_b_sj)/((SELECT COUNT(*)FROM college_b_hs) + (SELECT COUNT(*)FROM college_b_se)+ (SELECT COUNT(*) FROM college_b_sj)))*100 AS College_B_percentage 









