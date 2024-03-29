/* pre_levy_amount refers to the net premium of each invoice */
/* Aggregate the whole period net premium sum with policy number */
/* Assume all invoice with status as 'Open' will be paid */
WITH P1 AS (
  SELECT
    user_id,
    (CASE 
      WHEN
        COUNT(policy_number) = 1 THEN 'New'
      ELSE 'Returning'
    END)
    AS U_Type
  FROM 
    data.policy
  GROUP BY
    user_id
),
P2 AS (
  SELECT
    user_id,
    policy_number
  FROM
    data.policy
),
I1 AS (
  SELECT 
    policy_number,
    SUM(pre_levy_amount) AS PRE
  FROM
    data.invoice
  WHERE
    status IN ('Paid', 'open')
  GROUP BY
    policy_number
)
SELECT
  P1.U_Type,
  AVG (I1.PRE) AS AVG_Net_PRE
FROM
  P1
LEFT JOIN P2 ON P1.user_id = P2.user_id
LEFT JOIN I1 ON I1.policy_number = P2.policy_number
GROUP BY
  P1.U_Type