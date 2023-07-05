use project
 GO

--DOWN
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_student_schedules_schedule_id')
   ALTER table student_schedules drop CONSTRAINT fk_student_schedules_schedule_id
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_student_schedules_SUID')
   ALTER table student_schedules drop CONSTRAINT fk_student_student_SUID
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_students_student_workstation_name')
   ALTER table students drop CONSTRAINT fk_students_student_workstation_name
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_students_student_employer_name')
   ALTER table students drop CONSTRAINT fk_students_student_employer_name
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_student_jobtitles_jobtitle_id')
   ALTER table student_jobtitles drop CONSTRAINT fk_student_jobtitles_jobtitle_id
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_student_jobtitles_student_SUID')
   ALTER table student_jobtitles drop CONSTRAINT fk_student_jobtitles_student_SUID
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_workstation_schedules_workstation_name')
   ALTER table workstation_schedules drop CONSTRAINT fk_workstation_schedules_workstation_name
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_workstation_schedules_schedule_id')
   ALTER table workstation_schedules drop CONSTRAINT fk_workstation_schedules_schedule_id
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_subshifts_sub_schedule_id')
   ALTER table subshifts drop CONSTRAINT fk_subshifts_sub_schedule_id
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_subshifts_subbed_by')
   ALTER table subshifts drop CONSTRAINT fk_subshifts_subbed_by
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_subshifts_taken_by')
   ALTER table subshifts drop CONSTRAINT fk_subshifts_taken_by

drop table if exists subshifts
Drop table if exists workstation_schedules
Drop table if exists workstations
Drop table if exists student_jobtitles
Drop table if exists student_schedules
drop table if exists jobtitles
drop table if exists schedules
drop table if exists employers
drop table if exists students
GO

--UP

--students table
create table students(
student_SUID varchar(15) NOT NULL,
student_firstname varchar(50) NOT NULL,
student_lastname varchar(50) NOT NULL,
student_hiredate date NOT NULL,
student_jobtitle varchar(50) NOT NULL,
student_payrate Int NOT NULL,
student_employer_name VARCHAR(50) NOT NULL,
student_workstation_name varchar(50) NOT NULL

constraint pk_students_student_SUID Primary Key(student_SUID)
)
alter table students 
ADD constraint uk_students_employer_name_workstation_name UNIQUE (student_employer_name,student_workstation_name)
GO

--Employer lookup table

GO
create table employers_lookup (
employer_name varchar(50) NOT NULL,
employer_address varchar(25) NOT NULL,
employer_contact bigint NOT NULL
 
constraint pk_employers_lookup_employer_name Primary Key(employer_name),
constraint uk_employers_lookup_emplpoyer_contact UNIQUE (employer_contact)
)


-- jobtitles lookup Table

GO

create table jobtitles_lookup (
jobtitle_id int NOT NULL,   
jobtitle_name varchar(50) NOT NULL,
constraint uk_jobtitles_lookup_jobtitle_name Unique(jobtitle_name),   
constraint pk_jobtitles_lookup_jobtitle_id Primary Key(jobtitle_id)
)

--Workstations lookup table

GO
Create Table workstations_lookup (
workstation_name varchar(50) NOT NULL,
    
Constraint pk_workstations_lookup_workstation_name Primary Key(workstation_name),
Constraint uk_workstation_lookup_workstation_name Unique (workstation_name)
)
--permanent schedule table

GO

create Table schedules (
schedule_id int identity,
assigned_to varchar(15) not null,
workstation_name varchar(50) NOT NULL, 
schedule_from time NOT NULL,
schedule_to time NOT NULL,
schedule_date date NOT NULL,
schedule_day VARCHAR(50) NOT NULL,
    
constraint pk_schedules_schedule_id Primary Key(schedule_id),
constraint fk_schedules_assigned_to foreign key (assigned_to) references students (student_SUID),
constraint fk_schedules_workstation_name foreign key (workstation_name) references workstations (workstation_name)
)



GO
/*Create Table student_schedules(
schedule_id int NOT NULL,   
student_SUID varchar(15) NOT NULL, 
student_schedule VARCHAR(50) Null,    
CONSTRAINT pk_student_schedules_schedule_id PRIMARY KEY(schedule_id, student_SUID),
CONSTRAINT fk_student_schedules_schedule_id FOREIGN KEY (schedule_id) REFERENCES schedules (schedule_id),
CONSTRAINT fk_student_schedules_student_SUID FOREIGN KEY (student_SUID) REFERENCES students (student_SUID)
)*/

-- student jobtitles Table

GO
Create Table student_jobtitles(
student_SUID varchar(15) not NULL,   
jobtitle_id int NOT NULL,     
CONSTRAINT pk_student_jobtitles_student_SUID PRIMARY KEY(student_SUID, jobtitle_id),
CONSTRAINT fk_student_jobtitles_jobtitle_id FOREIGN KEY (jobtitle_id) REFERENCES jobtitles (jobtitle_id),
CONSTRAINT fk_student_jobtitles_student_SUID FOREIGN KEY (student_SUID) REFERENCES students (student_SUID)
)

ALTER table students 
ADD Constraint fk_students_student_employer_name Foreign Key(student_employer_name) References employers(employer_name),
Constraint fk_students_student_workstation_name Foreign Key(student_workstation_name) References workstations(workstation_name)
GO

--workstation schedules
GO

/*create table workstation_schedules(
workstation_name VARCHAR(50) NOT NULL,  
schedule_id int NOT NULL,    
CONSTRAINT pk_workstation_schedules_worskstation_id PRIMARY KEY(workstation_name, schedule_id),
CONSTRAINT fk_workstation_schedules_workstation_name FOREIGN KEY (workstation_name) REFERENCES workstations (workstation_name), 
CONSTRAINT fk_workstation_schedules_schedule_id FOREIGN KEY (schedule_id) REFERENCES schedules (schedule_id)
)*/

-- Sub-shifts table
 create table subshifts(
 sub_id int NOT NULL, 
 sub_schedule_id int NOT NULL, --schedule id of the shift being subbed
 subbed_by varchar(15) NOT NULL, --SUID of student subbing the shift   
 taken_by varchar(15) , --SUID of student taking the shift  
 constraint pk_subshifts_sub_id primary key(sub_id),
 constraint fk_subshifts_sub_schedule_id FOREIGN KEY (sub_schedule_id) REFERENCES schedules (schedule_id),
 constraint fk_subshifts_subbed_by foreign key (subbed_by) references students (student_SUID),
-- constraint fk_subshifts_taken_by foreign key (taken_by) references students (student_SUID)
 )
GO
alter table subshifts
    add constraint default_taken_by DEFAULT 'Vacant' FOR taken_by

GO
--Inserting values

INSERT INTO jobtitles VALUES (1, 'General Employee')
INSERT INTO jobtitles VALUES (2, 'Supervisor')


INSERT INTO workstations VALUES ('Deli')
INSERT INTO workstations VALUES ('Hotline')
INSERT INTO workstations VALUES ('Salads')
INSERT INTO workstations VALUES ('Vegan')
INSERT INTO workstations VALUES ('Dishroom')
INSERT INTO workstations VALUES ('Dining Room')
INSERT INTO workstations VALUES ('Express')
INSERT INTO workstations VALUES ('Dessert')
INSERT INTO workstations VALUES ('Beverages')
INSERT INTO workstations VALUES ('Gluten Free')


INSERT INTO employers ( employer_name, employer_address, employer_contact) VALUES ('Sadler Dining', 'Sims Drive street', 6809108108)
INSERT INTO employers ( employer_name, employer_address, employer_contact) VALUES ( 'Graham Dining',' Comstock street',  6809108121)
INSERT INTO employers (employer_name, employer_address, employer_contact) VALUES ( 'Ernie Davis Dining',' University Ave',  6803434565)
INSERT INTO employers (employer_name, employer_address, employer_contact) VALUES ( 'Shaw Dining',' Euclid street',  6809809977)
INSERT INTO employers ( employer_name, employer_address, employer_contact) VALUES ( 'Brockway Dining',' Van Buren street',  6801133242)

INSERT into schedules values( '09:00:00','13:00:00', '2021-11-22', 'Monday')
INSERT into schedules values( '13:00:00','17:00:00', '2021-11-22', 'Monday')
INSERT into schedules values( '17:00:00','21:00:00', '2021-11-22', 'Monday')
INSERT into schedules values( '09:00:00','13:00:00', '2021-11-23', 'Tuesday')
INSERT into schedules values( '13:00:00','17:00:00', '2021-11-23', 'Tuesday')
INSERT into schedules values( '17:00:00','21:00:00', '2021-11-23', 'Tuesday')
INSERT into schedules values( '09:00:00','13:00:00', '2021-11-24', 'Wednesday')
INSERT into schedules values( '13:00:00','17:00:00', '2021-11-24', 'Wednesday')
INSERT into schedules values('17:00:00','21:00:00', '2021-11-24', 'Wednesday')
INSERT into schedules values( '09:00:00','13:00:00', '2021-11-25', 'Thursday')
INSERT into schedules values( '13:00:00','17:00:00', '2021-11-25', 'Thursday')
INSERT into schedules values( '17:00:00','21:00:00', '2021-11-25', 'Thursday')
INSERT into schedules values( '09:00:00','13:00:00', '2021-11-26', 'Friday')
INSERT into schedules values( '13:00:00','17:00:00', '2021-11-26', 'Friday')
INSERT into schedules values( '17:00:00','21:00:00', '2021-11-26', 'Friday')
INSERT into schedules values( '09:00:00','13:00:00', '2021-11-27', 'Saturday')
INSERT into schedules values( '13:00:00','17:00:00', '2021-11-27', 'Saturday')
INSERT into schedules values( '17:00:00','21:00:00', '2021-11-27', 'Saturday')
INSERT into schedules values( '09:00:00','13:00:00', '2021-11-28', 'Sunday')
INSERT into schedules values( '13:00:00','17:00:00', '2021-11-28', 'Sunday')
INSERT into schedules values( '17:00:00','21:00:00', '2021-11-28', 'Sunday')

INSERT into students values (358554918,	'Ankita',	'Vartak',	'08/30/2021',	'General Employee',15,'Sadler Dining','Deli')
INSERT into students values (660307939,	'Chaitanya','Attarde',	'09/02/2021',	'General Employee',	15,'Sadler Dining', 'Salads')																		
INSERT into students values (859436780,	'Aishwary',	'Patel',	'09/04/2021',	'General Employee',	15,	'Ernie Davis Dining', 'Vegan')																		
INSERT into students values (812995446,	'Shivani',   'Pol',	    '09/01/2021',	'General Employee',	15,	'Graham Dining', 'Salads')																		
INSERT into students values (955036125,	'Vamsy',   'Krishna',	'08/31/2021',	'Supervisor',       17,	'Ernie Davis Dining', 'Dishroom')																		
INSERT into students values (411946624,	'Nivesh',	'Vaze',	    '09/05/2021',	'General Employee',	15,	'Brockway Dining', 'Hotline')																		
INSERT into students values (475885683,	'Anushree',	 'Keni',	'10/03/2021',	'General Employee',	15,	'Shaw Dining', 'Deli')																		
INSERT into students values (324669421,	'Abhijeet',	'Gokhale',	'08/28/2021',	'Supervisor',	    17,	'Sadler Dining', 'Vegan')																		
INSERT into students values (452175821,	'Nikita',	'Sirwani',	'09/03/2021',	'General Employee',	15,	'Graham Dining', 'Hotline')																		
INSERT into students values (458231945,	'Ruzan',	'Shaikh',	'09/15/2021',	'Student Manager',	18,	'Graham Dining', 'Dishroom')

/*INSERT into student_schedules VALUES(1,358554918, 'Ankita_shift')
INSERT into student_schedules VALUES(2,458231945, 'Ruz_shift')*/

/*INSERT into workstation_schedules values('Deli',1)
INSERT into workstation_schedules values('Dishroom',2)
INSERT into workstation_schedules values('Salads',3)
INSERT into workstation_schedules values('Vegan',4)
INSERT into workstation_schedules values('Hotline',5)
INSERT into workstation_schedules values('Vegan',1)*/

INSERT into subshifts  values (1,1,'358554918','859436780')
INSERT into subshifts  values (1,3,'859436780',default)



--VIEWS
--Drop Views(list of schedules) if exist

if exists(select * from sys.objects where name='Sadler Schedule')
	drop view [Sadler Schedule]

if exists(select * from sys.objects where name='Graham Schedule')
	drop view [Graham Schedule]

if exists(select * from sys.objects where name='Ernie Davis Schedule')
	drop view [Ernie Davis Schedule]

if exists(select * from sys.objects where name='Shaw Schedule')
	drop view [Shaw Schedule]

if exists(select * from sys.objects where name='Brockway Schedule')
	drop view [Brockway Schedule]

--Drop Views(list of employee) if exist

if exists(select * from sys.objects where name='Sadler Students')
	drop view [Sadler Students]

if exists(select * from sys.objects where name='Graham Students')
	drop view [Graham Students]

if exists(select * from sys.objects where name='Ernie Davis Students')
	drop view [Ernie Davis Students]

if exists(select * from sys.objects where name='Shaw Students')
	drop view [Shaw Students]

if exists(select * from sys.objects where name='Brockway Students')
	drop view [Brockway Students]


GO

--Current schedule of Sadler Dining--
CREATE VIEW [Sadler Schedule] AS
select s.student_SUID, s.student_firstname +' '+s.student_lastname as student_name, s.student_jobtitle, e.employer_name, w.workstation_name, sc.schedule_from, sc.schedule_to, schedule_date, sc.schedule_day
from students s
join employers e on s.student_employer_name = e.employer_name
join workstations w on s.student_workstation_name = w.workstation_name
join student_schedules ss on s.student_SUID = ss.student_SUID
join schedules sc on ss.schedule_id = sc.schedule_id
where e.employer_name='Sadler Dining';

GO

--Current schedule of Graham Dining--
CREATE VIEW [Graham Schedule] AS
select s.student_SUID, s.student_firstname +' '+s.student_lastname as student_name, s.student_jobtitle, e.employer_name, w.workstation_name, sc.schedule_from, sc.schedule_to, schedule_date, sc.schedule_day
from students s
join employers e on s.student_employer_name = e.employer_name
join workstations w on s.student_workstation_name = w.workstation_name
join student_schedules ss on s.student_SUID = ss.student_SUID
join schedules sc on ss.schedule_id = sc.schedule_id
where e.employer_name='Graham Dining';

GO
--Current schedule of Ernie Davis Dining--
CREATE VIEW [Ernie Davis Schedule] AS
select s.student_SUID, s.student_firstname +' '+s.student_lastname as student_name, s.student_jobtitle, e.employer_name, w.workstation_name, sc.schedule_from, sc.schedule_to, schedule_date, sc.schedule_day
from students s
join employers e on s.student_employer_name = e.employer_name
join workstations w on s.student_workstation_name = w.workstation_name
join student_schedules ss on s.student_SUID = ss.student_SUID
join schedules sc on ss.schedule_id = sc.schedule_id
where e.employer_name='Ernie Davis Dining';

GO
--Current schedule of Shaw Dining Dining--
CREATE VIEW [Shaw Schedule] AS
select s.student_SUID, s.student_firstname +' '+s.student_lastname as student_name, s.student_jobtitle, e.employer_name, w.workstation_name, sc.schedule_from, sc.schedule_to, schedule_date, sc.schedule_day
from students s
join employers e on s.student_employer_name = e.employer_name
join workstations w on s.student_workstation_name = w.workstation_name
join student_schedules ss on s.student_SUID = ss.student_SUID
join schedules sc on ss.schedule_id = sc.schedule_id
where e.employer_name='Shaw Dining';

GO
--Current schedule of Brockway Dining--
CREATE VIEW [Brockway Schedule] AS
select s.student_SUID, s.student_firstname +' '+s.student_lastname as student_name, s.student_jobtitle, e.employer_name, w.workstation_name, sc.schedule_from, sc.schedule_to, schedule_date, sc.schedule_day
from students s
join employers e on s.student_employer_name = e.employer_name
join workstations w on s.student_workstation_name = w.workstation_name
join student_schedules ss on s.student_SUID = ss.student_SUID
join schedules sc on ss.schedule_id = sc.schedule_id
where e.employer_name='Brockway Dining';

GO

--View for list of employees at specific dining 

--Total students at Sadler Dining--
CREATE VIEW [Sadler Students] AS
select * from students 
join employers on student_employer_name = employer_name
where employer_name='Sadler Dining';

GO
--Total students at Graham Dining--
CREATE VIEW [Graham Students] AS
select * from students 
join employers on student_employer_name = employer_name
where employer_name='Graham Dining';

GO
--Total students at Ernie Davis Dining--
CREATE VIEW [Ernie Davis Students] AS
select * from students 
join employers on student_employer_name = employer_name
where employer_name='Ernie Davis Dining';

GO
--Total students at Shaw Dining--
CREATE VIEW [Shaw Students] AS
select * from students 
join employers on student_employer_name = employer_name
where employer_name='Shaw Dining';

GO

--Total students at Brockway Dining--
CREATE VIEW [Brockway Students] AS
select * from students 
join employers on student_employer_name = employer_name
where employer_name='Brockway Dining';

GO
--Current Subshift table
create view [Current Subshift Table] AS
select *
from students s
join subshifts sb on s.student_SUID = sb.subbed_by
join student_schedules ss on s.student_SUID = ss.student_SUID
join workstations w on s.student_workstation_name = w.workstation_name


GO

select * from students
select * from schedules
select * from student_schedules
select * from [subshifts]