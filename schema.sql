-- 01_schema.sql
-- Target: PostgreSQL 13+

-- Start clean
DROP SCHEMA IF EXISTS company CASCADE;
CREATE SCHEMA company;
SET search_path TO company;

-- ========================
-- DDL: CREATE TABLES
-- ========================

-- Employee master table
CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    title       VARCHAR(100) NOT NULL,
    email       VARCHAR(120) UNIQUE NOT NULL,
    hired_at    DATE NOT NULL DEFAULT CURRENT_DATE,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE
);

-- Customer table with FK to employee (account manager)
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(120) UNIQUE NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_manager_id INT REFERENCES employee(employee_id),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
);

-- (Example ALTERs if you want to see them explicitly)
-- ALTER TABLE employee ALTER COLUMN title TYPE VARCHAR(100);
-- ALTER TABLE employee ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE;
-- ALTER TABLE customer ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE';

-- ========================
-- DML: INSERT sample data
-- ========================
INSERT INTO employee (first_name, last_name, title, email, hired_at)
VALUES
 ('Aarav','Menon','Sales Manager','aarav.menon@corp.example', CURRENT_DATE - INTERVAL '720 days'),
 ('Diya','Iyer','Account Executive','diya.iyer@corp.example', CURRENT_DATE - INTERVAL '400 days'),
 ('Kabir','Sharma','Support Lead','kabir.sharma@corp.example', CURRENT_DATE - INTERVAL '100 days'),
 ('Mira','Patel','Account Executive','mira.patel@corp.example', CURRENT_DATE - INTERVAL '30 days');

INSERT INTO customer (first_name, last_name, email, account_manager_id, status)
VALUES
 ('Shane','Kottuppallil','shane@example.com', 1, 'ACTIVE'),
 ('Riya','Kapoor','riya.kapoor@example.com', 2, 'ACTIVE'),
 ('Anil','Reddy','anil.reddy@example.com', 2, 'INACTIVE'),
 ('Priya','Nair','priya.nair@example.com', 4, 'ACTIVE'),
 ('Vijay','Singh','vijay.singh@example.com', NULL, 'ACTIVE');  -- no manager yet

-- ========================
-- DML: SELECT checks
-- ========================
SELECT * FROM employee;
SELECT * FROM customer;

-- ========================
-- DML: UPDATE & DELETE
-- ========================
-- Update a title
UPDATE employee
SET title = 'Senior Account Executive'
WHERE last_name = 'Iyer';

-- Assign an account manager to a customer that had none
UPDATE customer
SET account_manager_id = 3
WHERE email = 'vijay.singh@example.com';

-- Delete an INACTIVE customer
DELETE FROM customer
WHERE status = 'INACTIVE';

-- ========================
-- DDL: TRUNCATE (example, commented)
-- ========================
-- TRUNCATE TABLE customer RESTART IDENTITY;
-- (Reinsert rows if you use TRUNCATE and want to continue.)
