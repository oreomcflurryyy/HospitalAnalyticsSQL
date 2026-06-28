-- =====================================================
-- SUBQUERY QUERIES
-- =====================================================

--------------------------------------------------------
-- 1. Patients older than the average age
--------------------------------------------------------

SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth
FROM patients
WHERE date_of_birth <
(
    SELECT AVG(date_of_birth)
    FROM patients
);

--------------------------------------------------------
-- 2. Doctors with above-average experience
--------------------------------------------------------

SELECT
    doctor_id,
    first_name,
    last_name,
    experience_years
FROM doctors
WHERE experience_years >
(
    SELECT AVG(experience_years)
    FROM doctors
);

--------------------------------------------------------
-- 3. Bills higher than the average bill amount
--------------------------------------------------------

SELECT
    bill_id,
    patient_id,
    total_amount
FROM billing
WHERE total_amount >
(
    SELECT AVG(total_amount)
    FROM billing
)
ORDER BY total_amount DESC;

--------------------------------------------------------
-- 4. Patients who have at least one appointment
--------------------------------------------------------

SELECT
    patient_id,
    first_name,
    last_name
FROM patients
WHERE patient_id IN
(
    SELECT patient_id
    FROM appointments
);

--------------------------------------------------------
-- 5. Patients who were never admitted
--------------------------------------------------------

SELECT
    patient_id,
    first_name,
    last_name
FROM patients
WHERE patient_id NOT IN
(
    SELECT patient_id
    FROM admissions
);

--------------------------------------------------------
-- 6. Doctors who handled admissions
--------------------------------------------------------

SELECT
    doctor_id,
    first_name,
    last_name
FROM doctors
WHERE doctor_id IN
(
    SELECT DISTINCT doctor_id
    FROM admissions
);

--------------------------------------------------------
-- 7. Highest paid bill
--------------------------------------------------------

SELECT *
FROM billing
WHERE total_amount =
(
    SELECT MAX(total_amount)
    FROM billing
);

--------------------------------------------------------
-- 8. Patients with the maximum number of appointments
--------------------------------------------------------

SELECT
    patient_id,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY patient_id
HAVING COUNT(*) =
(
    SELECT MAX(total_count)
    FROM
    (
        SELECT COUNT(*) AS total_count
        FROM appointments
        GROUP BY patient_id
    ) AS counts
);

--------------------------------------------------------
-- 9. Departments with more doctors than average
--------------------------------------------------------

SELECT
    d.department_name,
    COUNT(*) AS total_doctors
FROM doctors doc
JOIN departments d
ON doc.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) >
(
    SELECT AVG(doctor_count)
    FROM
    (
        SELECT COUNT(*) AS doctor_count
        FROM doctors
        GROUP BY department_id
    ) AS dept_counts
);

--------------------------------------------------------
-- 10. Patients whose bill exceeds their insurance coverage
--------------------------------------------------------

SELECT
    patient_id,
    total_amount,
    insurance_covered,
    amount_paid
FROM billing
WHERE total_amount >
(
    SELECT AVG(insurance_covered)
    FROM billing
)
ORDER BY total_amount DESC;