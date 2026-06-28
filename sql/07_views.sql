-- =====================================================
-- SQL VIEWS
-- =====================================================

--------------------------------------------------------
-- 1. Patient Information
--------------------------------------------------------

CREATE OR REPLACE VIEW patient_details AS

SELECT
    patient_id,
    first_name,
    last_name,
    gender,
    date_of_birth,
    blood_group,
    city
FROM patients;

--------------------------------------------------------
-- 2. Doctor Details
--------------------------------------------------------

CREATE OR REPLACE VIEW doctor_details AS

SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    dep.department_name,
    d.specialization,
    d.experience_years
FROM doctors d
JOIN departments dep
ON d.department_id = dep.department_id;

--------------------------------------------------------
-- 3. Appointment Summary
--------------------------------------------------------

CREATE OR REPLACE VIEW appointment_summary AS

SELECT

    a.appointment_id,

    p.first_name || ' ' || p.last_name AS patient,

    d.first_name || ' ' || d.last_name AS doctor,

    dep.department_name,

    a.appointment_date,

    a.diagnosis,

    a.status

FROM appointments a

JOIN patients p
ON a.patient_id = p.patient_id

JOIN doctors d
ON a.doctor_id = d.doctor_id

JOIN departments dep
ON d.department_id = dep.department_id;

--------------------------------------------------------
-- 4. Admission Summary
--------------------------------------------------------

CREATE OR REPLACE VIEW admission_summary AS

SELECT

    ad.admission_id,

    p.first_name || ' ' || p.last_name AS patient,

    d.first_name || ' ' || d.last_name AS doctor,

    dep.department_name,

    ad.disease,

    ad.room_number,

    ad.admission_date,

    ad.discharge_date,

    ad.discharge_date - ad.admission_date
        AS stay_length

FROM admissions ad

JOIN patients p
ON ad.patient_id = p.patient_id

JOIN doctors d
ON ad.doctor_id = d.doctor_id

JOIN departments dep
ON d.department_id = dep.department_id;

--------------------------------------------------------
-- 5. Billing Summary
--------------------------------------------------------

CREATE OR REPLACE VIEW billing_summary AS

SELECT

    b.bill_id,

    p.first_name || ' ' || p.last_name AS patient,

    b.total_amount,

    b.insurance_covered,

    b.amount_paid,

    b.payment_method

FROM billing b

JOIN admissions ad
ON b.admission_id = ad.admission_id

JOIN patients p
ON ad.patient_id = p.patient_id;

--------------------------------------------------------
-- 6. Doctor Performance
--------------------------------------------------------

CREATE OR REPLACE VIEW doctor_performance AS

SELECT

    d.doctor_id,

    d.first_name,

    d.last_name,

    dep.department_name,

    COUNT(DISTINCT a.appointment_id)
        AS total_appointments,

    COUNT(DISTINCT ad.admission_id)
        AS total_admissions

FROM doctors d

LEFT JOIN appointments a
ON d.doctor_id = a.doctor_id

LEFT JOIN admissions ad
ON d.doctor_id = ad.doctor_id

JOIN departments dep
ON d.department_id = dep.department_id

GROUP BY

    d.doctor_id,

    d.first_name,

    d.last_name,

    dep.department_name;

--------------------------------------------------------
-- 7. Department Revenue
--------------------------------------------------------

CREATE OR REPLACE VIEW department_revenue AS

SELECT

    dep.department_name,

    COUNT(b.bill_id) AS total_bills,

    ROUND(SUM(b.amount_paid),2)
        AS revenue,

    ROUND(AVG(b.amount_paid),2)
        AS average_bill

FROM billing b

JOIN admissions ad
ON b.admission_id = ad.admission_id

JOIN doctors d
ON ad.doctor_id = d.doctor_id

JOIN departments dep
ON d.department_id = dep.department_id

GROUP BY dep.department_name;

--------------------------------------------------------
-- 8. Disease Statistics
--------------------------------------------------------

CREATE OR REPLACE VIEW disease_statistics AS

SELECT

    disease,

    COUNT(*) AS total_cases

FROM admissions

GROUP BY disease

ORDER BY total_cases DESC;

--------------------------------------------------------
-- 9. City Statistics
--------------------------------------------------------

CREATE OR REPLACE VIEW city_statistics AS

SELECT

    city,

    COUNT(*) AS total_patients

FROM patients

GROUP BY city

ORDER BY total_patients DESC;

--------------------------------------------------------
-- 10. Hospital Dashboard
--------------------------------------------------------

CREATE OR REPLACE VIEW hospital_dashboard AS

SELECT

    p.first_name || ' ' || p.last_name
        AS patient,

    d.first_name || ' ' || d.last_name
        AS doctor,

    dep.department_name,

    ad.disease,

    b.total_amount,

    b.insurance_covered,

    b.amount_paid,

    ad.admission_date,

    ad.discharge_date,

    ad.discharge_date - ad.admission_date
        AS stay_length

FROM admissions ad

JOIN patients p
ON ad.patient_id = p.patient_id

JOIN doctors d
ON ad.doctor_id = d.doctor_id

JOIN departments dep
ON d.department_id = dep.department_id

JOIN billing b
ON ad.admission_id = b.admission_id;