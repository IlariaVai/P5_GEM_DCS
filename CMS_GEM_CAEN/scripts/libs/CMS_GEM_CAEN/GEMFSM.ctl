global string ActiveRcp;
//bool HWinStb;
global dyn_string recipenames;

//This Fubnction changes Beam Mode and Stby mode, it checks Rcps in DB and transfers it to cache then to HW. If success then returns 1 otherwise -1
bool ChangeBMHV()
{
  
  string sys; 
  dyn_string exceptionInfo;
  uint BMode;
  sys=getSystemName(); 
  fwConfigurationDB_checkInit(exceptionInfo);
    if (dynlen(exceptionInfo)) 
     {
       fwConfigurationDB_initialize("",exceptionInfo);
       if (dynlen(exceptionInfo))
       {
         DebugN(exceptionInfo);
         dpSet(sys+"GL1.GEMCAEN.RcpError",TRUE);
         return 0;
       }
     }
  // Name of Recipes stored in GL1 DPE of CMS_GEM_LINKS DPT.      
   dpGet(sys+"GL1.GEMCAEN.RecipeNames",recipenames);     
  
  //BMode==0 is COSMIC, BMode==1 is Physics
   dpGet(sys+"GL1.GEMCAEN.Beam.BeamMode",BMode);
   if(RecipeSet(recipenames[BMode+1],"tempRcp")==-1)          // Name of Recipe HV ON
    {
     dpSet(sys+"GL1.GEMCAEN.RcpError",TRUE); 
     return 0;      //Error
    }
   uint rcpMode=1;
   dpSet(sys+"GL1.GEMCAEN.Beam.RcpMode",rcpMode); 
   dpSet(sys+"GL1.GEMCAEN.RcpError",FALSE); 
  return 1;
}
bool ChangeBMLV()
{
  
  string sys; 
  dyn_string exceptionInfo;
  uint BMode;
  sys=getSystemName(); 
  fwConfigurationDB_checkInit(exceptionInfo);
    if (dynlen(exceptionInfo)) 
     {
       fwConfigurationDB_initialize("",exceptionInfo);
       if (dynlen(exceptionInfo))
       {
         DebugN(exceptionInfo);
         dpSet(sys+"GL1.GEMCAEN.RcpError",TRUE);
         return 0;
       }
     }
  // Name of Recipes stored in GL1 DPE of CMS_GEM_LINKS DPT.      
   dpGet(sys+"GL1.GEMCAEN.RecipeNames",recipenames);     
  
  //BMode==0 is COSMIC, BMode==1 is Physics
  if(RecipeSet(recipenames[BMode+3],"tempRcpLV")==-1)          // Name of Recipe LV ON
    {
     dpSet(sys+"GL1.GEMCAEN.RcpError",TRUE); 
     return 0;      //Error
    }
   uint rcpMode=1;
   dpSet(sys+"GL1.GEMCAEN.Beam.RcpMode",rcpMode); 
   dpSet(sys+"GL1.GEMCAEN.RcpError",FALSE); 
  return 1;
}

SwitchOn(string device)
{
      float i,v;
      int onoff;
       dpGet(device+".settings.i1",i);
       dpSet(device+".settings.i0",i);
       dpGet(device+".settings.v1",v);
       dpSet(device+".settings.v0",v);
       dpGet(device+".actual.isOn",onoff);
       if(onoff==0)
        dpSetWait(device+".settings.onOff:_original.._value",1); 
 
}
int RecipeSet(string rcpName,string cacheName)
{
    dyn_dyn_mixed recipeObject;
    dyn_string deviceList;
    dyn_string exceptionInfo;
    fwConfigurationDB_loadRecipeFromDB(rcpName,deviceList, fwDevice_HARDWARE,
                   recipeObject,exceptionInfo,"");
    if (dynlen(exceptionInfo)) {DebugN(exceptionInfo); return -1;}
    //fwConfigurationDB_setRecipeType("rcType_VI",exceptionInfo);
    fwConfigurationDB_applyRecipe(recipeObject,fwDevice_HARDWARE,exceptionInfo);
    if (dynlen(exceptionInfo)) {DebugN(exceptionInfo); return -1;}
    if(strlen(cacheName))
    {
      fwConfigurationDB_saveRecipeToCache(recipeObject,fwDevice_HARDWARE,cacheName,exceptionInfo);
      if (dynlen(exceptionInfo)) {DebugN(exceptionInfo); return -1;}
    }
    return 1;
}
bool ApplyStbRcp()
{
  string sys; 
  dyn_string exceptionInfo;
  sys=getSystemName(); 
  fwConfigurationDB_checkInit(exceptionInfo);
    if (dynlen(exceptionInfo)) 
     {
       fwConfigurationDB_initialize("",exceptionInfo);
       if (dynlen(exceptionInfo))
       {
         DebugN(exceptionInfo);
         dpSet(sys+"GL1.GEMCAEN.RcpError",TRUE);
         return 0;
       }
     }
  // Name of Recipes stored in GL1 DPE of CMS_GEM_LINKS DPT.      
   dpGet(sys+"GL1.GEMCAEN.RecipeNames",recipenames);     
   
  if(RecipeSet(recipenames[5],"")==-1)          // Name of Recipe Stb HV ON
    {
      
      dpSet(sys+"GL1.GEMCAEN.RcpError",TRUE);
      return 0;      //Error
    }
    uint rcpMode=2;
    dpSet(sys+"GL1.GEMCAEN.Beam.RcpMode",rcpMode);  
    dpSet(sys+"GL1.GEMCAEN.RcpError",FALSE);        
  return 1;
}
SwitchToStby(string device)
{
      float i,ia0,v,va0,vd ;
       int n,onoff;   
       dpGet(device+".settings.i1",i);
       dpGet(device+".settings.v1",v);
       dpSet(device+".settings.v0",v);
       
          dpGet(device+".actual.isOn",onoff);
          if(onoff==0)
          dpSetWait(device+".settings.onOff:_original.._value",1); 
          //dpGet(device+".actual.vMon",va0);
          // vd=fabs(v-va0);
          n=0;
          do
          {
            dpGet(device+".actual.vMon",va0);
            vd=fabs(v-va0);
            delay(2);
            n++;
          }
          while(vd > 40 && n < 20);
          if(vd < 41)
           dpSet(device+".settings.i0",i);
           DebugN("Current Settings Applied for Ch="+device);
}

/*SetStByCurrent()
{
  
  delay(35);
  RecipeSet(recipenames[6],false,"");
  DebugN("Standby Current");
}*/

  
