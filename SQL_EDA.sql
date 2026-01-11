USE student_analytics ;

SELECT * from student;

select count(*) from student;

# What is the overall academic performance across subjects?
SELECT 
ROUND(AVG(math_score),2) as avg_math,
ROUND(AVG(writing_score),2) as avg_writing,
ROUND(AVG(reading_score),2) as avg_reading
FROM student;

# Are there performance differences between genders?
SELECT gender,
ROUND(AVG(math_score),2) as avg_math,
ROUND(AVG(writing_score),2) as avg_writing,
ROUND(AVG(reading_score),2) as avg_reading
FROM student 
GROUP BY gender;


# Which subject shows the highest score variability?
SELECT "math" AS math,
ROUND(STDDEV(math_score),2) as std_dev
FROM student
UNION ALL 
SELECT "reading",
ROUND(STDDEV(reading_score),2) 
FROM student
UNION ALL 
SELECT "writing",
ROUND(STDDEV(writing_score),2)
FROM student;
# The most variation occurs in writing subject which shows that the marks in that subject vary a lot


# Does test preparation course actually improve performance?
SELECT test_preparation_course, ROUND(AVG(average_score),2) as overall_avg_marks
FROM student
GROUP BY test_preparation_course;
# Hence we can see that the test preparation course increases the average score whereas students with no preperation course have a lower average (by almost 8 marks)


# What is the score improvement gap between prepared vs non-prepared students?
SELECT 
MAX(avg_score) - MIN(avg_score) as score_gap
FROM 
(SELECT
AVG(average_score) as avg_score
FROM student
GROUP BY test_preparation_course) as t; 


# How does parental education level influence student performance?
SELECT parental_level_of_education,
AVG(average_score) as avg_score 
FROM student
GROUP BY parental_level_of_education
ORDER BY avg_score DESC;
# We see that students with parents having higher educational qualification(Masters and Bachelors degrees) seem to perform better as compared to students with parents having lower educational qualification(high school or college)


# Do students with standard lunch perform better than subsidized lunch students?
SELECT lunch , 
AVG(average_score) as avg_score
FROM student
GROUP BY lunch ;
# Students with standard lunch seem to perform better as compared to free or reduced lunch. This may suggest that the food intake may be affecting student energy levels and concentration levels as well.alter


# What percentage of students fall into each performance category?
SELECT performance_category,student_count,
ROUND(student_count * 100 / SUM(student_count) OVER(),2) as percentage 
FROM (SELECT COUNT(*) as student_count, performance_category
FROM student
GROUP BY performance_category) as cnt ;


# Which demographic groups are over-represented in low performance?
SELECT
    gender,
    COUNT(*) AS poor_performers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM student s2 WHERE s2.gender = s1.gender),
        2
    ) AS poor_percentage
FROM student s1
WHERE performance_category = 'poor'
GROUP BY gender;


# Which parental education group has the highest proportion of excellent students?
SELECT
    parental_level_of_education,
    COUNT(*) AS excellent_students,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM student s2
         WHERE s2.parental_level_of_education = s1.parental_level_of_education),
        2
    ) AS excellent_percentage
FROM student s1
WHERE performance_category = 'excellent'
GROUP BY parental_level_of_education
ORDER BY excellent_percentage DESC;



