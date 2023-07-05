--create database capstone_project_bjob01 
--use capstone_project_bjob01


--DOWN

if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_schedules_workstation_name')
   ALTER table schedules drop CONSTRAINT fk_schedules_workstation_name
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_schedules_assigned_to')
   ALTER table schedules drop CONSTRAINT fk_schedules_assigned_to
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_subshifts_sub_schedule_id')
   ALTER table subshifts drop CONSTRAINT fk_subshifts_sub_schedule_id
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_subshifts_subbed_by')
   ALTER table subshifts drop CONSTRAINT fk_subshifts_subbed_by
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_sub_take_up_sub_id')
   ALTER table sub_take_up drop CONSTRAINT fk_sub_take_up_sub_id
if EXISTS (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE CONSTRAINT_NAME = 'fk_sub_take_up_taken_by')
   ALTER table sub_take_up drop CONSTRAINT fk_sub_take_up_taken_by

drop table if exists sub_take_up
drop table if exists subshifts
drop table if exists students
drop table if exists schedules
drop table if exists jobtitles_lookup
drop table if exists employers_lookup
drop table if exists workstations_lookup

--UP

--Job Title Lookup : There are mainly two job titles : General Employee and Supervisor
create table jobtitles_lookup (
jobtitle_id int NOT NULL,   
jobtitle_name varchar(50) NOT NULL,
constraint uk_jobtitles_lookup_jobtitle_name Unique(jobtitle_name),   
constraint pk_jobtitles_lookup_jobtitle_id Primary Key(jobtitle_id)
)
GO

--Employer Lookup : This table will store the anmes of all dining halls
create table employers_lookup (
employer_name varchar(50) NOT NULL,
employer_address varchar(25) NOT NULL,
employer_contact bigint NOT NULL
 
constraint pk_employers_lookup_employer_name Primary Key(employer_name),
constraint uk_employers_lookup_emplpoyer_contact UNIQUE (employer_contact)
)
GO

--workstations_lookup lookup : This describes the typemof workstation assigned to an employee at each dining hall
Create Table workstations_lookup (
workstation_name varchar(50) NOT NULL,
    
Constraint pk_workstations_lookup_workstation_name Primary Key(workstation_name),
Constraint uk_workstation_lookup_workstation_name Unique (workstation_name)
)
GO

--students table : store the student employee details
create table students(
student_SUID varchar(15) NOT NULL,
student_firstname varchar(50) NOT NULL,
student_lastname varchar(50) NOT NULL,
student_jobtitle varchar(50) NOT NULL,
student_employer_name VARCHAR(50) NOT NULL,
student_workstation_name varchar(50) NOT NULL,

constraint pk_students_student_SUID Primary Key(student_SUID),
constraint fk_students_job_title foreign key (student_jobtitle) references jobtitles_lookup (jobtitle_name),
constraint fk_students_employer_name foreign key (student_employer_name) references employers_lookup (employer_name),
constraint fk_students_workstation_name foreign key (student_workstation_name) references workstations_lookup (workstation_name)
)
alter table students 
ADD constraint uk_students_employer_name_workstation_name UNIQUE (student_employer_name,student_workstation_name)
GO

--Permanent fixed schedule
create Table schedules (
schedule_id int identity(1,1),
assigned_to varchar(15) not null,
workstation_name varchar(50) NOT NULL, 
schedule_from time NOT NULL,
schedule_to time NOT NULL,
schedule_day VARCHAR(50) NOT NULL,
    
constraint pk_schedules_schedule_id Primary Key(schedule_id),
constraint fk_schedules_assigned_to foreign key (assigned_to) references students (student_SUID),
constraint fk_schedules_workstation_name foreign key (workstation_name) references workstations_lookup (workstation_name)
)
GO

--Sub Shifts table
create table subshifts(
    sub_id int identity(1,1),
    sub_schedule_id int not null,
    subbed_by varchar(15) not null,

    constraint pk_subshifts_sub_id primary key (sub_id),
    constraint fk_subshifts_sub_schedule_id foreign key (sub_schedule_id) references schedules (schedule_id),
    constraint fk_subshifts_subbed_by foreign key (subbed_by) references students (student_SUID)
)
GO
--takeup
create table sub_take_up(
    sub_id int not null,
    taken_by  varchar(15) not null,

    constraint fk_sub_take_up_sub_id foreign key (sub_id) references subshifts (sub_id),
    constraint fk_sub_take_up_taken_by foreign key (taken_by) references students (student_SUID)
)
alter table sub_take_up
    add constraint uk_sub_take_up_sub_id UNIQUE (sub_id)
GO

--Inserting Values 

INSERT INTO jobtitles_lookup VALUES (1, 'General Employee')
INSERT INTO jobtitles_lookup VALUES (2, 'Supervisor')


INSERT INTO workstations_lookup VALUES ('Deli')
INSERT INTO workstations_lookup VALUES ('Hotline')
INSERT INTO workstations_lookup VALUES ('Salads')
INSERT INTO workstations_lookup VALUES ('Vegan')
INSERT INTO workstations_lookup VALUES ('Dishroom')
INSERT INTO workstations_lookup VALUES ('Dining Room')
INSERT INTO workstations_lookup VALUES ('Express')
INSERT INTO workstations_lookup VALUES ('Dessert')
INSERT INTO workstations_lookup VALUES ('Beverages')
INSERT INTO workstations_lookup VALUES ('Gluten Free')


INSERT INTO employers_lookup ( employer_name, employer_address, employer_contact) VALUES ('Sadler Dining', 'Sims Drive street', 6809108108)
INSERT INTO employers_lookup ( employer_name, employer_address, employer_contact) VALUES ( 'Graham Dining',' Comstock street',  6809108121)
INSERT INTO employers_lookup (employer_name, employer_address, employer_contact) VALUES ( 'Ernie Davis Dining',' University Ave',  6803434565)
INSERT INTO employers_lookup (employer_name, employer_address, employer_contact) VALUES ( 'Shaw Dining',' Euclid street',  6809809977)
INSERT INTO employers_lookup ( employer_name, employer_address, employer_contact) VALUES ( 'Brockway Dining',' Van Buren street',  6801133242)

INSERT into students values (358554918,	'Ankita',	'Vartak','General Employee','Sadler Dining','Deli')
INSERT into students values (660307939,	'Chaitanya','Attarde','General Employee','Sadler Dining', 'Salads')																		
INSERT into students values (859436780,	'Aishwary',	'Patel','General Employee',	'Ernie Davis Dining', 'Vegan')																		
INSERT into students values (812995446,	'Shivani',   'Pol',	 'General Employee',	'Graham Dining', 'Salads')																		
INSERT into students values (955036125,	'Vamsy',   'Krishna','Supervisor',	'Ernie Davis Dining', 'Dishroom')																		
INSERT into students values (411946624,	'Nivesh',	'Vaze',	'General Employee',	'Brockway Dining', 'Hotline')																		
INSERT into students values (475885683,	'Anushree',	 'Keni',	'General Employee',	'Shaw Dining', 'Deli')																		
INSERT into students values (324669421,	'Abhijeet',	'Gokhale',	'Supervisor',	'Sadler Dining', 'Vegan')																		
INSERT into students values (452175821,	'Nikita',	'Sirwani',	'General Employee',	'Graham Dining', 'Hotline')																		
INSERT into students values (458231945,	'Ruzan',	'Shaikh',	'General Employee',	'Graham Dining', 'Dishroom')
 
INSERT into schedules values( 358554918,'Deli','09:00:00','13:00:00', 'Monday')
INSERT into schedules values( 358554918,'Hotline','13:00:00','17:00:00', 'Monday')
INSERT into schedules values(358554918,'Salads', '17:00:00','21:00:00',  'Monday')
INSERT into schedules values(660307939,'Vegan', '09:00:00','13:00:00',  'Tuesday')
INSERT into schedules values(660307939,'Dishroom', '13:00:00','17:00:00', 'Tuesday')
INSERT into schedules values(660307939,'Dining Room', '17:00:00','21:00:00', 'Tuesday')
INSERT into schedules values( 859436780,'Express','09:00:00','13:00:00', 'Wednesday')
INSERT into schedules values( 859436780,'Dessert','13:00:00','17:00:00',  'Wednesday')
INSERT into schedules values(859436780,'Beverages','17:00:00','21:00:00', 'Wednesday')
INSERT into schedules values( 812995446,'Gluten Free','09:00:00','13:00:00', 'Thursday')
INSERT into schedules values(812995446,'Deli', '13:00:00','17:00:00',  'Thursday')
INSERT into schedules values(812995446,'Hotline', '17:00:00','21:00:00',  'Thursday')
INSERT into schedules values(955036125,'Salads', '09:00:00','13:00:00', 'Friday')
INSERT into schedules values(955036125,'Vegan', '13:00:00','17:00:00','Friday')
INSERT into schedules values(955036125,'Dishroom', '17:00:00','21:00:00', 'Friday')
INSERT into schedules values(411946624,'Dining Room', '09:00:00','13:00:00', 'Saturday')
INSERT into schedules values(475885683,'Express', '13:00:00','17:00:00', 'Saturday')
INSERT into schedules values(324669421,'Dessert', '17:00:00','21:00:00', 'Saturday')
INSERT into schedules values(452175821,'Beverages', '09:00:00','13:00:00', 'Sunday')
INSERT into schedules values(458231945,'Gluten Free', '13:00:00','17:00:00', 'Sunday')
INSERT into schedules values(458231945,'Deli', '17:00:00','21:00:00', 'Sunday')

INSERT into subshifts values (22,358554918)
INSERT into subshifts values (25,660307939)
INSERT into subshifts values (30,859436780)

INSERT into sub_take_up values (3,812995446)
INSERT into sub_take_up values (2,955036125)

GO


--VIEWS

--DROP
if exists(select * from sys.objects where name='Student Schedule')
	drop view [Student Schedule]

if exists(select * from sys.objects where name='Available Sub Shifts')
	drop view [Available Sub Shifts]

if exists(select * from sys.objects where name='Taken Sub Shifts')
	drop view [Taken Sub Shifts]

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

-- All shifts for a particular student
GO
create view [Student Schedule] as
select s.student_SUID, s.student_firstname + ' ' + s.student_lastname as student_name, sd.schedule_id, 
        sd.workstation_name, sd.schedule_from, sd. schedule_to, sd.schedule_day
    from schedules sd
        join students s on s.student_SUID = sd.assigned_to
    

GO
--Available Subshifts
create view [Available Sub Shifts] AS
select ss.sub_id, sd.schedule_id,ss.subbed_by, sd.workstation_name, sd.schedule_from, sd.schedule_to, sd.schedule_day  
    from schedules sd
     join subshifts ss on ss.sub_schedule_id = sd.schedule_id

GO

--Taken Subshifts
create view [Taken Sub Shifts] AS
select ss.sub_id, sd.schedule_id,ss.subbed_by, sd.workstation_name, sd.schedule_from, sd.schedule_to, sd.schedule_day,
        st.taken_by
    from subshifts ss
     join schedules sd  on ss.sub_schedule_id = sd.schedule_id
     join sub_take_up st on st.sub_id = ss.sub_id

GO 

--View for list of employees at specific dining 

--Total students at Sadler Dining--
CREATE VIEW [Sadler Students] AS
select * from students
join employers_lookup on student_employer_name = employer_name
where employer_name='Sadler Dining';

GO
--Total students at Graham Dining--
CREATE VIEW [Graham Students] AS
select * from students 
join employers_lookup on student_employer_name = employer_name
where employer_name='Graham Dining';

GO
--Total students at Ernie Davis Dining--
CREATE VIEW [Ernie Davis Students] AS
select * from students 
join employers_lookup on student_employer_name = employer_name
where employer_name='Ernie Davis Dining';

GO
--Total students at Shaw Dining--
CREATE VIEW [Shaw Students] AS
select * from students 
join employers_lookup on student_employer_name = employer_name
where employer_name='Shaw Dining'; 

GO

--Total students at Brockway Dining--
CREATE VIEW [Brockway Students] AS
select * from students 
join employers_lookup on student_employer_name = employer_name
where employer_name='Brockway Dining';

GO

select* from [Available Sub Shifts]
select * from subshifts
select * from students