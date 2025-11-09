-- 02_transactions_and_security.sql
SET search_path TO company;

-- ========================
-- TCL: Transaction demo
-- ========================
BEGIN;

-- Insert two new customers
INSERT INTO customer (first_name, last_name, email, account_manager_id, status)
VALUES
 ('Zoya','Agarwal','zoya.agarwal@example.com', 1, 'ACTIVE'),
 ('Rahul','Verma','rahul.verma@example.com', 4, 'ACTIVE');

-- Create a savepoint before a risky change
SAVEPOINT before_risky;

-- Risky update (simulate a mistake): set all customers to INACTIVE
UPDATE customer SET status = 'INACTIVE';

-- Undo the mistake
ROLLBACK TO SAVEPOINT before_risky;

-- Proceed with a safe, targeted update
UPDATE customer
SET status = 'INACTIVE'
WHERE email = 'rahul.verma@example.com';

-- Commit the good work
COMMIT;

-- ========================
-- DCL: GRANT / REVOKE demo
-- ========================
-- Create a limited user (requires superuser/privileged role)
DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'report_reader') THEN
      CREATE ROLE report_reader LOGIN PASSWORD 'report_reader_pw';
   END IF;
END$$;

-- Grant read-only access
GRANT USAGE ON SCHEMA company TO report_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA company TO report_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA company GRANT SELECT ON TABLES TO report_reader;

-- To revoke later (uncomment if needed):
-- REVOKE SELECT ON ALL TABLES IN SCHEMA company FROM report_reader;
-- REVOKE USAGE ON SCHEMA company FROM report_reader;
