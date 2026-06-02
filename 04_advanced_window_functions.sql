
-- 04_advanced_window_functions.sql

-- 1. DENSE_RANK vs RANK

SELECT 
    batter,
    total_runs,
    RANK() OVER (ORDER BY total_runs DESC) AS rank_position,
    DENSE_RANK() OVER (ORDER BY total_runs DESC) AS dense_rank_position
FROM (
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
) t;


-- 2️. Running Total (Match Momentum)


WITH match_runs AS (
    SELECT 
        match_no,
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
        ) AS runs
    FROM deliveries
    GROUP BY match_no, batter
)
SELECT *,
       SUM(runs) OVER (
           PARTITION BY batter
           ORDER BY match_no
       ) AS running_total
FROM match_runs;


-- 3. Season Ranking (Best Query in the File)
WITH clean_deliveries AS (
    SELECT 
        d.*,
        m.season,
        CASE 
            WHEN d.outcome LIKE '%wd%' THEN 0
            WHEN d.outcome LIKE '%nb%' THEN 0
            WHEN d.outcome LIKE '%lb%' THEN 0
            WHEN d.outcome LIKE '%b%' AND d.outcome NOT LIKE '%lb%' THEN 0
            WHEN d.outcome = 'w' THEN 0
            WHEN d.outcome IN ('0','1','2','3','4','5','6')
                THEN CAST(d.outcome AS INT)
            ELSE 0
        END AS runs_clean
    FROM deliveries d
    JOIN matches m
        ON m.match_number = d.match_no
),
season_batting AS (
    SELECT 
        season,
        batter,
        SUM(runs_clean) AS total_runs
    FROM clean_deliveries
    GROUP BY season, batter
)
SELECT 
    season,
    batter,
    total_runs,
    RANK() OVER (
        PARTITION BY season
        ORDER BY total_runs DESC
    ) AS season_rank
FROM season_batting;