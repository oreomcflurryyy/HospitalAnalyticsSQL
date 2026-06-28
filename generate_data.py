from faker import Faker
import pandas as pd
import numpy as np
import random
from datetime import timedelta

fake = Faker("en_IN")
random.seed(42)
np.random.seed(42)

# =====================================================
# Patients
# =====================================================

NUM_PATIENTS = 5000

blood_groups = [
    "A+", "A-", "B+", "B-",
    "AB+", "AB-", "O+", "O-"
]

cities = [
    "Mumbai", "Delhi", "Kolkata", "Bengaluru",
    "Hyderabad", "Chennai", "Pune", "Ahmedabad",
    "Lucknow", "Jaipur", "Bhopal", "Patna"
]

patients = []

for _ in range(NUM_PATIENTS):

    dob = fake.date_between(
        start_date="-90y",
        end_date="-1y"
    )

    admission = fake.date_between(
        start_date="-2y",
        end_date="today"
    )

    discharge = admission + timedelta(
        days=random.randint(1, 15)
    )

    patients.append({

        "first_name": fake.first_name(),

        "last_name": fake.last_name(),

        "gender": random.choice(
            ["Male", "Female"]
        ),

        "date_of_birth": dob,

        "blood_group": random.choice(
            blood_groups
        ),

        "phone": fake.phone_number(),

        "city": random.choice(
            cities
        ),

        "admission_date": admission,

        "discharge_date": discharge

    })

patients_df = pd.DataFrame(patients)

patients_df.to_csv(
    "data/patients.csv",
    index=False
)

print(f"✓ Generated {len(patients_df)} patients")


# =====================================================
# Departments
# =====================================================

departments = {
    1: ("Cardiology", "Cardiologist"),
    2: ("Neurology", "Neurologist"),
    3: ("Orthopedics", "Orthopedic Surgeon"),
    4: ("Dermatology", "Dermatologist"),
    5: ("Oncology", "Oncologist"),
    6: ("Pediatrics", "Pediatrician"),
    7: ("ENT", "ENT Specialist"),
    8: ("Gynecology", "Gynecologist"),
    9: ("General Medicine", "Physician"),
    10: ("Radiology", "Radiologist")
}


# =====================================================
# Doctors
# =====================================================

NUM_DOCTORS = 120

doctors = []

for _ in range(NUM_DOCTORS):

    department_id = random.randint(1, 10)

    _, specialization = departments[department_id]

    doctors.append({

        "first_name": fake.first_name(),

        "last_name": fake.last_name(),

        "department_id": department_id,

        "specialization": specialization,

        "experience_years": random.randint(1, 35)

    })

doctors_df = pd.DataFrame(doctors)

doctor_lookup = {}

for doctor_id, row in doctors_df.iterrows():

    department = row["department_id"]

    doctor_lookup.setdefault(
        department,
        []
    ).append(doctor_id + 1)

doctors_df.to_csv(
    "data/doctors.csv",
    index=False
)

print(f"✓ Generated {len(doctors_df)} doctors")


# =====================================================
# Appointments
# =====================================================

NUM_APPOINTMENTS = 12000

department_cases = {

    1: [
        "Hypertension",
        "Heart Disease",
        "Arrhythmia",
        "Chest Pain"
    ],

    2: [
        "Migraine",
        "Epilepsy",
        "Stroke",
        "Parkinson's Disease"
    ],

    3: [
        "Fracture",
        "Arthritis",
        "Back Pain",
        "Sports Injury"
    ],

    4: [
        "Skin Allergy",
        "Psoriasis",
        "Eczema",
        "Acne"
    ],

    5: [
        "Breast Cancer",
        "Lung Cancer",
        "Leukemia",
        "Chemotherapy Follow-up"
    ],

    6: [
        "Fever",
        "Chickenpox",
        "Childhood Asthma",
        "Growth Checkup"
    ],

    7: [
        "Sinusitis",
        "Hearing Loss",
        "Tonsillitis",
        "Ear Infection"
    ],

    8: [
        "Pregnancy Checkup",
        "PCOS",
        "Menstrual Disorder",
        "Prenatal Care"
    ],

    9: [
        "Diabetes",
        "Thyroid Disorder",
        "Gastritis",
        "Viral Fever"
    ],

    10: [
        "MRI Scan",
        "CT Scan",
        "Ultrasound",
        "X-Ray Review"
    ]
}

statuses = [
    "Completed",
    "Cancelled",
    "Scheduled"
]

appointments = []

for _ in range(NUM_APPOINTMENTS):

    department_id = random.randint(1, 10)

    doctor_id = random.choice(
        doctor_lookup[department_id]
    )

    diagnosis = random.choice(
        department_cases[department_id]
    )

    appointments.append({

        "patient_id": random.randint(
            1,
            NUM_PATIENTS
        ),

        "doctor_id": doctor_id,

        "appointment_date": fake.date_between(
            start_date="-2y",
            end_date="+3m"
        ),

        "diagnosis": diagnosis,

        "status": random.choices(
            statuses,
            weights=[70,10,20]
        )[0]

    })

appointments_df = pd.DataFrame(appointments)

appointments_df.to_csv(
    "data/appointments.csv",
    index=False
)

print(f"✓ Generated {len(appointments_df)} appointments")


# =====================================================
# Admissions
# =====================================================

ADMISSION_RATE = 0.25

admissions = []

room = 100

for patient_id in range(1, NUM_PATIENTS + 1):

    if random.random() > ADMISSION_RATE:
        continue

    doctor_id = random.randint(1, NUM_DOCTORS)

    admission = fake.date_between(
        start_date="-2y",
        end_date="today"
    )

    discharge = admission + timedelta(
        days=random.randint(2,15)
    )

    admissions.append({

        "patient_id": patient_id,

        "doctor_id": doctor_id,

        "room_number": room,

        "admission_date": admission,

        "discharge_date": discharge,

        "disease": random.choice(
            department_cases[
                doctors_df.loc[
                    doctor_id-1,
                    "department_id"
                ]
            ]
        )

    })

    room += 1

admissions_df = pd.DataFrame(admissions)

admissions_df.to_csv(
    "data/admissions.csv",
    index=False
)

print(f"✓ Generated {len(admissions_df)} admissions")


# =====================================================
# Billing
# =====================================================

payment_methods = [
    "Cash",
    "Card",
    "UPI",
    "Insurance"
]

billing = []

for admission_id in range(1, len(admissions_df)+1):

    total = random.randint(5000,150000)

    insurance = random.randint(
        0,
        int(total*0.8)
    )

    billing.append({

        "admission_id": admission_id,

        "total_amount": total,

        "insurance_covered": insurance,

        "amount_paid": total-insurance,

        "payment_method": random.choice(
            payment_methods
        )

    })

billing_df = pd.DataFrame(billing)

billing_df.to_csv(
    "data/billing.csv",
    index=False
)

print(f"✓ Generated {len(billing_df)} bills")