/* select * from customer_country;
 country | country_code 
---------+--------------
 India   |           91
 USA     |            1
 UK      |           10
(3 rows)

select * from customer;
 customer_id | name  | phone_number | country 
-------------+-------+--------------+---------
           1 | Arun  |    989896887 | India
           2 | Diva  |       754355 | USA
           3 | Sidhu |      9745372 | UK
(3 rows)*/

select customer_id,name,concat('+',cc.country_code,c.phone_number) as phone from customer as c left outer join customer_country as cc on c.country=cc.country;


output :

 customer_id | name  |    phone     
-------------+-------+--------------
           1 | Arun  | +91989896887
           2 | Diva  | +1754355
           3 | Sidhu | +109745372
(3 rows)


