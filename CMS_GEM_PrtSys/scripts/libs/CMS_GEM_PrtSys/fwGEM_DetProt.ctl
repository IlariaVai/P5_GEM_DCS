#uses "CMS_GEM_CAEN/GEMFSM.ctl"
fwGEM_MagnetProtLV_Fire()
{
  string sys;
  dyn_string lvchannels;
  sys=getSystemName();
  int ChNo=dynlen(lvchannels);
  /*lvchannels=dpNames(sys+"CAEN*LV*easyBoard*.settings.onOff","FwCaenChannel");
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(lvchannels[i]+":_lock._original._locked",TRUE);
  }*/
  lvchannels=dpNames(sys+"CAEN*LV*easyBoard*.settings.v0","FwCaenChannel");
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(lvchannels[i]+":_lock._original._locked",TRUE);
  }
  DebugN("Number of Channels locked="+ChNo);
  
}
fwGEM_MagnetProtLV_Gone()
{
  string sys;
  dyn_string lvchannels;
  sys=getSystemName();
  int ChNo=dynlen(lvchannels);
  /*lvchannels=dpNames(sys+"CAEN*LV*easyBoard*.settings.onOff","FwCaenChannel");
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(lvchannels[i]+":_lock._original._locked",FALSE);
  }*/
  lvchannels=dpNames(sys+"CAEN*LV*easyBoard*.settings.v0","FwCaenChannel"); 
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(lvchannels[i]+":_lock._original._locked",FALSE);
  }
  DebugN("Number of Channels unlocked="+ChNo);
  
}
fwGEM_MagnetProtHV_Fire()
{
  string sys;
  dyn_string hvchannelsV0,hvchannelsOnOff;
  sys=getSystemName();
  hvchannelsOnOff=dpNames(sys+"CAEN*HV*.settings.onOff","FwCaenChannel");
  int ChNo=dynlen(hvchannelsOnOff);
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(hvchannelsOnOff[i]+":_lock._original._locked",TRUE);
  }
  hvchannelsV0=dpNames(sys+"CAEN*HV*.settings.v0","FwCaenChannel"); 
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(hvchannelsV0[i]+":_lock._original._locked",TRUE);
  }
  DebugN("Number of Channels locked="+ChNo);
}
fwGEM_MagnetProtHV_FireOff()
{
  string sys;
  dyn_string hvchannelsV0,hvchannelsOnOff;
  sys=getSystemName();
  hvchannelsOnOff=dpNames(sys+"CAEN*HV*.settings.onOff","FwCaenChannel");
  int ChNo=dynlen(hvchannelsOnOff);
  for(int i=1;i<=ChNo;i++)
  {
    dpSet(hvchannelsOnOff[i],false); 
    dpSet(hvchannelsOnOff[i]+":_lock._original._locked",TRUE);
  }
  hvchannelsV0=dpNames(sys+"CAEN*HV*.settings.v0","FwCaenChannel"); 
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(hvchannelsV0[i]+":_lock._original._locked",TRUE);
  }
  DebugN("Number of Channels locked="+ChNo);
}
fwGEM_MagnetProtHV_Gone()
{
  string sys;
  dyn_string hvchannelsV0,hvchannelsOnOff;
  sys=getSystemName();
  hvchannelsOnOff=dpNames(sys+"CAEN*HV*.settings.onOff","FwCaenChannel");
  int ChNo=dynlen(hvchannelsOnOff);
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(hvchannelsOnOff[i]+":_lock._original._locked",FALSE);
  }
  hvchannelsV0=dpNames(sys+"CAEN*HV*.settings.v0","FwCaenChannel"); 
  for(int i=1;i<=ChNo;i++)
  {
     
    dpSet(hvchannelsV0[i]+":_lock._original._locked",FALSE);
  }
  DebugN("Number of Channels unlocked="+ChNo);
}
fwGEM_InjectionProtLV()
{
  
}
fwGEM_InjectionProtHV()
{
  
}
void configureProtection_old() {
dyn_mixed obj; string name,sys;
dyn_string exc;

string sys=getSystemName();
//CONFIG DP CMSfwDetectorProtection/Configuration/GEM_Prot
CMSfwDetectorProtection_initObject(obj);
CMSfwDetectorProtection_setDebugLevel(obj,2);
CMSfwDetectorProtection_setVerifyFrequency(obj, 60);


//Condition MagnetLock
name="MagnetLock";
CMSfwDetectorProtection_addCondition(obj,name,exc);
CMSfwDetectorProtection_setConditionType( obj,name,"generic",exc);
CMSfwDetectorProtection_setInput(obj,name,sys+"CMSfwDetectorProtection/Input/Prot_Input_Magnet",exc);
CMSfwDetectorProtection_setOutputModeUserFunction(obj,name,"dyn_string main(string conditionName, string conditionDp, string systemName, bool getVerifyDpes = false)\n{\n  string sys;\n  dyn_string hvchannelsV0,hvchannelsOnOff,dmy;\n  sys=getSystemName();\n  //hvchannelsOnOff=dpNames(sys+\"CAEN*HV*.settings.onOff\",\"FwCaenChannel\");\n  hvchannelsV0=dpNames(sys+\"CAEN*HV*.settings.v0\",\"FwCaenChannel\");\n  //dynAppend(names, dpNames(\"cms_rpc_dcs_2:CAEN/RPCHV02CMS/*channel*\",\"FwCaenChannel\"));\n  dmy=makeDynString(\"\");\n  return dmy;\n  \n}","0",DPEL_FLOAT, FALSE,exc);
CMSfwDetectorProtection_setPrePostUserFunction(obj,name,"#uses \"/CMS_GEM_CAEN/fwGEM_DetProt.ctl\"\nvoid CMSfwDetectorProtectionUser_pre_fired() \n {\n   \n  string sys=getSystemName();\n  fwGEM_MagnetProtHV_Fire();\n  fwGEM_MagnetProtLV_Fire();\n  dpSet(sys+\"GL1.GEMProt.Active\",TRUE);\n  \n   /*/ string sys;\n  dyn_string hvchannelsV0,hvchannelsOnOff;\n  sys=getSystemName();\n  //hvchannelsOnOff=dpNames(sys+\"CAEN*HV*.settings.onOff\",\"FwCaenChannel\");\n  hvchannelsV0=dpNames(sys+\"CAEN*HV*.settings.v0\",\"FwCaenChannel\");*/\n  \n } \n \n \n/* void CMSfwDetectorProtectionUser_post_fired() { } */\n/* void CMSfwDetectorProtectionUser_pre_gone() { } */\nvoid CMSfwDetectorProtectionUser_post_gone() \n{\n  string sys=getSystemName();\n  fwGEM_MagnetProtHV_Gone();\n  fwGEM_MagnetProtLV_Gone();\n  dpSet(sys+\"GL1.GEMProt.Active\",FALSE);\n  \n} \n\n/* dyn_string CMSfwDetectorProtectionUser_convertToReadback(string dpe) { \n // this is used to convert settings to readback, only if the user function is used to find the output dpes \n\nreturn dpe; } */\n",exc);
CMSfwDetectorProtection_setVerifyModeUserFunction(obj,name,"bool main(anytype value) \n{ \n  string sys;\n dyn_string hvchannelsV0;\n float v0;\n int OKChs=0;\n sys=getSystemName();\n hvchannelsV0=dpNames(sys+\"CAEN*HV*.actual.Vmon\",\"FwCaenChannel\");\n for(int ch=1; ch<= dynlen(hvchannelsV0); ch++)\n  {  \n   dpGet(hvchannelsV0[ch],v0);\n   if(v0 << 10)\n   {\n    OKChs++;\n   }\n  }\n if(OKChs==dynlen(hvchannelsV0))\n   return 1;\n else\n   return 0;\n  \n }",5,exc);

//Condition InjectionLock
name="InjectionLock";
CMSfwDetectorProtection_addCondition(obj,name,exc);
CMSfwDetectorProtection_setConditionType( obj,name,"generic",exc);
CMSfwDetectorProtection_setInput(obj,name,sys+"CMSfwDetectorProtection/Input/Prot_Input_Injection",exc);
CMSfwDetectorProtection_setOutputModeUserFunction(obj,name,"dyn_string main(string conditionName, string conditionDp, string systemName, bool getVerifyDpes = false)\n{\n  string sys;\n  dyn_string hvchannelsV0,hvchannelsOnOff,dmy;\n  sys=getSystemName();\n  //hvchannelsOnOff=dpNames(sys+\"CAEN*HV*.settings.onOff\",\"FwCaenChannel\");\n  hvchannelsV0=dpNames(sys+\"CAEN*HV*.settings.v0\",\"FwCaenChannel\");\n  //dynAppend(names, dpNames(\"cms_rpc_dcs_2:CAEN/RPCHV02CMS/*channel*\",\"FwCaenChannel\"));\n  dmy=makeDynString(\"\");\n  return dmy;\n  \n}","0",DPEL_FLOAT, FALSE,exc);
CMSfwDetectorProtection_setPrePostUserFunction(obj,name,"#uses \"/CMS_GEM_CAEN/fwGEM_DetProt.ctl\"\nvoid CMSfwDetectorProtectionUser_pre_fired() \n {\n   \n  string sys=getSystemName();\n  fwGEM_MagnetProtHV_Fire();\n  fwGEM_MagnetProtLV_Fire();\n  dpSet(sys+\"GL1.GEMProt.Active\",TRUE);\n  \n   /*/ string sys;\n  dyn_string hvchannelsV0,hvchannelsOnOff;\n  sys=getSystemName();\n  //hvchannelsOnOff=dpNames(sys+\"CAEN*HV*.settings.onOff\",\"FwCaenChannel\");\n  hvchannelsV0=dpNames(sys+\"CAEN*HV*.settings.v0\",\"FwCaenChannel\");*/\n  \n } \n \n \n/* void CMSfwDetectorProtectionUser_post_fired() { } */\n/* void CMSfwDetectorProtectionUser_pre_gone() { } */\nvoid CMSfwDetectorProtectionUser_post_gone() \n{\n  string sys=getSystemName();\n  fwGEM_MagnetProtHV_Gone();\n  fwGEM_MagnetProtLV_Gone();\n  dpSet(sys+\"GL1.GEMProt.Active\",FALSE);\n  \n} \n\n/* dyn_string CMSfwDetectorProtectionUser_convertToReadback(string dpe) { \n // this is used to convert settings to readback, only if the user function is used to find the output dpes \n\nreturn dpe; } */\n",exc);
CMSfwDetectorProtection_setVerifyModeUserFunction(obj,name,"bool main(anytype value) \n{ \n  string sys;\n dyn_string hvchannelsV0;\n float v0;\n int OKChs=0;\n sys=getSystemName();\n hvchannelsV0=dpNames(sys+\"CAEN*HV*.actual.Vmon\",\"FwCaenChannel\");\n for(int ch=1; ch<= dynlen(hvchannelsV0); ch++)\n  {  \n   dpGet(hvchannelsV0[ch],v0);\n   if(v0 << 10)\n   {\n    OKChs++;\n   }\n  }\n if(OKChs==dynlen(hvchannelsV0))\n   return 1;\n else\n   return 0;\n  \n }",5,exc);

//Condition InjectionStby
name="InjectionStby";
CMSfwDetectorProtection_addCondition(obj,name,exc);
CMSfwDetectorProtection_setConditionType( obj,name,"generic",exc);
CMSfwDetectorProtection_setInput(obj,name,sys+"CMSfwDetectorProtection/Input/Prot_Input_Stb",exc);
CMSfwDetectorProtection_setOutputModeUserFunction(obj,name,"dyn_string main(string conditionName, string conditionDp, string systemName, bool getVerifyDpes = false)\n{\n  string sys;\n  dyn_string hvchannelsV0,hvchannelsOnOff,dmy;\n  sys=getSystemName();\n  //hvchannelsOnOff=dpNames(sys+\"CAEN*HV*.settings.onOff\",\"FwCaenChannel\");\n  hvchannelsV0=dpNames(sys+\"CAEN*HV*.settings.v0\",\"FwCaenChannel\");\n  //dynAppend(names, dpNames(\"cms_rpc_dcs_2:CAEN/RPCHV02CMS/*channel*\",\"FwCaenChannel\"));\n  dmy=makeDynString(\"\");\n  return dmy;\n  \n}","0",DPEL_FLOAT, FALSE,exc);
CMSfwDetectorProtection_setPrePostUserFunction(obj,name,"#uses \"/CMS_GEM_CAEN/fwGEM_DetProt.ctl\"\n#uses \"/CMS_GEM_CAEN/GEMFSM.ctl\"\nvoid CMSfwDetectorProtectionUser_pre_fired() \n {\n   \n  string sys=getSystemName();\n \n //DebugN(dynlen(hvchannels));\n  ApplyStbRcp();\n  All_HV_Stb();\n  fwGEM_MagnetProtHV_Fire();\n  fwGEM_MagnetProtLV_Fire();\n  dpSet(sys+\"GL1.GEMProt.Active\",TRUE);\n  \n   /*/ string sys;\n  dyn_string hvchannelsV0,hvchannelsOnOff;\n  sys=getSystemName();\n  //hvchannelsOnOff=dpNames(sys+\"CAEN*HV*.settings.onOff\",\"FwCaenChannel\");\n  hvchannelsV0=dpNames(sys+\"CAEN*HV*.settings.v0\",\"FwCaenChannel\");*/\n  \n } \n \n \n/* void CMSfwDetectorProtectionUser_post_fired() { } */\n/* void CMSfwDetectorProtectionUser_pre_gone() { } */\nvoid CMSfwDetectorProtectionUser_post_gone() \n{\n  string sys=getSystemName();\n  fwGEM_MagnetProtHV_Gone();\n  fwGEM_MagnetProtLV_Gone();\n  //deBugN();\n  dpSet(sys+\"GL1.GEMProt.Active\",FALSE);\n  \n} \n\n/* dyn_string CMSfwDetectorProtectionUser_convertToReadback(string dpe) { \n // this is used to convert settings to readback, only if the user function is used to find the output dpes \n\nreturn dpe; } */\n",exc);
CMSfwDetectorProtection_setVerifyModeUserFunction(obj,name,"bool main(anytype value) \n{ \n  string sys;\n dyn_string hvchannelsV0;\n float v0;\n int OKChs=0;\n sys=getSystemName();\n hvchannelsV0=dpNames(sys+\"CAEN*HV*.actual.Vmon\",\"FwCaenChannel\");\n for(int ch=1; ch<= dynlen(hvchannelsV0); ch++)\n  {  \n   dpGet(hvchannelsV0[ch],v0);\n   if(v0 << 10)\n   {\n    OKChs++;\n   }\n  }\n if(OKChs==dynlen(hvchannelsV0))\n   return 1;\n else\n   return 0;\n  \n }",5,exc);

CMSfwDetectorProtection_setConfigDp(obj,"CMSfwDetectorProtection/Configuration/GEM_Prot");
CMSfwDetectorProtection_saveToDp(obj,exc);

DebugN("Detector Protection configured. Exceptions=",exc);
}
void configureProtection() {
dyn_mixed obj; string name;
dyn_string exc;

string sys=getSystemName();
//CONFIG DP CMSfwDetectorProtection/Configuration/GEM_Prot
CMSfwDetectorProtection_initObject(obj);
CMSfwDetectorProtection_setDebugLevel(obj,2);
CMSfwDetectorProtection_setVerifyFrequency(obj, 60);

//Condition should be "LHC_Required_Standby_CMS_GEM_GEM_PH"
//Condition InjectionStby
//;
name="InjectionStby";
CMSfwDetectorProtection_addCondition(obj,name,exc);
CMSfwDetectorProtection_setConditionType( obj,name,"generic",exc);
CMSfwDetectorProtection_setInput(obj,name,"cms_cen_dcs_2:CMSfwDetectorProtection/Input/LHC_Requires_Standby_CMS_GEM_GEM_PHY",exc);
CMSfwDetectorProtection_setOutputModeUserFunction(obj,name,"dyn_string main(string conditionName, string conditionDp, string systemName, bool getVerifyDpes = false)\n{\n  string sys;\n  dyn_string hvchannelsV0,hvchannelsOnOff,dmy;\n  sys=getSystemName();\n  //hvchannelsOnOff=dpNames(sys+\"CAEN*HV*.settings.onOff\",\"FwCaenChannel\");\n  hvchannelsV0=dpNames(sys+\"CAEN*HV*.settings.v0\",\"FwCaenChannel\");\n  //dynAppend(names, dpNames(\"cms_GEM:CAEN/RPCHV02CMS/*channel*\",\"FwCaenChannel\"));\n  \n  dmy=makeDynString(sys+\"GL1.GEMProt.bOutput\");\n  return dmy;\n  \n  \n}","0",DPEL_FLOAT, FALSE,exc);
CMSfwDetectorProtection_setPrePostUserFunction(obj,name,"#uses \"/CMS_GEM_PrtSys/fwGEM_DetProt.ctl\"\n#uses \"/CMS_GEM_CAEN/GEMFSM.ctl\"\nvoid CMSfwDetectorProtectionUser_pre_fired() \n {\n   \n  string sys=getSystemName();\n \n //DebugN(dynlen(hvchannels));\n  dpSet(sys+\"GL1.GEMProt.Active\",TRUE);\n  //dpSet(sys+\"myCondition.boolCondition\",TRUE);\n  \n  \n } \n \n \nvoid CMSfwDetectorProtectionUser_post_fired()\n{\n  ApplyStbRcp();\n  All_HV_Stb();\n  fwGEM_MagnetProtHV_Fire();\n  fwGEM_MagnetProtLV_Fire();\n\n} \nvoid CMSfwDetectorProtectionUser_pre_gone() \n{\n  string sys=getSystemName();\n  fwGEM_MagnetProtHV_Gone();\n  fwGEM_MagnetProtLV_Gone();\n  //deBugN();\n  dpSet(sys+\"GL1.GEMProt.Active\",FALSE);\n  //dpSet(sys+\"myCondition.boolCondition\",FALSE);\n}\n/*void CMSfwDetectorProtectionUser_post_gone() \n{\n  \n  \n} */\n\n/* dyn_string CMSfwDetectorProtectionUser_convertToReadback(string dpe) { \n // this is used to convert settings to readback, only if the user function is used to find the output dpes \n\nreturn dpe; } */\n",exc);
CMSfwDetectorProtection_setVerifyModeUserFunction(obj,name,"bool main(anytype value) \n{ \n  string sys;\n dyn_string hvchannelsV0;\n float v0;\n bool reply,reply_stdHV,reply_MC;\n int OKChs=0;\n sys=getSystemName();\n hvchannelsV0=dpNames(sys+\"CAEN*HV*.actual.vMon\",\"FwCaenChannel\");\n \n for(int ch=1; ch<= dynlen(hvchannelsV0); ch++)\n  {  \n   dpGet(hvchannelsV0[ch],v0);\n   if(v0 < 2600)\n   {\n    OKChs++;\n   }\n  }\n \n if(OKChs==dynlen(hvchannelsV0))\n   reply_stdHV=TRUE;\n else\n   reply_stdHV=FALSE;\n \n //dyn_string replyDP_MC = dpNames(sys+\"CMSfwDetectorProtection/Reply/myCondition_boolCondition/*\",\"CMSfwDetectorProtectionReplySys\");\n //dpGet(replyDP_MC[1]+\".reply\", reply_MC);\n reply= reply_stdHV;\n return reply;\n  \n }",5,exc);

CMSfwDetectorProtection_setConfigDp(obj,"CMSfwDetectorProtection/Configuration/GEM_Prot");
CMSfwDetectorProtection_saveToDp(obj,exc);
DebugN("Detector Protection configured. Exceptions=",exc);
}

void configureInputCond() {
dyn_string exc;
CMSfwDetectorProtection_createInput("Prot_Input_Injection", "GEM_ProtI.Value","p1", exc,"Prot Input Magnet");
CMSfwDetectorProtection_createInput("Prot_Input_Magnet", "GEM_ProtM.Value","p1", exc,"Prot Input Magnet");
CMSfwDetectorProtection_createInput("Prot_Input_Stb", "GEM_ProtStb.Value","p1", exc,"Prot Input Stb");
}
All_HV_Stb()
{
  dyn_string hvchannels;
  string sys=getSystemName();
  hvchannels=dpNames(sys+"CAEN*HV*","FwCaenChannel");
  //*******************************
   string msg;
    msg="*** INFO -";  
    msg=msg+getCurrentTime();
   dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",msg);
    msg="*** INFO -";  
    msg=msg+"Detector Protection ON";
    dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",msg);
    //*******************************
  int n=dynlen(hvchannels); 
  for(int i=1;i<=n;i++)
  {
   float v1;
   bool ch_sts;
   dpGet(hvchannels[i]+".settings.onOff",ch_sts);
   if(ch_sts)
   {
     dpGet(hvchannels[i]+".settings.v1",v1);
     dpSetWait(hvchannels[i]+".settings.v0",v1); 
     dpSetWait(hvchannels[i]+".settings.onOff",ch_sts);  
   }
  } 
  //delay(2); 
  Apply_HV_StbCurrent(hvchannels);
  /*delay(60);
  for(int i=1;i<=n;i++)
  {
   float i1;
   bool ch_sts;
   dpGet(hvchannels[i]+".onOff",ch_sts);
   if(ch_sts)
   {
    dpGet(hvchannels[i]+".i1",i1);
    dpSet(hvchannels[i]+".i0",i1); 
   }
  } */  
      
    
}
//*********************************
Apply_HV_StbCurrent(dyn_string ch)
{
  int DTime,STime,ETime;
  float vr,vs0,i0,i1 ;  
  string msg;
  string sys=getSystemName();
  bool mask;
  bool wait=TRUE;
  bool i0Ch=FALSE;
  bool iSet=FALSE;
  int iSetTCh=0;
  dyn_bool iSetnCh;
  int nCh=dynlen(ch);
  DTime=50;      //Max Delay time to aplly Current settings
  STime=period(getCurrentTime());      // Starting time polling
  ETime=0;                        //Eleapsed time
  delay(1);  
  do
  {
     
    for(int i=1; i<=nCh;i++)
    {
      i0Ch=FALSE;      
      dpGet(ch[i]+".actual.vMon",vr);
      dpGet(ch[i]+".settings.v1",vs0);
      dpGet(ch[i]+".settings.i1",i1);
      dpGet(ch[i]+".settings.i0",i0);
      dpGet(ch[i]+".mask",mask);
      if(i0==i1 || mask)
        iSetnCh[i]=TRUE;
      else 
        iSetnCh[i]=FALSE;
      //DebugN("vMon, V0, i1 for Channel-*-> "+vr+" ,"+vs0+" ,"+i1+" for Channel "+ch[i]+" ,i0= "+i0);
      if(vr <= (vs0+50) && !iSetnCh[i])
      {
       
       dpSetWait(ch[i]+".settings.i0",i1);
       dpGet(ch[i]+".readBackSettings.i0",i0);
       if(i0==i1)
       {
         iSetnCh[i]=TRUE;
         iSetTCh++;       
       }
        
       //DebugN("In loop vMon, V0, i1 for Channel-*-> "+vr+" ,"+vs0+" ,"+i1+" for Channel "+ch[i]);
      }
    }
   iSet=TRUE; 
   for(int i=1; i<=nCh;i++)
    {
     iSet=iSet & iSetnCh[i];
    }
  ETime=period(getCurrentTime())-STime;
  if(ETime>DTime)
    wait=FALSE;
  //DebugN("N Wait , iSetnCh, iSet, nCh, ETime",+wait+" , "+iSetTCh+" , "+iSet +" , "+nCh+" , "+ETime); 
  }
  while(wait && !iSet);
  DebugN("Wait , iSetnCh, iSet, nCh, ETime",+wait+" , "+iSetTCh+" , "+iSet +" , "+nCh+" , "+ETime);
  msg="*** INFO -";  
  msg=msg+getCurrentTime();
  dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",msg);
 if(iSet)
  {
    msg="*** INFO -";  
    msg=msg+"Standby Voltage/Current applied during Detector Protection";
    dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",msg);
  }
  else
  {
    msg="*** WARNING -"; 
    msg=msg+"Standby Voltage/Current failed during Detector Protection";
    dpSet(sys+"fwCU_GEM_ENDCAP_Minus.message",msg);
  }
}

//*****************************************
All_LV_Stb()
{
  dyn_string lvchannels;
  string sys=getSystemName();
  lvchannels=dpNames(sys+"CAEN*LV*easyBoard*.settings","FwCaenChannel");
  int n=dynlen(lhvchannels); 
  for(int i=1;i<=n;i++)
  {
    float v1;
   dpGet(lvchannels[i]+".v1",v1);
   dpSet(lvchannels[i]+".v0",v1);
   float i1;
   dpGet(lvchannels[i]+".i1",i1);
   dpSet(lhvchannels[i]+".i0",i1);  
   dpSet(lhvchannels[i]+".onOff",1);  
  }   
}
