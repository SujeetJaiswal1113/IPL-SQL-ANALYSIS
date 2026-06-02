

CASE 
    WHEN outcome LIKE '%wd%' THEN 0
    WHEN outcome LIKE '%nb%' THEN 0
    WHEN outcome LIKE '%lb%' THEN 0
    WHEN outcome LIKE '%b%' AND outcome NOT LIKE '%lb%' THEN 0
    WHEN outcome = 'w' THEN 0
    WHEN outcome IN ('0','1','2','3','4','5','6') THEN CAST(outcome AS INT)
    ELSE 0
END AS runs_clean