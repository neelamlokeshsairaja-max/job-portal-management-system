show databases;
use job_portal;
show tables;
select*from users;
select*from skills;
select*from seeker_skills;
select*from jobs;
select*from job_seekers;
select*from interviews;
select*from education;
select*from companies;
select*from categories;
select*from applications;
insert into users;
#filter job
SELECT *
FROM jobs
WHERE location = 'Hyderabad';

desc users;
SELECT *
FROM users
WHERE user_type = 'Job Seeker';

SELECT *
FROM users
WHERE user_role = 'Job Seeker';


SELECT *
FROM users
WHERE user_type = 'Recruiter';

SELECT *
FROM jobs
WHERE location = 'Hyderabad';

SELECT *
FROM applications
WHERE status = 'Shortlisted';

#distinct
SELECT DISTINCT user_type
FROM users;

SELECT DISTINCT location
FROM jobs;

SELECT DISTINCT status
FROM applications;

#aggregate functions

SELECT COUNT(*) AS total_users
FROM users;

SELECT COUNT(*) AS total_jobs
FROM jobs;

SELECT MAX(salary) AS highest_salary
FROM jobs;

SELECT MIN(salary) AS lowest_salary
FROM jobs;

SELECT AVG(salary) AS average_salary
FROM jobs;

#group by

SELECT user_type, COUNT(*) AS total_users
FROM users
GROUP BY user_type;

SELECT location, COUNT(*) AS total_jobs
FROM jobs
GROUP BY location;

SELECT status, COUNT(*) AS total_applications
FROM applications
GROUP BY status;

#having
SELECT status, COUNT(*) AS total
FROM applications
GROUP BY status
HAVING COUNT(*) > 2;

#like
SELECT *
FROM jobs
WHERE job_title LIKE '%Python%';

SELECT *
FROM jobs
WHERE job_title LIKE 'Data%';

SELECT *
FROM jobs
WHERE job_title LIKE '%Developer';

#in

SELECT *
FROM jobs
WHERE location IN ('Hyderabad', 'Bangalore', 'Pune');

#blw
SELECT *
FROM jobs
WHERE salary BETWEEN 400000 AND 800000;

#joins
SELECT
    j.job_title,
    c.company_name,
    j.location,
    j.salary
FROM jobs j
INNER JOIN companies c
ON j.company_id = c.company_id;

#inner join
SELECT
    j.job_id,
    j.job_title,
    c.company_name,
    j.location,
    j.salary
FROM jobs j
INNER JOIN companies c
ON j.company_id = c.company_id;

#left join
SELECT
    j.job_id,
    j.job_title,
    c.company_name,
    j.location,
    j.salary
FROM jobs j
LEFT JOIN companies c
ON j.company_id = c.company_id;

#right join
SELECT
    j.job_id,
    j.job_title,
    c.company_name,
    j.location,
    j.salary
FROM jobs j
RIGHT JOIN companies c
ON j.company_id = c.company_id;

#subquery
#avg sal
SELECT *
FROM jobs
WHERE salary > (
    SELECT AVG(salary)
    FROM jobs
);

#high sal
SELECT *
FROM jobs
WHERE salary = (
    SELECT MAX(salary)
    FROM jobs
);

#low sal
SELECT *
FROM jobs
WHERE salary = (
    SELECT MIN(salary)
    FROM jobs
);

#single row
SELECT *
FROM jobs
WHERE salary > (
    SELECT AVG(salary)
    FROM jobs
);

#multi row
SELECT *
FROM users
WHERE user_id IN (
    SELECT seeker_id
    FROM applications
);

#views

CREATE VIEW job_details AS
SELECT *
FROM jobs;

SELECT * FROM job_details;

SELECT * FROM job_company_details;

CREATE VIEW job_seeker_details AS
SELECT
    user_id,
    name,
    email,
    phone
FROM users
WHERE user_type = 'Job Seeker';

select * from job_seeker_details;

CREATE VIEW application_details AS
SELECT
    a.application_id,
    u.name AS seeker_name,
    j.job_title,
    c.company_name,
    a.status,
    a.application_date
FROM applications a
JOIN users u
ON a.seeker_id = u.user_id
JOIN jobs j
ON a.job_id = j.job_id
JOIN companies c
ON j.company_id = c.company_id;

SELECT * FROM application_details;

CREATE VIEW shortlisted_candidates AS
SELECT
    u.name AS seeker_name,
    j.job_title,
    c.company_name,
    a.status
FROM applications a
JOIN users u
ON a.seeker_id = u.user_id
JOIN jobs j
ON a.job_id = j.job_id
JOIN companies c
ON j.company_id = c.company_id
WHERE a.status = 'Shortlisted';

SELECT * FROM shortlisted_candidates;

CREATE VIEW high_salary_jobs AS
SELECT
    job_id,
    job_title,
    location,
    salary
FROM jobs
WHERE salary >= 500000;

SELECT * FROM high_salary_jobs;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

#store procedure

DELIMITER //

CREATE PROCEDURE get_jobs_by_location(IN loc VARCHAR(100))
BEGIN
    SELECT *
    FROM jobs
    WHERE location = loc;
END //

DELIMITER ;

CALL get_jobs_by_location('Hyderabad');

DELIMITER //

CREATE PROCEDURE get_jobs_by_salary(IN min_salary DECIMAL(10,2))
BEGIN
    SELECT
        job_id,
        job_title,
        location,
        salary
    FROM jobs
    WHERE salary >= min_salary;
END //

DELIMITER ;

CALL get_jobs_by_salary(600000);

DELIMITER //

CREATE PROCEDURE search_jobs(
    IN loc VARCHAR(100),
    IN min_salary DECIMAL(10,2)
)
BEGIN
    SELECT
        job_id,
        job_title,
        location,
        salary
    FROM jobs
    WHERE location = loc
    AND salary >= min_salary;
END //

DELIMITER ;

CALL search_jobs('Hyderabad', 500000);


DELIMITER //

CREATE PROCEDURE get_all_applications()
BEGIN
    SELECT *
    FROM applications;
END //

DELIMITER ;

CALL get_all_applications();

DELIMITER //

CREATE PROCEDURE get_applications_by_status(
    IN app_status VARCHAR(50)
)
BEGIN
    SELECT *
    FROM applications
    WHERE status = app_status;
END //

DELIMITER ;

CALL get_applications_by_status('Shortlisted');

CALL get_applications_by_status('Rejected');

CALL get_applications_by_status('Interview');

DELIMITER //

CREATE PROCEDURE get_application_details()
BEGIN
    SELECT
        a.application_id,
        u.name AS seeker_name,
        j.job_title,
        a.application_date,
        a.status
    FROM applications a
    INNER JOIN users u
        ON a.seeker_id = u.user_id
    INNER JOIN jobs j
        ON a.job_id = j.job_id;
END //

DELIMITER ;

CALL get_application_details();

SHOW PROCEDURE STATUS
WHERE Db = DATABASE();

SHOW CREATE PROCEDURE search_jobs;

DROP PROCEDURE IF EXISTS search_jobs;

#functions

DELIMITER //

CREATE FUNCTION salary_in_lakhs(sal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN sal / 100000;
END //

DELIMITER ;

SELECT salary_in_lakhs(600000);

SELECT
    job_title,
    salary,
    salary_in_lakhs(salary) AS salary_in_lakhs
FROM jobs;


DELIMITER //

CREATE FUNCTION experience_level(exp INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF exp = 0 THEN
        RETURN 'Fresher';
    ELSEIF exp <= 2 THEN
        RETURN 'Junior';
    ELSEIF exp <= 5 THEN
        RETURN 'Mid Level';
    ELSE
        RETURN 'Senior';
    END IF;
END //

DELIMITER ;

SELECT experience_level(0);

SELECT
    job_id,
    job_title,
    experience_required,
    experience_level(experience_required) AS level
FROM jobs;

DELIMITER //

CREATE FUNCTION application_score(app_status VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    IF app_status = 'Selected' THEN
        RETURN 4;
    ELSEIF app_status = 'Interview' THEN
        RETURN 3;
    ELSEIF app_status = 'Shortlisted' THEN
        RETURN 2;
    ELSEIF app_status = 'Applied' THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END //

DELIMITER ;

SELECT
    application_id,
    status,
    application_score(status) AS score
FROM applications;

DELIMITER //

CREATE FUNCTION total_applications(seeker INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM applications
    WHERE seeker_id = seeker;

    RETURN total;
END //

DELIMITER ;

SELECT total_applications(1);

SELECT
    user_id,
    name,
    total_applications(user_id) AS total_applications
FROM users;

DELIMITER //

CREATE FUNCTION job_application_count(jid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM applications
    WHERE job_id = jid;

    RETURN total;
END //

DELIMITER ;


SELECT
    job_id,
    job_title,
    job_application_count(job_id) AS total_applications
FROM jobs;

#salary check table

DELIMITER //

CREATE FUNCTION salary_category(sal DECIMAL(10,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN

    IF sal >= 60000 THEN
        RETURN 'High Salary';

    ELSEIF sal >= 40000 THEN
        RETURN 'Medium Salary';

    ELSE
        RETURN 'Low Salary';

    END IF;

END //

DELIMITER ;

SELECT salary_category(50000);

#triggers


CREATE TABLE user_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    name VARCHAR(100),
    email VARCHAR(150),
    user_type VARCHAR(50),
    action VARCHAR(50),
    action_time DATETIME
);

#create triggers

DELIMITER //

CREATE TRIGGER after_user_insert
AFTER INSERT
ON users
FOR EACH ROW
BEGIN

    INSERT INTO user_audit
    (
        user_id,
        name,
        email,
        user_type,
        action,
        action_time
    )
    VALUES
    (
        NEW.user_id,
        NEW.name,
        NEW.email,
        NEW.`type`,
        'NEW USER',
        NOW()
    );

END //

DELIMITER ;

DESC users;
SHOW COLUMNS FROM users;


DELIMITER //

CREATE TRIGGER after_user_insert
AFTER INSERT
ON users
FOR EACH ROW
BEGIN

    INSERT INTO user_audit
    (
        user_id,
        name,
        email,
        action,
        action_time
    )
    VALUES
    (
        NEW.user_id,
        NEW.name,
        NEW.email,
        'NEW USER',
        NOW()
    );

END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER before_job_insert
BEFORE INSERT
ON jobs
FOR EACH ROW
BEGIN

    IF NEW.salary < 0 THEN
        SET NEW.salary = 0;
    END IF;

END //

DELIMITER ;

Show triggers;

INSERT INTO jobs
(company_id, category_id, job_title, job_description, salary)
VALUES
(1, 1, 'Test Developer', 'Testing trigger', -50000);


SELECT * FROM jobs
WHERE job_title = 'Test Developer';

#Index
SHOW INDEX FROM users;

SHOW INDEX FROM jobs;

SHOW INDEX FROM applications;

#index tittle
CREATE INDEX idx_job_title
ON jobs(job_title);

SHOW INDEX FROM jobs;

#index salary
SELECT *
FROM jobs
WHERE salary > 500000;

CREATE INDEX idx_job_salary
ON jobs(salary);

#index companyid
SELECT j.job_title, c.company_name
FROM jobs j
JOIN companies c
ON j.company_id = c.company_id;

CREATE INDEX idx_job_company
ON jobs(company_id);

#category id
CREATE INDEX idx_job_category
ON jobs(category_id);

SELECT *
FROM jobs
WHERE category_id = 2;

#applications
SELECT *
FROM applications
WHERE job_id = 1;

CREATE INDEX idx_application_job
ON applications(job_id);

#application status 
SELECT *
FROM applications
WHERE status = 'Selected';

CREATE INDEX idx_application_status
ON applications(status);

#application index
DESC applications;

CREATE INDEX idx_application_seeker
ON applications(seeker_id);

#coposite index
CREATE INDEX idx_job_company_category
ON jobs(company_id, category_id);

#see all index
SHOW INDEX FROM users;
SHOW INDEX FROM jobs;
SHOW INDEX FROM applications;
SHOW INDEX FROM companies;

#Transaction
START TRANSACTION;

INSERT INTO applications
(job_id, status)
VALUES
(2, 'Pending');

SELECT * FROM applications;

commit

#roll back
START TRANSACTION;

INSERT INTO applications
(job_id, status)
VALUES
(3, 'Pending');

ROLLBACK;

#commit
START TRANSACTION;

INSERT INTO applications
(job_id, status)
VALUES
(3, 'Pending');

COMMIT;

#Real job protal 
ROLLBACK;

CREATE TABLE job_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT,
    job_title VARCHAR(100),
    action VARCHAR(50),
    action_time DATETIME
);

START TRANSACTION;

INSERT INTO jobs
(company_id, category_id, job_title, job_description, salary)
VALUES
(1, 1, 'Data Scientist',
'Develop machine learning models',
700000);

INSERT INTO job_audit
(job_id, job_title, action, action_time)
VALUES
(LAST_INSERT_ID(),
'Data Scientist',
'NEW JOB',
NOW());

COMMIT;

SELECT * FROM jobs
WHERE job_title = 'Data Scientist';

SELECT * FROM job_audit;

START TRANSACTION;

INSERT INTO jobs
(company_id, category_id, job_title, job_description, salary)
VALUES
(2, 2, 'Test Developer',
'Testing rollback',
400000);

ROLLBACK;

SELECT * FROM jobs
WHERE job_title = 'Test Developer';

#crud operation
INSERT INTO jobs
(company_id, category_id, job_title, job_description, salary)
VALUES
(1, 1, 'Python Developer',
 'Develop and maintain Python applications',
 600000);
 
 SELECT * FROM jobs;
 
 #read view jobs
 
 SELECT * FROM jobs;
 
 # read spefic col
 
 SELECT job_id, job_title, salary
FROM jobs;

#read a particular job

SELECT *
FROM jobs
WHERE job_id = 1;

#read job with salary
SELECT job_title, salary
FROM jobs
WHERE salary > 500000;


#update
UPDATE jobs
SET salary = 700000
WHERE job_id = 1;

SELECT *
FROM jobs
WHERE job_id = 1;

UPDATE jobs
SET
    job_title = 'Senior Python Developer',
    salary = 800000
WHERE job_id = 1;

#delete
SELECT *
FROM applications
WHERE job_id = 4;

DELETE FROM applications
WHERE job_id = 4;

SELECT * FROM jobs;

#on delete cascade
SHOW CREATE TABLE applications;


DELETE FROM jobs
WHERE job_id = 4;

#reports
SELECT COUNT(*) AS total_registered_users
FROM users;

SELECT COUNT(*) AS total_companies
FROM companies;

SELECT COUNT(*) AS total_jobs
FROM jobs;

SELECT COUNT(*) AS total_applications
FROM applications;

SELECT 
    j.job_id,
    j.job_title,
    COUNT(a.application_id) AS total_applications
FROM jobs j
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY j.job_id, j.job_title
ORDER BY total_applications DESC;

SELECT 
    c.company_id,
    c.company_name,
    COUNT(a.application_id) AS total_applications
FROM companies c
JOIN jobs j
    ON c.company_id = j.company_id
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY c.company_id, c.company_name
ORDER BY total_applications DESC;

DESC jobs;

SHOW COLUMNS FROM jobs;

SHOW COLUMNS FROM jobs;

SELECT
    job_type,
    COUNT(*) AS total_jobs
FROM jobs
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT job_type, COUNT(*) AS total_jobs
FROM jobs
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT 
    c.company_id,
    c.company_name,
    COUNT(a.application_id) AS total_applications
FROM companies c
JOIN jobs j
    ON c.company_id = j.company_id
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY c.company_id, c.company_name
ORDER BY total_applications DESC;

DESCRIBE jobs;

SELECT
    job_type,
    COUNT(*) AS total_jobs
FROM jobs
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT
    job_type,
    COUNT(*) AS total_jobs
FROM jobs
WHERE job_type IS NOT NULL
  AND job_type <> ''
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT job_type
FROM jobs;

SELECT *
FROM jobs;

SELECT job_type, COUNT(*) AS total_jobs
FROM jobs
WHERE job_type IS NOT NULL
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT COUNT(*) AS selected_candidates
FROM applications
WHERE status = 'Selected';

SELECT COUNT(*) AS rejected_candidates
FROM applications
WHERE status = 'Rejected';

SELECT 
    status,
    COUNT(*) AS total_candidates
FROM applications
WHERE status IN ('Selected', 'Rejected')
GROUP BY status;

DESC applications;

CREATE TABLE interviews (
    interview_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    interview_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
);

SELECT
    status,
    COUNT(*) AS total_interviews
FROM interviews
GROUP BY status;

SELECT DISTINCT status
FROM applications;

SELECT
    status,
    COUNT(*) AS total_candidates
FROM applications
WHERE status IN ('Selected', 'Rejected')
GROUP BY status;

DESC applications;

SELECT DISTINCT status FROM applications;

SELECT 
    status,
    COUNT(*) AS total_interviews
FROM interviews
GROUP BY status;

SELECT
    c.company_name,
    j.job_title,
    COUNT(a.application_id) AS total_applications
FROM companies c
JOIN jobs j
    ON c.company_id = j.company_id
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY
    c.company_name,
    j.job_title
ORDER BY total_applications DESC;

SELECT
    c.company_name,
    j.job_title,
    j.job_type,
    COUNT(a.application_id) AS total_applications
FROM companies c
JOIN jobs j
    ON c.company_id = j.company_id
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY
    c.company_name,
    j.job_title,
    j.job_type
ORDER BY total_applications DESC;

SELECT
    job_type,
    COUNT(*) AS total_jobs
FROM jobs
WHERE job_type IS NOT NULL
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT *
FROM applications;

SELECT
    application_id,
    status
FROM applications;

-- Applications by Company
SELECT
    c.company_name,
    j.job_title,
    COUNT(a.application_id) AS total_applications
FROM companies c
JOIN jobs j
    ON c.company_id = j.company_id
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY c.company_name, j.job_title
ORDER BY total_applications DESC;

-- Jobs by Category / Type
SELECT
    job_type,
    COUNT(*) AS total_jobs
FROM jobs
WHERE job_type IS NOT NULL
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT
    c.company_name,
    j.job_title,
    COUNT(a.application_id) AS total_applications
FROM companies c
JOIN jobs j
    ON c.company_id = j.company_id
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY
    c.company_name,
    j.job_title
ORDER BY total_applications DESC;

SELECT
    job_type,
    COUNT(*) AS total_jobs
FROM jobs
GROUP BY job_type
ORDER BY total_jobs DESC;

SELECT * FROM companies;

SELECT * FROM jobs;

SELECT * FROM applications;

