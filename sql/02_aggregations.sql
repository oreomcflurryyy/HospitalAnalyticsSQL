-- =====================================================
-- AGGREGATION QUERIES
-- =====================================================

--------------------------------------------------------
-- 1. Total number of patients
--------------------------------------------------------

SELECT COUNT(*) AS total_patients
FROM patients;

--------------------------------------------------------
-- 2. Number of patients by gender
--------------------------------------------------------

SELECT
    gender,
    COUNT(*) AS total_patients
FROM patients
GROUP BY gender;

--------------------------------------------------------
-- 3. Number of patients in each city
--------------------------------------------------------

SELECT
    city,
    COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC;

--------------------------------------------------------
-- 4. Number of patients by blood group
--------------------------------------------------------

SELECT
    blood_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY blood_group
ORDER BY total_patients DESC;

--------------------------------------------------------
-- 5. Average doctor experience
--------------------------------------------------------

SELECT
    ROUND(AVG(experience_years),2) AS average_experience
FROM doctors;

--------------------------------------------------------
-- 6. Maximum doctor experience
--------------------------------------------------------

SELECT
    MAX(experience_years) AS maximum_experience
FROM doctors;

--------------------------------------------------------
-- 7. Minimum doctor experience
--------------------------------------------------------

SELECT
    MIN(experience_years) AS minimum_experience
FROM doctors;

--------------------------------------------------------
-- 8. Doctors in each department
--------------------------------------------------------

SELECT
    d.department_name,
    COUNT(*) AS total_doctors
FROM doctors doc
JOIN departments d
ON doc.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_doctors DESC;

--------------------------------------------------------
-- 9. Average experience by department
--------------------------------------------------------

SELECT
    d.department_name,
    ROUND(AVG(doc.experience_years),2) AS average_experience
FROM doctors doc
JOIN departments d
ON doc.department_id = d.department_id
GROUP BY d.department_name
ORDER BY average_experience DESC;

--------------------------------------------------------
-- 10. Total appointments
--------------------------------------------------------

SELECT
    COUNT(*) AS total_appointments
FROM appointments;

--------------------------------------------------------
-- 11. Appointments by status
--------------------------------------------------------

SELECT
    status,
    COUNT(*) AS total
FROM appointments
GROUP BY status
ORDER BY total DESC;

--------------------------------------------------------
-- 12. Average bill amount
--------------------------------------------------------

SELECT
    ROUND(AVG(total_amount),2) AS average_bill
FROM billing;

--------------------------------------------------------
-- 13. Total hospital revenue
--------------------------------------------------------

SELECT
    ROUND(SUM(amount_paid),2) AS total_revenue
FROM billing;

--------------------------------------------------------
-- 14. Total insurance coverage
--------------------------------------------------------

SELECT
    ROUND(SUM(insurance_covered),2) AS total_insurance
FROM billing;

--------------------------------------------------------
-- 15. Average hospital stay (days)
--------------------------------------------------------

SELECT
    ROUND(AVG(discharge_date - admission_date),2) AS average_stay_days
FROM admissions;