-- =====================================================
-- Hospital Analytics SQL
-- Database Schema
-- =====================================================

DROP TABLE IF EXISTS billing CASCADE;
DROP TABLE IF EXISTS admissions CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

--------------------------------------------------------
-- Departments
--------------------------------------------------------

CREATE TABLE departments (

    department_id SERIAL PRIMARY KEY,

    department_name VARCHAR(100) UNIQUE NOT NULL

);

INSERT INTO departments (department_name)
VALUES
('Cardiology'),
('Neurology'),
('Orthopedics'),
('Dermatology'),
('Oncology'),
('Pediatrics'),
('ENT'),
('Gynecology'),
('General Medicine'),
('Radiology');

--------------------------------------------------------
-- Patients
--------------------------------------------------------

CREATE TABLE patients (

    patient_id SERIAL PRIMARY KEY,

    first_name VARCHAR(100) NOT NULL,

    last_name VARCHAR(100) NOT NULL,

    gender VARCHAR(20),

    date_of_birth DATE,

    blood_group VARCHAR(5),

    phone VARCHAR(20),

    city VARCHAR(100),

    admission_date DATE,

    discharge_date DATE

);

--------------------------------------------------------
-- Doctors
--------------------------------------------------------

CREATE TABLE doctors (

    doctor_id SERIAL PRIMARY KEY,

    first_name VARCHAR(100),

    last_name VARCHAR(100),

    department_id INTEGER
        REFERENCES departments(department_id),

    specialization VARCHAR(100),

    experience_years INTEGER

);

--------------------------------------------------------
-- Appointments
--------------------------------------------------------

CREATE TABLE appointments (

    appointment_id SERIAL PRIMARY KEY,

    patient_id INTEGER
        REFERENCES patients(patient_id),

    doctor_id INTEGER
        REFERENCES doctors(doctor_id),

    appointment_date DATE,

    diagnosis VARCHAR(150),

    status VARCHAR(30)

);

--------------------------------------------------------
-- Admissions
--------------------------------------------------------

CREATE TABLE admissions (

    admission_id SERIAL PRIMARY KEY,

    patient_id INTEGER
        REFERENCES patients(patient_id),

    doctor_id INTEGER
        REFERENCES doctors(doctor_id),

    room_number VARCHAR(20),

    admission_date DATE,

    discharge_date DATE,

    disease VARCHAR(150)

);

--------------------------------------------------------
-- Billing
--------------------------------------------------------

CREATE TABLE billing (

    bill_id SERIAL PRIMARY KEY,

    patient_id INTEGER
        REFERENCES patients(patient_id),

    admission_id INTEGER
        REFERENCES admissions(admission_id),

    total_amount NUMERIC(10,2),

    insurance_covered NUMERIC(10,2),

    amount_paid NUMERIC(10,2),

    payment_method VARCHAR(30)

);

--------------------------------------------------------
-- Useful Indexes
--------------------------------------------------------

CREATE INDEX idx_patient_city
ON patients(city);

CREATE INDEX idx_patient_gender
ON patients(gender);

CREATE INDEX idx_doctor_department
ON doctors(department_id);

CREATE INDEX idx_appointment_patient
ON appointments(patient_id);

CREATE INDEX idx_appointment_doctor
ON appointments(doctor_id);

CREATE INDEX idx_admission_patient
ON admissions(patient_id);

CREATE INDEX idx_admission_doctor
ON admissions(doctor_id);

CREATE INDEX idx_billing_patient
ON billing(patient_id);

--------------------------------------------------------
-- Schema Created Successfully
--------------------------------------------------------