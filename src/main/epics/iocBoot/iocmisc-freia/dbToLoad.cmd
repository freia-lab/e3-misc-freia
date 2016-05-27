#############################################
## DB loading                              ##
#############################################

cd "$(TOP)/db"
dbLoadRecords("rf_itlck_hb.db","P=IntlkF-cRio1:Intlk")
dbLoadRecords("from_rasp_pi.db")
#dbLoadTemplate(xxx.substitutions)

