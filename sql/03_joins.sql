-- =====================================================
-- JOIN QUERIES
-- =====================================================

--------------------------------------------------------
-- 1. Patient appointments with doctor names
--------------------------------------------------------

SELECT
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.first_name || ' ' || d.last_name AS doctor_name,
    a.appointment_date,
    a.status
FROM appointments a
JOIN patients p
ON a.patient_id = p.patient_id
JOIN doctors d
ON a.doctor_id = d.doctor_id;

--------------------------------------------------------
-- 2. Doctor department details
--------------------------------------------------------

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    dept.department_name
FROM doctors d
JOIN departments dept
ON d.department_id = dept.department_id;

--------------------------------------------------------
-- 3. Patient admissions with doctor
--------------------------------------------------------

SELECT
    a.admission_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.first_name || ' ' || d.last_name AS doctor_name,
    a.disease
FROM admissions a
JOIN patients p
ON a.patient_id = p.patient_id
JOIN doctors d
ON a.doctor_id = d.doctor_id;

--------------------------------------------------------
-- 4. Billing details with patient names
--------------------------------------------------------

SELECT
    b.bill_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    b.total_amount,
    b.amount_paid
FROM billing b
JOIN patients p
ON b.patient_id = p.patient_id;

--------------------------------------------------------
-- 5. Billing with admission details
--------------------------------------------------------

SELECT
    b.bill_id,
    a.disease,
    b.total_amount,
    b.amount_paid
FROM billing b
JOIN admissions a
ON b.admission_id = a.admission_id;

--------------------------------------------------------
-- 6. Doctors with their appointments
--------------------------------------------------------

SELECT
    d.first_name,
    d.last_name,
    a.appointment_date,
    a.status
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id;

--------------------------------------------------------
-- 7. Patients and appointment diagnoses
--------------------------------------------------------

SELECT
    p.first_name,
    p.last_name,
    a.diagnosis
FROM patients p
JOIN appointments a
ON p.patient_id = a.patient_id;

--------------------------------------------------------
-- 8. Number of appointments per doctor
--------------------------------------------------------

SELECT
    d.first_name,
    d.last_name,
    COUNT(*) AS total_appointments
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY total_appointments DESC;

--------------------------------------------------------
-- 9. Number of patients treated by each doctor
--------------------------------------------------------

SELECT
    d.first_name,
    d.last_name,
    COUNT(DISTINCT a.patient_id) AS unique_patients
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY unique_patients DESC;

--------------------------------------------------------
-- 10. Revenue generated from admissions
--------------------------------------------------------

SELECT
    a.admission_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    b.amount_paid
FROM admissions a
JOIN billing b
ON a.admission_id = b.admission_id
JOIN patients p
ON a.patient_id = p.patient_id;

--------------------------------------------------------
-- 11. Revenue by department
--------------------------------------------------------

SELECT
    dept.department_name,
    ROUND(SUM(b.amount_paid),2) AS revenue
FROM billing b
JOIN admissions a
ON b.admission_id = a.admission_id
JOIN doctors d
ON a.doctor_id = d.doctor_id
JOIN departments dept
ON d.department_id = dept.department_id
GROUP BY dept.department_name
ORDER BY revenue DESC;

--------------------------------------------------------
-- 12. Average bill by department
--------------------------------------------------------

SELECT
    dept.department_name,
    ROUND(AVG(b.total_amount),2) AS average_bill
FROM billing b
JOIN admissions a
ON b.admission_id = a.admission_id
JOIN doctors d
ON a.doctor_id = d.doctor_id
JOIN departments dept
ON d.department_id = dept.department_id
GROUP BY dept.department_name
ORDER BY average_bill DESC;

--------------------------------------------------------
-- 13. Total admitted patients by disease
--------------------------------------------------------

SELECT
    disease,
    COUNT(*) AS total_cases
FROM admissions
GROUP BY disease
ORDER BY total_cases DESC;

--------------------------------------------------------
-- 14. Patients with unpaid balance
--------------------------------------------------------

SELECT
    p.first_name,
    p.last_name,
    b.total_amount,
    b.amount_paid,
    (b.total_amount - b.amount_paid) AS due_amount
FROM patients p
JOIN billing b
ON p.patient_id = b.patient_id
WHERE b.total_amount > b.amount_paid
ORDER BY due_amount DESC;

--------------------------------------------------------
-- 15. Full hospital report
--------------------------------------------------------

SELECT
    p.first_name || ' ' || p.last_name AS patient,
    d.first_name || ' ' || d.last_name AS doctor,
    dept.department_name,
    a.disease,
    b.total_amount,
    b.amount_paid
FROM admissions a
JOIN patients p
ON a.patient_id = p.patient_id
JOIN doctors d
ON a.doctor_id = d.doctor_id
JOIN departments dept
ON d.department_id = dept.department_id
JOIN billing b
ON a.admission_id = b.admission_id;