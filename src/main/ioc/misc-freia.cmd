epicsEnvSet("AUTOSAVE_SYSM_PV_PREFIX","misc:")

epicsEnvSet("DMT_PREFIX" "$(DMTPREFIX=Cryo-CBox:Pur:QT3400)")

updateMenuConvert()

addScan(60)
addScan(300)

requireSnippet(userPreDriverConf-misc-freia.cmd, "IP_ADDR=192.168.1.103,IP_ADDR2=192.168.1.59:1137,IP_ADDR3=192.168.1.58:1137,IP_ADDR4=192.168.10.188:1137")
#requireSnippet(userPreDriverConf-misc-freia.cmd, "IP_ADDR=192.168.1.103,IP_ADDR2=192.168.10.62:3333")
requireSnippet(dbToLoad-misc-freia.cmd)

dbLoadRecords("asynRecord.db","P='Env-Ctrl',R=:asynRec,PORT='LIDAR_PORT',ADDR='0',IMAX='1024',OMAX='256'")

requireSnippet(ioc-misc-freia-preSaveRestore.cmd)


#############################################
## IOC Logging                             ##
#############################################
iocLogInit

#############################################
## IOC initialization                      ##
#############################################
iocInit

requireSnippet(ioc-misc-freia-postSaveRestore.cmd)
requireSnippet(seqToLoad-misc-freia.cmd)
#requireSnippet(userPostDriverConf-misc-freia.cmd"

# Initialize the "good" Sonar:Dist (let's hope it's good when we restart
# the IOC. Otherwise this command must be repeated when Sonar:Dist has
# valid data.
sleep 5
dbpf Cryo-Rec:LP:GasBagSonar-good.PROC 1

dbpf Cryo-Rec:LP:GasBagLidar:HIHI 500.0
dbpf Cryo-Rec:LP:GasBagLidar:HHSV MAJOR



