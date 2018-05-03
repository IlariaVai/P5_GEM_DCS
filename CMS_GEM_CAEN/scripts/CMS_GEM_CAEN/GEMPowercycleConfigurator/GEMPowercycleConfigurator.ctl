main()
{
	dyn_errClass err;

	dyn_string GEMINI27L1, GEMINI27L2, GEMINI28L1, GEMINI28L2, GEMINI29L1, GEMINI29L2, GEMINI30L1, GEMINI30L2; 
  string GEMINI01L1, GEMINI01L2;

  	GEMINI27L1 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard01/channel000.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard01/channel001.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard01/channel002.actual.isOn"
                              );
 		GEMINI27L2 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard01/channel003.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard01/channel004.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard01/channel005.actual.isOn"
                              );
 		GEMINI28L1 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard05/channel000.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard05/channel001.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard05/channel002.actual.isOn"
                              );
 		GEMINI28L2 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard05/channel003.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard05/channel004.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard05/channel005.actual.isOn"
                              );
		GEMINI29L1 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard09/channel000.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard09/channel001.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard09/channel002.actual.isOn"
                              );
		GEMINI29L2 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard09/channel003.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard09/channel004.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard09/channel005.actual.isOn"
                              );
		GEMINI30L1 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard13/channel000.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard13/channel001.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard13/channel002.actual.isOn"
                              );
		GEMINI30L2 = makeDynString("cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard13/channel003.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard13/channel004.actual.isOn",
                               "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard13/channel005.actual.isOn"
                              );
		GEMINI01L1 = "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard17/channel000.actual.isOn";
		GEMINI01L2 = "cms_gem_dcs_1:CAEN/GEM_CAEN_LV/branchController00/easyCrate0/easyBoard17/channel003.actual.isOn";
   
  dpConnect("Lock27L1", GEMINI27L1);
  dpConnect("Lock27L2", GEMINI27L2);
  dpConnect("Lock28L1", GEMINI28L1);
  dpConnect("Lock28L2", GEMINI28L2);
  dpConnect("Lock29L1", GEMINI29L1);
  dpConnect("Lock29L2", GEMINI29L2);
  dpConnect("Lock30L1", GEMINI30L1);
  dpConnect("Lock30L2", GEMINI30L2);
  dpConnect("Lock01L1", GEMINI01L1);
  dpConnect("Lock01L2", GEMINI01L2);

   
  err = getLastError();
      if(dynlen(err)>0)
         DebugTN(err);
      

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock27L1(dyn_string dps, dyn_bool values){
    
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";

  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI27L1.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI27L1 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
    }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel000.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel000.settings.onOff:_lock", 1);
      
      message = message + "GEMINI27L1 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel000.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel000.settings.onOff:_lock", 0);
    
      message = message + "GEMINI27L1 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock27L2(dyn_string dps, dyn_bool values){

  string sys=getSystemName();
  string message;
  message = "*** INFO - ";
  
  
  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI27L2.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI27L2 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel001.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel001.settings.onOff:_lock", 1);
      
      message = message + "GEMINI27L2 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel001.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel001.settings.onOff:_lock", 0);
    
      message = message + "GEMINI27L2 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock28L1(dyn_string dps, dyn_bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI28L1.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI28L1 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel002.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel002.settings.onOff:_lock", 1);
      
      message = message + "GEMINI28L1 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel002.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel002.settings.onOff:_lock", 0);

    message = message + "GEMINI28L1 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock28L2(dyn_string dps, dyn_bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI28L2.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI28L2 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel003.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel003.settings.onOff:_lock", 1);
      
      message = message + "GEMINI28L2 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel003.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel003.settings.onOff:_lock", 0);

      message = message + "GEMINI28L2 - LV is ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock29L1(dyn_string dps, dyn_bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI29L1.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI29L1 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel004.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel004.settings.onOff:_lock", 1);
      
      message = message + "GEMINI29L1 - LV OFF --> HV is Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel004.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel004.settings.onOff:_lock", 0);

      message = message + "GEMINI29L1 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock29L2(dyn_string dps, dyn_bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI29L2.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI29L2 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel005.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel005.settings.onOff:_lock", 1);
      
      message = message + "GEMINI29L2 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel005.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board02/channel005.settings.onOff:_lock", 0);

      message = message + "GEMINI29L2 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock30L1(dyn_string dps, dyn_bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI30L1.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI30L1 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel000.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel000.settings.onOff:_lock", 1);
      
      message = message + "GEMINI30L1 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel000.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel000.settings.onOff:_lock", 0);
 
      message = message + "GEMINI30L1 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock30L2(dyn_string dps, dyn_bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values[1] == 0 || values[2] == 0 || values[3] == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI30L2.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI30L2 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
    }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel001.settings.v0:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel001.settings.onOff:_lock", 1);
      
      message = message + "GEMINI30L2 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel001.settings.v0:_lock", 0);
    dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board04/channel001.settings.onOff:_lock", 0);

      message = message + "GEMINI30L2 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock01L1(string dps, bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI01L1.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI01L1 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel000.settings.v0:_lock",1);  
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel001.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel002.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel003.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel004.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel005.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel006.settings.v0:_lock",1);
      
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel000.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel001.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel002.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel003.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel004.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel005.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel006.settings.onOff:_lock", 1);

      message = message + "GEMINI01L1 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel000.settings.v0:_lock",0);  
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel001.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel002.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel003.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel004.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel005.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel006.settings.v0:_lock",0);
    
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel000.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel001.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel002.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel003.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel004.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel005.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel006.settings.onOff:_lock", 0);
  
      message = message + "GEMINI01L1 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Lock01L2(string dps, bool values){
  
  string sys=getSystemName();
  string message;
  message = "*** INFO - ";


  if(values == 0){
    bool Powercycling;
    dpGet("cms_gem_dcs_1:GEMINI01L2.value", Powercycling);
    
    if(Powercycling){
      message = message + "GEMINI01L2 - LV is powercycling";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);
     }
    else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel007.settings.v0:_lock",1);  
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel008.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel009.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel010.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel011.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel012.settings.v0:_lock",1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel013.settings.v0:_lock",1);
      
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel007.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel008.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel009.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel010.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel011.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel012.settings.onOff:_lock", 1);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel013.settings.onOff:_lock", 1);

      message = message + "GEMINI01L2 - LV OFF --> HV Locked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);    
    }
  
  }
  else{
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel007.settings.v0:_lock",0);  
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel008.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel009.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel010.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel011.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel012.settings.v0:_lock",0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel013.settings.v0:_lock",0);
    
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel007.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel008.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel009.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel010.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel011.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel012.settings.onOff:_lock", 0);
      dpSetWait("cms_gem_dcs_1:CAEN/GEM_CAEN_HV/board12/channel013.settings.onOff:_lock", 0);
      
      message = message + "GEMINI01L2 - LV ON --> HV Unlocked";
      dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",message);  
  }
}

