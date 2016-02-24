epicsEnvSet("AUTOSAVE_SYSM_PV_PREFIX","misc:")

epicsEnvSet("DMT_PREFIX" "$(DMTPREFIX=Cryo-CBox:Pur:QT3400)")

requireSnippet(userPreDriverConf-misc-freia.cmd, "IP_ADDR=192.168.1.103")
requireSnippet(dbToLoad-misc-freia.cmd)
#requireSnippet(ioc-misc-freia-preSaveRestore.cmd)


#############################################
## IOC Logging                             ##
#############################################
iocLogInit

#############################################
## IOC initialization                      ##
#############################################
iocInit

#requireSnippet(ioc-misc-freia-postSaveRestore.cmd)
requireSnippet(seqToLoad-misc-freia.cmd)
#requireSnippet(userPostDriverConf-misc-freia.cmd"


