
--Name type
CREATE OR REPLACE TYPE Name AS OBJECT (
	title VARCHAR2(6),
	firstName VARCHAR2(20),
	surName VARCHAR2(20));
	
/
	
--Address type
CREATE OR REPLACE TYPE Address AS OBJECT (
	street VARCHAR2(30),
	city VARCHAR2(20),
	postCode VARCHAR2(10));

/

--Nested table type for Phone	
CREATE OR REPLACE TYPE mobile_nested AS TABLE OF VARCHAR2(20);
	
/

--Phone type	
CREATE OR REPLACE TYPE Phone AS OBJECT (
	homePhone VARCHAR2(20),
	mobilePhone mobile_nested);
	
/

--Branch type - Used in Branch table
CREATE OR REPLACE TYPE Branch AS OBJECT (
	bID NUMBER,
	bAddress Address,
	bPhone VARCHAR2(20));
	
/

--Job type
CREATE OR REPLACE TYPE Job AS OBJECT (
	position VARCHAR2(20),
	salary NUMBER,
	bID ref Branch,
	joinDate DATE);
	
/

--Person type (Not final as this will be the parent of 2 other types)
CREATE OR REPLACE TYPE Person AS OBJECT (
	pAddress Address,
	pName Name,
	pPhone Phone,
	niNum VARCHAR2(15))
NOT FINAL;

/

--Customer type - Used in Customer table
CREATE OR REPLACE TYPE Customer UNDER Person (
	custID NUMBER);
	
/

--Employee type - Used in Employee table
CREATE OR REPLACE TYPE Employee UNDER Person (
	empID NUMBER,
	supervisorID ref Employee,
	position Job,
	MEMBER FUNCTION award(yearsWorked NUMBER, noSupervised NUMBER) RETURN STRING);

/
	
--Body type for employee - All the functions
CREATE OR REPLACE TYPE BODY Employee AS
MEMBER FUNCTION award(yearsWorked NUMBER, noSupervised NUMBER) RETURN STRING IS
BEGIN
	IF yearsWorked > 12 AND noSupervised => 6 THEN
	RETURN 'Gold medal';
	ELSIF yearsWorked > 8 AND noSupervised => 3 THEN
	RETURN 'Silver medal';
	ELSIF yearsWorked > 4 THEN
	RETURN 'Bronze medal';
	END IF;
END award;
END;

/*  USE LATER IN LAST QUERY
MEMBER FUNCTION yearsWorked RETURN NUMBER IS
BEGIN 
	RETURN DATEDIFF(year, self.position.joinDate, GETDATE());
END yearsWorked;

MEMBER FUNCTION noSupervised RETURN NUMBER IS
supervised NUMBER;
BEGIN 
	SELECT COUNT(*)
	INTO supervised
	FROM EmployeeTable
	WHERE supervisorID = self.empID;
				  
	RETURN supervised;
END noSupervised;
*/


/

--Account type - Used in Account table
CREATE OR REPLACE TYPE Account AS OBJECT (
	accNum NUMBER,
	accType VARCHAR2(20),
	balance NUMBER,
	bID ref Branch,
	inRate NUMBER,
	limitOfFreeOD NUMBER,
	openDate DATE);
	
/

--CustomerAccount type - Used in CustomerAccount Table
CREATE OR REPLACE TYPE CustomerAccount AS OBJECT (
	custID ref Customer,
	accNUM ref Account);
	

/

--Branch table with all of its constraints
CREATE TABLE BranchTable OF Branch (
	bID PRIMARY KEY,
	CONSTRAINT bStreet_const CHECK(bAddress.street IS NOT NULL),
	CONSTRAINT bCity_const CHECK(bAddress.city IS NOT NULL),
	CONSTRAINT bPostCode_const CHECK(bAddress.postCode IS NOT NULL),
	CONSTRAINT bPhone_const CHECK(bPhone IS NOT NULL));
	
/

--Customer table with all of its constraints
CREATE TABLE CustomerTable OF Customer (
	custID PRIMARY KEY,
	CONSTRAINT cStreet_const CHECK(pAddress.street IS NOT NULL),
	CONSTRAINT cCity_const CHECK(pAddress.city IS NOT NULL),
	CONSTRAINT cPostCode_const CHECK(pAddress.postCode IS NOT NULL),
	CONSTRAINT cFirstName_const CHECK(pName.firstName IS NOT NULL),
	CONSTRAINT cSurName_const CHECK(pName.surName IS NOT NULL),
	CONSTRAINT cNiNum_const UNIQUE(niNum))
	NESTED TABLE pPhone.mobilePhone STORE AS mobile_nested_table;

/

--Employee table with all of its constraints
CREATE TABLE EmployeeTable OF Employee (
	empID PRIMARY KEY,
	CONSTRAINT eStreet_const CHECK(pAddress.street IS NOT NULL),
	CONSTRAINT eCity_const CHECK(pAddress.city IS NOT NULL),
	CONSTRAINT ePostCode_const CHECK(pAddress.postCode IS NOT NULL),
	CONSTRAINT eFirstName_const CHECK(pName.firstName IS NOT NULL),
	CONSTRAINT eSurName_const CHECK(pName.surName IS NOT NULL),
	CONSTRAINT eNiNum_const UNIQUE(niNum),
	CONSTRAINT eSalary_const CHECK(position.salary IS NOT NULL),
	CONSTRAINT eJoinDate_const CHECK(position.joinDate IS NOT NULL))
	NESTED TABLE pPhone.mobilePhone STORE AS empMobile_nested_table;
	
/

--Account table with all its constraints	
CREATE TABLE AccountTable OF Account (
	accNum PRIMARY KEY,
	CONSTRAINT accType_const CHECK(accType IS NOT NULL),
	CONSTRAINT balance_const CHECK(balance IS NOT NULL),
	CONSTRAINT inRate_const CHECK(inRate IS NOT NULL),
	CONSTRAINT openDate_const CHECK(openDate IS NOT NULL));	
	
/

--CustomerAccount table 
CREATE TABLE CustomerAccountTable OF CustomerAccount;
	
--INSERT STATEMENTS FOR BRANCH

INSERT INTO BranchTable
	values
	(901,
	Address('Market', 'Edinburgh', 'EH1 5AB'),
	'01311235560'
	);
	
/

INSERT INTO BranchTable
	values
	(908,
	Address('Bridge', 'Glasgow', 'G18 1QQ'),
	'01413214556'
	);

/

INSERT INTO BranchTable
	values
	(902,
	Address('Grant', 'Edinburgh', 'EH2 7CB'),
	'01313214558'
	);
	
/

INSERT INTO BranchTable
	values
	(909,
	Address('Big', 'Glasgow', 'G14 2BB'),
	'01413214559'
	);
	
/

INSERT INTO BranchTable
	values
	(910,
	Address('Massive', 'Edinburgh', 'EH3 3KL'),
	'01313214560'
	);
	
	
/

INSERT INTO BranchTable
	values
	(911,
	Address('Heavy', 'Glasgow', 'G12 6RT'),
	'01413214561'
	);	
	
	
/

INSERT INTO BranchTable
	values
	(912,
	Address('Nice', 'Edinburgh', 'EH2 9OP'),
	'01313214562'
	);
	

/

INSERT INTO BranchTable
	values
	(913,
	Address('Water', 'Glasgow', 'G11 5GH'),
	'01413214563'
	);	
	
	
/

INSERT INTO BranchTable
	values
	(914,
	Address('Earth', 'Edinburgh', 'EH9 9JQ'),
	'01313214564'
	);		

/

INSERT INTO BranchTable
	values
	(915,
	Address('Air', 'Glasgow', 'G14 7TR'),
	'01413214565'
	);	
	
/

INSERT INTO BranchTable
	values
	(916,
	Address('Fire', 'Edinburgh', 'EH4 7JK'),
	'01313214566'
	);		

/

INSERT INTO BranchTable
	values
	(917,
	Address('Avatar', 'Glasgow', 'G13 4EB'),
	'01413214567'
	);
	
/

INSERT INTO BranchTable
	values
	(918,
	Address('Burly', 'Edinburgh', 'EH7 1FD'),
	'01313214568'
	);
	
/

INSERT INTO BranchTable
	values
	(919,
	Address('Various', 'Glasgow', 'G15 8NB'),
	'01413214569'
	);	

/

INSERT INTO BranchTable
	values
	(920,
	Address('Road', 'Edinburgh', 'EH8 4KS'),
	'01313214570'
	);	
	
/

INSERT INTO BranchTable
	values
	(921,
	Address('Rowling', 'Glasgow', 'G16 8XS'),
	'01413214571'
	);		

/

INSERT INTO BranchTable
	values
	(922,
	Address('Colinton', 'Edinburgh', 'EH5 6YG'),
	'01313214572'
	);	
	
/

INSERT INTO BranchTable
	values
	(923,
	Address('Collecting', 'Glasgow', 'G14 7YT'),
	'01413214573'
	);
	
/

INSERT INTO BranchTable
	values
	(924,
	Address('Lovely', 'Edinburgh', 'EH3 8EW'),
	'01313214574'
	);
	
/

INSERT INTO BranchTable
	values
	(925,
	Address('Horrible', 'Aberdeen', 'AB7 8TH'),
	'01613214575'
	);
	
/


--INSERT STATEMENTS FOR ACCOUNT
	
	
INSERT INTO AccountTable
	values
	(1001,
	'current',
	820.50,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 901),
	0.005,
	800,
	'01-May-11');

/
	
INSERT INTO AccountTable
	values
	(1010,
	'savings',
	3122.20,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 901),
	0.02,
	'',
	'08-Mar-10');	
	
/
	
INSERT INTO AccountTable
	values
	(8002,
	'current',
	200.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 908),
	0.005,
	100,
	'05-May-09');		
	
/
	
INSERT INTO AccountTable
	values
	(1011,
	'current',
	900.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 911),
	0.005,
	800,
	'13-Apr-00');	
	
/
	
INSERT INTO AccountTable
	values
	(1012,
	'current',
	364.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 909),
	0.005,
	300,
	'24-Aug-00');		
	
/
	
INSERT INTO AccountTable
	values
	(1013,
	'savings',
	5012.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 909),
	0.02,
	'',
	'21-Dec-00');	
	
/
	
INSERT INTO AccountTable
	values
	(1014,
	'savings',
	9100.67,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 909),
	0.02,
	'',
	'16-Jul-02');		
	
/
	
INSERT INTO AccountTable
	values
	(1015,
	'savings',
	3490.23,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 911),
	0.02,
	'',
	'04-Sep-02');		
	
/
	
INSERT INTO AccountTable
	values
	(1016,
	'savings',
	4512.12,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 908),
	0.02,
	'',
	'21-Mar-03');		
	
/
	
INSERT INTO AccountTable
	values
	(1017,
	'current',
	786.35,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 921),
	0.005,
	600,
	'19-Jan-04');		
	
/
	
INSERT INTO AccountTable
	values
	(1018,
	'current',
	143.45,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 911),
	0.005,
	200,
	'26-Dec-06');	

/
	
INSERT INTO AccountTable
	values
	(1019,
	'current',
	10.90,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 909),
	0.005,
	100,
	'29-Dec-06');	

/
	
INSERT INTO AccountTable
	values
	(1020,
	'savings',
	16934.34,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 911),
	0.02,
	'',
	'09-Mar-07');	
	
/
	
INSERT INTO AccountTable
	values
	(1021,
	'current',
	456.45,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 919),
	0.005,
	300,
	'06-Jul-07');
	
/
	
INSERT INTO AccountTable
	values
	(1022,
	'savings',
	7632.21,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 919),
	0.02,
	'',
	'19-Mar-09');
	
/
	
INSERT INTO AccountTable
	values
	(1023,
	'savings',
	2385.90,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 915),
	0.02,
	'',
	'16-Mar-12');
	
/
	
INSERT INTO AccountTable
	values
	(1024,
	'current',
	1011.78,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 918),
	0.005,
	700,
	'11-Feb-15');
	
/
	
INSERT INTO AccountTable
	values
	(1025,
	'savings',
	27987.23,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 908),
	0.02,
	'',
	'08-Feb-16');
	
/
	
INSERT INTO AccountTable
	values
	(1026,
	'current',
	254.10,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 921),
	0.005,
	200,
	'08-Dec-16');
	
/
	
INSERT INTO AccountTable
	values
	(1027,
	'savings',
	7254.10,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 923),
	0.02,
	'',
	'11-Jan-17');
	
/
	
INSERT INTO AccountTable
	values
	(1028,
	'savings',
	6587.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 918),
	0.02,
	'',
	'22-Feb-16');
	
/
	
INSERT INTO AccountTable
	values
	(1029,
	'savings',
	9876.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 910),
	0.02,
	'',
	'12-Jan-08');
	
/
	
INSERT INTO AccountTable
	values
	(1030,
	'current',
	340.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 902),
	0.005,
	400,
	'11-Jul-07');
	
/
	
INSERT INTO AccountTable
	values
	(1031,
	'savings',
	11090.00,
	(SELECT REF(b)
	FROM BranchTable b
	WHERE b.bID = 902),
	0.02,
	'',
	'05-Aug-04');
	
/
--INSERT STATEMENTS FOR EMPLOYEE

INSERT INTO EmployeeTable
	values
	(Address('Dart', 'Edinburgh', 'EH10 5TT'),
	Name('Mrs', 'Alison', 'Smith'),
	Phone('01312125555', mobile_nested('07705623443', '07907812345')),
	'NI001',
	101,
	null,
	Job('Head', 50000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 901), 
						'01-Feb-01')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('New', 'Edinburgh', 'EH2 4AB'),
	Name('Mr', 'John', 'William'),
	Phone('01312031990', mobile_nested('07902314551', '07701234567')),
	'NI010',
	105,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Manager', 40000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 901), 
						'04-Mar-04')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Old', 'Edinburgh', 'EH9 4BB'),
	Name('Mr', 'Mark', 'Slack'),
	Phone('01312102211', null),
	'NI120',
	108,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 105),
	Job('Accountant', 30000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 901), 
						'01-Feb-12')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Adam', 'Edinburgh', 'EH1 6EA'),
	Name('Mr', 'Jack', 'Smith'),
	Phone('01311112223', mobile_nested('0781209890')),
	'NI810',
	804,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Leader', 35000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 908), 
						'05-Feb-14')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Collecting', 'Glasgow', 'G14 7YT'),
	Name('Mr', 'Ronald', 'Donald'),
	Phone('01311112224', mobile_nested('0781209887', '0781209857', '0781209839')),
	'NI221',
	109,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Manager', 40000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 909), 
						'22-Feb-02')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Various', 'Glasgow', 'G15 8NB'),
	Name('Mrs', 'Sarah', 'Marah'),
	Phone('01311112233', mobile_nested('0770209888', '0781209858', '0781209840')),
	'NI222',
	110,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Manager', 40000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 919), 
						'04-Feb-04')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Big', 'Glasgow', 'G14 2BB'),
	Name('Mr', 'Jon', 'Moring'),
	Phone('01311112244', mobile_nested('0781209123')),
	'NI223',
	111,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Manager', 40000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 911), 
						'24-Sep-04')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Heavy', 'Glasgow', 'G12 6RT'),
	Name('Mr', 'Donald', 'Trump'),
	Phone('01311112266', mobile_nested('0781209124')),
	'NI224',
	112,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Manager', 40000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 915), 
						'09-Oct-07')
	);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Road', 'Edinburgh', 'EH8 4KS'),
	Name('Mrs', 'Genna', 'Hitty'),
	Phone('01311112277', mobile_nested('0770209999', '0781207865', '0781209125')),
	'NI225',
	113,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Manager', 40000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 918), 
						'21-Feb-08')
);

/

INSERT INTO EmployeeTable
	values
	(Address('Rowling', 'Glasgow', 'G16 8XS'),
	Name('Mrs', 'Monica', 'Giglet'),
	Phone('01311112288', mobile_nested('0781209126', '0781209567')),
	'NI226',
	114,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 101),
	Job('Manager', 40000, 	(SELECT REF(b)
						FROM BranchTable b
						WHERE b.bID = 921), 
						'23-Mar-09')
);
	
/

INSERT INTO EmployeeTable
	values
	(Address('Earth', 'Edinburgh', 'EH9 9JQ'),
	Name('Mr', 'Robert', 'Bobert'),
	Phone('01311112299', mobile_nested('0781209127')),
	'NI227',
	115,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 105),
	Job('Accountant', 30000,(SELECT REF(b)
							FROM BranchTable b
							WHERE b.bID = 901), 
							'18-May-09')
);	

/

INSERT INTO EmployeeTable
	values
	(Address('Nice', 'Edinburgh', 'EH2 9OP'),
	Name('Mrs', 'Wera', 'Jarret'),
	Phone('01311112200', mobile_nested('0781209128')),
	'NI228',
	116,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 105),
	Job('Cashier', 25000,(SELECT REF(b)
						  FROM BranchTable b
						  WHERE b.bID = 901), 
						  '18-Jan-10')
);	

/

INSERT INTO EmployeeTable
	values
	(Address('Jeremy', 'Glasgow', 'G15 7CS'),
	Name('Mr', 'Webster', 'Baxter'),
	Phone('01314512200', mobile_nested('0781209129')),
	'NI229',
	117,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 109),
	Job('Cashier', 25000,(SELECT REF(b)
						  FROM BranchTable b
						  WHERE b.bID = 909), 
						  '14-Mar-06')
);	

/

INSERT INTO EmployeeTable
	values
	(Address('Princess', 'Glasgow', 'G13 9IU'),
	Name('Mr', 'Punit', 'Odell'),
	Phone('01314512201', mobile_nested('0781209130')),
	'NI230',
	118,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 109),
	Job('Accountant', 30000,(SELECT REF(b)
						  FROM BranchTable b
						  WHERE b.bID = 909), 
						  '11-Mar-08')
);

/

INSERT INTO EmployeeTable
	values
	(Address('Hello', 'Glasgow', 'G13 1DF'),
	Name('Mr', 'Keefe', 'Peacock'),
	Phone('01314512202', mobile_nested('0781209131')),
	'NI231',
	119,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 109),
	Job('Cashier', 25000,(SELECT REF(b)
						  FROM BranchTable b
						  WHERE b.bID = 909), 
						  '22-Aug-08')
);

/

INSERT INTO EmployeeTable
	values
	(Address('Sunflower', 'Glasgow', 'G11 0NB'),
	Name('Mrs', 'Pearlie', 'Walton'),
	Phone('', mobile_nested('0781209132')),
	'NI232',
	120,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 111),
	Job('Accountant', 30000,(SELECT REF(b)
							FROM BranchTable b
							WHERE b.bID = 911), 
							'13-Jul-09')
);

/

INSERT INTO EmployeeTable
	values
	(Address('Evil', 'Glasgow', 'G10 4GH'),
	Name('Mrs', 'Jessa', 'Gabriels'),
	Phone('01314512203', mobile_nested('0781209133')),
	'NI233',
	121,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 111),
	Job('Cashier', 25000,(SELECT REF(b)
						  FROM BranchTable b
						  WHERE b.bID = 911), 
						  '21-Jan-10')
);

/

INSERT INTO EmployeeTable
	values
	(Address('Good', 'Glasgow', 'G11 6TR'),
	Name('Mr', 'Levi', 'Simms'),
	Phone('01314512204', mobile_nested('0781209134')),
	'NI234',
	122,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 111),
	Job('Cashier', 25000,(SELECT REF(b)
						  FROM BranchTable b
						  WHERE b.bID = 911), 
						  '07-Apr-10')
);

/

INSERT INTO EmployeeTable
	values
	(Address('Master', 'Glasgow', 'G12 6VD'),
	Name('Mrs', 'Bethany', 'Knight'),
	Phone('01314512205', mobile_nested('0781209135')),
	'NI235',
	123,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 110),
	Job('Cashier', 25000,(SELECT REF(b)
						  FROM BranchTable b
						  WHERE b.bID = 919), 
						  '12-Dec-11')
);

/

INSERT INTO EmployeeTable
	values
	(Address('Ugly', 'Glasgow', 'G14 3MB'),
	Name('Mr', 'Denny', 'Gary'),
	Phone('01314512206', mobile_nested('0781209136')),
	'NI236',
	124,
	(SELECT REF(e)
	FROM EmployeeTable e
	WHERE e.empID = 110),
	Job('Accountant', 30000,(SELECT REF(b)
							FROM BranchTable b
							WHERE b.bID = 919), 
							'15-Dec-11')
);

/
--INSERT STATEMENTS FOR CUSTOMER

INSERT INTO CustomerTable
	values
	(Address('Adam', 'Edinburgh', 'EH1 6EA'),
	Name('Mr', 'Jack', 'Smith'),
	Phone('01311112223', mobile_nested('0781209890', '0770234567')),
	'NI810',
	1002);
	
/

INSERT INTO CustomerTable
	values
	(Address('Adam', 'Edinburgh', 'EH1 6EA'),
	Name('Ms', 'Anna', 'Smith'),
	Phone('01311112223', mobile_nested('0770111222')),
	'NI310',
	1003);

/

INSERT INTO CustomerTable
	values
	(Address('New', 'Edinburgh', 'EH2 8XN'),
	Name('Mr', 'Liam', 'Bain'),
	Phone('01314425567', null),
	'NI034',
	1098);
	
/

INSERT INTO CustomerTable
	values
	(Address('Sunflower', 'Glasgow', 'G11 0NB'),
	Name('Mrs', 'Pearlie', 'Walton'),
	Phone('', mobile_nested('0781209132')),
	'NI232',
	1004);
	
/

INSERT INTO CustomerTable
	values
	(Address('Hello', 'Glasgow', 'G13 1DF'),
	Name('Mr', 'Keefe', 'Peacock'),
	Phone('01314512202', mobile_nested('0781209131')),
	'NI231',
	1005);
	
/

INSERT INTO CustomerTable
	values
	(Address('Hello', 'Glasgow', 'G13 1DF'),
	Name('Mrs', 'Jenny', 'Peacock'),
	Phone('01314512202', mobile_nested('0770209142', '0770208242')),
	'NI340',
	1006);
	
/

INSERT INTO CustomerTable
	values
	(Address('Earth', 'Edinburgh', 'EH9 9JQ'),
	Name('Mr', 'Robert', 'Bobert'),
	Phone('01311112299', mobile_nested('0781209127')),
	'NI227',
	1007);
	
/

INSERT INTO CustomerTable
	values
	(Address('Earth', 'Edinburgh', 'EH9 9JQ'),
	Name('Ms', 'Robertina', 'Bobert'),
	Phone('01311112299', mobile_nested('0770209345')),
	'NI341',
	1008);
	
/

INSERT INTO CustomerTable
	values
	(Address('Evil', 'Glasgow', 'G10 4GH'),
	Name('Mrs', 'Jessa', 'Gabriels'),
	Phone('01314512203', mobile_nested('0781209133')),
	'NI233',
	1009);
	
/

INSERT INTO CustomerTable
	values
	(Address('Evil', 'Glasgow', 'G10 4GH'),
	Name('Mr', 'John', 'Gabriels'),
	Phone('01314512203', mobile_nested('0770123456', '0770123489', '0770125436')),
	'NI342',
	1010);
	
/

INSERT INTO CustomerTable
	values
	(Address('Princess', 'Glasgow', 'G13 9IU'),
	Name('Mr', 'Punit', 'Odell'),
	Phone('01314512201', mobile_nested('0781209130')),
	'NI230',
	1011);
	
/

INSERT INTO CustomerTable
	values
	(Address('Ugly', 'Glasgow', 'G14 3MB'),
	Name('Mr', 'Denny', 'Gary'),
	Phone('01314512206', mobile_nested('0781209136')),
	'NI236',
	1012);
	
/

INSERT INTO CustomerTable
	values
	(Address('Good', 'Glasgow', 'G11 6TR'),
	Name('Mr', 'Levi', 'Simms'),
	Phone('01314512204', mobile_nested('0781209134')),
	'NI234',
	1013);
	
/

INSERT INTO CustomerTable
	values
	(Address('Road', 'Edinburgh', 'EH8 4KS'),
	Name('Mrs', 'Genna', 'Hitty'),
	Phone('01311112277', mobile_nested('0770209999', '0781207865', '0781209125')),
	'NI225',
	1014);
	
/

INSERT INTO CustomerTable
	values
	(Address('Various', 'Glasgow', 'G15 8NB'),
	Name('Mrs', 'Sarah', 'Marah'),
	Phone('01311112233', mobile_nested('0770209888', '0781209858', '0781209840')),
	'NI222',
	1015);
	
/

INSERT INTO CustomerTable
	values
	(Address('Big', 'Glasgow', 'G14 2BB'),
	Name('Mr', 'Jon', 'Moring'),
	Phone('01311112244', mobile_nested('0781209123')),
	'NI223',
	1016);
	
/

INSERT INTO CustomerTable
	values
	(Address('Heavy', 'Glasgow', 'G12 6RT'),
	Name('Mr', 'Donald', 'Trump'),
	Phone('01311112266', mobile_nested('0781209124')),
	'NI224',
	1017);
	
/

INSERT INTO CustomerTable
	values
	(Address('Master', 'Glasgow', 'G12 6VD'),
	Name('Mrs', 'Bethany', 'Knight'),
	Phone('01314512205', mobile_nested('0781209135')),
	'NI235',
	1018);
	
/

INSERT INTO CustomerTable
	values
	(Address('Jeremy', 'Glasgow', 'G15 7CS'),
	Name('Mr', 'Webster', 'Baxter'),
	Phone('01314512200', mobile_nested('0781209129')),
	'NI229',
	1019);
	
/

INSERT INTO CustomerTable
	values
	(Address('Nice', 'Edinburgh', 'EH2 9OP'),
	Name('Mrs', 'Wera', 'Jarret'),
	Phone('01311112200', mobile_nested('0781209128')),
	'NI228',
	1020);
	

/
--INSERT STATEMENTS FOR CUSTOMERACCOUNT

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1002),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1001));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1002),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1010));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1003),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1010));

/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1098),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 8002));

/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1004),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1012));

/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1004),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1013));	
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1005),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1011));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1005),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1015));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1006),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1011));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1007),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1024));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1007),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1028));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1008),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1024));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1009),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1014));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1009),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1019));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1010),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1019));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1011),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1017));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1012),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1026));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1013),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1021));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1013),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1022));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1014),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1029));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1015),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1025));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1016),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1023));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1017),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1018));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1017),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1020));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1018),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1027));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1019),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1016));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1020),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1030));
	
/

INSERT INTO CustomerAccountTable
	values
	((SELECT REF(c)
	FROM CustomerTable c
	WHERE c.custID = 1020),
	(SELECT REF(a)
	FROM AccountTable a
	WHERE a.accNum = 1031));
	