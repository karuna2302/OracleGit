CREATE OR REPLACE function      xxcus_amountpaid(l_PO_HEADER_ID number , 
l_PO_LINE_ID number ,
l_LINE_LOCATION_ID  number ,
l_PO_DISTRIBUTION_ID  number )
return number 
as 
cursor cur_amt_paid 
is 
select amount from ap_invoice_lines_All 
where  PO_HEADER_ID = l_PO_HEADER_ID
--and PO_LINE_ID =l_PO_LINE_ID
and PO_LINE_LOCATION_ID  =  l_LINE_LOCATION_ID
and  PO_DISTRIBUTION_ID  = l_PO_DISTRIBUTION_ID
 ;



l_amount  number ;
lv_amount  number ;

begin 

l_amount := 0 ;
lv_amount := 0 ;
for r_amt_paid in cur_amt_paid
loop 
D.M('looping INSIDE ');
D.M('looping INSIDE  r_amt_paid.amount '||r_amt_paid.amount);
l_amount := r_amt_paid.amount ;
lv_amount := l_amount + lv_amount ;  
end loop ; 
D.M('looping INSIDE lv_amount '||lv_amount);
return lv_amount ; 

exception 
when others then 
raise;
end;

/