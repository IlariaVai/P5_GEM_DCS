void main()  //looks for all GEMCaenConfigurator datapoints and performs the dpConnect on their .outValue
{
  dyn_string dpList = dpNames("Gemini??L{1,2}*");
                          
  for (int i=1; i<=dynlen(dpList); i++)
  {
    dpList[i] = dpSubStr(dpList[i], DPSUB_DP);
    string dpType = dpTypeName(dpList[i]);
    if ( dpType == "GEMCaenConfigurator" )
    {
      dpConnect("hvCallback", false, dpList[i]+".outValue");
                                         DebugTN("dpConnect started on GEMCaenConfigurator "+dpList[i]);
    }
    
  }

}

void hvCallback(string dp, int value)
{
  if(value == 1)  //switch_on
  {
    doCommandChannels(dp, value, "SWITCH_ON", "ON");
  }
  else if(value == 2)  //go_to_standby
  {
    doCommandChannels(dp, value, "GO_TO_STANDBY", "STANDBY");
  }
  else if(value == 0)  //switch_off
  {
    doCommandChannels(dp, value, "SWITCH_OFF", "OFF");
  }
}


void doCommandChannels(string configurator, int lastCommand, string fsmCommand, string targetState)
{
  
  configurator = dpSubStr(configurator, DPSUB_DP);
                                           
  //set channels from 0 to 6 for L1, channels from 7 to 13 for L2
  dyn_string order;
  string layer = FALSE;
  if ( strpos(configurator, "L1") >= 0 )
  {
    layer = "L1";
    order = makeDynString("000","002","004","006","001","003","005");
  }
  else if ( strpos(configurator, "L2") >= 0 )
  {
    layer = "L2";
    order = makeDynString("007","009","011","013","008","010","012");  
  }

  dpSet(configurator+".inValue", 0);  //set Configurator to "Applying"  
  
  //choose board number depending on Gemini number
  //for slice test there's only Gemini01 --> board12
  //!!!!!!!!!!!!!!!! the name of the DATAPOINT GemCaenConfigurator MUST be in the form:
  //!!!!!!!!!!!!!!!! GeminiXXLX* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //for example: Gemini01L1      (mind the capital letters!)
  dyn_string board;
  int posGemini = strpos(configurator, "Gemini");
  string strGeminiNr = configurator;
  strGeminiNr = substr( strGeminiNr, posGemini+6, 2);

  string board, upperCU, upperNode, upperNodeState;
  if ( strGeminiNr == "01" )
  { 
    board = "board12";
    upperCU = "GEMINI01_HV";
    upperNode = "GEMINI01"+layer+"_HV";
  }
  // to update with new Gemini in the future to get the correct board, CU and nodes
  
  //reversing the order to send the commands if the voltage is being lowered
  if (targetState == "OFF")
  {
    reverseorder(order);
  }
  if (targetState == "STANDBY" )
  {
    dpGet(upperCU+"|"+upperNode+".fsm.currentState", upperNodeState);
    if ( (upperNodeState == "ON") || (upperNodeState == "ERROR") || (upperNodeState == "WARNING") || (upperNodeState == "RAMPING_UP") || (upperNodeState == "RAMPING_DOWN") )
    {
      reverseorder(order);
    }    
  }
                
//  bool boardMode;
//  dpGet("CAEN/GEM_CAEN_HV/"+board+".readBackSettings.opMode", boardMode);

    //(if board in GEM mode, the board could ramp up/down channels before the FSM has changed the limit i0.
    // In general when a channel is ramped, some current fluctuation is induced also in other channels,
    // that could trip if their limit has not been raised.
    //Here I raise ALL the limts i0 before sending any command, to avoid having trips.)
    for(int i=1; i<=7; i++)
    {
      string nrChannel = order[i];
      dpSet("CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".settings.i0", 50);
    }
   
  for(int i=1; i<=7; i++)
  {
    string nrChannel = order[i];
    int enabled;
                                   
    string state;
    dpGet(upperCU+"|CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".fsm.currentState", state);
    dpGet(upperCU+"|CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".mode.enabled", enabled);
    
    if (enabled == 0) 
    {
      continue;
    }
    
    if (i!=1)
    {    
    for(int j=1; j<=i-1; j++)
      {
        string lastChannel = order[j];
        dpSet("CAEN/GEM_CAEN_HV/"+board+"/channel"+lastChannel+".settings.i0", 50);
      }
    }   
    
    //if channel not switched on
    //maybe it is safer to switch it on only if it is off
    if(state != targetState)
    {
     dpSet(upperCU+"|CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".fsm.sendCommand",fsmCommand); 
    }
    int command;
    //wait for each channel to switch on
    bool timedOut = FALSE;
    time tStart = getCurrentTime();
    time tNow = tStart;
    int tElapsed = period(tNow)-period(tStart); //elapsed time in s
    while( (state != targetState) && (tElapsed<40) )
    {
      dpGet(upperCU+"|CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".fsm.currentState", state);
      dpGet(configurator+".outValue", command);
      //if they send command to switch off while we are still switching on 
      //return
      if(command != lastCommand)
      {
                                              DebugTN("FSM command changed. Aborting last command to channel "+nrChannel+".");
        dpSet(configurator+".inValue", 0);
        return;      
      }
       tNow = getCurrentTime();
       tElapsed = period(tNow)-period(tStart); //update elapsed time
    }
  }
  
  //get the beamMode (cosmics / physics) and set i0 accordingly
    dyn_bool runMode;  
    bool cosmics, physics, standby;
    dyn_string dpStatus = makeDynString("GL1.GEMCAEN.Beam.Physics","GL1.GEMCAEN.Beam.Cosmic","GL1.GEMCAEN.Beam.StandBy");
    
    dpGet(dpStatus, runMode);
    physics = runMode[1];
    cosmics = runMode[2];
    standby = runMode[3];
    
    float i0Low = 2;
    
    if (fsmCommand == "GO_TO_STANDBY") i0Low = 2;
    if (fsmCommand == "SWITCH_OFF")    i0Low = 2;
    if (fsmCommand == "SWITCH_ON")
    {  
      if (physics) i0Low = 10;
      if (cosmics) i0Low = 2;
    }
  
      for(int i=1; i<=7; i++)  //restore low i0 when the action on the layer has finished
    {
      string nrChannel = order[i];
      dpSetWait("CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".settings.i0", i0Low);
    }
      
  dpSet(configurator+".inValue", 1);
  

  /////////////////////////////// CHECK i0 VALUES ///////////////////////////////////////
  // This part is to make sure that the new i0 is set to all HV channels.
  // This part is REDUNDANT, but in production we have seen that
  // sometimes the final i0 is not applied to some channels.
  // So here the i0 is set again, after 20­ seconds (unless a new command has been sent).
  
  //if they send command to switch off while we are still switching on 
  //return
  int command;
  dpGet(configurator+".outValue", command);
  if(command != lastCommand)
  {
    DebugTN("FSM command changed. Aborting last command.");
    dpSet(configurator+".inValue", 0);
    return;      
  }

  time tStart = getCurrentTime();
  time tNow = tStart;
  int tElapsed = period(tNow)-period(tStart); //elapsed time in s
  while(tElapsed<20)
  {
    tNow = getCurrentTime();
    tElapsed = period(tNow)-period(tStart); //update elapsed time
  }
        
  for(int i=1; i<=7; i++)  //restore low i0 when the action on the layer has finished
  {
    string nrChannel = order[i];
    string state;
    dpGet(upperCU+"|CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".fsm.currentState", state);
    float i0readback;
    dpGet("CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".readBackSettings.i0", i0readback);
    if ( (i0readback != i0Low) && (state == targetState) )
    {
      dpSetWait("CAEN/GEM_CAEN_HV/"+board+"/channel"+nrChannel+".settings.i0", i0Low);
    }
  }
  //
  //////////////////////////// END: check i0 values ///////////////////////////////////////

  
  
}  //end of doCommandChannels function

reverseorder(dyn_string& order)
{
  dyn_string copy = order;
  int size = dynlen(order);
  
  for (int i=1; i<=size; i++)
  {
    order[i]=copy[size+1-i];
  }
}
