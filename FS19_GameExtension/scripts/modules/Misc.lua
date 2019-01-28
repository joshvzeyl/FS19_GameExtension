--
-- M_Misc
--
-- @author:    	Xentro (Marcus@Xentro.se)
-- @website:	www.Xentro.se
-- @history:	
-- 
	
M_Misc = {};

-- BL_STATE_NORMAL 		= 0;
-- BL_STATE_DONT_SHOW 	= 1; -- Don't show in gui, will save
-- BL_STATE_NOTHING 	= 2; -- Won't show or save setting

-- Module, Name, GUI Page, value
-- f = function, b = blacklist, e = event


local settings = {};
settings = g_gameExtension:addSetting(settings, { name = "SHOW_HELP_BUTTON", 		page = "Client", value = true, b = g_gameExtension.BL_STATE_NORMAL, f = "setShowHelpButton" });
settings = g_gameExtension:addSetting(settings, { name = "VEHICLE_TABBING", 		page = "Server", value = true, b = g_gameExtension.BL_STATE_NORMAL, f = "setTabState" });

settings = g_gameExtension:addSetting(settings, { name = "CRUISE_ACTIVE", 			page = "Client", value = true, b = g_gameExtension.BL_STATE_NORMAL, f = "changeCruiseControlState" });
settings = g_gameExtension:addSetting(settings, { name = "CRUISE_SCROOL_SPEED", 	page = "Client", value = 1,	   b = g_gameExtension.BL_STATE_NORMAL,
	options = {4, 1, 5}
});

g_gameExtension:addModule("MISC", M_Misc, settings, false);

g_gameExtension:addSpecialization("Cruise_Control", Utils.getFilename("Cruise_Control.lua", folderPaths.vehicles));


function M_Misc:loadMap()
	-- This extend the customTrack script, it will leave the tracks that are made when vehicle are sold.
	g_currentMission.customTrackController 	= true;
	g_currentMission.customTrackSystem		= {};
end;

function M_Misc:deleteMap()
	if g_currentMission.customTrackSystem ~= nil then
		for _, system in ipairs(g_currentMission.customTrackSystem) do
			system:delete();
		end;
		
		g_currentMission.customTrackController = nil;
		g_currentMission.customTrackSystem 	   = nil;
	end;
end;


function M_Misc:setShowHelpButton(state)
	for name, v in pairs(self.actionEventInfo) do
		if v.text ~= nil and v.text ~= "" then
			g_inputBinding:setActionEventTextVisibility(v.eventId, state);
		end;
	end;
end;

function M_Misc:setTabState(state)
	g_currentMission.isToggleVehicleAllowed = state;
end;

function M_Misc:changeCruiseControlState(state)
	if g_currentMission.controlledVehicle ~= nil then
		if g_currentMission.controlledVehicle.updateCruiseActionEvents ~= nil then
			g_currentMission.controlledVehicle:updateCruiseActionEvents(state);
		end;
	end;
end;