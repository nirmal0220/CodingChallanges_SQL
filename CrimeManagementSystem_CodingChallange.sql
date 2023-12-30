create database CARS_CC
use CARS_CC

CREATE TABLE Crime (
 CrimeID INT PRIMARY KEY,
 IncidentType VARCHAR(255),
 IncidentDate DATE,
 Location VARCHAR(255),
 Description TEXT,
 Status VARCHAR(20)
);
CREATE TABLE Victim (
 VictimID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 ContactInfo VARCHAR(255),
 Injuries VARCHAR(255),
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);
CREATE TABLE Suspect (
 SuspectID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 Description TEXT,
 CriminalHistory TEXT,
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);
-- Insert sample data
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description,
Status)
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a
convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a
murder case', 'Under Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a
mall', 'Closed');
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)
VALUES
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES
 (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
 (2, 2, 'Unknown', 'Investigation ongoing', NULL),
 (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

--1)
 select * from crime where Status='open';

--2)
 select count(*) as total_no_of_incidents from crime;

--3)
select distinct IncidentType from crime;

--4)
select * from crime where [IncidentDate]  between '2023-09-01' and '2023-09-10';

--5)
--no dob column in suspect so adding new column
alter table suspect add DOB date;

--adding data

update suspect 
set DOB='2002-01-10'
where SuspectID=1;

update suspect 
set DOB='2000-10-03'
where SuspectID=2;

update suspect 
set DOB='1988-08-11'
where SuspectID=3;

select * from suspect order by DOB desc ;

--6)
select avg(abs(datediff(year,getdate(),dob))) as avg_date from suspect;

--7)
select [IncidentType],count(*) as total_cases 
from [dbo].[Crime]
where [Status]='open'
group by  [IncidentType];

--8)
select name from suspect where name like '%Doe%'
union 
select name from victim where name like '%Doe%'

--9)
select name from suspect where suspectID in(select [SuspectID] from crime where status in('open','closed'))
union
select name from Victim where VictimID in(select VictimID from crime where status in('open','closed'))

--10)
select [IncidentType] from crime 
where CrimeID in ( select CrimeID from Suspect where abs(DATEDIFF(year,DOB,getdate())) in(30,35))

--11)
select name from suspect where crimeid in( select crimeid from crime where IncidentType='Robbery')
union
select name from Victim where crimeid in( select crimeid from crime where IncidentType='Robbery')

--12)
--inserting 1 more open case having incident type Robbery
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description,
Status)
VALUES
 (4, 'Robbery', '2023-10-05', '132 main street, pune', 'Armed robbery at a
bank', 'Open');

select [IncidentType] from crime 
where status='open'
group by [IncidentType] 
having count(*)>1;

--13)
--adding one victim who is already a suspect and new crime
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES
 (4, 5, 'Jane Smith', 'Armed thifes', 'Previous robbery convictions');

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description,
Status)
VALUES
 (5, 'Robbery', '2023-09-20', '123 Main St, Mumbai', 'Armed robbery at a
home', 'Closed');

select * from suspect where name in (select victim.name from victim inner join crime on Victim.CrimeID=crime.CrimeID )

--14)
select crime.*,suspect.name as Suspect_name, victim.name as Victim_name
from crime left join suspect 
on crime.CrimeID=suspect.CrimeID
left join victim on crime.CrimeID=victim.CrimeID

--15)
--no dob column in suspect so adding new column
alter table victim add DOB date;

--adding data

update victim 
set DOB='2003-11-10'
where victimID=1;

update victim 
set DOB='2002-01-10'
where victimID=2;

update victim 
set DOB='2000-12-10'
where victimID=3;

select crime.*,suspect.name as Suspect_name, victim.name as Victim_name
from crime  join suspect 
on crime.CrimeID=suspect.CrimeID
 join victim on crime.CrimeID=victim.CrimeID
where abs(DATEDIFF(year,suspect.DOB,getdate()))>abs(DATEDIFF(year,victim.DOB,getdate()))


--16)
select Suspect.SuspectID, suspect.name from suspect 
group by suspect.SuspectID,Suspect.name
having count(*)>1;

--17)
select * from crime where crimeid not in(select crimeid from suspect );

--18)
--no case table is given

--19)
select crime.*, 
case 
	when suspect.name is null or suspect.name='Unknown' then 'No Suspect'
	else suspect.name
end as suspect_name
from crime left join suspect 
on crime.CrimeID=suspect.CrimeID;

--20)

select * from suspect where crimeid in 
( select crimeid from crime 
where [IncidentType] in('Robbery','Assault'));