#############################################
## DB loading                              ##
#############################################

#dbLoadTemplate(xxx.substitutions)

dbLoadRecords "longin.template", "P=$(DMT_PREFIX)_, R=sOk, PORT=DMT_STATUS, OFFSET=0, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=1"
dbLoadRecords "longin.template", "P=$(DMT_PREFIX)_, R=sOn, PORT=DMT_STATUS, OFFSET=1, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=1"
dbLoadRecords "longin.template", "P=$(DMT_PREFIX)_, R=sErrCode1, PORT=DMT_STATUS, OFFSET=3, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=0xffff"
dbLoadRecords "longin.template", "P=$(DMT_PREFIX)_, R=sErrCode2, PORT=DMT_STATUS, OFFSET=4, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=0xffff"
dbLoadRecords "dmt340_meas.template", "P=$(DMT_PREFIX), PORT=DMT_DATA_F, SCAN=I/O Intr"
dbLoadRecords "tfromp.template", "P=CstatH-LHe, X=101"
dbLoadRecords "tfromp.template", "P=CstatH-LHe, X=102"
dbLoadRecords "from_rasp_pi.db"
dbLoadRecords "from_Labview.db"

