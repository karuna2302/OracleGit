CREATE OR REPLACE PACKAGE      xxmaf_cash_forecast_pkg
AS
 
PROCEDURE validate (Batch_number IN varchar2,
                    user_id IN Varchar2 ,
                    year IN varchar2,
                    period IN varchar2,
                    projecttype IN varchar2,
                    project IN varchar2); 

 END xxmaf_cash_forecast_pkg;

/