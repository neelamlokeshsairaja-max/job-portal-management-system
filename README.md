# 💼 Job Portal Management System using MySQL

An end-to-end relational database management system designed using **MySQL** to handle job portal operations, including user account management, job postings, candidate applications, interview scheduling, salary tracking, and automated audit trails.

---

## 📌 Project Overview

The **Job Portal Management System** provides a structured relational database architecture connecting **Job Seekers**, **Recruiters**, **Companies**, and **Job Categories**. 

It demonstrates core and advanced SQL concepts, including table normalization, data integrity constraints, foreign key relationships, complex joins, subqueries, view abstractions, stored procedures, user-defined functions, automated triggers, performance indexing, and transaction management (`COMMIT` / `ROLLBACK`).

---

## 🏗️ Database Architecture & ER Diagram

The entity-relationship model and relational database design for the system are illustrated below:

<p align="center">
  <img src=""C:\Users\dell\OneDrive\Desktop\project\er.png"" alt="Job Portal Management System ER Diagram" width="100%">
</p>

### ER Diagram Explanation

The Entity-Relationship (ER) diagram models the architecture of the recruitment platform, illustrating how users, companies, job listings, and application workflows relate to one another:

1. **`users` (Central Actor Entity):** Represents all system participants, including both **Job Seekers** and **Recruiters**, storing credentials, contact details, and user types.
2. **`companies` & `categories`:** 
   * `companies` stores organization details of hiring companies (One-to-Many relationship with `jobs`).
   * `categories` classifies job openings by industry sectors (e.g., Software Development, Marketing, Finance).
3. **`jobs`:** Stores job descriptions, titles, salaries, locations, and experience requirements, linked directly to companies and categories via foreign keys.
4. **`job_seekers`, `skills`, & `education`:** Extends user profiles with candidate-specific data, manages Many-to-Many skill mappings via `seeker_skills`, and records educational qualifications.
5. **`applications` & `interviews`:** 
   * `applications` links job seekers to jobs, tracking candidate application progress and statuses (`Applied`, `Shortlisted`, `Selected`, `Rejected`).
   * `interviews` connects directly to applications to schedule and track interview rounds and feedback.
6. **Audit Logs (`user_audit` & `job_audit`):** Background tables populated automatically via database triggers to log new user registrations and job insertions.

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
   git clone [https://github.com/neelamlokeshsairaja-max/job-portal-management-system.git](https://github.com/neelamlokeshsairaja-max/job-portal-management-system.git)
