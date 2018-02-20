epicsEnvSet("AUTOSAVE_SYSM_PV_PREFIX","misc:")

epicsEnvSet("DMT_PREFIX" "$(DMTPREFIX=Cryo-CBox:Pur:QT3400)")

updateMenuConvert()

requireSnippet(userPreDriverConf-misc-freia.cmd, "IP_ADDR=192.168.1.103,IP_ADDR2=192.168.1.59:1137")
#requireSnippet(userPreDriverConf-misc-freia.cmd, "IP_ADDR=192.168.1.103,IP_ADDR2=192.168.10.62:3333")
requireSnippet(dbToLoad-misc-freia.cmd)
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


