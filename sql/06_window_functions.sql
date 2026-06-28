-- =====================================================
-- WINDOW FUNCTIONS
-- =====================================================

--------------------------------------------------------
-- 1. Rank doctors by experience
--------------------------------------------------------

SELECT
    doctor_id,
    first_name,
    last_name,
    experience_years,
    RANK() OVER (
        ORDER BY experience_years DESC
    ) AS experience_rank
FROM doctors;

--------------------------------------------------------
-- 2. Dense rank doctors by experience
--------------------------------------------------------

SELECT
    doctor_id,
    first_name,
    last_name,
    experience_years,
    DENSE_RANK() OVER (
        ORDER BY experience_years DESC
    ) AS experience_rank
FROM doctors;

--------------------------------------------------------
-- 3. Row number for patients by admission date
--------------------------------------------------------

SELECT
    patient_id,
    first_name,
    last_name,
    admission_date,
    ROW_NUMBER() OVER (
        ORDER BY admission_date
    ) AS row_num
FROM patients;

--------------------------------------------------------
-- 4. Rank patients by total bill
--------------------------------------------------------

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    b.total_amount,
    RANK() OVER (
        ORDER BY b.total_amount DESC
    ) AS bill_rank
FROM billing b
JOIN admissions a
ON b.admission_id = a.admission_id
JOIN patients p
ON a.patient_id = p.patient_id;

--------------------------------------------------------
-- 5. Running revenue
--------------------------------------------------------

SELECT
    bill_id,
    amount_paid,
    SUM(amount_paid) OVER (
        ORDER BY bill_id
    ) AS running_revenue
FROM billing;

--------------------------------------------------------
-- 6. Cumulative appointments
--------------------------------------------------------

SELECT
    appointment_date,
    COUNT(*) AS appointments,
    SUM(COUNT(*)) OVER (
        ORDER BY appointment_date
    ) AS cumulative_appointments
FROM appointments
GROUP BY appointment_date
ORDER BY appointment_date;

--------------------------------------------------------
-- 7. Previous bill amount (LAG)
--------------------------------------------------------

SELECT
    bill_id,
    total_amount,
    LAG(total_amount)
    OVER (
        ORDER BY bill_id
    ) AS previous_bill
FROM billing;

--------------------------------------------------------
-- 8. Next bill amount (LEAD)
--------------------------------------------------------

SELECT
    bill_id,
    total_amount,
    LEAD(total_amount)
    OVER (
        ORDER BY bill_id
    ) AS next_bill
FROM billing;

--------------------------------------------------------
-- 9. Difference from previous bill
--------------------------------------------------------

SELECT
    bill_id,
    total_amount,
    total_amount -
    LAG(total_amount)
    OVER (
        ORDER BY bill_id
    ) AS difference
FROM billing;

--------------------------------------------------------
-- 10. Average bill by department
--------------------------------------------------------

SELECT
    dep.department_name,
    b.total_amount,
    ROUND(
        AVG(b.total_amount)
        OVER (
            PARTITION BY dep.department_name
        ),
        2
    ) AS department_average
FROM billing b
JOIN admissions a
ON b.admission_id = a.admission_id
JOIN doctors d
ON a.doctor_id = d.doctor_id
JOIN departments dep
ON d.department_id = dep.department_id;

--------------------------------------------------------
-- 11. Rank doctors within each department
--------------------------------------------------------

SELECT
    dep.department_name,
    d.first_name,
    d.last_name,
    d.experience_years,
    RANK() OVER (
        PARTITION BY dep.department_name
        ORDER BY d.experience_years DESC
    ) AS department_rank
FROM doctors d
JOIN departments dep
ON d.department_id = dep.department_id;

--------------------------------------------------------
-- 12. Top earning patients
--------------------------------------------------------

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    SUM(b.amount_paid) AS total_paid,
    DENSE_RANK() OVER (
        ORDER BY SUM(b.amount_paid) DESC
    ) AS payment_rank
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
JOIN billing b
ON a.admission_id = b.admission_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name;

--------------------------------------------------------
-- 13. Percent rank of doctor experience
--------------------------------------------------------

SELECT
    doctor_id,
    first_name,
    last_name,
    experience_years,
    PERCENT_RANK()
    OVER (
        ORDER BY experience_years
    ) AS percentile
FROM doctors;

--------------------------------------------------------
-- 14. NTILE - Divide bills into quartiles
--------------------------------------------------------

SELECT
    bill_id,
    total_amount,
    NTILE(4)
    OVER (
        ORDER BY total_amount DESC
    ) AS revenue_quartile
FROM billing;

--------------------------------------------------------
-- 15. Moving average of daily revenue
--------------------------------------------------------

WITH daily_revenue AS (

    SELECT
        a.discharge_date,
        SUM(b.amount_paid) AS revenue

    FROM billing b

    JOIN admissions a
    ON b.admission_id = a.admission_id

    GROUP BY a.discharge_date
)

SELECT
    discharge_date,
    revenue,

    ROUND(
        AVG(revenue)
        OVER (
            ORDER BY discharge_date
            ROWS BETWEEN 6 PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS seven_day_moving_average

FROM daily_revenue

ORDER BY discharge_date;