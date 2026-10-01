/* ============================================================
   PROJECT: Indian Railway Delay & Reliability Analysis
   DATABASE: MySQL
   DATA: 500-row synthetic railway journey dataset
   ============================================================ */


/* ============================================================
   1. DATABASE SETUP
   ============================================================ */

CREATE DATABASE IF NOT EXISTS indian_railway_analysis;

USE indian_railway_analysis;


/* ============================================================
   2. TABLE CREATION
   ============================================================ */

DROP TABLE IF EXISTS railway_journeys;

CREATE TABLE railway_journeys (
    journey_id VARCHAR(20) PRIMARY KEY,
    train_number INT,
    train_type VARCHAR(30),
    departure_date DATE,
    year INT,
    month INT,
    day_of_week VARCHAR(15),
    departure_hour INT,
    is_weekend BOOLEAN,
    is_night_departure BOOLEAN,
    is_peak_hour BOOLEAN,
    is_festival_season BOOLEAN,
    season VARCHAR(15),
    zone VARCHAR(100),
    zone_abbr VARCHAR(10),
    source_station_category VARCHAR(30),
    destination_station_category VARCHAR(30),
    distance_km INT,
    num_scheduled_stops INT,
    scheduled_travel_hours DECIMAL(6,2),
    track_doubled BOOLEAN,
    is_hdn_route BOOLEAN,
    traction_type VARCHAR(20),
    is_electrified BOOLEAN,
    psr_count INT,
    is_circular_route BOOLEAN,
    is_monsoon_season BOOLEAN,
    is_fog_risk BOOLEAN,
    fog_risk_score DECIMAL(4,2),
    zone_fog_index DECIMAL(4,2),
    zone_congestion_index DECIMAL(4,2),
    season_severity_score DECIMAL(4,2),
    loco_age_years DECIMAL(5,1),
    coach_age_years DECIMAL(5,1),
    has_lhb_coaches BOOLEAN,
    is_rake_shared BOOLEAN,
    maintenance_score DECIMAL(4,2),
    seat_utilisation_pct DECIMAL(5,1),
    is_overloaded BOOLEAN,
    late_incoming_rake BOOLEAN,
    is_special_train BOOLEAN,
    route_historical_ontime_pct DECIMAL(5,1),
    primary_delay_cause VARCHAR(50),
    delay_minutes INT,
    is_delayed BOOLEAN
);


/* ============================================================
   3. DATA IMPORT
   ------------------------------------------------------------
   Run this only after placing the CSV at the specified path.
   Change the file path according to your computer.
   ============================================================ */

-- LOAD DATA LOCAL INFILE
-- 'C:/path/to/indian_railway_delay_sample_500.csv'
-- INTO TABLE railway_journeys
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;


/* ============================================================
   4. DATA QUALITY CHECKS
   ============================================================ */

-- Total number of records

SELECT
    COUNT(*) AS total_journeys
FROM railway_journeys;


-- Check for duplicate journey IDs

SELECT
    journey_id,
    COUNT(*) AS occurrences
FROM railway_journeys
GROUP BY journey_id
HAVING COUNT(*) > 1;


-- Check missing important values

SELECT
    SUM(journey_id IS NULL) AS missing_journey_id,
    SUM(train_number IS NULL) AS missing_train_number,
    SUM(departure_date IS NULL) AS missing_departure_date,
    SUM(delay_minutes IS NULL) AS missing_delay,
    SUM(primary_delay_cause IS NULL) AS missing_delay_cause
FROM railway_journeys;


-- Check delay range

SELECT
    MIN(delay_minutes) AS minimum_delay,
    MAX(delay_minutes) AS maximum_delay,
    ROUND(AVG(delay_minutes),2) AS average_delay
FROM railway_journeys;


/* ============================================================
   5. ANALYSIS 1
   OVERALL RAILWAY DELAY PERFORMANCE
   ============================================================ */

SELECT
    COUNT(*) AS total_journeys,
    ROUND(AVG(delay_minutes),2) AS avg_delay_minutes,
    MAX(delay_minutes) AS max_delay_minutes,
    SUM(is_delayed) AS delayed_journeys,
    ROUND(100 * AVG(is_delayed),2) AS delay_rate_pct,
    ROUND(100 * AVG(NOT is_delayed),2) AS on_time_rate_pct
FROM railway_journeys;


/* ============================================================
   6. ANALYSIS 2
   DELAY CAUSE ANALYSIS
   ============================================================ */

SELECT
    primary_delay_cause,
    COUNT(*) AS journeys,
    ROUND(AVG(delay_minutes),2) AS avg_delay_minutes,
    ROUND(100 * AVG(is_delayed),2) AS delay_rate_pct,
    MAX(delay_minutes) AS maximum_delay
FROM railway_journeys
GROUP BY primary_delay_cause
ORDER BY avg_delay_minutes DESC;


/* ============================================================
   7. ANALYSIS 3
   TRAIN RELIABILITY ANALYSIS
   ============================================================ */

SELECT
    train_number,
    train_type,
    COUNT(*) AS journeys,
    ROUND(AVG(delay_minutes),2) AS avg_delay_minutes,
    ROUND(100 * AVG(is_delayed),2) AS delay_rate_pct,
    ROUND(100 * AVG(NOT is_delayed),2) AS on_time_rate_pct
FROM railway_journeys
GROUP BY train_number, train_type
ORDER BY on_time_rate_pct DESC;


/* ============================================================
   8. ANALYSIS 4
   SEASONAL DELAY ANALYSIS
   ============================================================ */

SELECT
    season,
    COUNT(*) AS journeys,
    ROUND(AVG(delay_minutes),2) AS avg_delay_minutes,
    ROUND(100 * AVG(is_delayed),2) AS delay_rate_pct,
    MAX(delay_minutes) AS maximum_delay
FROM railway_journeys
GROUP BY season
ORDER BY avg_delay_minutes DESC;


/* ============================================================
   9. ANALYSIS 5
   RAILWAY ZONE ANALYSIS
   ============================================================ */

SELECT
    zone,
    zone_abbr,
    COUNT(*) AS journeys,
    ROUND(AVG(delay_minutes),2) AS avg_delay_minutes,
    ROUND(100 * AVG(is_delayed),2) AS delay_rate_pct,
    ROUND(100 * AVG(NOT is_delayed),2) AS on_time_rate_pct
FROM railway_journeys
GROUP BY zone, zone_abbr
ORDER BY avg_delay_minutes DESC;


/* ============================================================
   10. ANALYSIS 6
   PEAK HOUR + WEEKEND ANALYSIS
   ============================================================ */

SELECT
    CASE
        WHEN is_peak_hour = TRUE THEN 'Peak Hour'
        ELSE 'Non-Peak Hour'
    END AS period,

    CASE
        WHEN is_weekend = TRUE THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    COUNT(*) AS journeys,
    ROUND(AVG(delay_minutes),2) AS avg_delay_minutes,
    ROUND(100 * AVG(is_delayed),2) AS delay_rate_pct
FROM railway_journeys
GROUP BY
    is_peak_hour,
    is_weekend
ORDER BY avg_delay_minutes DESC;


/* ============================================================
   11. ANALYSIS 7
   DELAY SEVERITY ANALYSIS
   ============================================================ */

SELECT
    CASE
        WHEN delay_minutes = 0
            THEN 'On Time'

        WHEN delay_minutes <= 15
            THEN 'Minor Delay'

        WHEN delay_minutes <= 30
            THEN 'Moderate Delay'

        WHEN delay_minutes <= 60
            THEN 'Major Delay'

        ELSE 'Severe Delay'
    END AS delay_category,

    COUNT(*) AS journeys,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM railway_journeys),
        2
    ) AS percentage_of_journeys

FROM railway_journeys

GROUP BY
    CASE
        WHEN delay_minutes = 0
            THEN 'On Time'

        WHEN delay_minutes <= 15
            THEN 'Minor Delay'

        WHEN delay_minutes <= 30
            THEN 'Moderate Delay'

        WHEN delay_minutes <= 60
            THEN 'Major Delay'

        ELSE 'Severe Delay'
    END

ORDER BY
    CASE
        WHEN delay_category = 'On Time' THEN 1
        WHEN delay_category = 'Minor Delay' THEN 2
        WHEN delay_category = 'Moderate Delay' THEN 3
        WHEN delay_category = 'Major Delay' THEN 4
        WHEN delay_category = 'Severe Delay' THEN 5
    END;


