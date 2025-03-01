  -- count records
SELECT
  COUNT(*)
FROM
  `bank_v2.bank_v2`
  -- 41188

-- prediction distribution

select case 
when ModelPrediction >= 0.9 then '10. >= 0.9'
when ModelPrediction >= 0.8 then '09. 0.8 - 0.9'
when ModelPrediction >= 0.7 then '08. 0.7 - 0.8'
when ModelPrediction >= 0.6 then '07. 0.6 - 0.7'
when ModelPrediction >= 0.5 then '06. 0.5 - 0.6'
when ModelPrediction >= 0.4 then '05. 0.4 - 0.5'
when ModelPrediction >= 0.3 then '04. 0.3 - 0.4'
when ModelPrediction >= 0.2 then '03. 0.2 - 0.3'
when ModelPrediction >= 0.1 then '02. 0.1 - 0.2'
when ModelPrediction < 0.1 then '01. < 0.1' else 'others' end as ModelPrediction_bucket,
count(*) ct
from  `bank_v2.bank_v2`
group by 1
order by 1


-- dataset preview
SELECT
  *
FROM
  `bank_v2.bank_v2`
LIMIT
  5
  -- confusion matrix
WITH
  cte AS (
  SELECT
    *,
    CASE
      WHEN ModelPrediction >= 0.5 THEN 'Y'
      ELSE 'N'
  END
    AS prediction,
    CASE
      WHEN y = TRUE THEN 'Y'
      ELSE 'N'
  END
    AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction,
    outcome,
    COUNT(*) ct
  FROM
    cte
  GROUP BY
    1,
    2
  ORDER BY
    1,
    2)
SELECT
  SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'Y' ) OR (prediction = 'N' AND outcome = 'N') THEN ct
      ELSE 0
  END
    ) correct,
  SUM(ct) AS total,
  1.00* SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'Y' ) OR (prediction = 'N' AND outcome = 'N') THEN ct
      ELSE 0
  END
    ) /SUM(ct) AS accuracy
FROM
  matrix
  -- correct 4217
  -- all 41188
  -- accuracy 10.24%
  -- adjust threshold to 0.1
WITH
  cte AS (
  SELECT
    *,
    CASE
      WHEN ModelPrediction >= 0.1 THEN 'Y'
      ELSE 'N'
  END
    AS prediction,
    CASE
      WHEN y = TRUE THEN 'Y'
      ELSE 'N'
  END
    AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction,
    outcome,
    COUNT(*) ct
  FROM
    cte
  GROUP BY
    1,
    2
  ORDER BY
    1,
    2)
SELECT
  SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct
      ELSE 0
  END
    ) AS TP,
  SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct
      ELSE 0
  END
    ) AS FP,
  SUM(CASE
      WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct
      ELSE 0
  END
    ) AS FN,
  SUM(CASE
      WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct
      ELSE 0
  END
    ) AS TN
FROM
  matrix
  -- adjust threshold to 0.2
WITH
  cte AS (
  SELECT
    *,
    CASE
      WHEN ModelPrediction >= 0.2 THEN 'Y'
      ELSE 'N'
  END
    AS prediction,
    CASE
      WHEN y = TRUE THEN 'Y'
      ELSE 'N'
  END
    AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction,
    outcome,
    COUNT(*) ct
  FROM
    cte
  GROUP BY
    1,
    2
  ORDER BY
    1,
    2)
SELECT
  SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct
      ELSE 0
  END
    ) AS TP,
  SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct
      ELSE 0
  END
    ) AS FP,
  SUM(CASE
      WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct
      ELSE 0
  END
    ) AS FN,
  SUM(CASE
      WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct
      ELSE 0
  END
    ) AS TN
FROM
  matrix
  -- adjust threshold to 0.3
WITH
  cte AS (
  SELECT
    *,
    CASE
      WHEN ModelPrediction >= 0.3 THEN 'Y'
      ELSE 'N'
  END
    AS prediction,
    CASE
      WHEN y = TRUE THEN 'Y'
      ELSE 'N'
  END
    AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction,
    outcome,
    COUNT(*) ct
  FROM
    cte
  GROUP BY
    1,
    2
  ORDER BY
    1,
    2)
SELECT
  SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct
      ELSE 0
  END
    ) AS TP,
  SUM(CASE
      WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct
      ELSE 0
  END
    ) AS FP,
  SUM(CASE
      WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct
      ELSE 0
  END
    ) AS FN,
  SUM(CASE
      WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct
      ELSE 0
  END
    ) AS TN
FROM
  matrix


 -- adjust threshold to 0.4
WITH cte AS (
  SELECT *,
    CASE WHEN ModelPrediction >= 0.4 THEN 'Y' ELSE 'N' END AS prediction,
    CASE WHEN y = TRUE THEN 'Y' ELSE 'N' END AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction, outcome,
    COUNT(*) ct
  FROM cte
  GROUP BY 1, 2
  ORDER BY 1, 2)
SELECT
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct  ELSE 0 END ) AS TP,
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS FP,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct ELSE 0 END) AS FN,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS TN
FROM
  matrix

-- adjust the threshold to 0.5
WITH cte AS (
  SELECT *,
    CASE WHEN ModelPrediction >= 0.5 THEN 'Y' ELSE 'N' END AS prediction,
    CASE WHEN y = TRUE THEN 'Y' ELSE 'N' END AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction, outcome,
    COUNT(*) ct
  FROM cte
  GROUP BY 1, 2
  ORDER BY 1, 2)
SELECT
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct  ELSE 0 END ) AS TP,
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS FP,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct ELSE 0 END) AS FN,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS TN
FROM
  matrix

-- adjust threshold to 0.6
WITH cte AS (
  SELECT *,
    CASE WHEN ModelPrediction >= 0.6 THEN 'Y' ELSE 'N' END AS prediction,
    CASE WHEN y = TRUE THEN 'Y' ELSE 'N' END AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction, outcome,
    COUNT(*) ct
  FROM cte
  GROUP BY 1, 2
  ORDER BY 1, 2)
SELECT
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct  ELSE 0 END ) AS TP,
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS FP,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct ELSE 0 END) AS FN,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS TN
FROM
  matrix

-- adjust threshold to 0.7
WITH cte AS (
  SELECT *,
    CASE WHEN ModelPrediction >= 0.7 THEN 'Y' ELSE 'N' END AS prediction,
    CASE WHEN y = TRUE THEN 'Y' ELSE 'N' END AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction, outcome,
    COUNT(*) ct
  FROM cte
  GROUP BY 1, 2
  ORDER BY 1, 2)
SELECT
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct  ELSE 0 END ) AS TP,
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS FP,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct ELSE 0 END) AS FN,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS TN
FROM
  matrix

-- adjust threshold to 0.8
WITH cte AS (
  SELECT *,
    CASE WHEN ModelPrediction >= 0.8 THEN 'Y' ELSE 'N' END AS prediction,
    CASE WHEN y = TRUE THEN 'Y' ELSE 'N' END AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction, outcome,
    COUNT(*) ct
  FROM cte
  GROUP BY 1, 2
  ORDER BY 1, 2)
SELECT
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct  ELSE 0 END ) AS TP,
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS FP,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct ELSE 0 END) AS FN,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS TN
FROM
  matrix

-- adjust threshold to 0.9
WITH cte AS (
  SELECT *,
    CASE WHEN ModelPrediction >= 0.9 THEN 'Y' ELSE 'N' END AS prediction,
    CASE WHEN y = TRUE THEN 'Y' ELSE 'N' END AS outcome
  FROM
    `bank_v2.bank_v2`),
  matrix AS (
  SELECT
    prediction, outcome,
    COUNT(*) ct
  FROM cte
  GROUP BY 1, 2
  ORDER BY 1, 2)
SELECT
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'Y' ) THEN ct  ELSE 0 END ) AS TP,
  SUM(CASE WHEN (prediction = 'Y' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS FP,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'Y' ) THEN ct ELSE 0 END) AS FN,
  SUM(CASE WHEN (prediction = 'N' AND outcome = 'N' ) THEN ct  ELSE 0 END) AS TN
FROM
  matrix

  -- subscription rate
  -- by age
SELECT
  CASE
    WHEN age > 70 THEN '7. 70 +'
    WHEN age > 60 THEN '6. 60 - 70'
    WHEN age > 50 THEN '5. 50 - 60'
    WHEN age > 40 THEN '4. 40 - 50'
    WHEN age > 30 THEN '3. 30 - 40'
    WHEN age > 20 THEN '2. 20 - 30'
    ELSE '1. <= 20'
END
  AS age_bucket,
  AVG(age) AS avg_age,
  SUM(CASE
      WHEN y = TRUE THEN 1
      ELSE 0
  END
    ) AS subscription,
    COUNT(*) as users,
  1.00 * SUM(CASE
      WHEN y = TRUE THEN 1
      ELSE 0
  END
    ) / COUNT(*) AS actual_subscription_rate,

  1.00 * SUM(CASE
      WHEN ModelPrediction >= 0.5 THEN 1
      ELSE 0
  END
    ) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1
  order by 1

# those <= 20y or 60+ had 40%+ subscription rate. the prediction didn't predict the same pattern

-- by education  -- doesn't show difference
SELECT
  education,
  AVG(age) AS avg_age,
  SUM(CASE
      WHEN y = TRUE THEN 1
      ELSE 0
  END
    ) AS subscription,
    COUNT(*) as users,
  1.00 * SUM(CASE
      WHEN y = TRUE THEN 1
      ELSE 0
  END
    ) / COUNT(*) AS actual_subscription_rate,

  1.00 * SUM(CASE
      WHEN ModelPrediction >= 0.5 THEN 1
      ELSE 0
  END
    ) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1


-- by marital -- doesn't show difference
SELECT
  marital,
  AVG(age) AS avg_age,
  SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
       COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1

-- by housing -- doesn't show difference
SELECT
  housing,
  AVG(age) AS avg_age,
  SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
           COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1

-- by loan -- doesn't show difference
SELECT
  loan,
  AVG(age) AS avg_age,
  SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
      COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1

-- by poutcome -- if previous was succeed, then we should prioritize it. the model didn't predict the same way
SELECT
  poutcome,
  AVG(age) AS avg_age,
  SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
      COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1
-- success were across all campaigns
SELECT
  campaign, poutcome,
  AVG(age) AS avg_age,
  SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
       COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1, 2


-- duration
select y, avg(duration) avg_duration,

max(duration) max_duration, min(duration) min_duration, count(*) users
from   `bank_v2.bank_v2`
group by 1

select distinct y,
PERCENTILE_disc(duration, 0.5) OVER (PARTITION BY y)  median_duration
from   `bank_v2.bank_v2`


select * 
from   `bank_v2.bank_v2`
where duration is null
-- no null data


-- emp_var_rate: If employment is decreasing, fewer people may be willing to commit funds.

select emp_var_rate, 
SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
       COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1
order by 1

-- bucket of Consumer Price Index: no difference

select floor(cons_price_idx)  cons_price_idx_bucket, 
SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
            COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1
order by 1

-- consumer confidence index: yes see a difference
select -- cons_conf_idx, 
ceiling(cons_conf_idx / 10) * 10 as cons_conf_idx_bucket , 
SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
       COUNT(*) as users,

  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1 --,2
order by 1

-- euribor3m:

select --euribor3m, 
floor(euribor3m * 10) / 10 as euribor3m_bucket,
-- case when euribor3m < 0.7 then '< 0.7'
-- when euribor3m < 0.8 then '0.7- 0.8'
-- else 'others' end as euribor3m_bucket,
SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
      COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1 --,2
order by 1

select case
when euribor3m < 0.1 then '< 0.1'
when euribor3m < 1.5 then '0.1 - 1.5'
when euribor3m < 2 then '1.5 - 2'
when euribor3m < 2.5 then '2 - 2.5'
when euribor3m < 3 then '2.5 - 3'
when euribor3m < 3.5 then '3 - 3.5'
when euribor3m < 4 then '3.5 - 4'
when euribor3m < 4.5 then '4 - 4.5'
when euribor3m < 5 then '4.5 - 5'
when euribor3m < 5.5 then '5 - 5.5'
else 'others' end as euribor3m_bucket,
SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
      COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1 --,2
order by 1

-- nr_employed: less than 5000 was the best
select -- nr_employed, 
floor(nr_employed/100) * 100 as nr_bucket,
SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
      COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1 --,2
order by 1



select month, SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
      COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1 --,2
order by 1

-- select duration from   `bank_v2.bank_v2` order by 1

select contact, SUM(CASE
      WHEN y = TRUE THEN 1 ELSE 0 END) AS subscription,
      COUNT(*) as users,
  1.00 * SUM(CASE WHEN y = TRUE THEN 1 ELSE 0 END) / COUNT(*) AS actual_subscription_rate,
  1.00 * SUM(CASE WHEN ModelPrediction >= 0.5 THEN 1 ELSE 0 END) / COUNT(*) AS predict_subscription_rate
FROM
  `bank_v2.bank_v2`
GROUP BY
  1 --,2
order by 1