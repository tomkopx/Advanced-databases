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
Number of savings accounts Street                         City                 Post Code
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
  

