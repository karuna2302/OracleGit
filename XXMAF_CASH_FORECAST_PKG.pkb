CREATE OR REPLACE PACKAGE BODY      xxmaf_cash_forecast_pkg
 AS

PROCEDURE validate         (Batch_number in  varchar2,
                            user_id in Varchar2,
                            year IN varchar2,
                            period IN varchar2,
                            projecttype IN varchar2,
                            project IN varchar2
                            ) IS
                             
Cursor cur_maf_csh_flow_stg_vl
is 
SELECT CASF_FOECAST_ID,
          (SELECT name
             FROM hr_operating_units
            WHERE organization_id IN ( (SELECT org_id
                                          FROM pa_projects_all
                                         WHERE project_id = a.project_id)))
             opname,
          (SELECT NAME
             FROM pa_projects_all
            WHERE project_id = a.project_id)
             projname,
          (SELECT SEGMENT1
             FROM pa_projects_all
            WHERE project_id = a.project_id)
             projnum,
          PROJECT_ID,
          TASK_ID,          
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
          PO_NUMBER,
          BATCH_ID,
          ERRORMSG,
          CBSLEVEL1,
          CBSLEVEL1DESC,
          CBSLEVEL2,
          CBSLEVEL2DESC,
          VENDOR_NAME,
          VENDOR_SITE_CODE,
          PO_CURRENCY,
          RATE,
          PO_AMOUNT,
          RECEIVED_AMOUNT,
          BILLED_AMOUNT,
          AMOUNT_PAID,
          BALANCE_TO_PAY,
          ORIGINAL_BUDGET,
          COST_CATEGORY,
          TOTAL_FORECAST,
          UNCOMMITTED_BUDGET,
          FORECAST,
          REVISED_FORECAST,
          VARIANCE,
          YEAR1,
          YEAR2,
          YEAR3,    
          TYPE,  
 (nvl(PERIOD1 ,0)+            
  nvl(PERIOD2 ,0)+            
  nvl(PERIOD3 ,0)+            
  nvl(PERIOD4 ,0)+            
  nvl(PERIOD5 ,0)+            
  nvl(PERIOD6 ,0)+            
  nvl(PERIOD7 ,0)+            
  nvl(PERIOD8 ,0)+            
  nvl(PERIOD9 ,0)+            
  nvl(PERIOD10,0)+            
  nvl(PERIOD11,0)+            
  nvl(PERIOD12,0)+            
  nvl(PERIOD13,0)+            
  nvl(PERIOD14,0)+            
  nvl(PERIOD15,0)+            
  nvl(PERIOD16,0)+            
  nvl(PERIOD17,0)+            
  nvl(PERIOD18,0)+            
  nvl(PERIOD19,0)+            
  nvl(PERIOD20,0)+            
  nvl(PERIOD21,0)+            
  nvl(PERIOD22,0)+            
  nvl(PERIOD23,0)+            
  nvl(PERIOD24,0)+            
  nvl(PERIOD25,0)+            
  nvl(PERIOD26,0)+            
  nvl(PERIOD27,0)+            
  nvl(PERIOD28,0)+            
  nvl(PERIOD29,0)+            
  nvl(PERIOD30,0)+            
  nvl(PERIOD31,0)+            
  nvl(PERIOD32,0)+            
  nvl(PERIOD33,0)+            
  nvl(PERIOD34,0)+            
  nvl(PERIOD35,0)+            
  nvl(PERIOD36,0)+            
  nvl(PERIOD37,0)+            
  nvl(PERIOD38,0)+            
  nvl(PERIOD39,0)+            
  nvl(PERIOD40,0)+            
  nvl(PERIOD41,0)+            
  nvl(PERIOD42,0)+            
  nvl(PERIOD43,0)+            
  nvl(PERIOD44,0)+            
  nvl(PERIOD45,0)+            
  nvl(PERIOD46,0)+            
  nvl(PERIOD47,0)+            
  nvl(PERIOD48,0)+            
  nvl(PERIOD49,0)+            
  nvl(PERIOD50,0)+            
  nvl(PERIOD51,0)+            
  nvl(PERIOD52,0)+            
  nvl(PERIOD53,0)+            
  nvl(PERIOD54,0)+            
  nvl(PERIOD55,0)+            
  nvl(PERIOD56,0)+            
  nvl(PERIOD57,0)+            
  nvl(PERIOD58,0)+            
  nvl(PERIOD59,0)+            
  nvl(PERIOD60,0)) LN_total_forecast
 FROM XXCUS_CASH_FORECAS_STG a
WHERE batch_id = Batch_number
and  CREATED_BY = to_number(user_id)
and NVL(STATUS_FLAG,'N') in  ('N','E')
ORDER BY CBSLEVEL1
;

ln_project_id       number  ;
ln_task_id          number  ;
lv_period              varchar2(240) ;
lv_error_msg          varchar2(240);
lv_per_cnt            number; 
lv_prj_count          number ;
o_err_code     number ;
o_err_msg    varchar2(240);

l_status    varchar2(100) := 'P';
l_err_msg   varchar2(4000);
l_total_forecast number ;
l_po_number  varchar2(240);
l_variance    number ;
l_task_cnt    number;
                             
BEGIN

ln_project_id := 0;
ln_task_id := 0;
lv_period := '' ;

FOR r_maf_csh_flow_stg_vl IN cur_maf_csh_flow_stg_vl
  LOOP 

    l_status := 'S';
    l_err_msg  := NULL;
    ln_project_id := r_maf_csh_flow_stg_vl.PROJECT_ID;
    ln_task_id := r_maf_csh_flow_stg_vl.TASK_ID;
    lv_period := r_maf_csh_flow_stg_vl.PERIOD ;
    
    IF period != lv_period THEN
      l_status := 'E';
      l_err_msg := l_err_msg||'Uploaded period is not matching with selected period';
    END IF;
    
    IF year != r_maf_csh_flow_stg_vl.year THEN
      l_status := 'E';
      l_err_msg := l_err_msg||','||'Uploaded year is not matching with selected year';
    END IF;
    
    IF project != r_maf_csh_flow_stg_vl.projname THEN
      l_status := 'E';
      l_err_msg := l_err_msg||','||'Uploaded project is not matching with selected project';
    END IF;
    
    -- Validating project & task
    BEGIN
      SELECT count(*)
       INTO l_task_cnt
       FROM pa_tasks
       WHERE project_id = ln_project_id
       AND task_id = ln_task_id;
       IF l_task_cnt<=0 THEN
          l_status := 'E';
          l_err_msg := l_err_msg||','||'Task ID :'||ln_task_id||' is not associated with project '||r_maf_csh_flow_stg_vl.projname;
       END IF;
    END;
    
    -- Validating GL Period
    SELECT count(1)
    INTO lv_per_cnt
    FROM gl_periods
    WHERE sysdate between START_DATE and END_DATE
    AND replace(PERIOD_NAME,'-''')  = lv_period ;

   /* IF lv_per_cnt = 0   THEN 
     l_status := 'E';
     l_err_msg := 'GL Period is Closed.';
    END IF; */
    
    -- Validating project
    SELECT count(1)
    INTO lv_prj_count
    FROM pa_projects_All
    WHERE project_id = ln_project_id 
    AND sysdate between nvl(START_DATE,sysdate -1 ) and  nvl(COMPLETION_DATE,sysdate+1);

    IF lv_prj_count = 0 THEN 
     l_status := 'E';
     l_err_msg := l_err_msg||','||'Project is end dated.please load/select other project';
    END IF ;


    -- Populating total forecast and variance amounts for POs
    IF r_maf_csh_flow_stg_vl.po_number is not  null THEN 
        l_variance := nvl(r_maf_csh_flow_stg_vl.BALANCE_TO_PAY,0) - nvl(r_maf_csh_flow_stg_vl.LN_total_forecast,0) ;

        UPDATE XXCUS_CASH_FORECAS_STG
        SET TOTAL_FORECAST = nvl(r_maf_csh_flow_stg_vl.LN_total_forecast,0) , variance = l_variance
        WHERE PROJECT_ID = r_maf_csh_flow_stg_vl.PROJECT_ID
        AND TASK_ID = r_maf_csh_flow_stg_vl.TASK_ID
        AND PERIOD =  r_maf_csh_flow_stg_vl.PERIOD
        AND YEAR =   r_maf_csh_flow_stg_vl.YEAR 
        AND po_number =  r_maf_csh_flow_stg_vl.po_number 
        AND TYPE = r_maf_csh_flow_stg_vl.TYPE
        AND BATCH_ID = r_maf_csh_flow_stg_vl.BATCH_ID;

    END IF;

    IF r_maf_csh_flow_stg_vl.po_number is null then 
        l_variance := nvl(r_maf_csh_flow_stg_vl.UNCOMMITTED_BUDGET,0) + nvl(r_maf_csh_flow_stg_vl.FORECAST,0) - nvl(r_maf_csh_flow_stg_vl.LN_total_forecast,0) ;


        UPDATE XXCUS_CASH_FORECAS_STG
        SET TOTAL_FORECAST = nvl(r_maf_csh_flow_stg_vl.LN_total_forecast,0) , REVISED_FORECAST  = nvl(r_maf_csh_flow_stg_vl.UNCOMMITTED_BUDGET,0) + nvl(r_maf_csh_flow_stg_vl.FORECAST,0) ,
        variance = l_variance
        WHERE PROJECT_ID = r_maf_csh_flow_stg_vl.PROJECT_ID
        AND TASK_ID = r_maf_csh_flow_stg_vl.TASK_ID
        AND PERIOD =  r_maf_csh_flow_stg_vl.PERIOD
        AND YEAR =   r_maf_csh_flow_stg_vl.YEAR 
        AND TYPE = r_maf_csh_flow_stg_vl.TYPE
        AND BATCH_ID = r_maf_csh_flow_stg_vl.BATCH_ID; 

    END IF;

    IF l_status='S'  THEN
          UPDATE XXCUS_CASH_FORECAS_STG
        SET STATUS_FLAG = 'S', ERRORMSG=null
        WHERE PROJECT_ID = r_maf_csh_flow_stg_vl.PROJECT_ID
        AND TASK_ID = r_maf_csh_flow_stg_vl.TASK_ID
        AND PERIOD =  r_maf_csh_flow_stg_vl.PERIOD
        AND YEAR =   r_maf_csh_flow_stg_vl.YEAR 
        AND TYPE = r_maf_csh_flow_stg_vl.TYPE
        AND BATCH_ID = r_maf_csh_flow_stg_vl.BATCH_ID;
        
    ELSE
    
        UPDATE XXCUS_CASH_FORECAS_STG
        SET ERRORMSG = l_err_msg, STATUS_FLAG = 'E'
        WHERE PROJECT_ID = r_maf_csh_flow_stg_vl.PROJECT_ID
        AND TASK_ID = r_maf_csh_flow_stg_vl.TASK_ID
        AND PERIOD =  r_maf_csh_flow_stg_vl.PERIOD
        AND YEAR =   r_maf_csh_flow_stg_vl.YEAR 
        AND TYPE = r_maf_csh_flow_stg_vl.TYPE
        AND BATCH_ID = r_maf_csh_flow_stg_vl.BATCH_ID;
        
    END IF;


END LOOP ;
  
commit;
EXCEPTION
WHEN OTHERS THEN
     o_err_code:= 1;
     o_err_msg := 'Unexpected error occoured';
END validate;                                

END xxmaf_cash_forecast_pkg;

/