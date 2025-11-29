use crowdfunding_kickstarter;
----- total number of projects based on outcomcome ------

SELECT state, COUNT(*) AS total_projects
FROM projects
GROUP BY state;

----- total number of projects based on location ---------

select location_id,count(location_id) as total_projects
from projects
group by location_id;

 ------- # total number of projects based on category # -----
 
select category_id,count(category_id) as total_projects
from projects
group by category_id;

-------# total number of projects created by year,quarter,month #------

SELECT
    YEAR(FROM_UNIXTIME(created_at)) AS project_year,
    QUARTER(FROM_UNIXTIME(created_at)) AS project_quarter,
    MONTH(FROM_UNIXTIME(created_at)) AS project_month,
    COUNT(*) AS total_projects
FROM projects
GROUP BY
    YEAR(FROM_UNIXTIME(created_at)),
    QUARTER(FROM_UNIXTIME(created_at)),
    MONTH(FROM_UNIXTIME(created_at))
ORDER BY
    project_year,
    project_quarter,
    project_month;
    
    ------ # successful projects #---------
             
    SELECT
    COUNT(*) AS successful_projects,
    SUM(pledged* static_usd_rate) AS total_amount_raised_usd,
    SUM(backers_count) AS number_backers
FROM
    projects
WHERE
    state = 'successful';
    SELECT
    COUNT(*) AS successful_projects,
    SUM(pledged * static_usd_rate) AS total_pledged_usd,
    SUM(backers_count) AS total_backers,
    AVG(DATEDIFF(FROM_UNIXTIME(deadline), FROM_UNIXTIME(launched_at))) AS avg_days_to_success
FROM
    projects
WHERE
    state = 'successful';
    
 --------- # top 10 successful projects based on number of backers #--------   
    
    SELECT 
	ProjectID,
  name,
  backers_count
FROM projects
ORDER BY backers_count DESC
LIMIT 10;

-------- # top 10 successful projects based on amount raised #-----------

SELECT
    ProjectID,
    name,
    pledged AS amount_raised
FROM projects
ORDER BY pledged DESC
LIMIT 10;

------ # percentage of successfl projects overall #------

SELECT
    COUNT(*) AS total_projects,
    SUM(CASE WHEN pledged >= goal THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN pledged >= goal THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS success_percentage
FROM projects;

 ------ # percentage of successfl projects by category # --------

SELECT
    category_id,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN pledged >= goal THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN pledged >= goal THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS success_percentage
FROM projects
GROUP BY category_id
ORDER BY success_percentage DESC;

-------- # percentage of successfl projects by year,month #------

SELECT
    YEAR(FROM_UNIXTIME(launched_at)) AS project_year,
    MONTH(FROM_UNIXTIME(launched_at)) AS project_month,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN pledged >= goal THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN pledged >= goal THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS success_percentage
FROM projects
GROUP BY project_year, project_month
ORDER BY project_year, project_month;

----- # percentage of successfl projects by goal range #------

SELECT
    CASE
        WHEN goal >= 10000 THEN '10000 or more'
        WHEN goal >= 5000 THEN '5000-9999'
        WHEN goal >= 1000 THEN '1000-4999'
        ELSE 'Below 1000'
    END AS goal_range,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND(SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS success_percentage
FROM projects
GROUP BY goal_range
ORDER BY goal_range;


    
    
    
   
    

