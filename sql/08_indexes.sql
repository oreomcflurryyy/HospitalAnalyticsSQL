-- =====================================================
-- INDEXES
-- =====================================================

--------------------------------------------------------
-- Patient searches
--------------------------------------------------------

CREATE INDEX idx_patient_city
ON patients(city);

CREATE INDEX idx_patient_gender
ON patients(gender);

CREATE INDEX idx_patient_blood_group
ON patients(blood_group);

--------------------------------------------------------
-- Doctor searches
--------------------------------------------------------

CREATE INDEX idx_doctor_department
ON doctors(department_id);

CREATE INDEX idx_doctor_experience
ON doctors(experience_years);

--------------------------------------------------------
-- Appointment searches
--------------------------------------------------------

CREATE INDEX idx_appointment_patient
ON appointments(patient_id);

CREATE INDEX idx_appointment_doctor
ON appointments(doctor_id);

CREATE INDEX idx_appointment_date
ON appointments(appointment_date);

--------------------------------------------------------
-- Admission searches
--------------------------------------------------------

CREATE INDEX idx_admission_patient
ON admissions(patient_id);

CREATE INDEX idx_admission_doctor
ON admissions(doctor_id);

CREATE INDEX idx_admission_disease
ON admissions(disease);

--------------------------------------------------------
-- Billing searches
--------------------------------------------------------

CREATE INDEX idx_billing_patient
ON billing(patient_id);

CREATE INDEX idx_billing_amount
ON billing(total_amount);