-- 03_queries_joins_sets.sql
SET search_path TO company;

-- ========================
-- JOINS
-- ========================

-- 1) Simple JOIN (default INNER) customers with their account managers
SELECT c.customer_id,
       c.first_name AS customer_first,
       c.last_name  AS customer_last,
       e.employee_id,
       e.first_name AS emp_first,
       e.last_name  AS emp_last,
       e.title
FROM customer c
JOIN employee e
  ON e.employee_id = c.account_manager_id;

-- 2) LEFT JOIN: all customers, even those without a manager
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       e.first_name AS manager_first,
       e.last_name  AS manager_last
FROM customer c
LEFT JOIN employee e
  ON e.employee_id = c.account_manager_id;

-- 3) RIGHT JOIN: all employees, show customers if any
SELECT c.customer_id,
       c.first_name AS customer_first,
       c.email      AS customer_email,
       e.employee_id,
       e.first_name AS emp_first,
       e.title
FROM customer c
RIGHT JOIN employee e
  ON e.employee_id = c.account_manager_id;

-- 4) Explicit INNER JOIN (same as #1 but spelled out)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       e.first_name AS manager_first
FROM customer c
INNER JOIN employee e
  ON e.employee_id = c.account_manager_id;

-- 5) FULL OUTER JOIN: include customers without managers and employees without customers
SELECT c.customer_id,
       c.first_name AS customer_first,
       e.employee_id,
       e.first_name AS emp_first,
       e.title
FROM customer c
FULL OUTER JOIN employee e
  ON e.employee_id = c.account_manager_id
ORDER BY c.customer_id NULLS LAST, e.employee_id;

-- ========================
-- SET OPERATIONS
-- ========================

-- Distinct union of first names
SELECT first_name FROM customer
UNION
SELECT first_name FROM employee;

-- Union all (keep duplicates)
SELECT first_name FROM customer
UNION ALL
SELECT first_name FROM employee;

-- Intersect (names in both tables)
SELECT first_name FROM customer
INTERSECT
SELECT first_name FROM employee;

-- MINUS equivalent in PostgreSQL is EXCEPT:
-- names in customer but not in employee
SELECT first_name FROM customer
EXCEPT
SELECT first_name FROM employee;

-- If you are using Oracle, use MINUS instead:
-- SELECT first_name FROM customer
-- MINUS
-- SELECT first_name FROM employee;
