WITH C AS (
  SELECT 
    submit_date,
    policy_number
  FROM
    data.claim
  WHERE
    EXTRACT(YEAR FROM submit_date) = 2021
),
P AS (
  SELECT
    policy_number,
    product
  FROM
    data.policy
)
SELECT
  P.product,
  COUNT(C.policy_number) AS Claim_count
FROM
  C
LEFT JOIN 
  P
  ON P.policy_number = C.policy_number
GROUP BY
  P.product