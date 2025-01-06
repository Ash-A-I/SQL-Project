-- creating database
create database bank;
use bank;
-- creating tables
create table customers(customerid int primary key,firstname varchar(20),lastname varchar(20),DOB date,address varchar(50),phonenumber int);
create table accounts(accountid int primary key,customerid int,accounttype varchar(20),balance decimal(10,2),openingdate date,foreign key (customerid) references customers(customerid));
create table loan(loanid int primary key,customerid int,loanamt float,loandate date,loanstat varchar(20),foreign key (customerid) references customers(customerid));
desc customers;
desc accounts;
desc loan;
-- inserting values
insert into customers values(101,"Rahul","Sharma","1996-05-16","Mumbai",1234567890),(102,"Pravin","Kumble","1999-06-08","Chennai",0123456789),(103,"Preeti","Yadav","1997-02-12","Pune",2564123687),(104,"Pooja","Mishra","1998-08-24","Bangalore",8456325794),(105,"Akhil","Ghutti","2000-09-03","Delhi",8754963512);
insert into accounts values(1,101,"Savings",50000,"2015-07-20"),(2,102,"Current",200000,"2020-01-14"),(3,103,"Savings",100000,"2016-05-16"),(4,104,"Current",150000,"2017-07-16"),(5,105,"Savings",300000,"2011-04-08");
insert into loan values(201,101,20000,"2020-04-12","Active"),(202,102,50000,"2024-09-18","Active"),(203,103,40000,"2021-01-12","Paid"),(204,104,60000,"2022-06-16","Active"),(205,105,100000,"2023-10-27","Paid");
select * from customers;
select * from accounts;
select * from loan;
-- view
create view customer_acc_bal as select s.customerid,s.firstname,s.lastname,st.accountid,st.accounttype,st.balance from customers s join accounts st on s.customerid=st.customerid;
select * from customer_acc_bal;
-- stored procedure
delimiter //
create procedure deposit(in accid int,in depositamt decimal(10,2))
begin
update accounts set balance = balance + depositamt where accountid=accid;
end //
call deposit(101,200.00);
-- cursor
delimiter //
create procedure get_loan_details()
begin
declare done int default 0;
declare loanid int;
declare customerid int;
declare loanamt float;
declare loanstat varchar(20);
declare loancur cursor for select loanid,customerid,loanamt,loanstat from loan;
declare continue handler for not found set done=1;
open loancur;
read_loop:loop
fetch loancur into loanid,customerid,loanamt,loanstat;
if done then
leave read_loop;
end if;
end loop;
close loancur;
end //
call get_loan_details();
select * from loan;
-- functions
delimiter //
create function get_tot_bal(customer_id int)
returns decimal(10,2)
deterministic
begin
declare totalbal decimal(10,2);
select sum(balance) into totalbal from accounts where customerid=customer_id;
return totalbal;
end //
select get_tot_bal(101);
-- trigger
create table acc_backup(accountid int,customerid int,accounttype varchar(20),balance decimal(10,2));
delimiter //
create trigger backup
after insert on accounts
for each row
begin
insert into acc_backup values(new.accountid,new.customerid,new.accounttype,new.balance);
end //
select * from acc_backup;