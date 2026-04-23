create database db_miniprj;
use db_miniprj;

create table Customers(
	customer_id varchar(10) primary key not null, -- (vd: c001)
    full_name varchar(100) not null,
    license_no varchar(20) not null unique,
    phone varchar(15) not null,
    address varchar(200) not null
);

create table Staffs(
	staff_id varchar(10) primary key not null, -- (vd: s001)
    full_name varchar(100) not null,
    branch varchar(50) not null,
    salary_base decimal(15,2) check (salary_base >= 0),
    performance_score decimal(3,2) default(0) -- (0.0 -> 5.0)
);

create table Rentals(
	rental_id int primary key auto_increment not null,
    customer_id varchar(10) not null,
	foreign key (customer_id) references Customers(customer_id),
    staff_id varchar(10) not null,
	foreign key (staff_id) references Staffs(staff_id),
    rental_date timestamp not null,
    return_date timestamp not null,
    status enum('Booked', 'PickedUp', 'Returned', 'Cancelled') not null
);
create table Payments(
	payment_id int primary key auto_increment not null,
    rental_id int not null,
	foreign key (rental_id)references Rentals(rental_id),
    payment_method varchar(50) not null,
    payment_date timestamp default(current_timestamp()) not null,
    amount decimal(15,2) check(amount >= 0 )
);

INSERT INTO Customers (customer_id, full_name, license_no, phone, address) VALUES
('C001', 'Nguyen Van A', 'L123456789', '0901234567', '123 Tran Phu, Ha Noi'),
('C002', 'Tran Thi B', 'L987654321', '0912345678', '45 Le Loi, Da Nang'),
('C003', 'Le Van C', 'L555888222', '0923456789', '78 Nguyen Hue, Ho Chi Minh'),
('C004', 'Pham Thi G', 'L111222333', '0934567890', '12 Bach Dang, Da Nang'),
('C005', 'Vu Van Hoang', 'L444555666', '0945678901', '56 Ly Thuong Kiet, Ha Noi');

INSERT INTO Staffs (staff_id, full_name, branch, salary_base, performance_score) VALUES
('S001', 'Pham Van D', 'Ha Noi', 12000000, 4.5),
('S002', 'Hoang Thi E', 'Da Nang', 10000000, 3.8),
('S003', 'Do Van F', 'Ho Chi Minh', 15000000, 4.2),
('S004', 'Nguyen Thi I', 'Hai Phong', 9500000, 3.6),
('S005', 'Tran Van J', 'Can Tho', 11000000, 4.0);

INSERT INTO Rentals (customer_id, staff_id, rental_date, return_date, status) VALUES
('C001', 'S001', '2026-04-01 09:00:00', '2026-04-05 09:00:00', 'Booked'),
('C002', 'S002', '2026-04-02 10:00:00', '2026-04-06 10:00:00', 'PickedUp'),
('C003', 'S003', '2026-04-03 11:00:00', '2026-04-07 11:00:00', 'Returned'),
('C004', 'S004', '2026-04-04 14:00:00', '2026-04-08 14:00:00', 'Cancelled'),
('C005', 'S005', '2026-04-05 15:00:00', '2026-04-09 15:00:00', 'Booked');

INSERT INTO Payments (rental_id, payment_method, amount) VALUES
(1, 'Credit Card', 2000000),
(2, 'Cash', 2500000),
(3, 'Bank Transfer', 1800000),
(4, 'Momo', 2200000),
(5, 'ZaloPay', 2400000);

update Customers
set address = 'Lien Chau, Da Nang'
where customer_id = 'C003';

update Staffs
set salary_base = 10000000
where staff_id = 'S002';

update Staffs
set salary_base = salary_base * 1.1
where staff_id = 'S002';

update Staffs
set performance_score = 4.8
where staff_id = 'S002';
select * from Staffs;

ALTER TABLE Payments DROP FOREIGN KEY payments_ibfk_1;
ALTER TABLE Payments MODIFY rental_id INT NULL;
ALTER TABLE Payments
ADD CONSTRAINT payments_fk
FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
ON DELETE SET NULL;


delete from Rentals
where status = 'Cancelled' and rental_date < '2026-04-05 15:00:00';
select * from Rentals;
alter table Customers
modify address varchar(200) not null default('Unknown');

select * from Customers;
alter table Staffs
add column email varchar(100) not null
after full_name;
select * from Staffs;


update Payments
set amount = amount - (amount * 0.05)
where rental_id = 2;
select * from Payments;

select full_name from Staffs
where performance_score >= 4.0;

select full_name, phone from Customers
where full_name like '%Hoang%';

select rental_id, rental_date, status from Rentals
order by rental_date desc;

select rental_id, payment_method from Payments
where payment_method = 'Credit Card' limit 3;

select rental_id, amount from Payments
where amount between 1000000 and 5000000;

select customer_id, staff_id from Rentals
where rental_date between '2026-04-01' and '2026-04-03';

select distinct branch from Staffs;

select full_name, branch from Staffs
where branch in('Ha Noi', 'Da Nang');

select c.full_name, s.full_name from Rentals as r
inner join Customers as c
on r.customer_id = c.customer_id
inner join Staffs as s
on r.staff_id = s.staff_id
where status = 'PickedUp';

alter table Rentals
add constraint check_rental
check(return_date >= rental_date);

select * from Rentals;

SELECT payment_method, SUM(amount) AS total_revenue
FROM Payments
GROUP BY payment_method;

SELECT s.staff_id, s.full_name, COUNT(r.rental_id) AS total_contracts
FROM Rentals r
INNER JOIN Staffs s ON r.staff_id = s.staff_id
GROUP BY s.staff_id, s.full_name
HAVING COUNT(r.rental_id) > 2;

SELECT staff_id, full_name, salary_base
FROM Staffs
WHERE salary_base > (SELECT AVG(salary_base) FROM Staffs);


