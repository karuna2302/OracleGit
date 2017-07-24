CREATE TABLE APPS.XXMAF_CASHFLOW_APPROVAL
(
  PROJECT            VARCHAR2(100 BYTE),
  PERIOD             VARCHAR2(100 BYTE),
  ITEM_KEY           VARCHAR2(100 BYTE),
  STATUS             VARCHAR2(100 BYTE),
  LAST_UPDATE_DATE   DATE                       NOT NULL,
  LAST_UPDATED_BY    NUMBER                     NOT NULL,
  CREATION_DATE      DATE                       NOT NULL,
  CREATED_BY         NUMBER                     NOT NULL,
  LAST_UPDATE_LOGIN  NUMBER
)