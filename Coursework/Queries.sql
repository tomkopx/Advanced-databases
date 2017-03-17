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
									  
									  
									  
									 


--Question 4d

COLUMN position.bID.bAddress.street HEADING 'Working Branch street'
COLUMN position.bID.bAddress.city HEADING 'Working Branch city'
COLUMN position.bID.bAddress.postCode FORMAT A25 HEADING 'Working Branch post code'
COLUMN accNum.bID.bAddress.street HEADING 'Account Branch street'
COLUMN accNum.bID.bAddress.city HEADING 'Account Branch city'
COLUMN accNum.bID.bAddress.postCode FORMAT A25 HEADING 'Account Branch post code'
SELECT e.position.bID.bAddress.street , e.position.bID.bAddress.city ,e.position.bID.bAddress.postCode , c.accNum.Bid.bAddress.street, c.accNum.Bid.bAddress.city, c.accNum.Bid.bAddress.postcode
FROM CustomerAccountTable c , EmployeeTable e 
WHERE c.custID.niNum = e.niNum  AND e.supervisorID IS NOT NULL ;
--Checking whether or not the employees national insurance number appears in the customer table and then checking to make sure 
--that the employee also has a supervisor 

--Output                                                                     

Working Branch street          Working Branch city  Working Branch post code  Account Branch street          Account Branch city  Account Branch post code
------------------------------ -------------------- ------------------------- ------------------------------ -------------------- -------------------------
Bridge                         Glasgow              G18 1QQ                   Market                         Edinburgh            EH1 5AB                  
Bridge                         Glasgow              G18 1QQ                   Market                         Edinburgh            EH1 5AB                  
Heavy                          Glasgow              G12 6RT                   Big                            Glasgow              G14 2BB                  
Heavy                          Glasgow              G12 6RT                   Big                            Glasgow              G14 2BB                  
Big                            Glasgow              G14 2BB                   Heavy                          Glasgow              G12 6RT                  
Big                            Glasgow              G14 2BB                   Heavy                          Glasgow              G12 6RT                  
Market                         Edinburgh            EH1 5AB                   Burly                          Edinburgh            EH7 1FD                  
Market                         Edinburgh            EH1 5AB                   Burly                          Edinburgh            EH7 1FD                  
Heavy                          Glasgow              G12 6RT                   Big                            Glasgow              G14 2BB                  
Heavy                          Glasgow              G12 6RT                   Big                            Glasgow              G14 2BB                  
Big                            Glasgow              G14 2BB                   Rowling                        Glasgow              G16 8XS                  

Working Branch street          Working Branch city  Working Branch post code  Account Branch street          Account Branch city  Account Branch post code
------------------------------ -------------------- ------------------------- ------------------------------ -------------------- -------------------------
Various                        Glasgow              G15 8NB                   Rowling                        Glasgow              G16 8XS                  
Heavy                          Glasgow              G12 6RT                   Various                        Glasgow              G15 8NB                  
Heavy                          Glasgow              G12 6RT                   Various                        Glasgow              G15 8NB                  
Burly                          Edinburgh            EH7 1FD                   Massive                        Edinburgh            EH3 3KL                  
Various                        Glasgow              G15 8NB                   Bridge                         Glasgow              G18 1QQ                  
Heavy                          Glasgow              G12 6RT                   Air                            Glasgow              G14 7TR                  
Air                            Glasgow              G14 7TR                   Heavy                          Glasgow              G12 6RT                  
Air                            Glasgow              G14 7TR                   Heavy                          Glasgow              G12 6RT                  
Various                        Glasgow              G15 8NB                   Collecting                     Glasgow              G14 7YT                  
Big                            Glasgow              G14 2BB                   Bridge                         Glasgow              G18 1QQ                  
Market                         Edinburgh            EH1 5AB                   Grant                          Edinburgh            EH2 7CB                  

Working Branch street          Working Branch city  Working Branch post code  Account Branch street          Account Branch city  Account Branch post code
------------------------------ -------------------- ------------------------- ------------------------------ -------------------- -------------------------
Market                         Edinburgh            EH1 5AB                   Grant                          Edinburgh            EH2 7CB                  																  



--Question 4f


SELECT c.pName.firstName, c.pName.surName, t.*
FROM CustomerTable c, table(c.pPhone.mobilePhone) t
WHERE (SELECT count(*) FROM table(c.pPhone.mobilePhone) t) > 1 AND '0770' IN (SELECT SUBSTR(t.column_value, 0,4) FROM table(c.pPhone.mobilePhone) t); 
--The first nested select statement counts the number of numbers each customer has, then checks whether or not its more than 1
--The next nested select statement selects a substring of each mobile number (first 4 characters) and 
--sees whether or not 0770 is in the nested table.

--Output

First Name           Last Name            Mobile Number      
-------------------- -------------------- --------------------
Jack                 Smith                0781209890          
Jack                 Smith                0770234567          
Jenny                Peacock              0770209142          
Jenny                Peacock              0770208242          
John                 Gabriels             0770123456          
John                 Gabriels             0770123489          
John                 Gabriels             0770125436          
Sarah                Marah                0770209888          
Sarah                Marah                0781209858          
Sarah                Marah                0781209840     



--Question 4g

COLUMN PNAME.firstName HEADING 'First Name'
COLUMN PNAME.surName HEADING 'Last Name'
COLUMN Super FORMAT A30 HEADING 'Number of supervised employees'
COLUMN supervisorID.empID HEADING 'Supervisor ID'
SELECT e.pName.firstName, e.pName.surName, (SELECT COUNT(e.supervisorID) FROM EmployeeTable e WHERE e.supervisorID.empID = 105) AS Super, e.supervisorID.empID
FROM EmployeeTable e
WHERE e.pName.surName LIKE 'William' AND e.pName.title LIKE 'Mr';
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
