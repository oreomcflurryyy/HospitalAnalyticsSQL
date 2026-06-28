-- =====================================================
-- BASIC SQL QUERIES
-- =====================================================

--------------------------------------------------------
-- 1. Display all patients
--------------------------------------------------------

SELECT *
FROM patients;

--------------------------------------------------------
-- 2. Female patients
--------------------------------------------------------

SELECT *
FROM patients
WHERE gender = 'Female';

--------------------------------------------------------
-- 3. Patients from Mumbai
--------------------------------------------------------

SELECT *
FROM patients
WHERE city = 'Mumbai';

--------------------------------------------------------
-- 4. Experienced doctors
--------------------------------------------------------

SELECT
    doctor_id,
    first_name,
    last_name,
    experience_years
FROM doctors
WHERE experience_years > 20
ORDER BY experience_years DESC;

--------------------------------------------------------
-- 5. Completed appointments
--------------------------------------------------------

SELECT *
FROM appointments
WHERE status = 'Completed';

--------------------------------------------------------
-- 6. Upcoming appointments
--------------------------------------------------------

SELECT *
FROM appointments
WHERE appointment_date > CURRENT_DATE;

--------------------------------------------------------
-- 7. Highest bills
--------------------------------------------------------

SELECT *
FROM billing
ORDER BY total_amount DESC
LIMIT 10;

--------------------------------------------------------
-- 8. Lowest bills
--------------------------------------------------------

SELECT *
FROM billing
ORDER BY total_amount
LIMIT 10;

--------------------------------------------------------
-- 9. O+ blood group
--------------------------------------------------------

SELECT *
FROM patients
WHERE blood_group = 'O+';

--------------------------------------------------------
-- 10. Recent admissions
--------------------------------------------------------

SELECT *
FROM admissions
WHERE admission_date >= '2025-01-01';

--------------------------------------------------------
-- 11. Cardiology doctors
--------------------------------------------------------

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    dep.department_name
FROM doctors d
JOIN departments dep
ON d.department_id = dep.department_id
WHERE dep.department_name = 'Cardiology';

--------------------------------------------------------
-- 12. Recently discharged patients
--------------------------------------------------------

SELECT *
FROM admissions
ORDER BY discharge_date DESC
LIMIT 20;