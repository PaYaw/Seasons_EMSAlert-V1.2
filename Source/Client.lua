local ReportList = {}
ESX = nil
local firsttime = true
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Wait(1000)
end)

RegisterKeyMapping("emsalert", "EMS-Alert List", "keyboard", "F4")
RegisterCommand("emsalert", function()
	if ESX.GetPlayerData().job.name == 'ambulance' then
		if firsttime then
			TriggerServerEvent("Seasons_EMSAlert:GetReports")
			firsttime = false
		end
		Wait(100)
		ReportNUI(true)
	end
end)

function ReportNUI(bool)
	SetNuiFocus(true, true)
	if bool then
		SendNUIMessage({
			action = "updateReportList",
			reportList = ReportList
		})
		SendNUIMessage({
			action = "openReportList",
		})
	else
		SendNUIMessage({
			action = "startReportForm",
		})
	end
end

RegisterNUICallback("action", function(data)
	local action = data.action
	if action ~= "solvedreport" then
		SetNuiFocus(false, false)
	end
	if action == "setwaypoint" then
		if ReportList[data.id] then
			local id = ReportList[data.id].playerid
			TriggerServerEvent("Seasons_EMSAlert:Location",data.id,true)
		end
	elseif action == "solvedreport" then
		local id = data.id
		local can = data.can
		local reportinfo = ReportList[id]
		if reportinfo then
			if reportinfo.solved ~= true or can then
				TriggerServerEvent("Seasons_EMSAlert:ReportSolved",id,can)
			end
		end
	end
end)

RegisterNetEvent("Seasons_EMSAlert:sendLocation")
AddEventHandler("Seasons_EMSAlert:sendLocation", function(posx,posy)
	SetNewWaypoint(posx, posy)
	print(posx, posy)
end)

RegisterNetEvent('Seasons_EMSAlert:ReportSolved')
AddEventHandler('Seasons_EMSAlert:ReportSolved', function(id,more)
	if ESX.GetPlayerData().job.name == 'ambulance' then
		local report = ReportList[id]
		ReportList[id].solved = more
		SendNUIMessage({
			action = "updateReportList",
			reportList = ReportList
		})
	end
end)

RegisterNetEvent('Seasons_EMSAlert:GetReports')
AddEventHandler('Seasons_EMSAlert:GetReports', function(reports)
	ReportList = reports
end)

RegisterNetEvent('Seasons_EMSAlert:AddToList')
AddEventHandler('Seasons_EMSAlert:AddToList', function(newreport)
	print ("client  add list")
	ReportList[#ReportList+1] = newreport
	SendNUIMessage({
		action = "updateReportList",
		reportList = ReportList
	})
	if ESX.GetPlayerData().job.name == 'ambulance' then
		SendNUIMessage({
			action = "notification",
		})
	end
end)