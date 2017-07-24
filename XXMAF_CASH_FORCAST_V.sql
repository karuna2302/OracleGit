CREATE OR REPLACE FORCE VIEW APPS.XXMAF_CASH_FORCAST_V
(
   BUDGET_VERSION_ID,
   TYPE,
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
   PO_NUMBER,
   VENDOR_NAME,
   VENDOR_SITE_CODE,
   PO_CREATION_DATE,
   CURRENCY_CODE,
   RATE,
   PO_AMOUNT,
   RECEIVED_AMOUNT,
   BILLED_AMOUNT,
   AMOUNT_PAID,
   BALANCE_TO_PAY,
   CASF_FOECAST_ID,
   PERIOD,
   YEAR,
   REV_NUM,
   PERIOD1,
   PERIOD2,
   PERIOD3,
   PERIOD4,
   PERIOD5,
   PERIOD6,
   PERIOD7,
   PERIOD8,
   PERIOD9,
   PERIOD10,
   PERIOD11,
   PERIOD12,
   PERIOD13,
   PERIOD14,
   PERIOD15,
   PERIOD16,
   PERIOD17,
   PERIOD18,
   LAST_UPDATE_DATE,
   LAST_UPDATED_BY,
   CREATION_DATE,
   CREATED_BY,
   LAST_UPDATE_LOGIN,
   STATUS_FLAG,
   PO_HEADER_ID,
   PERIOD19,
   PERIOD20,
   PERIOD21,
   PERIOD22,
   PERIOD23,
   PERIOD24,
   PERIOD25,
   PERIOD26,
   PERIOD27,
   PERIOD28,
   PERIOD29,
   PERIOD30,
   PERIOD31,
   PERIOD32,
   PERIOD33,
   PERIOD34,
   PERIOD35,
   PERIOD36,
   PERIOD37,
   PERIOD38,
   PERIOD39,
   PERIOD40,
   PERIOD41,
   PERIOD42,
   PERIOD43,
   PERIOD44,
   PERIOD45,
   PERIOD46,
   PERIOD47,
   PERIOD48,
   PERIOD49,
   PERIOD50,
   PERIOD51,
   PERIOD52,
   PERIOD53,
   PERIOD54,
   PERIOD55,
   PERIOD56,
   PERIOD57,
   PERIOD58,
   PERIOD59,
   PERIOD60,
   BI_DATE,
   VARIANCE,
   YEAR1,
   YEAR2,
   YEAR3,
   UNCOMMITED_FORECAST,
   UNCOMMITTED_BUDGET,
   REVISED_FORECAST
)
AS
   SELECT xcv.BUDGET_VERSION_ID,
          'COMMITTED' TYPE,
          xcv.PROJECT_ID,
          xcv.proj_start_date,
          xcv.ORG_ID,
          xcv.OU_NAME,
          xcv.BG,
          xcv.PROJ_TYPE,
          xcv.PROJ_NAME,
          xcv.PROJ_SEG,
          xcv.BUDGET_TYPE_CODE,
          xcv.VERSION_NUMBER,
          xcv.BUDGET_STATUS_CODE,
          xcv.CBS1,
          xcv.CBS1_DESC,
          xcv.TASK_ID,
          xcv.CBS2,
          xcv.CBS2DESC,
          xcv.PARENT_TASK_ID,
          xcv.BURDENED_COST_TOTAL,
          xcv.COST_CATEGORY,
          (  NVL (xcfv.PERIOD1, 0)
           + NVL (xcfv.PERIOD2, 0)
           + NVL (xcfv.PERIOD3, 0)
           + NVL (xcfv.PERIOD4, 0)
           + NVL (xcfv.PERIOD5, 0)
           + NVL (xcfv.PERIOD6, 0)
           + NVL (xcfv.PERIOD7, 0)
           + NVL (xcfv.PERIOD8, 0)
           + NVL (xcfv.PERIOD9, 0)
           + NVL (xcfv.PERIOD10, 0)
           + NVL (xcfv.PERIOD11, 0)
           + NVL (xcfv.PERIOD12, 0)
           + NVL (xcfv.PERIOD13, 0)
           + NVL (xcfv.PERIOD14, 0)
           + NVL (xcfv.PERIOD15, 0)
           + NVL (xcfv.PERIOD16, 0)
           + NVL (xcfv.PERIOD17, 0)
           + NVL (xcfv.PERIOD18, 0)
           + NVL (xcfv.PERIOD19, 0)
           + NVL (xcfv.PERIOD20, 0)
           + NVL (xcfv.PERIOD21, 0)
           + NVL (xcfv.PERIOD22, 0)
           + NVL (xcfv.PERIOD23, 0)
           + NVL (xcfv.PERIOD24, 0)
           + NVL (xcfv.PERIOD25, 0)
           + NVL (xcfv.PERIOD26, 0)
           + NVL (xcfv.PERIOD27, 0)
           + NVL (xcfv.PERIOD28, 0)
           + NVL (xcfv.PERIOD29, 0)
           + NVL (xcfv.PERIOD30, 0)
           + NVL (xcfv.PERIOD31, 0)
           + NVL (xcfv.PERIOD32, 0)
           + NVL (xcfv.PERIOD33, 0)
           + NVL (xcfv.PERIOD34, 0)
           + NVL (xcfv.PERIOD35, 0)
           + NVL (xcfv.PERIOD36, 0)
           + NVL (xcfv.PERIOD37, 0)
           + NVL (xcfv.PERIOD38, 0)
           + NVL (xcfv.PERIOD39, 0)
           + NVL (xcfv.PERIOD40, 0)
           + NVL (xcfv.PERIOD41, 0)
           + NVL (xcfv.PERIOD42, 0)
           + NVL (xcfv.PERIOD43, 0)
           + NVL (xcfv.PERIOD44, 0)
           + NVL (xcfv.PERIOD45, 0)
           + NVL (xcfv.PERIOD46, 0)
           + NVL (xcfv.PERIOD47, 0)
           + NVL (xcfv.PERIOD48, 0)
           + NVL (xcfv.PERIOD49, 0)
           + NVL (xcfv.PERIOD50, 0)
           + NVL (xcfv.PERIOD51, 0)
           + NVL (xcfv.PERIOD52, 0)
           + NVL (xcfv.PERIOD53, 0)
           + NVL (xcfv.PERIOD54, 0)
           + NVL (xcfv.PERIOD55, 0)
           + NVL (xcfv.PERIOD56, 0)
           + NVL (xcfv.PERIOD57, 0)
           + NVL (xcfv.PERIOD58, 0)
           + NVL (xcfv.PERIOD59, 0)
           + NVL (xcfv.PERIOD60, 0))
             TOT_FORECAST,
          xcv.PO_NUMBER,
          xcv.VENDOR_NAME,
          xcv.VENDOR_SITE_CODE,
          xcv.PO_CREATION_DATE,
          xcv.CURRENCY_CODE,
          NVL (xcv.RATE, 1) RATE,
          xcv.PO_AMOUNT,
          xcv.RECEIVED_AMOUNT,
          xcv.BILLED_AMOUNT,
          xcv.AMOUNT_PAID,
          xcv.BALANCE_TO_PAY,
          xcfv.CASF_FOECAST_ID,
          xcv.PERIOD,
          xcfv.YEAR,
          xcfv.REV_NUM,
          xcfv.PERIOD1,
          xcfv.PERIOD2,
          xcfv.PERIOD3,
          xcfv.PERIOD4,
          xcfv.PERIOD5,
          xcfv.PERIOD6,
          xcfv.PERIOD7,
          xcfv.PERIOD8,
          xcfv.PERIOD9,
          xcfv.PERIOD10,
          xcfv.PERIOD11,
          xcfv.PERIOD12,
          xcfv.PERIOD13,
          xcfv.PERIOD14,
          xcfv.PERIOD15,
          xcfv.PERIOD16,
          xcfv.PERIOD17,
          xcfv.PERIOD18,
          xcfv.LAST_UPDATE_DATE,
          xcfv.LAST_UPDATED_BY,
          xcfv.CREATION_DATE,
          xcfv.CREATED_BY,
          xcfv.LAST_UPDATE_LOGIN,
          xcfv.STATUS_FLAG,
          xcfv.PO_HEADER_ID,
          xcfv.PERIOD19,
          xcfv.PERIOD20,
          xcfv.PERIOD21,
          xcfv.PERIOD22,
          xcfv.PERIOD23,
          xcfv.PERIOD24,
          xcfv.PERIOD25,
          xcfv.PERIOD26,
          xcfv.PERIOD27,
          xcfv.PERIOD28,
          xcfv.PERIOD29,
          xcfv.PERIOD30,
          xcfv.PERIOD31,
          xcfv.PERIOD32,
          xcfv.PERIOD33,
          xcfv.PERIOD34,
          xcfv.PERIOD35,
          xcfv.PERIOD36,
          xcfv.PERIOD37,
          xcfv.PERIOD38,
          xcfv.PERIOD39,
          xcfv.PERIOD40,
          xcfv.PERIOD41,
          xcfv.PERIOD42,
          xcfv.PERIOD43,
          xcfv.PERIOD44,
          xcfv.PERIOD45,
          xcfv.PERIOD46,
          xcfv.PERIOD47,
          xcfv.PERIOD48,
          xcfv.PERIOD49,
          xcfv.PERIOD50,
          xcfv.PERIOD51,
          xcfv.PERIOD52,
          xcfv.PERIOD53,
          xcfv.PERIOD54,
          xcfv.PERIOD55,
          xcfv.PERIOD56,
          xcfv.PERIOD57,
          xcfv.PERIOD58,
          xcfv.PERIOD59,
          xcfv.PERIOD60,
          NVL (TO_DATE (xcv.PERIOD, 'Mon-RR'), TRUNC (xcv.proj_start_date))
             BI_DAte,
          (  NVL (xcv.BALANCE_TO_PAY, 0)
           - (  NVL (xcfv.PERIOD1, 0)
              + NVL (xcfv.PERIOD2, 0)
              + NVL (xcfv.PERIOD3, 0)
              + NVL (xcfv.PERIOD4, 0)
              + NVL (xcfv.PERIOD5, 0)
              + NVL (xcfv.PERIOD6, 0)
              + NVL (xcfv.PERIOD7, 0)
              + NVL (xcfv.PERIOD8, 0)
              + NVL (xcfv.PERIOD9, 0)
              + NVL (xcfv.PERIOD10, 0)
              + NVL (xcfv.PERIOD11, 0)
              + NVL (xcfv.PERIOD12, 0)
              + NVL (xcfv.PERIOD13, 0)
              + NVL (xcfv.PERIOD14, 0)
              + NVL (xcfv.PERIOD15, 0)
              + NVL (xcfv.PERIOD16, 0)
              + NVL (xcfv.PERIOD17, 0)
              + NVL (xcfv.PERIOD18, 0)
              + NVL (xcfv.PERIOD19, 0)
              + NVL (xcfv.PERIOD20, 0)
              + NVL (xcfv.PERIOD21, 0)
              + NVL (xcfv.PERIOD22, 0)
              + NVL (xcfv.PERIOD23, 0)
              + NVL (xcfv.PERIOD24, 0)
              + NVL (xcfv.PERIOD25, 0)
              + NVL (xcfv.PERIOD26, 0)
              + NVL (xcfv.PERIOD27, 0)
              + NVL (xcfv.PERIOD28, 0)
              + NVL (xcfv.PERIOD29, 0)
              + NVL (xcfv.PERIOD30, 0)
              + NVL (xcfv.PERIOD31, 0)
              + NVL (xcfv.PERIOD32, 0)
              + NVL (xcfv.PERIOD33, 0)
              + NVL (xcfv.PERIOD34, 0)
              + NVL (xcfv.PERIOD35, 0)
              + NVL (xcfv.PERIOD36, 0)
              + NVL (xcfv.PERIOD37, 0)
              + NVL (xcfv.PERIOD38, 0)
              + NVL (xcfv.PERIOD39, 0)
              + NVL (xcfv.PERIOD40, 0)
              + NVL (xcfv.PERIOD41, 0)
              + NVL (xcfv.PERIOD42, 0)
              + NVL (xcfv.PERIOD43, 0)
              + NVL (xcfv.PERIOD44, 0)
              + NVL (xcfv.PERIOD45, 0)
              + NVL (xcfv.PERIOD46, 0)
              + NVL (xcfv.PERIOD47, 0)
              + NVL (xcfv.PERIOD48, 0)
              + NVL (xcfv.PERIOD49, 0)
              + NVL (xcfv.PERIOD50, 0)
              + NVL (xcfv.PERIOD51, 0)
              + NVL (xcfv.PERIOD52, 0)
              + NVL (xcfv.PERIOD53, 0)
              + NVL (xcfv.PERIOD54, 0)
              + NVL (xcfv.PERIOD55, 0)
              + NVL (xcfv.PERIOD56, 0)
              + NVL (xcfv.PERIOD57, 0)
              + NVL (xcfv.PERIOD58, 0)
              + NVL (xcfv.PERIOD59, 0)
              + NVL (xcfv.PERIOD60, 0)))
             VARIANCE,
          xcfv.year1,
          xcfv.year2,
          xcfv.year3,
          NULL uncommited_forecast,
          NULL uncommited_budget,
          NULL REVISED_FORECAST
     FROM xxmaf_cashforecast_v xcv, xxmaf_cash_fcst_period_v xcfv
    WHERE     1 = 1                                   --xcv.project_id = 19631
          AND xcv.project_id = xcfv.project_id(+)
          AND xcv.task_id = xcfv.task_id(+)
          AND xcv.po_number = xcfv.po_number(+)
          AND xcv.period = xcfv.period(+)
   UNION ALL
   SELECT BUDGET_VERSION_ID,
          'UNCOMMITTED' TYPE,
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
          NULL PO_NUMBER,
          NULL VENDOR_NAME,
          NULL VENDOR_SITE_CODE,
          NULL PO_CREATION_DATE,
          NULL CURRENCY_CODE,
          NULL RATE,
          NULL PO_AMOUNT,
          NULL RECEIVED_AMOUNT,
          NULL BILLED_AMOUNT,
          NULL AMOUNT_PAID,
          NULL BALANCE_TO_PAY,
          CASF_FOECAST_ID,
          PERIOD,
          YEAR,
          REV_NUM,
          PERIOD1,
          PERIOD2,
          PERIOD3,
          PERIOD4,
          PERIOD5,
          PERIOD6,
          PERIOD7,
          PERIOD8,
          PERIOD9,
          PERIOD10,
          PERIOD11,
          PERIOD12,
          PERIOD13,
          PERIOD14,
          PERIOD15,
          PERIOD16,
          PERIOD17,
          PERIOD18,
          LAST_UPDATE_DATE,
          LAST_UPDATED_BY,
          CREATION_DATE,
          CREATED_BY,
          LAST_UPDATE_LOGIN,
          STATUS_FLAG,
          NULL PO_HEADER_ID,
          PERIOD19,
          PERIOD20,
          PERIOD21,
          PERIOD22,
          PERIOD23,
          PERIOD24,
          PERIOD25,
          PERIOD26,
          PERIOD27,
          PERIOD28,
          PERIOD29,
          PERIOD30,
          PERIOD31,
          PERIOD32,
          PERIOD33,
          PERIOD34,
          PERIOD35,
          PERIOD36,
          PERIOD37,
          PERIOD38,
          PERIOD39,
          PERIOD40,
          PERIOD41,
          PERIOD42,
          PERIOD43,
          PERIOD44,
          PERIOD45,
          PERIOD46,
          PERIOD47,
          PERIOD48,
          PERIOD49,
          PERIOD50,
          PERIOD51,
          PERIOD52,
          PERIOD53,
          PERIOD54,
          PERIOD55,
          PERIOD56,
          PERIOD57,
          PERIOD58,
          PERIOD59,
          PERIOD60,
          BI_DATE,
          VARIANCE,
          YEAR1,
          YEAR2,
          YEAR3,
          UNCOMMITED_FORECAST,
          UNCOMMITTED_BUDGET,
          REVISED_FORECAST
     FROM XXMAF_CASH_FORCAST_TSK_V;