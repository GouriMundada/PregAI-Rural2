<div align="center">

# 🌸 PregAI Rural

### AI-Assisted Maternal Healthcare & Personalized Nutrition Support for Rural India

**Empowering safer pregnancies through accessible digital support, pregnancy risk awareness, and personalized nutrition guidance.**

![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?logo=flutter)
![Python](https://img.shields.io/badge/Backend-Python-3776AB?logo=python)
![Flask](https://img.shields.io/badge/API-Flask-black?logo=flask)
![Status](https://img.shields.io/badge/Status-Working%20Prototype-green)
![Domain](https://img.shields.io/badge/Domain-Rural%20Healthcare-E91E63)

**SEVA FIRST INNOVATION CHALLENGE | MAHARASHTRA ZONE**

</div>

---

# 💡 1. THE PROBLEM

Pregnancy is one of the most important stages in a woman's life. However, women in rural and underserved communities may face challenges accessing timely maternal-health information and practical nutrition guidance.

Some important challenges include:

- Limited access to maternal-health information.
- Difficulty recognizing pregnancy-related warning signs.
- Lack of personalized and practical nutrition guidance.
- Dietary recommendations that may not consider locally available foods.
- Language and digital accessibility barriers.
- Difficulty maintaining continuity of pregnancy-related health information.

There is a need for accessible digital support that complements existing maternal healthcare services.

# 🌸 2. OUR SOLUTION — PREGAI RURAL

**PregAI Rural** is a digital maternal-health support platform designed to make pregnancy-related awareness and nutrition guidance more accessible.

Our application combines two important aspects of maternal wellness:

### 🩺 Pregnancy Risk Assessment

The application collects pregnancy-related information and presents a risk-assessment result using its current rule-based decision-support logic.

### 🥗 Personalized Nutrition Support

Users can select their dietary preferences and locally available food options. The nutrition engine uses these preferences to generate educational meal suggestions.

### 🤝 Community Healthcare Support

The platform is designed with the potential to complement ASHA workers and other frontline healthcare professionals.

**Our vision: A healthier pregnancy should not depend on where a woman lives.**

# ✨ 3. KEY FEATURES

| Feature | Description |
|---|---|
| Pregnancy Risk Assessment | Presents risk-related results using entered information and rule-based logic. |
| Patient Details Dashboard | Organizes patient information, pregnancy details, and ANC visit information. |
| Personalized Nutrition | Generates educational meal suggestions based on user preferences. |
| Local Food Preferences | Considers food options selected as locally available. |
| Vegetarian Food Filtering | Filters eggs, fish, and chicken for vegetarian profiles. |
| Preference Storage | Saves nutrition preferences for the meal-planning workflow. |
| Detailed Risk Indicators | Displays relevant maternal-health indicators used by the assessment workflow. |
| Data Synchronization | Provides an interface for synchronizing locally saved records with the backend. |
| ASHA Worker Support | Includes an ASHA worker login interface in the application. |

# 📱 4. APPLICATION SCREENSHOTS

Explore the current PregAI Rural application interface.

### 1. Patient Details Dashboard

Displays personal information, pregnancy details, latest ANC visit information, and risk-assessment status.

![Patient Details Dashboard](patient-details-dashboard.jpeg)

### 2. Pregnancy Risk Assessment Result

Displays the assessment category and suggested next steps based on the current rule-based assessment.

![Pregnancy Risk Assessment](pregnancy-risk-assessment-result.jpeg)

### 3. Detailed Risk Indicators

Displays pregnancy-related indicators such as gestational age, blood pressure, hemoglobin, maternal heart rate, fetal heart rate, weight, and reported symptoms.

![Detailed Risk Indicators](detailed-risk-indicators.jpeg)

### 4. Data Synchronization

Provides a synchronization interface showing connectivity status and records waiting to be synchronized.

![Data Synchronization](data-synchronization.jpeg)

# 🚀 5. HOW PREGAI RURAL WORKS

The application follows a simple user journey:

1. The user opens the PregAI Rural application.
2. The user enters the pregnancy information requested by the application.
3. The application performs its current rule-based risk assessment.
4. The user views the assessment result and suggested next steps.
5. The user navigates to nutrition preferences.
6. The user selects dietary preferences and locally available foods.
7. The application saves the selected preferences.
8. The nutrition engine generates educational meal suggestions.

### Application Workflow

```text
       PREGNANT WOMAN
              |
              v
     ENTER PREGNANCY DETAILS
              |
              v
    RULE-BASED RISK ASSESSMENT
              |
              v
       RISK RESULT SCREEN
              |
              v
     SELECT NUTRITION PREFERENCES
              |
              v
      SELECT AVAILABLE FOODS
              |
              v
      SAVE USER PREFERENCES
              |
              v
    PERSONALIZED MEAL SUGGESTIONS
```

# 🌍 6. TARGET BENEFICIARIES

### Primary Beneficiaries

- Pregnant women in rural and underserved communities.
- Women seeking accessible maternal-health information.
- Families and caregivers supporting pregnant women.

### Potential Ecosystem Beneficiaries

- ASHA workers.
- Auxiliary Nurse Midwives (ANMs).
- Healthcare professionals.
- Rural healthcare organizations.
- Community health programs.

PregAI Rural aims to complement existing healthcare services rather than replace professional medical care.

# 💎 7. WHAT MAKES OUR PROJECT INNOVATIVE?

### 1. Integrated Maternal Support

Combines pregnancy risk awareness and nutrition support in one application.

### 2. Preference-Based Nutrition

Generates educational meal suggestions based on individual dietary preferences.

### 3. Local Food Consideration

Considers food options selected by users as locally available.

### 4. Rural Community Focus

Designed around the accessibility and practical needs of rural communities.

### 5. Connected Digital Workflow

Connects patient information, risk assessment, and nutrition preferences in a unified user journey.

### 6. Potential for Community-Level Adoption

Provides a foundation for future collaboration with ASHA workers and rural healthcare organizations.

# 🛠️ 8. TECHNOLOGY STACK

| Technology | Purpose |
|---|---|
| Flutter | Frontend application |
| Dart | Application programming |
| Python | Backend programming |
| Flask | Backend API |
| SQLite | Data storage where configured |
| Rule-Based Engine | Risk assessment and educational nutrition workflows |

### System Architecture

```text
       FLUTTER APPLICATION
                |
                v
          BACKEND API
                |
                v
          PYTHON / FLASK
                |
                v
        APPLICATION LOGIC
                |
          --------------
          |            |
          v            v
     RISK ENGINE   NUTRITION ENGINE
                        |
                        v
                 USER PREFERENCES
```

**Technology transparency:** The current prototype uses rule-based decision-support logic. It is not a clinically validated AI/ML prediction system.

# 📊 9. CURRENT DEVELOPMENT STATUS

**Stage: Working Prototype | Testing in Progress**

The current application includes:

- Flutter-based user interface.
- Patient details dashboard.
- Pregnancy risk-assessment workflow.
- Risk-result presentation.
- Detailed risk indicators.
- Nutrition preference selection.
- Preference storage.
- Educational meal suggestion engine.
- Vegetarian food filtering.
- Data synchronization interface.
- ASHA worker login interface.

### Software Testing

Latest reported development checks:

- `flutter analyze` — No issues found.
- `flutter test` — 24 tests passed.

These results demonstrate software-level testing only. They do not establish clinical accuracy or real-world health outcomes.

# 🗺️ 10. FUTURE ROADMAP

Our goal is to develop PregAI Rural into a responsible and accessible maternal-health support platform.

| Phase | Planned Development |
|---|---|
| Phase 1 | Improve application usability and reliability. |
| Phase 2 | Seek expert review of pregnancy risk-assessment rules. |
| Phase 3 | Validate nutrition guidance with qualified professionals. |
| Phase 4 | Improve regional language accessibility, including Marathi. |
| Phase 5 | Improve low-connectivity usability and synchronization reliability. |
| Phase 6 | Conduct consent-based usability testing with intended users and ASHA workers. |
| Phase 7 | Explore a supervised rural Maharashtra pilot with appropriate partners and approvals. |

# ❤️ 11. EXPECTED SOCIAL IMPACT

PregAI Rural aims to contribute to:

- Better access to understandable maternal-health information.
- Greater awareness of pregnancy-related health concerns.
- More practical nutrition guidance.
- Improved engagement with digital maternal-health support.
- Stronger collaboration with frontline healthcare workers.
- Greater inclusion of rural women in digital healthcare initiatives.

These are intended outcomes that require future testing and evaluation. They are not claimed as already achieved results.

# 🔐 12. PRIVACY AND RESPONSIBLE HEALTHCARE

Maternal-health information is sensitive. Privacy and safety are essential for responsible deployment.

Our principles include:

- Respecting user consent.
- Protecting sensitive information.
- Using synthetic demonstration data.
- Strengthening application security.
- Seeking professional review of health-related content.
- Ensuring digital support does not replace medical care.

### Medical Disclaimer

PregAI Rural is an early-stage educational support prototype. Its risk-assessment logic and nutrition suggestions have not been clinically validated.

It does not diagnose medical conditions or prescribe treatment. It does not replace doctors, ANMs, ASHA workers, or other qualified healthcare professionals.

Users should seek professional medical advice for health concerns and urgent symptoms.

# 👩‍💻 13. RUN THE PROJECT LOCALLY

### Prerequisites

- Python 3
- Flutter SDK
- Git
- Chrome or Android Emulator

### Step 1: Clone the Repository

```bash
git clone https://github.com/GouriMundada/PregAI-Rural2.git
cd PregAI-Rural2
```

### Step 2: Set Up the Backend

Open PowerShell:

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

If `backend/.env.example` is available, create a local `.env` file and configure the required values.

Never commit real passwords, API keys, or secret credentials.

Start the backend using the current development entry point:

```powershell
.\.venv\Scripts\python.exe -c "from app import app; app.run(host='0.0.0.0', port=5000, debug=False)"
```

Keep this terminal running.

### Step 3: Run the Flutter Application

Open another PowerShell terminal:

```powershell
cd frontend/pregai
flutter pub get
flutter run -d chrome --dart-define=PREG_API_BASE_URL=http://127.0.0.1:5000/api
```

For Android Emulator:

```powershell
flutter run -d emulator-5554 --dart-define=PREG_API_BASE_URL=http://10.0.2.2:5000/api
```

These addresses are for local development and are not public demo URLs.

# 🤝 14. COLLABORATION OPPORTUNITIES

We welcome feedback and collaboration from:

- Maternal healthcare professionals.
- Nutrition experts.
- ASHA workers.
- Rural healthcare organizations.
- Developers and technology enthusiasts.
- Community health organizations.

Our next important milestone is to validate the application with the people it is intended to support.

# 📌 15. PROJECT INFORMATION

| Category | Details |
|---|---|
| Project Name | PregAI Rural |
| Domain | Healthcare Technology |
| Focus Area | Rural Maternal Healthcare |
| Frontend | Flutter |
| Backend | Python / Flask |
| Data Storage | SQLite, where configured |
| Development Stage | Working Prototype |
| Innovation Challenge | Seva First Innovation Challenge — Maharashtra Zone |

### Project Repository

[https://github.com/GouriMundada/PregAI-Rural2](https://github.com/GouriMundada/PregAI-Rural2)

**Live Demo:** Not publicly deployed yet.

---

<div align="center">

# 🌸 OUR VISION

### Every woman deserves access to understandable health information and practical support throughout her pregnancy journey.

**PregAI Rural — Technology for healthier pregnancies and stronger rural communities.**

Made with care for rural India ❤️

</div>
