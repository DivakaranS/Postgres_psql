/* problem group by */
select 
  g.d :: date as recorded_date, 
  case when at.recorded_date is not null then 'Present' else 'Absent' end as status, 
  array_agg(name) 
from 
  generate_series(
    '2021-01-01', '2021-01-03', '1 day' :: interval
  ) as g(d) 
  join employee on true 
  left join attendance_register as at on at.employee_id = employee.id 
  and at.recorded_date = g.d 
group by 
  1, 
  2 
order by 
  status desc;

  output;
   recorded_date | status  | array_agg 
---------------+---------+-----------
 2021-01-01    | Present | {F,A,E,B}
 2021-01-02    | Present | {D,B,C}
 2021-01-03    | Present | {B,C,F}
 2021-01-01    | Absent  | {D,G,C}
 2021-01-02    | Absent  | {E,G,A,F}
 2021-01-03    | Absent  | {E,D,A,G}
(6 rows)


/* simplify problem code */

select 
  a1.date as recorded_date, 
  name, 
  case when recorded_date is null then 'Absent' else 'Present' end as Status 
from 
  employee e cross 
  join (
    select 
      distinct date(recorded_date) "date" 
    from 
      attendance_register
  ) a1 
  left join attendance_register a on e.id = a.employee_id 
  and a.recorded_date = a1.date 
order by 
  a1.date asc;

output:
 recorded_date | name | status  
---------------+------+---------
 2021-01-01    | A    | Present
 2021-01-01    | B    | Present
 2021-01-01    | C    | Absent
 2021-01-01    | D    | Absent
 2021-01-01    | E    | Present
 2021-01-01    | F    | Present
 2021-01-01    | G    | Absent
 2021-01-02    | A    | Absent
 2021-01-02    | B    | Present
 2021-01-02    | C    | Present
 2021-01-02    | D    | Present
 2021-01-02    | E    | Absent
 2021-01-02    | F    | Absent
 2021-01-02    | G    | Absent
 2021-01-03    | A    | Absent
 2021-01-03    | B    | Present
 2021-01-03    | C    | Present
 2021-01-03    | D    | Absent
 2021-01-03    | E    | Absent
 2021-01-03    | F    | Present
 2021-01-03    | G    | Absent
(21 rows)

/* */
select 
  a1.date as recorded_date, 
  name, 
  case when recorded_date is null then 'Absent' else 'Present' end as Status 
from 
  employee e 
  left join (
    select 
      distinct date(recorded_date) "date" 
    from 
      attendance_register
  ) a1 on true 
  left join attendance_register a on e.id = a.employee_id 
  and a.recorded_date = a1.date 
order by 
  a1.date asc;
  

/*problem 2 psql*/
/* insert to attendance table */
insert into attendance_table(
  with ins_tab as (
    with temp_atten as (
      with date_table as (
        select 
          distinct(recorded_date) as Date 
        from 
          attendance_register 
        order by 
          Date asc
      ) 
      select 
        Date, 
        name, 
        id as emp_id 
      from 
        date_table cross 
        join (
          select 
            id, 
            name 
          from 
            employee
        ) employee 
      where 
        employee.id in (1, 2, 3, 4, 5, 6)
    ) 
    select 
      date, 
      name as Employee_name, 
      case when attendance_register.employee_id is null then 'absent' else 'present' end as Status 
    from 
      temp_atten 
      left outer join attendance_register on temp_atten.date = attendance_register.recorded_date 
      and temp_atten.emp_id = attendance_register.employee_id 
    order by 
      date, 
      name asc
  ) 
  select 
    * 
  from 
    ins_tab
);

/*i have tried this query step by step*/
with temp_atten as (
  with date_table as (
    select 
      distinct(recorded_date) as Date 
    from 
      attendance_register 
    order by 
      Date asc
  ) 
  select 
    Date, 
    name, 
    id as emp_id 
  from 
    date_table cross 
    join (
      select 
        id, 
        name 
      from 
        employee
    ) employee 
  where 
    employee.id in (1, 2, 3, 4, 5, 6)
) 
select 
  date, 
  name as Employee_name, 
  case when attendance_register.employee_id is null then 'absent' else 'present' end as Status 
from 
  temp_atten 
  left outer join attendance_register on temp_atten.date = attendance_register.recorded_date 
  and temp_atten.emp_id = attendance_register.employee_id 
order by 
  date, 
  name asc;

   /*tried without cross join conditions*/
with temp_atten as (
  with date_table as (
    select 
      distinct(recorded_date) as Date 
    from 
      attendance_register 
    order by 
      Date asc
  ) 
  select 
    Date, 
    name, 
    id as emp_id 
  from 
    date_table cross 
    join employee
) 
select 
  date, 
  name as Employee_name, 
  case when attendance_register.employee_id is null then 'absent' else 'present' end as Status 
from 
  temp_atten 
  left outer join attendance_register on temp_atten.date = attendance_register.recorded_date 
  and temp_atten.emp_id = attendance_register.employee_id 
order by 
  date, 
  name asc;
