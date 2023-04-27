Problem 1

/*Most regular and more irregular employee*/

create table employee
(
    id   SERIAL PRIMARY KEY,
    name CHARACTER VARYING(255) not null
);

create table attendance_register
(
    id SERIAL PRIMARY KEY,
    employee_id int not null references employee(id),
    recorded_date timestamp not null
);

insert into employee (name) values ('A');
insert into employee (name) values ('B');
insert into employee (name) values ('C');
insert into employee (name) values ('D');
insert into employee (name) values ('E');
insert into employee (name) values ('F');
insert into employee (name) values ('G');

insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'A'), '2021-01-01');
insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'B'), '2021-01-01');
insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'E'), '2021-01-01');
insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'F'), '2021-01-01');

insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'B'), '2021-01-02');
insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'C'), '2021-01-02');
insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'D'), '2021-01-02');

insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'B'), '2021-01-03');
insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'C'), '2021-01-03');
insert into attendance_register (employee_id, recorded_date) values ((select id from employee where name = 'F'), '2021-01-03');


/*Write SQL queries to output the most regular (maximum attendance) and irregular employee (minimum attendance) names.*/

/* most regular maximum attendance */

select 
name,count(*)as most_regular 
from 
employee e,attendance_register as a1 
where e.id =a1.employee_id 
group by 
name 
having count(*)= (select max(mycount) from (select count(*) as mycount from attendance_register as d 
group by 
d.employee_id)a);

output:

 name | most_regular 
------+--------------
 B    |            3
(1 row)

/* most irr-regular maximum attendance */
select 
name,count(*)as most_irregular 
from 
employee e,attendance_register as a1 
where e.id =a1.employee_id group by name 
having 
count(*)= (select min(mycount) from (select count(*) as mycount from attendance_register as d 
group by 
d.employee_id)a);

output:
 name | most_irregular 
------+----------------
 D    |              1
 E    |              1
 A    |              1
(3 rows)


/* most regular attendance using limit*/
select 
  name, 
  count(*) maximum_attendance 
from 
  employee 
  inner join attendance_register on attendance_register.employee_id = employee.id 
group by 
  1 
order by 
  maximum_attendance desc 
limit 
  1 

  
 /*more irregular attendance*/
select 
  name, 
  count(*) minimum_attendance 
from 
  employee 
  inner join attendance_register on attendance_register.employee_id = employee.id 
group by 
  1 
order by 
  minimum_attendance asc 
limit 
  1;