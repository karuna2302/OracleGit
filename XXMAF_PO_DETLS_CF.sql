CREATE OR REPLACE FORCE VIEW APPS.XXMAF_PO_DETLS_CF
(
   EXPENDITURE_TYPE,
   PO_NUMBER,
   VENDOR_NAME,
   VENDOR_SITE_CODE,
   PO_CREATION_DATE,
   CURRENCY_CODE,
   RATE,
   PO_AMOUNT,
   PO_AMOUNT_IN_AED,
   RECEIVED_AMOUNT,
   BILLED_AMOUNT,
   AMOUNT_PAID,
   BALANCE_TO_PAY,
   ORG_ID,
   PROJECT_ID,
   TASK_ID
)
AS
   SELECT DISTINCT
          pd.expenditure_type,
          PH.SEGMENT1 PO_NUMBER,
          ap.vendor_name,
          (SELECT vendor_site_code
             FROM ap_supplier_sites_all aps
            WHERE     aps.vendor_id = ap.vendor_id
                  AND aps.org_id = ph.org_id
                  AND aps.vendor_site_id = ph.vendor_site_id)
             vendor_site_code,
          ph.creation_date PO_CREATION_DATE,
          ph.CURRENCY_CODE,
          ph.rate,
          NVL (
             pl.amount,
               (NVL (pD.quantity_ordered, 0) - NVL (pD.quantity_cancelled, 0))
             * NVL (pL.unit_price, 0))
             PO_AMOUNT,
          (  NVL (
                pl.amount,
                  (  NVL (pD.quantity_ordered, 0)
                   - NVL (pD.quantity_cancelled, 0))
                * NVL (pL.unit_price, 0))
           * NVL (ph.rate, 1))
             po_amount_in_AED,
          NVL (AMOUNT_RECEIVED,
               NVL (pll.QUANTITY_RECEIVED, 0) * NVL (pL.unit_price, 0))
             Received_amount,
          NVL (pll.AMOUNT_BILLED,
               NVL (pll.QUANTITY_BILLED, 0) * NVL (pL.unit_price, 0))
             Billed_amount,
          xxcus_amountpaid (pd.PO_HEADER_ID,
                            pd.PO_LINE_ID,
                            pd.LINE_LOCATION_ID,
                            pd.PO_DISTRIBUTION_ID)
             AMount_paid,
            --          (  NVL (
            --                pl.amount,
            --                  (  NVL (pD.quantity_ordered, 0)
            --                   - NVL (pD.quantity_cancelled, 0))
            --                * NVL (pL.unit_price, 0))
            --           - NVL (pll.AMOUNT_BILLED,
            --                  NVL (pll.QUANTITY_BILLED, 0) * NVL (pL.unit_price, 0))
            --           - xxcus_amountpaid (pd.PO_HEADER_ID,
            --                               pd.PO_LINE_ID,
            --                               pd.LINE_LOCATION_ID,
            --                               pd.PO_DISTRIBUTION_ID))
            NVL (
               pl.amount,
                 (  NVL (pD.quantity_ordered, 0)
                  - NVL (pD.quantity_cancelled, 0))
               * NVL (pL.unit_price, 0))
          - xxcus_amountpaid (pd.PO_HEADER_ID,
                              pd.PO_LINE_ID,
                              pd.LINE_LOCATION_ID,
                              pd.PO_DISTRIBUTION_ID)
             Balance_To_Pay,
          pd.org_id,
          pd.project_id,
          pd.task_id
     FROM po_distributions_all pd,
          po_line_locations_all pll,
          po_lines_all pl,
          po_headers_all ph,
          ap_suppliers ap,
          pa_projects_all pja,
          pa_tasks pt
    WHERE     1 = 1
          AND pd.project_id = pja.project_id(+)
          AND pt.task_id(+) = pd.task_id
          AND pd.line_location_id = pll.line_location_id(+)
          AND pd.org_id = pll.org_id(+)
          AND pll.po_line_id = pl.po_line_id(+)
          AND pll.org_id = pl.org_id(+)
          AND pl.po_header_id = ph.po_header_id(+)
          AND pl.org_id = ph.org_id(+)
          AND ap.vendor_id = ph.vendor_id
          AND TO_NUMBER (TO_CHAR (ph.CREATION_DATE, 'RRRR')) >= 2017
   UNION
   SELECT DISTINCT
          pd.expenditure_type,
          PH.SEGMENT1 PO_NUMBER,
          ap.vendor_name,
          (SELECT vendor_site_code
             FROM ap_supplier_sites_all aps
            WHERE     aps.vendor_id = ap.vendor_id
                  AND aps.org_id = ph.org_id
                  AND aps.vendor_site_id = ph.vendor_site_id)
             vendor_site_code,
          ph.creation_date PO_CREATION_DATE,
          ph.CURRENCY_CODE,
          ph.rate,
          NVL (
             pl.amount,
               (NVL (pD.quantity_ordered, 0) - NVL (pD.quantity_cancelled, 0))
             * NVL (pL.unit_price, 0))
             PO_AMOUNT,
          (  NVL (
                pl.amount,
                  (  NVL (pD.quantity_ordered, 0)
                   - NVL (pD.quantity_cancelled, 0))
                * NVL (pL.unit_price, 0))
           * NVL (ph.rate, 1))
             po_amount_in_AED,
          NVL (AMOUNT_RECEIVED,
               NVL (pll.QUANTITY_RECEIVED, 0) * NVL (pL.unit_price, 0))
             Received_amount,
          NVL (pll.AMOUNT_BILLED,
               NVL (pll.QUANTITY_BILLED, 0) * NVL (pL.unit_price, 0))
             Billed_amount,
          xxcus_amountpaid (pd.PO_HEADER_ID,
                            pd.PO_LINE_ID,
                            pd.LINE_LOCATION_ID,
                            pd.PO_DISTRIBUTION_ID)
             AMount_paid,
            --          (  NVL (
            --                pl.amount,
            --                  (  NVL (pD.quantity_ordered, 0)
            --                   - NVL (pD.quantity_cancelled, 0))
            --                * NVL (pL.unit_price, 0))
            --           - NVL (pll.AMOUNT_BILLED,
            --                  NVL (pll.QUANTITY_BILLED, 0) * NVL (pL.unit_price, 0))
            --           - xxcus_amountpaid (pd.PO_HEADER_ID,
            --                               pd.PO_LINE_ID,
            --                               pd.LINE_LOCATION_ID,
            --                               pd.PO_DISTRIBUTION_ID))
            NVL (
               pl.amount,
                 (  NVL (pD.quantity_ordered, 0)
                  - NVL (pD.quantity_cancelled, 0))
               * NVL (pL.unit_price, 0))
          - xxcus_amountpaid (pd.PO_HEADER_ID,
                              pd.PO_LINE_ID,
                              pd.LINE_LOCATION_ID,
                              pd.PO_DISTRIBUTION_ID)
             Balance_To_Pay,
          pd.org_id,
          pd.project_id,
          pd.task_id
     FROM po_distributions_all pd,
          po_line_locations_all pll,
          po_lines_all pl,
          po_headers_all ph,
          ap_suppliers ap,
          pa_projects_all pja,
          pa_tasks pt
    WHERE     1 = 1
          AND pd.project_id = pja.project_id(+)
          AND pt.task_id(+) = pd.task_id
          AND pd.line_location_id = pll.line_location_id(+)
          AND pd.org_id = pll.org_id(+)
          AND pll.po_line_id = pl.po_line_id(+)
          AND pll.org_id = pl.org_id(+)
          AND pl.po_header_id = ph.po_header_id(+)
          AND pl.org_id = ph.org_id(+)
          AND ap.vendor_id = ph.vendor_id
          AND ph.AUTHORIZATION_STATUS = 'APPROVED'
          AND ph.closed_code = 'OPEN'
          AND TO_NUMBER (TO_CHAR (ph.CREATION_DATE, 'RRRR')) < 2017
   ORDER BY 1, 2, 3;