-- =====================================================
-- QUERY OPTIMIZATION
-- =====================================================

EXPLAIN ANALYZE
SELECT *
FROM patients
WHERE city = 'Mumbai';

--------------------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM doctors
WHERE department_id = 3;

--------------------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM appointments
WHERE patient_id = 100;

--------------------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM billing
WHERE total_amount > 50000;

--------------------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM admissions
WHERE disease = 'Diabetes';