-- 03_player_analysis.sql

-- Query 1: Top Batsmen

SELECT
    batter,
    SUM(
        CASE
            WHEN outcome LIKE '%wd%' THEN 0
            WHEN outcome LIKE '%nb%' THEN 0
            WHEN outcome LIKE '%lb%' THEN 0
            WHEN outcome LIKE '%b%' AND outcome NOT LIKE '%lb%' THEN 0
            WHEN outcome = 'w' THEN 0
            WHEN outcome IN ('0','1','2','3','4','5','6')
                THEN CAST(outcome AS INT)
            ELSE 0
        END
    ) AS total_runs
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC;


-- Query 2: Top Bowlers

SELECT
    bowler,
    COUNT(*) AS wickets
FROM deliveries
WHERE outcome = 'w'
GROUP BY bowler
ORDER BY wickets DESC;

-- Query 3: Player Consistency

SELECT
    batter,

    SUM(
        CASE
            WHEN outcome LIKE '%wd%' THEN 0
            ELSE 1
        END
    ) AS balls_faced,

    SUM(
        CASE
            WHEN outcome LIKE '%wd%' THEN 0
            WHEN outcome LIKE '%nb%' THEN 0
            WHEN outcome = 'w' THEN 0
            WHEN outcome LIKE '%lb%' THEN 0
            WHEN outcome LIKE '%b%' AND outcome NOT LIKE '%lb%' THEN 0
            WHEN outcome IN ('0','1','2','3','4','5','6')
                THEN CAST(outcome AS INT)
            ELSE 0
        END
    ) AS total_runs

FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC;


-- strike-rate style KPI:

SELECT
    batter,

    SUM(
        CASE
            WHEN outcome IN ('0','1','2','3','4','5','6')
            THEN CAST(outcome AS INT)
            ELSE 0
        END
    ) AS total_runs,

    COUNT(*) AS balls_faced,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN outcome IN ('0','1','2','3','4','5','6')
                THEN CAST(outcome AS INT)
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS strike_rate

FROM deliveries
GROUP BY batter
ORDER BY strike_rate DESC;