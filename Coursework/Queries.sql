--Question 4a

COLUMN PNAME.firstName HEADING 'First Name'
COLUMN PNAME.surName HEADING 'Last Name'
SELECT e.pName.firstName, e.pName.surName
FROM EmployeeTable e
WHERE e.pAddress.city LIKE 'Glasgow' AND e.pName.firstName LIKE '%on%';
--LIKE basically looks for the characters in the string and % is a wild card which fills in the blanks 
--so %on% will look for on in the wanted string

--Output
First Name           Last Name          
-------------------- --------------------
Ronald               Donald              
Jon                  Moring              
Donald               Trump               
Monica               Giglet    


--Question 4b
COLUMN COUNT(a.accType) HEADING 'Number of savings accounts'
COLUMN bID.bAddress.street HEADING 'Street'
COLUMN bID.bAddress.city HEADING 'City' 
COLUMN bID.bAddress.postCode HEADING 'Post Code'   
SELECT count(a.accType), a.bID.bAddress.street, a.bID.bAddress.city, a.bID.bAddress.postCode
FROM AccountTable a
WHERE a.accType LIKE 'savings'
GROUP BY a.bID;
--This basically groups everything by branchID value and then counts all savings accounts in each branch


--Output             
Number of savings accounts 				Street                         City                 Post Code
--------------------------------------- ------------------------------ -------------------- ----------
                                      2 Bridge                         Glasgow              G18 1QQ   
                                      1 Market                         Edinburgh            EH1 5AB   
                                      1 Various                        Glasgow              G15 8NB   
                                      1 Collecting                     Glasgow              G14 7YT   
                                      1 Massive                        Edinburgh            EH3 3KL   
                                      1 Air                            Glasgow              G14 7TR   
                                      2 Heavy                          Glasgow              G12 6RT   
                                      1 Burly                          Edinburgh            EH7 1FD   
                                      2 Big                            Glasgow              G14 2BB   
                                      1 Grant                          Edinburgh            EH2 7CB   
									  
									  
									  
									  
--Question 4c

SELECT max(c.accNum.balance), c.accNum.bID.bID
FROM CustomerAccountTable c
WHERE c.accNum.accType LIKE 'savings'
GROUP BY c.accNum.bID;



--Question 4d

SELECT e.position.bID.bAddress.street, e.position.bID.bAddress.city, e.position.bID.bAddress.postCode
FROM EmployeeTable e, BranchTable b
WHERE e.supervisorID.position.position LIKE 'Manager' AND e.niNum IN (SELECT c.niNum
                                                                      FROM CustomerTable c);
																	  
																	  
--Question 4e




--Question 4f

SELECT c.pName.firstName, t.*
FROM CustomerTable c, table(c.pPhone.mobilePhone) t
WHERE (SELECT count(*) FROM table(c.pPhone.mobilePhone) t) > 1; 




--Question 4g

COLUMN PNAME.firstName HEADING 'First Name'
COLUMN PNAME.surName HEADING 'Last Name'
COLUMN Super FORMAT A30 HEADING 'Number of supervised employees'
COLUMN supervisorID.empID HEADING 'Supervisor ID'
SELECT e.pName.firstName, e.pName.surName, (SELECT COUNT(e.supervisorID) FROM EmployeeTable e WHERE e.supervisorID.empID = 105) AS Super, e.supervisorID.empID
FROM EmployeeTable e
WHERE e.empID = 105;
--Nested select statement to basically count all the supervised employees.
--FORMAT A30 to make sure the column width is good enough to fit heading.
--Basically whats happening here is im finding the number of supervised employees by John William who is
--supervised by Mrs Smith

--Output

First Name           Last Name            Number of supervised employees                           Supervisor ID
-------------------- -------------------- ------------------------------ ---------------------------------------
John                 William                                           3                                     101



--Question 4h
COLUMN PNAME.firstName HEADING 'First Name'
COLUMN PNAME.surName HEADING 'Last Name'
COLUMN Medal FORMAT A15 HEADING 'Medal Awarded'
SELECT e.pName.firstName, e.pName.surName, e.award( e.calculateYears(e.position.joinDate, SYSDATE), 
													(SELECT COUNT(f.supervisorID) FROM EmployeeTable f WHERE f.supervisorID.empID = e.empID )) AS Medal
FROM EmployeeTable e
WHERE e.award(e.calculateYears(e.position.joinDate, SYSDATE), 
													(SELECT COUNT(f.supervisorID) FROM EmployeeTable f WHERE f.supervisorID.empID = e.empID )) != 'null';

--award function takes in a number returned by calculateYears which is the number of years each employee worked 
--at the branch for and then I added a select statement that counts how many people each employee supervises.
--Where has e.award() with the same stuff as e.award in the select clause just to make sure to not display
--any employee who does not deserve any medal. In my case it was just 1 employee who did not recieve any reward.
--SYSDATE is basically the current date.
--FORMAT A15 allowed me to fix the Medal column because it's length was too big which ruined the output.

--Output

First Name           Last Name            Medal Awarded 
-------------------- -------------------- ---------------
Alison               Smith                Gold medal     
John                 William              Silver medal   
Mark                 Slack                Bronze medal   
Ronald               Donald               Silver medal   
Sarah                Marah                Bronze medal   
Jon                  Moring               Silver medal   
Donald               Trump                Bronze medal   
Genna                Hitty                Bronze medal   
Monica               Giglet               Bronze medal   
Robert               Bobert               Bronze medal   
Wera                 Jarret               Bronze medal   

First Name           Last Name            Medal Awarded 
-------------------- -------------------- ---------------
Webster              Baxter               Bronze medal   
Punit                Odell                Bronze medal   
Keefe                Peacock              Bronze medal   
Pearlie              Walton               Bronze medal   
Jessa                Gabriels             Bronze medal   
Levi                 Simms                Bronze medal   
Bethany              Knight               Bronze medal   
Denny                Gary                 Bronze medal  
