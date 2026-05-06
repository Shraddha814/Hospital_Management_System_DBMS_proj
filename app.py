import streamlit as st
import mysql.connector
import datetime

# DB CONNECTION
con = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Mysql@26",
    database="hospitaldb"
)
cursor = con.cursor()

# FORMAT DATE
def format_row(row):
    new_row = []
    for val in row:
        if isinstance(val, datetime.date):
            new_row.append(val.strftime("%Y-%m-%d"))
        else:
            new_row.append(val)
    return tuple(new_row)

st.title("🏥 Hospital Management System")

# ==========================
# SIDEBAR GROUPED NAVIGATION
# ==========================
st.sidebar.title("🏥 Navigation")

module = st.sidebar.radio(
    "Select Module",
    ["Patient Management", "Doctor Management", "Treatment", "Reports"]
)

# Dynamic submenu
if module == "Patient Management":
    menu = st.sidebar.selectbox("Options", [
        "Add Patient",
        "View Patients",
        "Update Patient",
        "Delete Patient",
        "Search Patient"
    ])

elif module == "Doctor Management":
    menu = st.sidebar.selectbox("Options", [
        "Add Doctor",
        "View Doctors",
        "Doctor Wise Patients"
    ])

elif module == "Treatment":
    menu = st.sidebar.selectbox("Options", [
        "Admit Patient",
        "Discharge Patient",
        "Checkup Entry",
        "Operation Entry",
    ])

elif module == "Reports":
    menu = st.sidebar.selectbox("Options", [
        "Total Patients",
        "Ongoing Patients"
    ])

# ==============================
# 1 ADD PATIENT
# ==============================
if menu == "Add Patient":
    st.subheader("🧑 Add Patient")

    col1, col2 = st.columns(2)

    with col1:
        pno = st.text_input("Patient ID")
        name = st.text_input("Name")
        hno = st.text_input("House No")
        street = st.text_input("Street")
        city = st.text_input("City")

    with col2:
        sex = st.selectbox("Sex", ["M", "F"])
        phone = st.text_input("Phone", max_chars=10)
        dob = st.text_input("DOB (YYYY-MM-DD)")
        age = st.text_input("Age")

    if st.button("Add"):
        cursor.execute("""
            INSERT INTO PATIENT VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (pno, name, hno, street, city, sex, phone, dob, age))
        con.commit()
        st.success("Patient Added ✔")

# ==============================
# VIEW PATIENTS
# ==============================
elif menu == "View Patients":
    st.subheader("📋 All Patients")

    cursor.execute("""
        SELECT P_No, Pat_Name, Sex, dob, CalculateAge(DOB) AS Age, hno, street, city, phno
        FROM PATIENT
    """)

    data = cursor.fetchall()
    st.dataframe(data)

# ==============================
# UPDATE PATIENT
# ==============================
elif menu == "Update Patient":
    st.subheader("✏️ Update Patient Name")

    pno = st.text_input("Patient ID")
    name = st.text_input("New Name")

    if st.button("Update"):
        cursor.execute("UPDATE PATIENT SET Pat_Name=%s WHERE P_No=%s", (name, pno))
        con.commit()
        st.success("Updated ✔")

# ==============================
# DELETE PATIENT
# ==============================
elif menu == "Delete Patient":
    st.subheader("🗑️ Delete Patient")

    pno = st.text_input("Patient ID")
    
    if st.button("Delete"):
        cursor.execute("DELETE FROM PATIENT WHERE P_No=%s", (pno,))
        con.commit()
        st.success("Deleted ✔ (Backup Trigger Active)")

# ==============================
# SEARCH PATIENT
# ==============================
elif menu == "Search Patient":
    st.subheader("🔍 Search Patient")

    pno = st.text_input("Patient ID")

    if st.button("Search"):
        st.write("PATIENT")
        cursor.execute("SELECT * FROM PATIENT WHERE P_No=%s", (pno,))
        st.dataframe(cursor.fetchall())

        st.write("ADMIT")
        cursor.execute("SELECT * FROM PATIENT_ADMIT WHERE P_No=%s", (pno,))
        st.dataframe(cursor.fetchall())

        st.write("DISCHARGE")
        cursor.execute("SELECT * FROM PATIENT_DISCHARGED WHERE P_No=%s", (pno,))
        st.dataframe(cursor.fetchall())

        st.write("CHECKUP")
        cursor.execute("SELECT * FROM CHECK_UP WHERE P_No=%s", (pno,))
        st.dataframe(cursor.fetchall())

        st.write("OPERATION")
        cursor.execute("SELECT * FROM OPERATE_ON WHERE P_No=%s", (pno,))
        st.dataframe(cursor.fetchall())

# ==============================
# ADD DOCTOR
# ==============================
elif menu == "Add Doctor":
    st.subheader("🧑‍⚕️ Add Doctor")

    did = st.text_input("Doctor ID")
    fn = st.text_input("First Name")
    ln = st.text_input("Last Name")
    ph = st.text_input("Phone")
    qual = st.text_input("Qualification")
    sal = st.text_input("Salary")
    dept = st.text_input("Department")

    if st.button("Add Doctor"):
        cursor.execute("""
            INSERT INTO DOCTORS VALUES (%s,%s,%s,%s,%s,%s,%s)
        """, (did, fn, ln, ph, qual, sal, dept))
        con.commit()
        st.success("Doctor Added ✔")

# ==============================
# VIEW DOCTORS
# ==============================
elif menu == "View Doctors":
    st.subheader("👨‍⚕️ Doctors List")
    cursor.execute("SELECT * FROM DOCTORS")
    st.dataframe(cursor.fetchall())

# ==============================
# DOCTOR WISE PATIENTS
# ==============================
elif menu == "Doctor Wise Patients":
    st.subheader("👨‍⚕️ Doctor Wise Patients")

    did = st.text_input("Enter Doctor ID")
    if st.button("Show"):
        cursor.callproc("GetDoctorPatients_WithCount", [did])

        for result in cursor.stored_results():
            st.dataframe(result.fetchall())

# ==============================
# ADMIT PATIENT
# ==============================
elif menu == "Admit Patient":
    st.subheader("🛏️ Admit Patient")

    pno = st.text_input("Patient ID")
    room = st.text_input("Room No")
    adv = st.text_input("Advance Payment")

    if st.button("Admit"):
        cursor.execute("""
            INSERT INTO PATIENT_ADMIT (P_No, Room_No, Adv_Payment)
            VALUES (%s,%s,%s)
        """, (pno, room, adv))
        con.commit()
        st.success("Admitted ✔")

# ==============================
# DISCHARGE PATIENT
# ==============================
elif menu == "Discharge Patient":
    st.subheader("🏥 Discharge Patient")

    pno = st.text_input("Patient ID")
    med = st.text_input("Medicine")
    pay = st.selectbox("Payment Type", ["Cash", "Card", "Insurance"])

    if st.button("Discharge"):
        cursor.execute("""
            INSERT INTO PATIENT_DISCHARGED (P_No, Medicine, Payment_Type)
            VALUES (%s,%s,%s)
        """, (pno, med, pay))
        con.commit()
        st.success("Discharged ✔")

# ==============================
# CHECKUP ENTRY
# ==============================
elif menu == "Checkup Entry":
    st.subheader("🩺 Checkup Entry")

    pno = st.text_input("Patient ID")
    did = st.text_input("Doctor ID")
    diag = st.text_input("Diagnosis")
    status = st.selectbox("Status", ["Ongoing", "Completed"])
    treatment = st.text_input("Treatment")

    if st.button("Save"):
        cursor.execute("""
            INSERT INTO CHECK_UP (P_No, Doc_No, Diagnosis, Status, Treatment)
            VALUES (%s,%s,%s,%s,%s)
        """, (pno, did, diag, status, treatment))
        con.commit()
        st.success("Checkup Saved ✔")

# ==============================
# OPERATION ENTRY
# ==============================
elif menu == "Operation Entry":
    st.subheader("🔬 Operation Entry")

    pno = st.text_input("Patient ID")
    did = st.text_input("Doctor ID")
    op = st.text_input("Operation Type")
    res = st.selectbox("Result", ["Success", "Failure", "Pending"])

    if st.button("Save"):
        cursor.execute("""
            INSERT INTO OPERATE_ON (P_No, Doc_No, Operation_Type, Result)
            VALUES (%s,%s,%s,%s)
        """, (pno, did, op, res))
        con.commit()
        st.success("Operation Saved ✔")

# ==============================
# ONGOING PATIENTS
# ==============================
elif menu == "Ongoing Patients":
    st.subheader("⏳ Patients with Ongoing Treatment")

    if st.button("Show"):
        cursor.callproc("GetOngoingPatients")

        for result in cursor.stored_results():
            st.dataframe(result.fetchall())

# ==============================
# TOTAL PATIENTS
# ==============================
elif menu == "Total Patients":
    st.subheader("📊 Total Patients")

    if st.button("Show Count"):
        cursor.execute("SELECT TotalPatients()")
        result = cursor.fetchone()
        st.success(f"Total Patients: {result[0]}")