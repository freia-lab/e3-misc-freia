#############################################
## DB loading                              ##
#############################################

cd "$(TOP)/db"
dbLoadRecords("rf_itlck_hb.db","P=IntlkF-cRio1:Intlk")
#dbLoadTemplate(xxx.substitutions)

