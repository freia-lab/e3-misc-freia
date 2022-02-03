program TP_startstop
// ("p1 = PT001, p2 = PT014, p3 = PT010, p4 = TP001, p6 = FV000, p7 = IBox")
//program TP_startstop ("p1 = PT004, p2 = PT011, p3 = PT015, p4 = TP002, p5 = TT214A, p6 = FV001, p7 = HNOSS")

double PTin;    
double PTout1;  /*TPG300-1 A2, Pi*/
double PTout2;  /*TPG300-2 A2, Pi*/
short TPStatus;      /*TP status*/
short FVon;
short FVoff;
short FVcmdAuto;
short FVcmdMan;
short FVcmdSet;    /* open*/
short FVcmdRst;    /* close*/
short TP_start;
short TP_stop;
short TP_on;
short SS_permissive;
short Stop_permissive;
string TP_state;
int FVsAuto;
short ICB = 0;

double VACok_Low = 1.1e-3;
double VACok_High = 1.2e-3;
double PT_LIMIT1 = 2.e-1;    /*(mbar)*/
double PT_LIMIT2 = 1.e-3;    /*(mbar) Limit for VacOK based on PTOUT1*/
double PT_LIMIT3 = 1.e-3;    /*(mbar) PTIN limit for one of conditions for closing the FV in auto mode*/
double PT_LIMIT4 = 200.;     /*(mbar) Max diff pressure to open FV*/
double PT_LIMIT5 = 1.e-2;    /*(mbar) Max PTOUT1 pressure to open FV in “cold” condition*/
double PTMARGI = 3.e-4 ;   /*(mbar) Hysteresis for PT_LIMIT3*/
int count = 0;

assign PTin to "CstatH-Vac:{p1}:sRdV";    
assign PTout1 to "CstatH-Vac:{p2}:PrsR";  //TPG300-1 A2, Pi
assign PTout2 to "CstatH-Vac:{p3}:PrsR";  //TPG300-2 A2, Pi
assign TPStatus to "CstatH-Vac:{p4}:sStatus";  //Turbo pump status
assign TP_on to "CstatH-Vac:{p4}:cOn"; //Pump on / off 1 / 0
assign FVon to "CstatH-Vac:{p6}:sOn";
assign FVoff to "CstatH-Vac:{p6}:sOff";
assign FVsAuto  to "CstatH-Vac:{p6}:sAuto";
assign FVcmdAuto  to "CstatH-Vac:{p6}:cmdAuto";
assign FVcmdMan to "CstatH-Vac:{p6}:cmdMan";
assign FVcmdSet to "CstatH-Vac:{p6}:cmdSet";    // open
assign FVcmdRst to "CstatH-Vac:{p6}:cmdRst";    // close
assign SS_permissive to "CstatH-Vac:Ctrl-{p7}:StartPmp-sPerm";
assign Stop_permissive to "CstatH-Vac:Ctrl-{p7}:StopPmp-sPerm";
assign TP_state to "CstatH-Vac:Ctrl-{p7}:StartPmp-sState";
assign TP_start to "CstatH-Vac:Ctrl-{p7}:StartPmp-cOn";
assign TP_stop to "CstatH-Vac:Ctrl-{p7}:StopPmp-cOn";



monitor TP_start;
monitor TP_stop;
monitor PTout2;
monitor PTin;
monitor FVsAuto;
monitor TPStatus;

ss start_stop {

        state init {
	      entry {
	      	    if (macValueGet("ICB") != NULL) ICB = 1;
	      	    printf ("ICB: %d\n", ICB);
		    if (ICB == 0) {
		       pvAssign (TPStatus, "CstatH-Vac:TP002:sOn");
		    }
  	      }
	      when (pvConnected(TP_state)) { } state Wait_For_cmd
	}

	state Wait_For_cmd {
	      entry {
		printf ("Entering Wait_For_cmd state\n");
		sprintf (TP_state, "Wait for cmd");
		pvPut(TP_state);
	      }
	      when (TP_start > 0) {
	      	   printf ("Got start command\n");
	      } state Turbo_pump_Start
	      when (TP_stop > 0) {} state Turbo_pump_Stop
	}

	state Turbo_pump_Start {
	// Initialize the start sequence, Check permissives
	      entry{	
		sprintf (TP_state, "Permissiv check");
		pvPut(TP_state);
		pvGet(SS_permissive,SYNC);
 	      }

	      when ((SS_permissive & 0x00FF) != 255) {
	      	   printf ("1: SS_permissive %d\n", SS_permissive);
		   TP_start = 0;
		   pvPut(TP_start, SYNC);
  	      } state Wait_For_cmd
		
	      when ((SS_permissive & 0x00FF) == 255) {
	      	   printf ("2: SS_permissive %d\n", SS_permissive);
	      } state Open_FV
		
	      when ( delay( 10.0 ) ) {
		sprintf (TP_state, "Permissiv check timeout");
	      } state Timeout
	}

	state Open_FV{
	// Prepare to open the valve,check if already open, put in manual  
	      entry {
		sprintf (TP_state, "Open Valve");
		pvPut(TP_state);
		pvGet(FVsAuto,SYNC);
		if (FVsAuto == 1) {
		  FVcmdMan = 1;
		  pvPut(FVcmdMan,SYNC);
		}
		pvGet(FVon,SYNC);
	     }

	     when (delay(2) && (FVon != 1)) {
	     	  pvGet(FVon,SYNC);
	     } state check_pressure

	     when ( FVsAuto == 0) {} state open

	     when (delay (10 ) && (FVsAuto > 0)) {
               sprintf (TP_state, "Error manual mode failed");
             } state Timeout
		
	     when ( delay( 15.0 ) ) {
		sprintf (TP_state,  "Open FV Timeout");
	     } state Timeout
	}

	state open {
	// Open the valve, wait for 15 s
	      entry { FVcmdSet = 1;
	      	printf ("Entering open state\n");
	        sprintf (TP_state, "Open");
		pvPut(TP_state);
		pvPut(FVcmdSet,SYNC);
	      }
	      when (delay (3)) {
              } state check_pressure
	}

	state check_pressure {
        // Wait until pressure difference is ok, maximum 0.5 h 
	      entry {
	      	printf ("Entering check_pressure state. PTout2=%f\n", PTout2);
	      	sprintf (TP_state, "Check pressure");
	        pvPut(TP_state);
		pvGet(FVon,SYNC);
		printf("FVon= %d\n", FVon);
	      }

	      when (FVon == 0) {
	        sprintf (TP_state, "Error FV: still closed TP not started");
              } state Timeout

	      when (PTout2 < PT_LIMIT1 ) {} state start_pump
	      
	      when (TP_start == 0) {} state Wait_For_cmd
			
 	      when ( delay( 1800 ) ) {
	        sprintf (TP_state,  "Timeout pressure diff");
	      } state Timeout

    	}

	state start_pump {
	// Start pumping if not already started, wait for 10 s
	       entry {
	       	 printf ("Entering start pump state\n");
	       	 sprintf (TP_state, "Starting pump");
	       	 pvPut(TP_state);
		 TP_on = 1;
		 pvPut (TP_on,SYNC);		    
		}
		when (TPStatus == 1) 
		{} state  FV_auto

		when (delay(5)) {
//		  pvGet(TPStatus,SYNC);
		 } state check_TP_status

	}

	state check_TP_status {
	//
		entry  {
	    	  printf ("In check_TP_status state,TPstatus=%d\n", TPStatus);
	    	  sprintf (TP_state, "Check TP status");
           	  pvPut(TP_state);
//            	  pvGet(TPStatus);
	  	}

	        when (delay(300)) {
	     	  sprintf (TP_state, "Error: pump not started nafter 5 min");
	        } state Timeout

	        when (((ICB == 1) && (TPStatus == 5)) || ((ICB == 0) && (TPStatus == 1))) {} state FV_auto	     
	}

	state FV_auto {
	// Put valve in auto mode when PTin < (PT_LIMIT3-PTMARGI) 
	       entry  {
	         printf ("In FV_auto state\n");
		 sprintf (TP_state, "Set FV in auto");
	       	 pvPut(TP_state);
	      }

       	      when (FVsAuto > 0) {
	      	 sprintf (TP_state, "Error: FV already in auto mode");
	      } state Timeout

	      when ( PTin < (PT_LIMIT3-PTMARGI)) {
	      	  FVcmdAuto = 1;
		  pvPut(FVcmdAuto);
	      	  TP_start = 0;
	      	  pvPut(TP_start);
	       } state Wait_For_cmd

	       when (delay(3600)) {
	   	 sprintf (TP_state, "Too high pressure to set Auto");
	       } state Timeout
	}

	state Timeout {
	// Timeout and error state, show message for 10 s
	      entry {
	      	 pvPut(TP_state);
	      }

	      when (delay (10)) {
		TP_start = 0;
	      	pvPut(TP_start);
		TP_stop = 0;
	      	pvPut(TP_stop);
	      } state Wait_For_cmd 
	}

////// Stop sequence
 	state Turbo_pump_Stop {
	// Initialize the stop sequence, Check permissives
	      entry{	
		sprintf (TP_state, "Permissiv check");
		pvPut(TP_state);
		pvGet(Stop_permissive,SYNC);
 	      }

	      when ((Stop_permissive & 0x00FF) != 255) {
	      	   printf ("1: Stop_permissive %d\n", Stop_permissive);
		   TP_stop = 0;
		   pvPut(TP_stop, SYNC);
  	      } state Wait_For_cmd
		
	      when ((Stop_permissive & 0x00FF) == 255) {
	      	   printf ("2: Stop_permissive %d\n", Stop_permissive);
		   FVcmdMan = 1;
		   pvPut(FVcmdMan,SYNC);
	      } state Close_FV
		
	      when (delay(10)) {			
	      	TP_stop = 0;
	        pvPut(TP_stop);
	      } state Wait_For_cmd
	 }

	state Close_FV {
	// Prepare to close the valve if open, put in manual  
	      entry {
	        printf ("In Close_FV state\n");
		sprintf (TP_state, "Close Valve");
		pvPut(TP_state);
	     }

	     when (delay (5) && (FVsAuto == 0)) {
	     	  FVcmdRst = 1;
		  pvPut (FVcmdRst);
	     } state stop_pump

	     when ( delay( 6.0 ) ) {
		sprintf (TP_state,  "Close FV Timeout");
	     } state Timeout
	}


	state stop_pump {
	// Stop TP if FV is closed
	       entry {
	         printf ("In stop_pump state\n");
	       	 sprintf (TP_state, "Stopping pump");
	       	 pvPut(TP_state);
		}

		when (delay (3)) {
		 pvGet(FVoff,SYNC);
		 pvGet(FVon,SYNC);
		 printf ("FVon=%d, FVoff=%d\n", FVon,FVoff); 
		  if ((FVon == 0) && (FVoff == 1)) {
		     TP_on = 0;
		     pvPut(TP_on);
		 } 
		 TP_stop = 0;
		 pvPut(TP_stop,SYNC);
		} state Wait_For_cmd
	}	
}
