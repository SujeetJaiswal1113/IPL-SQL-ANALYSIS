 -- 01_basic.sql

-- Table checks

SELECT COUNT(*) AS total_matches
FROM matches;

SELECT COUNT(*) AS total_deliveries
FROM deliveries;

-- Basic KPIs

SELECT COUNT(DISTINCT season) AS total_seasons
FROM matches;

SELECT 
    season,
    COUNT(*) AS matches_played
FROM matches
GROUP BY season
ORDER BY season;

SELECT SUM(
    CASE 
        WHEN outcome IN ('0','1','2','3','4','5','6')
        THEN CAST(outcome AS INT)
        ELSE 0
    END
) AS total_runs
FROM deliveries;

SELECT COUNT(*) AS total_wickets
FROM deliveries
WHERE outcome = 'w';
