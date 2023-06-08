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
    SUM(
      CASE
        WHEN status = 'refunded' THEN total_amount * -1
        ELSE total_amount
      END) AS PRE
  FROM
    data.invoice
  WHERE
    status IN ('Paid', 'refunded', 'open')
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