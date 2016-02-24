#############################################
## DB loading                              ##
#############################################

dbLoadRecords("rf_itlck_hb.db","P=IntlkF-cRio1:Intlk")
#dbLoadTemplate(xxx.substitutions)

dbLoadRecords "longin.template", "P=$(DMT_PREFIX):, R=sOK, PORT=DMT_STATUS, OFFSET=0, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=1"
dbLoadRecords "longin.template", "P=$(DMT_PREFIX):, R=sOn, PORT=DMT_STATUS, OFFSET=1, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=1"
dbLoadRecords "longin.template", "P=$(DMT_PREFIX):, R=sErrCode1, PORT=DMT_STATUS, OFFSET=3, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=0xffff"
dbLoadRecords "longin.template", "P=$(DMT_PREFIX):, R=sErrCode2, PORT=DMT_STATUS, OFFSET=4, DATA_TYPE=UINT16, PREC=0, SCAN=I/O Intr, LOPR=0, HOPR=0xffff"
dbLoadRecords "dmt340_meas.template", "P=$(DMT_PREFIX), PORT=DMT_DATA_F, SCAN=I/O Intr"
