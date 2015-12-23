epicsEnvSet("AUTOSAVE_SYSM_PV_PREFIX","misc:")

#requireSnippet(PreDriverConf-misc-freia.cmd)
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


