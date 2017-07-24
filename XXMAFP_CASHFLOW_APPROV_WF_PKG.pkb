CREATE OR REPLACE PACKAGE BODY      XXMAFP_CASHFLOW_APPROV_WF_PKG AS
 
  PROCEDURE LAUNCH_WORKFLOW(BATCH_NUMBER        in VARCHAR2,
                            USER_ID             in VARCHAR2
                            ) IS
    v_item_number      VARCHAR2(100);
    v_add_item_id      VARCHAR2(5000);
    error_code         VARCHAR2(100);
    error_msg          VARCHAR2(5000);
    l_user_key         VARCHAR2(100);
    lc_requestor       VARCHAR2(240);
    l_count            NUMBER;
    lv_sum_wps         NUMBER;
    ln_count_wps       NUMBER;
    lv_sum_nonwps      NUMBER;
    ln_count_nonwps    NUMBER;
    ln_costing         NUMBER;
    ln_request_id      NUMBER;
    lv_file_wps        VARCHAR2(240);
    lv_file_nonwps     VARCHAR2(240);
    ln_total_amt       NUMBER;
    ln_total_count     NUMBER;
    lv_approver_name11 VARCHAR2(240);
    ln_cheque_sum      NUMBER;
    ln_cheque_count    NUMBER;
    lv_user_name       VARCHAR2(240);
    lv_user_full_name  VARCHAR2(240);
    lv_hr_req_id       VARCHAR2(240);
    lv_fn_req_id       VARCHAR2(240);
    l_count_hr         NUMBER;
    l_count_fn         NUMBER;
    lv_request_hr_id1  NUMBER;
    lv_request_hr_id2  NUMBER;
    lv_request_hr_id3  NUMBER;
    lv_request_fn_id1  NUMBER;
    lv_request_fn_id2  NUMBER;
    lv_request_fn_id3  NUMBER;
    lv_request_id      VARCHAR2(240);
    lv_request_update  varchar2(240);
    lv_update_pay_wf   varchar2(2000);
    ITEMTYPE           varchar2(100);
    ITEMKEY            varchar2(100);
    PROCESS            varchar2(100);
    L_user_id    number ;
    l_period   varchar2(240);
    l_batch_id   varchar2(240);
    l_PO_CNT     number ;
    l_po_flag   varchar2(240);
    l_proj_flag   varchar2(240);
    lv_proj_type   varchar2(240);
    
  
  BEGIN
  
  
    ITEMTYPE := 'MAFPCSHF';
    ITEMKEY  := 'MAFPCSHF-' ||BATCH_NUMBER;
    PROCESS  := 'MAFPCSHFLOWAPPRV';
   L_user_id := to_number(USER_ID);
   l_batch_id := BATCH_NUMBER;

  
  
    BEGIN
      SELECT distinct fu.USER_NAME, papf.FULL_NAME 
        INTO lc_requestor, lv_user_full_name 
        FROM fnd_user fu, per_all_people_f papf
       WHERE 1 = 1
         AND papf.person_id = fu.employee_id
         AND fu.user_id = L_user_id -- fnd_profile.value('USER_ID')
         AND sysdate between papf.effective_start_date and
             nvl(papf.effective_end_date, sysdate);
             d.m('nooor started');
             d.m('lc_requestor'||lc_requestor);
             d.m('lv_user_full_name'||lv_user_full_name);
             d.m('USER_ID'||L_user_id);
    EXCEPTION
      WHEN OTHERS THEN
        lc_requestor      := NULL;
        lv_user_full_name := null;
    END;
  
   -- WF_ENGINE.Threshold := -1;

    
    WF_ENGINE.CREATEPROCESS(itemtype,
                            itemkey,
                            PROCESS
                          --  l_user_key,
                           -- lc_requestor
                            ); 
     
    XXMAFP_CASHFLOW_APPROV_WF_PKG.Gv_process_method := 'MAFPCSHFLOWAPPRV';
  
    -----------------------------------table Information ------------------------------
  
    WF_ENGINE.SetItemAttrText(itemtype, itemkey, 'USER_NAME', lc_requestor);
    WF_ENGINE.SetItemAttrText(itemtype, itemkey, 'WF_TYPE', 'MAFPCSHF');
    WF_ENGINE.SetItemAttrText(itemtype,
                              itemkey,
                              'USER_NAME_FULL',
                              lv_user_full_name);
  
    WF_ENGINE.SetItemAttrNumber(itemtype, itemkey, 'LEVEL', 1);
   
    
    begin 
    
    
    select distinct replace(PERIOD,'-','')
    into l_period
    from XXCUS_CASH_FORECAS_STG 
    where BATCH_ID = l_batch_id
    and CREATED_BY = L_user_id ;
    
    
    exception 
    when others then 
    raise;
    end;
    dbms_output.put_line('l_period :'||l_period);
      begin 
    
    
    select COUNT(PO_NUMBER)
    into l_PO_CNT
    from XXCUS_CASH_FORECAS_STG 
    where BATCH_ID = l_batch_id
    and CREATED_BY = L_user_id ;
    
   if  l_PO_CNT > 0 then 
   l_po_flag :='Y' ;
   else
   l_po_flag := 'N';
   end if ; 
    
    exception 
    when others then 
    l_po_flag := 'N' ;
    end;
    
    
begin 
 select distinct pa.project_type
 into lv_proj_type
from XXCUS_CASH_FORECAS_STG  csh , pa_projects_all pa
where CSH.PROJECT_ID  = pa.project_id 
and csh.BATCH_ID = l_batch_id
and csh.CREATED_BY = L_user_id ;
 
  dbms_output.put_line('lv_proj_type :'||lv_proj_type); 
   if  upper(lv_proj_type) like '%INV%' then 
   l_proj_flag :='Y' ;
   elsif upper(lv_proj_type) like '%CAPEX%' then 
   l_proj_flag := 'N';
   end if ; 
    
    exception 
    when others then 
    l_proj_flag := 'N' ;
    end;
    
    
    WF_ENGINE.SetItemAttrText(itemtype, itemkey, 'CSH_APPROVAL_PERIOD', l_period); 
    WF_ENGINE.SetItemAttrText(itemtype, itemkey, 'BATCH_NUMBER', l_batch_id);
    WF_ENGINE.SetItemAttrText(itemtype, itemkey, 'USER_ID', L_user_id);
    WF_ENGINE.SetItemAttrText(itemtype, itemkey, 'PO_FLAG', l_po_flag);
    WF_ENGINE.SetItemAttrText(itemtype, itemkey, 'PROJ_FLAG', l_proj_flag);
        wf_engine.setitemattrdocument(itemtype   => itemtype,
                                  itemkey    => itemkey,
                                  aname      => 'MAFP_BUDGET_DETAILS',
                               /*   documentid => 'JSP:/OA_HTML/OA.jsp?OAFunc=OA_APPROVAL_WF_RN_F&BATCH_NUMBER=' ||
                                                BATCH_NUMBER || '&User_id=' ||USER_ID||'&Period='||l_period*/
                                                
                                           documentid => 'JSP:/OA_HTML/OA.jsp?page=/xxcus/oracle/apps/pa/cashflow/webui/apprvworkflowRN&batchId='||
                                                BATCH_NUMBER ||'&UserId=' ||USER_ID||'&Period='||l_period||'&poFlag='||l_po_flag
                                                      
                                                );
  
    
    
    
  
   WF_ENGINE.STARTPROCESS(itemtype, itemkey);
   dbms_output.put_line('STARTPROCESS :'); 
   BEGIN
    INSERT INTO XXMAF_CASHFLOW_APPROVAL
    (
     PROJECT     ,
    PERIOD   ,
    ITEM_KEY  ,
    STATUS     ,
    LAST_UPDATE_DATE   ,
    LAST_UPDATED_BY ,
    CREATION_DATE  ,
    CREATED_BY   ,
    LAST_UPDATE_LOGIN
    )
    VALUES
    (
     (
      select distinct pa.name
        from XXCUS_CASH_FORECAS_STG  csh , pa_projects_all pa
        where CSH.PROJECT_ID  = pa.project_id 
        and csh.BATCH_ID = l_batch_id
        and rownum=1
     ),
     to_char(to_date(l_period,'MONYY'),'MON-YY'),--l_period,
     itemkey,
     'I',
     SYSDATE,
     L_user_id,
     SYSDATE,
     L_user_id,
     L_user_id
    );
  EXCEPTION
   WHEN OTHERS THEN
    NULL;
  END ;
  
  UPDATE XXCUS_CASH_FORECAS_STG a
   SET 
     REVISED_FORECAST = NVL(a.uncommitted_budget,0) + NVL (a.forecast, 0),
     VARIANCE = ( NVL (a.PERIOD1, 0)
           + NVL (a.PERIOD2, 0)
           + NVL (a.PERIOD3, 0)
           + NVL (a.PERIOD4, 0)
           + NVL (a.PERIOD5, 0)
           + NVL (a.PERIOD6, 0)
           + NVL (a.PERIOD7, 0)
           + NVL (a.PERIOD8, 0)
           + NVL (a.PERIOD9, 0)
           + NVL (a.PERIOD10, 0)
           + NVL (a.PERIOD11, 0)
           + NVL (a.PERIOD12, 0)
           + NVL (a.PERIOD13, 0)
           + NVL (a.PERIOD14, 0)
           + NVL (a.PERIOD15, 0)
           + NVL (a.PERIOD16, 0)
           + NVL (a.PERIOD17, 0)
           + NVL (a.PERIOD18, 0)
           + NVL (a.PERIOD19, 0)
           + NVL (a.PERIOD20, 0)
           + NVL (a.PERIOD21, 0)
           + NVL (a.PERIOD22, 0)
           + NVL (a.PERIOD23, 0)
           + NVL (a.PERIOD24, 0)
           + NVL (a.PERIOD25, 0)
           + NVL (a.PERIOD26, 0)
           + NVL (a.PERIOD27, 0)
           + NVL (a.PERIOD28, 0)
           + NVL (a.PERIOD29, 0)
           + NVL (a.PERIOD30, 0)
           + NVL (a.PERIOD31, 0)
           + NVL (a.PERIOD32, 0)
           + NVL (a.PERIOD33, 0)
           + NVL (a.PERIOD34, 0)
           + NVL (a.PERIOD35, 0)
           + NVL (a.PERIOD36, 0)
           + NVL (a.PERIOD37, 0)
           + NVL (a.PERIOD38, 0)
           + NVL (a.PERIOD39, 0)
           + NVL (a.PERIOD40, 0)
           + NVL (a.PERIOD41, 0)
           + NVL (a.PERIOD42, 0)
           + NVL (a.PERIOD43, 0)
           + NVL (a.PERIOD44, 0)
           + NVL (a.PERIOD45, 0)
           + NVL (a.PERIOD46, 0)
           + NVL (a.PERIOD47, 0)
           + NVL (a.PERIOD48, 0)
           + NVL (a.PERIOD49, 0)
           + NVL (a.PERIOD50, 0)
           + NVL (a.PERIOD51, 0)
           + NVL (a.PERIOD52, 0)
           + NVL (a.PERIOD53, 0)
           + NVL (a.PERIOD54, 0)
           + NVL (a.PERIOD55, 0)
           + NVL (a.PERIOD56, 0)
           + NVL (a.PERIOD57, 0)
           + NVL (a.PERIOD58, 0)
           + NVL (a.PERIOD59, 0)
           + NVL (a.PERIOD60, 0)) - (NVL(a.uncommitted_budget,0) + NVL (a.forecast, 0))
    WHERE BATCH_ID=l_batch_id;
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
    
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(SQLCODE);
    
  END LAUNCH_WORKFLOW;

  PROCEDURE GET_APPROVER(itemtype  IN VARCHAR2,
                         itemkey   IN VARCHAR2,
                         actid     IN NUMBER,
                         funcmode  IN VARCHAR2,
                         resultout OUT NOCOPY VARCHAR2) IS
    CURSOR Cur_Appr(p_level NUMBER) IS
    
      SELECT fu.USER_NAME,
             (SELECT FULL_NAME
                FROM PER_ALL_PEOPLE_F
               WHERE PERSON_ID = fu.EMPLOYEE_ID
                 AND SYSDATE BETWEEN EFFECTIVE_START_DATE AND
                     NVl(EFFECTIVE_END_DATE, SYSDATE)) USER_FULL_NAME
        FROM XXMAF_APPROVAL_HEADERS_ALL xaha,
             XXMAF_APPROVAL_LINES_ALL   xala,
             FND_USER                   fu
       WHERE xaha.APPROVAL_HEADER_ID = xala.APPROVAL_HEADER_ID
         AND xala.EMPLOYEE_ID = fu.employee_id
         AND SYSDATE BETWEEN xala.START_DATE_ACTIVE AND
             NVL(xala.END_DATE_ACTIVE, SYSDATE)
         AND xaha.APPROVAL_TYPE_CODE = 'MAFPCASHFLOWWF'
         AND xala.APPRVL_TYPE = 'Approval'
         AND LEVEL_NUM = p_level
         AND EXISTS (SELECT 1
                FROM PER_ALL_PEOPLE_F
               WHERE PERSON_ID = fu.EMPLOYEE_ID
                 AND SYSDATE BETWEEN EFFECTIVE_START_DATE AND
                     NVl(EFFECTIVE_END_DATE, SYSDATE))
         AND FU.USER_NAME != 'SYSADMIN';
  
    l_level           NUMBER;
    l_next_appr       VARCHAR2(100);
    l_next_appr_fname VARCHAR2(100);
    l_header_id       VARCHAR2(100);
    l_comments        VARCHAR2(500);
    l_subject         VARCHAR2(100);
    l_msg_body        VARCHAR2(4000);
    l_mode            VARCHAR2(100);
    l_trans_id        NUMBER;
  
  BEGIN
  
    l_level := WF_ENGINE.GETItemAttrNumber(itemtype, itemkey, 'LEVEL');
  
    IF funcmode = 'RUN' THEN
      OPEN Cur_Appr(l_level);
      LOOP
        FETCH Cur_Appr
          INTO l_next_appr, l_next_appr_fname;
        Exit WHEN Cur_Appr%NOTFOUND;
      END LOOP;
      CLOSE Cur_Appr;
      IF l_next_appr IS NULL THEN
        resultout := 'COMPLETE:N';
      ELSE
        WF_ENGINE.SetItemAttrText(itemtype,
                                  itemkey,
                                  'APPR_NAME',
                                  l_next_appr);
        WF_ENGINE.SetItemAttrText(itemtype,
                                  itemkey,
                                  'APPR_FULL_NAME',
                                  l_next_appr_fname);
        resultout := 'COMPLETE:Y';
      
      END IF;
    END IF;
  End GET_APPROVER;

  PROCEDURE CHECK_LEVELS(itemtype  IN VARCHAR2,
                         itemkey   IN VARCHAR2,
                         actid     IN NUMBER,
                         funcmode  IN VARCHAR2,
                         resultout OUT NOCOPY VARCHAR2) IS
    CURSOR Cur_Appr(p_level NUMBER) IS
      SELECT fu.USER_NAME,
             (SELECT FULL_NAME
                FROM PER_ALL_PEOPLE_F
               WHERE PERSON_ID = fu.EMPLOYEE_ID
                 AND SYSDATE BETWEEN EFFECTIVE_START_DATE AND
                     NVl(EFFECTIVE_END_DATE, SYSDATE)) USER_FULL_NAME
        FROM XXMAF_APPROVAL_HEADERS_ALL xaha,
             XXMAF_APPROVAL_LINES_ALL   xala,
             FND_USER                   fu
       WHERE xaha.APPROVAL_HEADER_ID = xala.APPROVAL_HEADER_ID
         AND xala.EMPLOYEE_ID = fu.employee_id
         AND SYSDATE BETWEEN xala.START_DATE_ACTIVE AND
             NVL(xala.END_DATE_ACTIVE, SYSDATE)
         AND xaha.APPROVAL_TYPE_CODE = 'MAFPCASHFLOWWF'
         AND xala.APPRVL_TYPE = 'Approval'
         AND LEVEL_NUM = p_level
         AND EXISTS (SELECT 1
                FROM PER_ALL_PEOPLE_F
               WHERE PERSON_ID = fu.EMPLOYEE_ID
                 AND SYSDATE BETWEEN EFFECTIVE_START_DATE AND
                     NVl(EFFECTIVE_END_DATE, SYSDATE));
  
    l_level               NUMBER;
    l_next_appr           VARCHAR2(100);
    l_next_appr_fname     VARCHAR2(100);
    l_header_id           VARCHAR2(100);
    l_comments            VARCHAR2(500);
    l_wf_type             VARCHAR2(50);
    L_MILESTONE_HEADER_ID NUMBER;
    V_ERRBUF              VARCHAR2(500);
    V_RETCODE             VARCHAR2(500);
    V_STATUS              VARCHAR2(500);
    V_ERROR_MSG           VARCHAR2(500);
    V_CM_TRX_ID           NUMBER;
  
  BEGIN
  
    L_LEVEL := WF_ENGINE.GETITEMATTRNUMBER(ITEMTYPE, ITEMKEY, 'LEVEL');
  
    L_WF_TYPE := WF_ENGINE.GETITEMATTRTEXT(ITEMTYPE, ITEMKEY, 'WF_TYPE');
  
    IF funcmode = 'RUN' THEN
      OPEN Cur_Appr(l_level + 1);
      LOOP
        FETCH Cur_Appr
          INTO l_next_appr, l_next_appr_fname;
        Exit WHEN Cur_Appr%NOTFOUND;
      END LOOP;
      CLOSE Cur_Appr;
      IF l_next_appr IS NULL THEN
      
        IF l_level >= 1 THEN
        
          resultout := 'COMPLETE:N';
       END IF;
      ELSE
          l_level := l_level + 1;
          WF_ENGINE.SetItemAttrNumber(itemtype, itemkey, 'LEVEL', l_level);
          resultout := 'COMPLETE:Y';                
      END IF;
    END IF;
  
  End CHECK_LEVELS;
----------------------------------------------------
  PROCEDURE REJECTED(itemtype  IN VARCHAR2,
                     itemkey   IN VARCHAR2,
                     actid     IN NUMBER,
                     funcmode  IN VARCHAR2,
                     resultout OUT NOCOPY VARCHAR2) IS
  
    l_level           NUMBER;
    l_next_appr       VARCHAR2(100);
    l_next_appr_fname VARCHAR2(100);
    l_header_id       VARCHAR2(100);
    l_comments        VARCHAR2(500);
    L_WF_TYPE         VARCHAR2(100);
    l_batch_id        VARCHAR2(100);
  
  BEGIN
   
    l_batch_id := WF_ENGINE.GETItemAttrText (itemtype,
                                 itemkey, 
                                 'BATCH_NUMBER') ;
    
    UPDATE XXCUS_CASH_FORECAS_STG
     SET status_flag='E',
         errormsg='Forecast Approval Rejected'
     WHERE batch_id = l_batch_id;
     Commit;                                          
  
  End REJECTED;

  PROCEDURE APPROVED(itemtype  IN VARCHAR2,
                     itemkey   IN VARCHAR2,
                     actid     IN NUMBER,
                     funcmode  IN VARCHAR2,
                     resultout OUT NOCOPY VARCHAR2) IS
  
   l_batch_id  varchar2(240);
   l_user_id  varchar2(240);
    lv_CASF_FOECAST_ID      number          ;
  lv_PROJECT_ID           number          ;
  lv_TASK_ID              number          ;
  lv_PERIOD               varchar2(240)   ;
  lv_YEAR                 number          ;
  lv_REV_NUM              number          ;
  lv_PERIOD1              number          ;
  lv_PERIOD2              number          ;
  lv_PERIOD3              number          ;
  lv_PERIOD4              number          ;
  lv_PERIOD5              number          ;
  lv_PERIOD6              number          ;
  lv_PERIOD7              number          ;
  lv_PERIOD8              number          ;
  lv_PERIOD9              number          ;
  lv_PERIOD10             number          ;
  lv_PERIOD11             number          ;
  lv_PERIOD12             number          ;
  lv_PERIOD13             number          ;
  lv_PERIOD14             number          ;
  lv_PERIOD15             number          ;
  lv_PERIOD16             number          ;
  lv_PERIOD17             number          ;
  lv_PERIOD18             number          ;
  lv_PO_HEADER_ID         number          ;
  lv_PERIOD19             number          ;
  lv_PERIOD20             number          ;
  lv_PERIOD21             number          ;
  lv_PERIOD22             number          ;
  lv_PERIOD23             number          ;
  lv_PERIOD24             number          ;
  lv_PERIOD25             number          ;
  lv_PERIOD26             number          ;
  lv_PERIOD27             number          ;
  lv_PERIOD28             number          ;
  lv_PERIOD29             number          ;
  lv_PERIOD30             number          ;
  lv_PERIOD31             number          ;
  lv_PERIOD32             number          ;
  lv_PERIOD33             number          ;
  lv_PERIOD34             number          ;
  lv_PERIOD35             number          ;
  lv_PERIOD36             number          ;
  lv_PERIOD37             number          ;
  lv_PERIOD38             number          ;
  lv_PERIOD39             number          ;
  lv_PERIOD40             number          ;
  lv_PERIOD41             number          ;
  lv_PERIOD42             number          ;
  lv_PERIOD43             number          ;
  lv_PERIOD44             number          ;
  lv_PERIOD45             number          ;
  lv_PERIOD46             number          ;
  lv_PERIOD47             number          ;
  lv_PERIOD48             number          ;
  lv_PERIOD49             number          ;
  lv_PERIOD50             number          ;
  lv_PERIOD51             number          ;
  lv_PERIOD52             number          ;
  lv_PERIOD53             number          ;
  lv_PERIOD54             number          ;
  lv_PERIOD55             number          ;
  lv_PERIOD56             number          ;
  lv_PERIOD57             number          ;
  lv_PERIOD58             number          ;
  lv_PERIOD59             number          ;
  lv_PERIOD60             number          ;
  lv_PO_NUMBER            varchar2(240)   ;
  lv_UNCOMMITED_FORECAST  number          ;
  lv_TOTAL_FORECAST       number          ;
  lv_UNCOMMITTED_BUDGET   number          ;
  lv_FORECAST             number          ;
  lv_VARIANCE             number          ;
  lv_REVISED_FORECAST     number          ;
 l_period    varchar2(249);   
               
   
   
 cursor cur_final_date_stg ( l_batch_id  varchar2, l_created_by  number , l_period  varchar2)
is 
select * 
from XXCUS_CASH_FORECAS_STG
where  batch_id = l_batch_id
and  created_by = l_created_by
and replace(period,'-','') = l_period ;
   
  BEGIN
   
 
     l_batch_id := WF_ENGINE.GETItemAttrText (itemtype,
                                 itemkey, 
                                 'BATCH_NUMBER') ;  
       
     l_user_id := WF_ENGINE.GetItemAttrText (itemtype,
                                 itemkey, 
                                 'USER_ID') ;
    
      l_period := WF_ENGINE.GETItemAttrText (itemtype,
                                 itemkey, 
                                 'CSH_APPROVAL_PERIOD') ;
     
    begin  
    select nvl(max(REV_NUM),0)+1
    into lv_rev_num 
    from XXCUS_CASH_FORECAS_tbl
    where 1 = 1  -- nvl(batch_id,'X') =  l_batch_id
    and project_id = (select distinct project_id from XXCUS_CASH_FORECAS_stg 
           where  nvl(batch_id,'X') = l_batch_id
            and created_by = l_user_id 
            )
    and nvl(replace(period,'-',''),'X') =  l_period ;

    exception 
    when no_data_found then 
     lv_rev_num := 1 ;
    when others then 
    lv_rev_num := 1 ; 
    end ;
     
   for r_final_date_stg in cur_final_date_stg (l_batch_id , l_user_id , l_period )
   loop 
    BEGIN
  insert into XXCUS_CASH_FORECAS_tbl (
   CASF_FOECAST_ID      
  ,PROJECT_ID           
  ,TASK_ID              
  ,PERIOD               
  ,YEAR                 
  ,REV_NUM              
  ,PERIOD1              
  ,PERIOD2              
  ,PERIOD3              
  ,PERIOD4              
  ,PERIOD5              
  ,PERIOD6              
  ,PERIOD7              
  ,PERIOD8              
  ,PERIOD9              
  ,PERIOD10             
  ,PERIOD11             
  ,PERIOD12             
  ,PERIOD13             
  ,PERIOD14             
  ,PERIOD15             
  ,PERIOD16             
  ,PERIOD17             
  ,PERIOD18             
  ,LAST_UPDATE_DATE     
  ,LAST_UPDATED_BY      
  ,CREATION_DATE        
  ,CREATED_BY           
  ,LAST_UPDATE_LOGIN             
  ,PO_HEADER_ID         
  ,PERIOD19             
  ,PERIOD20             
  ,PERIOD21             
  ,PERIOD22             
  ,PERIOD23             
  ,PERIOD24             
  ,PERIOD25             
  ,PERIOD26             
  ,PERIOD27             
  ,PERIOD28             
  ,PERIOD29             
  ,PERIOD30             
  ,PERIOD31             
  ,PERIOD32             
  ,PERIOD33             
  ,PERIOD34             
  ,PERIOD35             
  ,PERIOD36             
  ,PERIOD37             
  ,PERIOD38             
  ,PERIOD39             
  ,PERIOD40             
  ,PERIOD41             
  ,PERIOD42             
  ,PERIOD43             
  ,PERIOD44             
  ,PERIOD45             
  ,PERIOD46             
  ,PERIOD47             
  ,PERIOD48             
  ,PERIOD49             
  ,PERIOD50             
  ,PERIOD51             
  ,PERIOD52             
  ,PERIOD53             
  ,PERIOD54             
  ,PERIOD55             
  ,PERIOD56             
  ,PERIOD57             
  ,PERIOD58             
  ,PERIOD59             
  ,PERIOD60             
  ,PO_NUMBER            
  --,UNCOMMITED_FORECAST  
  ,TOTAL_FORECAST       
  ,UNCOMMITTED_BUDGET   
  ,UNCOMMITED_FORECAST             
  ,VARIANCE             
  ,REVISED_FORECAST
  ,batch_id ,
  TYPE)
 values
(
   XXCUS_CASH_FORCST_TBL_S.nextval      
  ,r_final_date_stg.PROJECT_ID           
  ,r_final_date_stg.TASK_ID              
  ,r_final_date_stg.PERIOD               
  ,r_final_date_stg.YEAR                 
  ,nvl(lv_rev_num,1)              
  ,r_final_date_stg.PERIOD1              
  ,r_final_date_stg.PERIOD2              
  ,r_final_date_stg.PERIOD3              
  ,r_final_date_stg.PERIOD4              
  ,r_final_date_stg.PERIOD5              
  ,r_final_date_stg.PERIOD6              
  ,r_final_date_stg.PERIOD7              
  ,r_final_date_stg.PERIOD8              
  ,r_final_date_stg.PERIOD9              
  ,r_final_date_stg.PERIOD10             
  ,r_final_date_stg.PERIOD11             
  ,r_final_date_stg.PERIOD12             
  ,r_final_date_stg.PERIOD13             
  ,r_final_date_stg.PERIOD14             
  ,r_final_date_stg.PERIOD15             
  ,r_final_date_stg.PERIOD16             
  ,r_final_date_stg.PERIOD17             
  ,r_final_date_stg.PERIOD18             
  ,sysdate     
  ,fnd_global.user_id      
  ,sysdate        
  ,fnd_global.user_id           
  ,fnd_global.user_id             
  ,r_final_date_stg.PO_HEADER_ID         
  ,r_final_date_stg.PERIOD19             
  ,r_final_date_stg.PERIOD20             
  ,r_final_date_stg.PERIOD21             
  ,r_final_date_stg.PERIOD22             
  ,r_final_date_stg.PERIOD23             
  ,r_final_date_stg.PERIOD24             
  ,r_final_date_stg.PERIOD25             
  ,r_final_date_stg.PERIOD26             
  ,r_final_date_stg.PERIOD27             
  ,r_final_date_stg.PERIOD28             
  ,r_final_date_stg.PERIOD29             
  ,r_final_date_stg.PERIOD30             
  ,r_final_date_stg.PERIOD31             
  ,r_final_date_stg.PERIOD32             
  ,r_final_date_stg.PERIOD33             
  ,r_final_date_stg.PERIOD34             
  ,r_final_date_stg.PERIOD35             
  ,r_final_date_stg.PERIOD36             
  ,r_final_date_stg.PERIOD37             
  ,r_final_date_stg.PERIOD38             
  ,r_final_date_stg.PERIOD39             
  ,r_final_date_stg.PERIOD40             
  ,r_final_date_stg.PERIOD41             
  ,r_final_date_stg.PERIOD42             
  ,r_final_date_stg.PERIOD43             
  ,r_final_date_stg.PERIOD44             
  ,r_final_date_stg.PERIOD45             
  ,r_final_date_stg.PERIOD46             
  ,r_final_date_stg.PERIOD47             
  ,r_final_date_stg.PERIOD48             
  ,r_final_date_stg.PERIOD49             
  ,r_final_date_stg.PERIOD50             
  ,r_final_date_stg.PERIOD51             
  ,r_final_date_stg.PERIOD52             
  ,r_final_date_stg.PERIOD53             
  ,r_final_date_stg.PERIOD54             
  ,r_final_date_stg.PERIOD55             
  ,r_final_date_stg.PERIOD56             
  ,r_final_date_stg.PERIOD57             
  ,r_final_date_stg.PERIOD58             
  ,r_final_date_stg.PERIOD59             
  ,r_final_date_stg.PERIOD60             
  ,r_final_date_stg.PO_NUMBER            
 -- ,r_final_date_stg.UNCOMMITED_FORECAST  
  ,r_final_date_stg.TOTAL_FORECAST       
  ,r_final_date_stg.UNCOMMITTED_BUDGET  
  ,r_final_date_stg.FORECAST             
  ,r_final_date_stg.VARIANCE             
  , NVL(r_final_date_stg.FORECAST,0) + NVL (r_final_date_stg.PERIOD1, 0)
           + NVL (r_final_date_stg.PERIOD2, 0)
           + NVL (r_final_date_stg.PERIOD3, 0)
           + NVL (r_final_date_stg.PERIOD4, 0)
           + NVL (r_final_date_stg.PERIOD5, 0)
           + NVL (r_final_date_stg.PERIOD6, 0)
           + NVL (r_final_date_stg.PERIOD7, 0)
           + NVL (r_final_date_stg.PERIOD8, 0)
           + NVL (r_final_date_stg.PERIOD9, 0)
           + NVL (r_final_date_stg.PERIOD10, 0)
           + NVL (r_final_date_stg.PERIOD11, 0)
           + NVL (r_final_date_stg.PERIOD12, 0)
           + NVL (r_final_date_stg.PERIOD13, 0)
           + NVL (r_final_date_stg.PERIOD14, 0)
           + NVL (r_final_date_stg.PERIOD15, 0)
           + NVL (r_final_date_stg.PERIOD16, 0)
           + NVL (r_final_date_stg.PERIOD17, 0)
           + NVL (r_final_date_stg.PERIOD18, 0)
           + NVL (r_final_date_stg.PERIOD19, 0)
           + NVL (r_final_date_stg.PERIOD20, 0)
           + NVL (r_final_date_stg.PERIOD21, 0)
           + NVL (r_final_date_stg.PERIOD22, 0)
           + NVL (r_final_date_stg.PERIOD23, 0)
           + NVL (r_final_date_stg.PERIOD24, 0)
           + NVL (r_final_date_stg.PERIOD25, 0)
           + NVL (r_final_date_stg.PERIOD26, 0)
           + NVL (r_final_date_stg.PERIOD27, 0)
           + NVL (r_final_date_stg.PERIOD28, 0)
           + NVL (r_final_date_stg.PERIOD29, 0)
           + NVL (r_final_date_stg.PERIOD30, 0)
           + NVL (r_final_date_stg.PERIOD31, 0)
           + NVL (r_final_date_stg.PERIOD32, 0)
           + NVL (r_final_date_stg.PERIOD33, 0)
           + NVL (r_final_date_stg.PERIOD34, 0)
           + NVL (r_final_date_stg.PERIOD35, 0)
           + NVL (r_final_date_stg.PERIOD36, 0)
           + NVL (r_final_date_stg.PERIOD37, 0)
           + NVL (r_final_date_stg.PERIOD38, 0)
           + NVL (r_final_date_stg.PERIOD39, 0)
           + NVL (r_final_date_stg.PERIOD40, 0)
           + NVL (r_final_date_stg.PERIOD41, 0)
           + NVL (r_final_date_stg.PERIOD42, 0)
           + NVL (r_final_date_stg.PERIOD43, 0)
           + NVL (r_final_date_stg.PERIOD44, 0)
           + NVL (r_final_date_stg.PERIOD45, 0)
           + NVL (r_final_date_stg.PERIOD46, 0)
           + NVL (r_final_date_stg.PERIOD47, 0)
           + NVL (r_final_date_stg.PERIOD48, 0)
           + NVL (r_final_date_stg.PERIOD49, 0)
           + NVL (r_final_date_stg.PERIOD50, 0)
           + NVL (r_final_date_stg.PERIOD51, 0)
           + NVL (r_final_date_stg.PERIOD52, 0)
           + NVL (r_final_date_stg.PERIOD53, 0)
           + NVL (r_final_date_stg.PERIOD54, 0)
           + NVL (r_final_date_stg.PERIOD55, 0)
           + NVL (r_final_date_stg.PERIOD56, 0)
           + NVL (r_final_date_stg.PERIOD57, 0)
           + NVL (r_final_date_stg.PERIOD58, 0)
           + NVL (r_final_date_stg.PERIOD59, 0)
           + NVL (r_final_date_stg.PERIOD60, 0) 
  ,r_final_date_stg.batch_id
  , r_final_date_stg.TYPE
) ;
 EXCEPTION
  WHEN OTHERS THEN
   NULL;
 END;
    end loop ;  
    
    UPDATE XXMAF_CASHFLOW_APPROVAL
     SET STATUS='S'
     WHERE ITEM_KEY=itemkey;
         
commit;
exception
when others then 
wf_core.CONTEXT ('XXMAFP_CASHFLOW_APPROV_WF_PKG',
                          'APPROVED',
                          itemtype,
                          itemkey,
                          TO_CHAR (actid),
                          funcmode
                         );
         RAISE;    
     
  End APPROVED;

END XXMAFP_CASHFLOW_APPROV_WF_PKG;

/