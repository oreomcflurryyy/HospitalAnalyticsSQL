from sqlalchemy import create_engine, text
import os

# =====================================================
# PostgreSQL Connection
# =====================================================

PASSWORD = "051004"

engine = create_engine(
    f"postgresql+psycopg2://postgres:{PASSWORD}@localhost:5432/hospital_analytics"
)

# =====================================================
# CSV Columns
# =====================================================

TABLE_COLUMNS = {

    "patients": """
        first_name,
        last_name,
        gender,
        date_of_birth,
        blood_group,
        phone,
        city,
        admission_date,
        discharge_date
    """,

    "doctors": """
        first_name,
        last_name,
        department_id,
        specialization,
        experience_years
    """,

    "appointments": """
        patient_id,
        doctor_id,
        appointment_date,
        diagnosis,
        status
    """,

    "admissions": """
        patient_id,
        doctor_id,
        room_number,
        admission_date,
        discharge_date,
        disease
    """,

    "billing": """
        admission_id,
        total_amount,
        insurance_covered,
        amount_paid,
        payment_method
    """
}

# =====================================================
# COPY CSV into PostgreSQL
# =====================================================

def copy_csv(table_name, csv_path):

    with engine.raw_connection() as conn:

        cursor = conn.cursor()

        with open(csv_path, "r", encoding="utf-8") as file:

            cursor.copy_expert(
                f"""
                COPY {table_name}
                (
                    {TABLE_COLUMNS[table_name]}
                )
                FROM STDIN
                WITH (
                    FORMAT CSV,
                    HEADER TRUE
                );
                """,
                file
            )

        conn.commit()
        cursor.close()

# =====================================================
# Clear Existing Data (Development Only)
# =====================================================

CLEAR_TABLES = True

if CLEAR_TABLES:

    with engine.begin() as conn:

        conn.execute(text("""
            TRUNCATE TABLE
                billing,
                admissions,
                appointments,
                doctors,
                patients
            RESTART IDENTITY CASCADE;
        """))

# =====================================================
# Files to Import
# =====================================================

FILES = [
    ("patients", "data/patients.csv"),
    ("doctors", "data/doctors.csv"),
    ("appointments", "data/appointments.csv"),
    ("admissions", "data/admissions.csv"),
    ("billing", "data/billing.csv")
]

# =====================================================
# Load Data
# =====================================================

for table_name, csv_file in FILES:

    if os.path.exists(csv_file):

        copy_csv(table_name, csv_file)

        print(f"✓ Loaded {table_name}")

    else:

        print(f"• Skipping {table_name} (file not found)")

print("\n✅ Database loaded successfully.")