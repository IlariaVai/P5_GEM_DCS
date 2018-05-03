/***************************************************************
  
  GEM General Library v:1.0
  
  author: Ilaria Vai
  
****************************************************************/  
#uses "fwInstallationUtils.ctl"
#uses "CMSfwAlertSystem/CMSfwAlertSystemUtil.ctl"
#uses "fwRDBArchiving/fwRDBConfig.ctl"
#uses "CMSfwFsmXml/CMSfwFsmXml.ctl"
#uses "fwFsm.ctl"
#uses "fwFsmTreeDisplay.ctl"


void CMS_GEMfwGeneralInstallation_createSMSnotification(string confName)
{

  CMSfwAlertSystemUtil_loadFromConfigurationDb(confName);
  
  loadUsers();   refreshNotifications();
    CMSfwAlertSystemUtil_showMsg("Loaded");



}




void CMS_GEMfwHardwareGas_generateTree()
{
	dyn_string nodes, exInfo;
	string gas_system_node,distribution_node,mixer_node, rack_node, mixture_node;
	string ar_node, co2_node;
	string mixer_stepper, gas_system_stepper, distribution_stepper, rack_stepper; 
	string flowcells_node, input_node, diff_node;
	dyn_string flowcells=makeDynString("Channel2","Channel3","Channel4");
	dyn_string diff=makeDynString("CMS_GEM_Di_Ch2","CMS_GEM_Di_Ch3","CMS_GEM_Di_Ch4");
	dyn_string input=makeDynString("CMSGEM_Di_FE6102Ch2","CMSGEM_Di_FE6102Ch3","CMSGEM_Di_FE6102Ch4");
	
	//create GasSystem (type DCSNode)
	fwTree_getRootNodes(nodes,exInfo);
	DebugN(nodes, exInfo);
	if(fwFsmTree_isNode("GasSystem")) fwFsmTree_removeNode("FSM","GasSystem");
	gas_system_node=fwFsmTree_addNode("GEM_ENDCAP_Minus","GasSystem","GS",1);
		DebugN("Gas System node created");

	fwTree_getRootNodes(nodes, exInfo);
	//add list of children CU (type DiscNode)

	//create Mixer node		
	mixer_node=fwFsmTree_addNode("GasSystem","GEMMixer","Mixer",1);
		mixer_stepper=fwFsmTree_addNode("GEMMixer","CMSGEM_Mx_StepperWS","DipSubscriptionsIntMixer",0);

		mixture_node=fwFsmTree_addNode("GEMMixer","Mixture","Mixture",1);
			ar_node=fwFsmTree_addNode("Mixture","CMSGEM_Mx_L1CompRatioAS","DipSubscriptionsFloatArgon",0);
			co2_node=fwFsmTree_addNode("Mixture","CMSGEM_Mx_L2CompRatioAS","DipSubscriptionsFloatCO2",0);
		DebugN("Mixer node created");


	//create Distribution node
	distribution_node=fwFsmTree_addNode("GasSystem","Distribution","Distribution",1);
		rack_node=fwFsmTree_addNode("Distribution","Rack61","Rack",1);
		for(int i=1; i<=dynlen(flowcells);i++)
		{
			flowcells_node=fwFsmTree_addNode("Rack61",flowcells[i],"Flowcell",1);
				diff_node=fwFsmTree_addNode(flowcells[i],diff[i],"DifferenceChannel",0);
				input_node=fwFsmTree_addNode(flowcells[i],input[i],"DipSubscriptionsFloatInputFlow",0);
		}

	rack_stepper=fwFsmTree_addNode("Rack61","CMSGEM_Di_Rack61StepWS","DipSubscriptionsIntRack",0);

	distribution_stepper=fwFsmTree_addNode("Distribution","CMSGEM_Di_ModStepWS","DipSubscriptionsIntDistribution",0);

	DebugN("Distribution node created");


	gas_system_stepper=fwFsmTree_addNode("GasSystem","CMSGEM_Gs_GsStepWS","DipSubscriptionsIntGS",0);



	//Set correct node labels
	fwFsmTree_setNodeLabel("GasSystem","GEM Gas System");
	fwFsmTree_setNodeLabel("GEMMixer","GEM Mixer");
	fwFsmTree_setNodeLabel("CMSGEM_Mx_StepperWS","Mixer Stepper");
	fwFsmTree_setNodeLabel("CMSGEM_Mx_L1CompRatioAS","Argon");
	fwFsmTree_setNodeLabel("CMSGEM_Mx_L2CompRatioAS","CO2");
	fwFsmTree_setNodeLabel("CMSGEM_Di_Rack61StepWS","Rack Stepper");
	fwFsmTree_setNodeLabel("CMSGEM_Di_ModStepWS","Distribution Stepper");
	fwFsmTree_setNodeLabel("CMSGEM_Gs_GsStepWS","Gas System Stepper");
	
		
	for(int i=1; i<=dynlen(flowcells);i++)
		{
			fwFsmTree_setNodeLabel(diff[i],"Input-Output");
			fwFsmTree_setNodeLabel(input[i],"Input Flow");
		}
	
	DebugN("Labels set");


	//Set user panel to node
	//fwFsmTree_setNodePanel(gas_system_node, GS.pnl);

	//fwFsmTree_generateAll(); // NEEDED for next steps??
	//fwFsmTree_refreshTree(); 
	DebugN("Structure ready");
}


