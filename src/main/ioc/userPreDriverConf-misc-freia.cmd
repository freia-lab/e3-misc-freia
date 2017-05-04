###################################################################
## User provided PLC or fast controller driver pre configuration ##
###################################################################

# Documentation: http://cars9.uchicago.edu/software/epics/modbusDoc.html

#drvAsynIPPortConfigure(portName, hostInfo, priority, noAutoConnect, noProcessEos)

drvAsynIPPortConfigure("DMT340_1","$(IP_ADDR):502",0,0,1)

#modbusInterposeConfig(portName, 
#                      linkType,
#                      timeoutMsec,
#                      writeDelayMsec)

modbusInterposeConfig("DMT340_1",0,1000,0)

#drvModbusAsynConfigure(portName, 
#                       tcpPortName,
#                       slaveAddress, 
#                       modbusFunction, 
#                       modbusStartAddress, 
#                       modbusLength,
#                       dataType,
#                       pollMsec, 
#                       plcType);

drvModbusAsynConfigure(DMT_DATA_F, "DMT340_1", 0, 3, 0, 66, 7, 2000, "dmt340")
drvModbusAsynConfigure(DMT_STATUS, "DMT340_1", 0, 3, 512, 5, 4, 2000, "dmt340")

#asynSetTraceIOMask "DMT340_1",0,4   # Enable traceIOHex
#asynSetTraceMask "DMT340_1",0,9     # Enable traceError and traceIODriver
asynSetTraceMask "DMT340_1",0,1     # Enable traceError

#asynSetTraceIOMask "DMT_STATUS",0,4   # Enable traceIOHex
#asynSetTraceMask "DMT_STATUS",0,9     # Enable traceError and traceIODriver
#asynSetTraceIOMask "DMT_DATA_F",0,4   # Enable traceIOHex
#asynSetTraceMask "DMT_DATA_F",0,9     # Enable traceError and traceIODriver

