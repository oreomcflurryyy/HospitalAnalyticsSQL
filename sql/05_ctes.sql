-- =====================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- =====================================================

--------------------------------------------------------
-- 1. Average bill amount by department
--------------------------------------------------------

WITH department_bills AS (

    SELECT
        dep.department_name,
        b.total_amount

    FROM billing b

    JOIN admissions a
    ON b.admission_id = a.admission_id

    JOIN doctors d
    ON a.doctor_id = d.doctor_id

    JOIN departments dep
    ON d.department_id = dep.department_id
)

SELECT
    department_name,
    ROUND(AVG(total_amount),2) AS average_bill
FROM department_bills
GROUP BY department_name
ORDER BY average_bill DESC;

--------------------------------------------------------
-- 2. Top 10 doctors by appointment count
--------------------------------------------------------

WITH doctor_appointments AS (

    SELECT
        doctor_id,
        COUNT(*) AS total_appointments

    FROM appointments

    GROUP BY doctor_id
)

SELECT
    d.first_name,
    d.last_name,
    da.total_appointments

FROM doctor_appointments da

JOIN doctors d
ON da.doctor_id = d.doctor_id

ORDER BY da.total_appointments DESC

LIMIT 10;

--------------------------------------------------------
-- 3. Revenue by department
--------------------------------------------------------

WITH department_revenue AS (

    SELECT
        dep.department_name,
        b.amount_paid

    FROM billing b

    JOIN admissions a
    ON b.admission_id = a.admission_id

    JOIN doctors d
    ON a.doctor_id = d.doctor_id

    JOIN departments dep
    ON d.department_id = dep.department_id
)

SELECT
    department_name,
    ROUND(SUM(amount_paid),2) AS revenue
FROM department_revenue
GROUP BY department_name
ORDER BY revenue DESC;

--------------------------------------------------------
-- 4. Patients with more than 3 appointments
--------------------------------------------------------

WITH patient_visits AS (

    SELECT
        patient_id,
        COUNT(*) AS visits

    FROM appointments

    GROUP BY patient_id
)

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    pv.visits

FROM patient_visits pv

JOIN patients p
ON pv.patient_id = p.patient_id

WHERE pv.visits > 3

ORDER BY pv.visits DESC;

--------------------------------------------------------
-- 5. Longest hospital stays
--------------------------------------------------------

WITH stay_length AS (

    SELECT
        admission_id,
        patient_id,
        discharge_date - admission_date AS days

    FROM admissions
)

SELECT
    p.first_name,
    p.last_name,
    s.days

FROM stay_length s

JOIN patients p
ON s.patient_id = p.patient_id

ORDER BY s.days DESC

LIMIT 10;

--------------------------------------------------------
-- 6. Most common diseases
--------------------------------------------------------

WITH disease_counts AS (

    SELECT
        disease,
        COUNT(*) AS total_cases

    FROM admissions

    GROUP BY disease
)

SELECT *

FROM disease_counts

ORDER BY total_cases DESC;

--------------------------------------------------------
-- 7. Patients with outstanding balance
--------------------------------------------------------

WITH dues AS (

    SELECT

        admission_id,

        total_amount,

        amount_paid,

        total_amount - amount_paid AS due_amount

    FROM billing
)

SELECT *

FROM dues

WHERE due_amount > 0

ORDER BY due_amount DESC;

--------------------------------------------------------
-- 8. Department-wise doctor experience
--------------------------------------------------------

WITH experience_cte AS (

    SELECT

        dep.department_name,

        d.experience_years

    FROM doctors d

    JOIN departments dep

    ON d.department_id = dep.department_id
)

SELECT

    department_name,

    ROUND(AVG(experience_years),2) AS average_experience,

    MAX(experience_years) AS maximum_experience,

    MIN(experience_years) AS minimum_experience

FROM experience_cte

GROUP BY department_name

ORDER BY average_experience DESC;

--------------------------------------------------------
-- 9. Patients admitted in the last year
--------------------------------------------------------

WITH recent_admissions AS (

    SELECT *

    FROM admissions

    WHERE admission_date >= CURRENT_DATE - INTERVAL '1 year'
)

SELECT

    p.first_name,

    p.last_name,

    ra.admission_date,

    ra.disease

FROM recent_admissions ra

JOIN patients p

ON ra.patient_id = p.patient_id

ORDER BY ra.admission_date DESC;

--------------------------------------------------------
-- 10. Complete hospital report
--------------------------------------------------------

WITH hospital_report AS (

    SELECT

        p.first_name || ' ' || p.last_name AS patient,

        d.first_name || ' ' || d.last_name AS doctor,

        dep.department_name,

        a.disease,

        b.total_amount,

        b.amount_paid

    FROM admissions a

    JOIN patients p
    ON a.patient_id = p.patient_id

    JOIN doctors d
    ON a.doctor_id = d.doctor_id

    JOIN departments dep
    ON d.department_id = dep.department_id

    JOIN billing b
    ON a.admission_id = b.admission_id
)

SELECT *

FROM hospital_report

ORDER BY total_amount DESC;