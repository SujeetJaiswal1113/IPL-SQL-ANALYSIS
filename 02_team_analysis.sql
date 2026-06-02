-- 02_team_analysis.sql

-- Team wins

SELECT
    winner,
    COUNT(*) AS total_wins
FROM matches
GROUP BY winner
ORDER BY total_wins DESC;

-- Toss impact

SELECT
    COUNT(*) AS total_matches,
    SUM(CASE WHEN toss_won = winner THEN 1 ELSE 0 END) AS toss_winner_matches,
    ROUND(
        100.0 * SUM(CASE WHEN toss_won = winner THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS toss_win_percentage
FROM matches;

-- Toss decision impact

SELECT
    toss_decision,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN toss_won = winner THEN 1 ELSE 0 END) AS wins_after_toss
FROM matches
GROUP BY toss_decision;

-- Venue analysis

SELECT
    venue,
    COUNT(*) AS matches_played
FROM matches
GROUP BY venue
ORDER BY matches_played DESC;