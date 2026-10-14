# 💼 Job Portal Management System using MySQL

An end-to-end relational database management system designed using **MySQL** to handle job portal operations, including user account management, job postings, candidate applications, interview scheduling, salary tracking, and automated audit trails.

---

## 📌 Project Overview

The **Job Portal Management System** provides a structured relational database architecture connecting **Job Seekers**, **Recruiters**, **Companies**, and **Job Categories**. 

It demonstrates core and advanced SQL concepts, including table normalization, data integrity constraints, foreign key relationships, complex joins, subqueries, view abstractions, stored procedures, user-defined functions, automated triggers, performance indexing, and transaction management (`COMMIT` / `ROLLBACK`).

---

## ✨ Features & Capabilities

- **User & Profile Management:** Differentiates between Job Seekers and Recruiters with contact and skill mappings.
- **Job & Category Tracking:** Categorizes jobs by industry type, salary, experience level, and geographic location.
- **Application Workflow:** Tracks candidate application stages (`Applied`, `Shortlisted`, `Interview`, `Selected`, `Rejected`).
- **Interview Scheduling:** Links candidate applications directly with interview schedules and results.
- **Automated Audit Trail:** Tracks system updates, job postings, and user insertions using background database triggers.
- **Custom Functions & Logic:** Includes procedural logic to categorize salary brackets, evaluate application scores, and determine experience levels.
- **Query Bank & Reports:** Provides multi-table aggregation reports for company applications, salary analysis, and candidate demographics.

---

## 🏗️ Database Architecture

The system contains **11 core relational tables**:

1. **`users`**: Central table for system profiles (Seekers and Recruiters).
2. **`companies`**: Details of hiring organizations.
3. **`categories`**: Classification of job fields (e.g., IT, Finance, Marketing).
4. **`jobs`**: Job postings linked to companies and categories.
5. **`job_seekers`**: Extended profiles for job candidates.
6. **`skills` & `seeker_skills`**: Skill inventory and seeker-to-skill mappings.
7. **`education`**: Candidate educational records.
8. **`applications`**: Application tracking linking seekers and job listings.
9. **`interviews`**: Scheduled interviews for shortlisted applicants.
10. **`user_audit` & `job_audit`**: Automated logging tables for tracking schema insertions and transactions.

---

## ⚙️ SQL Concepts & Database Objects

### 1. Views
- `job_details`: Summary view of available jobs.
- `job_seeker_details`: Pre-filtered list of registered job seekers.
- `application_details`: Combined report of candidate names, job titles, companies, and application dates.
- `shortlisted_candidates`: Filters applications with 'Shortlisted' status.
- `high_salary_jobs`: Displays job postings offering salaries $\ge$ 500,000.

### 2. Stored Procedures
- `get_jobs_by_location(loc)`: Retrieves job listings filtered by city.
- `get_jobs_by_salary(min_salary)`: Returns jobs meeting or exceeding a salary limit.
- `search_jobs(loc, min_salary)`: Combined filter for location and minimum salary.
- `get_applications_by_status(app_status)`: Filters candidate applications by status.
- `get_application_details()`: Joining routine displaying application metadata.

### 3. User-Defined Functions (UDFs)
- `salary_in_lakhs(sal)`: Converts raw numbers to Lakhs.
- `experience_level(exp)`: Categorizes experience into *Fresher*, *Junior*, *Mid Level*, or *Senior*.
- `application_score(status)`: Returns a numerical rank based on candidate stage.
- `total_applications(seeker)`: Returns total applications submitted by a user.
- `job_application_count(jid)`: Returns application counts for a specific job post.
- `salary_category(sal)`: Categorizes jobs into *High*, *Medium*, or *Low* salary brackets.

### 4. Triggers & Audits
- `before_job_insert`: Ensures inserted salaries cannot be negative (defaults to 0).
- `after_user_insert`: Automatically logs newly created accounts into `user_audit`.

### 5. Performance Indexes
Indexes created across high-frequency lookup fields:
- `idx_job_title`, `idx_job_salary`, `idx_job_company`, `idx_job_category`
- `idx_application_job`, `idx_application_status`, `idx_application_seeker`
- Composite Index: `idx_job_company_category`

---

## 🛠️ How to Run the Project

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/your-username/job-portal-management-system.git](https://github.com/your-username/job-portal-management-system.git)
