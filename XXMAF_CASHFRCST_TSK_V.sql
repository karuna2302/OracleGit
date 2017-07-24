CREATE OR REPLACE FORCE VIEW APPS.XXMAF_CASHFRCST_TSK_V
(
   BUDGET_VERSION_ID,
   PROJECT_ID,
   PROJ_START_DATE,
   ORG_ID,
   OU_NAME,
   BG,
   PROJ_TYPE,
   PROJ_NAME,
   PROJ_SEG,
   BUDGET_TYPE_CODE,
   VERSION_NUMBER,
   BUDGET_STATUS_CODE,
   CBS1,
   CBS1_DESC,
   TASK_ID,
   CBS2,
   CBS2DESC,
   PARENT_TASK_ID,
   BURDENED_COST_TOTAL,
   COST_CATEGORY,
   TOT_FORECAST,
   PERIOD
)
AS
     SELECT DISTINCT a.BUDGET_VERSION_ID,
                     a.PROJECT_ID,
                     (SELECT start_date
                        FROM pa_projects_All
                       WHERE project_id = a.project_id)
                        proj_start_date,
                     a.ORG_ID,
                     a.OU_NAME,
                     hr_general.DECODE_ORGANIZATION (hou.BUSINESS_GROUP_ID) BG,
                     a.PROJ_TYPE,
                     a.PROJ_NAME,
                     a.PROJ_SEG,
                     a.BUDGET_TYPE_CODE,
                     a.VERSION_NUMBER,
                     a.BUDGET_STATUS_CODE,
                     a.CBS1,
                     a.CBS1_DESC,
                     a.TASK_ID,
                     a.CBS2,
                     a.CBS2DESC,
                     a.PARENT_TASK_ID,
                     a.BURDENED_COST_TOTAL,
                     a.COST_CATEGORY,
                     a.TOT_FORECAST,
                     periods.PERIOD
       FROM XXMAF_BUDGET_CASH_FORECAST_V a,
            hr_operating_units hou,
            (SELECT TO_CHAR (which_month, 'Mon-yy') period
               FROM (  SELECT ADD_MONTHS (SYSDATE, ROWNUM - 1) which_month
                         FROM all_objects
                        WHERE ROWNUM <=
                                 MONTHS_BETWEEN (ADD_MONTHS (SYSDATE, 12),
                                                 ADD_MONTHS (SYSDATE, -1))
                     ORDER BY which_month)) periods
      WHERE 1 = 1 AND hou.organization_id = a.org_id
   --- and a.project_id = 19631
   ORDER BY CBS1, cbs2;