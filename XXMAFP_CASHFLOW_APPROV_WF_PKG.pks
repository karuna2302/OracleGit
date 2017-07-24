CREATE OR REPLACE PACKAGE      XXMAFP_CASHFLOW_APPROV_WF_PKG AS

  GV_PROCESS_METHOD VARCHAR2(240);
  
  PROCEDURE LAUNCH_WORKFLOW(BATCH_NUMBER        in VARCHAR2,
                            USER_ID             in VARCHAR2
                            );

  PROCEDURE GET_APPROVER(ITEMTYPE  IN VARCHAR2,
                         ITEMKEY   IN VARCHAR2,
                         ACTID     IN NUMBER,
                         FUNCMODE  IN VARCHAR2,
                         RESULTOUT OUT NOCOPY VARCHAR2);

  PROCEDURE CHECK_LEVELS(ITEMTYPE  IN VARCHAR2,
                         ITEMKEY   IN VARCHAR2,
                         ACTID     IN NUMBER,
                         FUNCMODE  IN VARCHAR2,
                         RESULTOUT OUT NOCOPY VARCHAR2);
  PROCEDURE REJECTED(ITEMTYPE  IN VARCHAR2,
                     ITEMKEY   IN VARCHAR2,
                     ACTID     IN NUMBER,
                     FUNCMODE  IN VARCHAR2,
                     RESULTOUT OUT NOCOPY VARCHAR2);

  PROCEDURE APPROVED(ITEMTYPE  IN VARCHAR2,
                     ITEMKEY   IN VARCHAR2,
                     ACTID     IN NUMBER,
                     FUNCMODE  IN VARCHAR2,
                     RESULTOUT OUT NOCOPY VARCHAR2);
END XXMAFP_CASHFLOW_APPROV_WF_PKG;

/