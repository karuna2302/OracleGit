CREATE OR REPLACE FORCE VIEW APPS.XXMAF_BUDGET_CASH_FORECAST_V
(
   BUDGET_VERSION_ID,
   PROJECT_ID,
   ORG_ID,
   OU_NAME,
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
   TOT_FORECAST
)
AS
     SELECT BUDGET_VERSION_ID,
            PROJECT_ID,
            org_id,
            OU_name,
            proj_type,
            proj_name,
            proj_seg,
            BUDGET_TYPE_CODE,
            VERSION_NUMBER,
            BUDGET_STATUS_CODE,
            CBS1,
            CBS1_desc,
            TASK_ID,
            cbs2,
            cbs2desc,
            PARENT_TASK_ID,
            BURDENED_COST_TOTAL,
            cost_category,
            NULL tot_Forecast
       FROM (  SELECT BUDGET_VERSION_ID,
                      PROJECT_ID,
                      (SELECT name
                         FROM hr_operating_units
                        WHERE organization_id =
                                 (SELECT DISTINCT a.org_id
                                    FROM pa_projects_All a
                                   WHERE a.project_id = b.PROJECT_ID))
                         OU_name,
                      (SELECT DISTINCT a.org_id
                         FROM pa_projects_All a
                        WHERE a.project_id = b.PROJECT_ID)
                         org_id,
                      (SELECT DISTINCT a.project_type
                         FROM pa_projects_All a
                        WHERE a.project_id = b.PROJECT_ID)
                         proj_type,
                      (SELECT DISTINCT a.NAME
                         FROM pa_projects_All a
                        WHERE a.project_id = b.PROJECT_ID)
                         proj_name,
                      (SELECT DISTINCT a.segment1
                         FROM pa_projects_All a
                        WHERE a.project_id = b.PROJECT_ID)
                         proj_seg,
                      BUDGET_TYPE_CODE,
                      VERSION_NUMBER,
                      BUDGET_STATUS_CODE,
                      (SELECT TASK_NUMBER
                         FROM pa_tasks
                        WHERE task_id = b.PARENT_TASK_ID)
                         CBS1,
                      (SELECT TASK_name
                         FROM pa_tasks
                        WHERE task_id = b.PARENT_TASK_ID)
                         CBS1_desc,
                      TASK_ID,
                      TASK_NUMBER cbs2,
                      TASK_NAME cbs2desc,
                      PARENT_TASK_ID,
                      -- PA_TASK_UTILS.SORT_ORDER_TREE_WALK (PARENT_TASK_ID, TASK_NUMBER)
                      -- SORT_ORDER,
                      SUM (RAW_COST_TOTAL) RAW_COST_TOTAL,
                      SUM (BURDENED_COST_TOTAL) BURDENED_COST_TOTAL,
                      SUM (REVENUE_TOTAL) REVENUE_TOTAL,
                      SUM (QUANTITY_TOTAL) QUANTITY_TOTAL,
                      cost_category
                 --RESOURCE_ASSIGNMENT_ID
                 FROM (SELECT BUDGET_VERSION_ID,
                              PROJECT_ID,
                              BUDGET_TYPE_CODE,
                              VERSION_NUMBER,
                              BUDGET_STATUS_CODE,
                              TASK_ID,
                              TASK_NUMBER,
                              TASK_NAME,
                              PARENT_TASK_ID,
                              RAW_COST_TOTAL,
                              BURDENED_COST_TOTAL,
                              REVENUE_TOTAL,
                              QUANTITY_TOTAL,
                              RESOURCE_ASSIGNMENT_ID,
                              cost_category
                         FROM (SELECT V.BUDGET_VERSION_ID,
                                      V.PROJECT_ID,
                                      V.BUDGET_TYPE_CODE,
                                      V.VERSION_NUMBER,
                                      V.BUDGET_STATUS_CODE,
                                      T.TASK_ID,
                                      T.TASK_NUMBER,
                                      T.TASK_NAME,
                                      T.PARENT_TASK_ID,
                                      0 RAW_COST_TOTAL,
                                      0 BURDENED_COST_TOTAL,
                                      0 REVENUE_TOTAL,
                                      0 QUANTITY_TOTAL,
                                      NULL RESOURCE_ASSIGNMENT_ID,
                                      NULL cost_category
                                 FROM PA_TASKS T, PA_BUDGET_VERSIONS V
                                WHERE V.PROJECT_ID = T.PROJECT_ID
                               --  AND PA_BUDGET_UTILS.GET_ENTRY_LEVEL_CODE <> 'P'
                               UNION ALL
                               SELECT V.BUDGET_VERSION_ID,
                                      V.PROJECT_ID,
                                      V.BUDGET_TYPE_CODE,
                                      V.VERSION_NUMBER,
                                      V.BUDGET_STATUS_CODE,
                                      0 TASK_ID,
                                      NULL TASK_NUMBER,
                                      NULL TASK_NAME,
                                      0 PARENT_TASK_ID,
                                      0 RAW_COST_TOTAL,
                                      0 BURDENED_COST_TOTAL,
                                      0 REVENUE_TOTAL,
                                      0 QUANTITY_TOTAL,
                                      NULL RESOURCE_ASSIGNMENT_ID,
                                      NULL cost_category
                                 FROM PA_BUDGET_VERSIONS V
                                WHERE 1 = 1 -- PA_BUDGET_UTILS.GET_ENTRY_LEVEL_CODE = 'P'
                               UNION ALL
                                 SELECT V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        T.TASK_ID,
                                        T.TASK_NUMBER,
                                        T.TASK_NAME,
                                        T.PARENT_TASK_ID,
                                        SUM (NVL (L.RAW_COST, 0)) RAW_COST_TOTAL,
                                        SUM (NVL (L.BURDENED_COST, 0))
                                           BURDENED_COST_TOTAL,
                                        SUM (NVL (L.REVENUE, 0)) REVENUE_TOTAL,
                                        SUM (
                                           DECODE (A.TRACK_AS_LABOR_FLAG,
                                                   'Y', NVL (L.QUANTITY, 0),
                                                   0))
                                           QUANTITY_TOTAL,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1 cost_category
                                   FROM PA_BUDGET_LINES L,
                                        PA_TASKS T,
                                        PA_RESOURCE_ASSIGNMENTS A,
                                        PA_BUDGET_VERSIONS V
                                  WHERE     V.BUDGET_VERSION_ID =
                                               A.BUDGET_VERSION_ID
                                        AND A.TASK_ID = T.TASK_ID
                                        AND A.RESOURCE_ASSIGNMENT_ID =
                                               L.RESOURCE_ASSIGNMENT_ID
                               --  AND PA_BUDGET_UTILS.GET_ENTRY_LEVEL_CODE <> 'P'
                               GROUP BY V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        T.TASK_ID,
                                        T.TASK_NUMBER,
                                        T.TASK_NAME,
                                        T.PARENT_TASK_ID,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1
                               UNION ALL
                                 SELECT V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        T1.TOP_TASK_ID,
                                        T1.TASK_NUMBER,
                                        T1.TASK_NAME,
                                        T1.PARENT_TASK_ID,
                                        SUM (NVL (L.RAW_COST, 0)) RAW_COST_TOTAL,
                                        SUM (NVL (L.BURDENED_COST, 0))
                                           BURDENED_COST_TOTAL,
                                        SUM (NVL (L.REVENUE, 0)) REVENUE_TOTAL,
                                        SUM (
                                           DECODE (A.TRACK_AS_LABOR_FLAG,
                                                   'Y', NVL (L.QUANTITY, 0),
                                                   0))
                                           QUANTITY_TOTAL,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1 cost_category
                                   FROM PA_BUDGET_LINES L,
                                        PA_TASKS T,
                                        PA_TASKS T1,
                                        PA_RESOURCE_ASSIGNMENTS A,
                                        PA_BUDGET_VERSIONS V
                                  WHERE     V.BUDGET_VERSION_ID =
                                               A.BUDGET_VERSION_ID
                                        AND A.TASK_ID = T.TASK_ID
                                        AND T.PROJECT_ID = T1.PROJECT_ID
                                        AND T.TASK_ID <> T1.TOP_TASK_ID
                                        AND T.TOP_TASK_ID = T1.TASK_ID
                                        AND T1.PARENT_TASK_ID IS NULL
                                        AND A.RESOURCE_ASSIGNMENT_ID =
                                               L.RESOURCE_ASSIGNMENT_ID
                               --   AND PA_BUDGET_UTILS.GET_ENTRY_LEVEL_CODE = 'M'
                               GROUP BY V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        T1.TOP_TASK_ID,
                                        T1.TASK_NUMBER,
                                        T1.TASK_NAME,
                                        T1.PARENT_TASK_ID,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1
                               UNION ALL
                                 SELECT V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        T.TASK_ID,
                                        T.TASK_NUMBER,
                                        T.TASK_NAME,
                                        T.PARENT_TASK_ID,
                                        SUM (NVL (L.RAW_COST, 0)) RAW_COST_TOTAL,
                                        SUM (NVL (L.BURDENED_COST, 0))
                                           BURDENED_COST_TOTAL,
                                        SUM (NVL (L.REVENUE, 0)) REVENUE_TOTAL,
                                        SUM (
                                           DECODE (A.TRACK_AS_LABOR_FLAG,
                                                   'Y', NVL (L.QUANTITY, 0),
                                                   0))
                                           QUANTITY_TOTAL,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1 cost_category
                                   FROM PA_BUDGET_LINES L,
                                        PA_TASKS T,
                                        PA_RESOURCE_ASSIGNMENTS A,
                                        PA_BUDGET_VERSIONS V
                                  WHERE     V.BUDGET_VERSION_ID =
                                               A.BUDGET_VERSION_ID
                                        AND A.RESOURCE_ASSIGNMENT_ID =
                                               L.RESOURCE_ASSIGNMENT_ID
                                        AND T.PROJECT_ID = V.PROJECT_ID
                                        AND T.PARENT_TASK_ID IS NOT NULL
                                        AND T.TASK_ID <> A.TASK_ID
                                        AND T.TASK_ID IN
                                               (    SELECT TASK_ID
                                                      FROM PA_TASKS PT
                                                START WITH PT.TASK_ID = A.TASK_ID
                                                CONNECT BY PRIOR PT.PARENT_TASK_ID =
                                                              PT.TASK_ID)
                                        AND PA_BUDGET_UTILS.GET_ENTRY_LEVEL_CODE =
                                               'M'
                               GROUP BY V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        T.TASK_ID,
                                        T.TASK_NUMBER,
                                        T.TASK_NAME,
                                        T.PARENT_TASK_ID,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1
                               UNION ALL
                                 SELECT V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        0 TASK_ID,
                                        NULL TASK_NUMBER,
                                        NULL TASK_NAME,
                                        0 PARENT_TASK_ID,
                                        SUM (NVL (L.RAW_COST, 0)) RAW_COST_TOTAL,
                                        SUM (NVL (L.BURDENED_COST, 0))
                                           BURDENED_COST_TOTAL,
                                        SUM (NVL (L.REVENUE, 0)) REVENUE_TOTAL,
                                        SUM (
                                           DECODE (A.TRACK_AS_LABOR_FLAG,
                                                   'Y', NVL (L.QUANTITY, 0),
                                                   0))
                                           QUANTITY_TOTAL,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1 cost_category
                                   FROM PA_BUDGET_LINES L,
                                        PA_RESOURCE_ASSIGNMENTS A,
                                        PA_BUDGET_VERSIONS V
                                  WHERE     V.BUDGET_VERSION_ID =
                                               A.BUDGET_VERSION_ID
                                        AND A.TASK_ID = 0
                                        AND A.RESOURCE_ASSIGNMENT_ID =
                                               L.RESOURCE_ASSIGNMENT_ID
                               --   AND PA_BUDGET_UTILS.GET_ENTRY_LEVEL_CODE = 'P'
                               GROUP BY V.BUDGET_VERSION_ID,
                                        V.PROJECT_ID,
                                        V.BUDGET_TYPE_CODE,
                                        V.VERSION_NUMBER,
                                        V.BUDGET_STATUS_CODE,
                                        l.RESOURCE_ASSIGNMENT_ID,
                                        l.attribute1)) b
             GROUP BY BUDGET_VERSION_ID,
                      PROJECT_ID,
                      BUDGET_TYPE_CODE,
                      VERSION_NUMBER,
                      BUDGET_STATUS_CODE,
                      TASK_ID,
                      TASK_NUMBER,
                      TASK_NAME,
                      PARENT_TASK_ID,
                      cost_category) DETAILS
      WHERE     1 = 1
            --AND PROJECT_ID  =  19631
            AND BUDGET_TYPE_CODE = 'AC'
            AND budget_status_code = 'B'
            AND BUDGET_VERSION_ID =
                   (SELECT MAX (BUDGET_VERSION_ID)
                      FROM pa_budget_versions
                     WHERE     BUDGET_TYPE_CODE = 'AC'
                           AND BUDGET_STATUS_CODE = 'B'
                           AND project_id = DETAILS.PROJECT_ID)
            -- AND PARENT_TASK_ID = LV_PARENT_TASK_ID
            AND parent_task_id IS NOT NULL
            AND cbs2 IS NOT NULL
   ORDER BY PROJECT_ID,
            BUDGET_TYPE_CODE,
            VERSION_NUMBER,
            cbs2;