-- required name of view: user_usage_spreadsheets_daily
SELECT
  user_usage.date AS date,
  user_usage.email AS email,
  IFNULL(users.ou, 'NA') AS ou,
  user_usage.num_sheets_created AS num_spreadsheets,
  user_usage.num_sheets_created as num_sheets_created,
  user_usage.num_sheets_edited as num_sheets_edited,
  user_usage.num_sheets_trashed as num_sheets_trashed,
  user_usage.num_sheets_viewed as num_sheets_viewed  
FROM (
  SELECT
    date,
    user_email AS email,
    drive.num_owned_google_spreadsheets_created  AS num_sheets_created,
    drive.num_owned_google_spreadsheets_edited AS num_sheets_edited,
    drive.num_owned_google_spreadsheets_trashed AS num_sheets_trashed,
    drive.num_owned_google_spreadsheets_viewed AS num_sheets_viewed
  FROM
    [YOUR_PROJECT_ID:Reports.usage]
  WHERE
    TRUE
    AND _PARTITIONTIME = YOUR_TIMESTAMP_PARAMETER
    AND (drive.num_owned_google_spreadsheets_created + drive.num_owned_google_spreadsheets_edited + drive.num_owned_google_spreadsheets_trashed + drive.num_owned_google_spreadsheets_viewed) > 0
    AND record_type = 'user' ) user_usage
LEFT JOIN (
  SELECT
    ou,
    email
  FROM
    [YOUR_PROJECT_ID:users.users_ou_list]
  WHERE
    TRUE
    AND _PARTITIONTIME = YOUR_TIMESTAMP_PARAMETER) users
ON
  users.email = user_usage.email
GROUP BY 1,2,3,4,5,6,7,8