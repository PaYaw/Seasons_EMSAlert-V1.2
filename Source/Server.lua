local ReportList = {}
local staffs = {}
local onesync = true
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

RegisterNetEvent("Seasons_EMSAlert:NewReport")
AddEventHandler("Seasons_EMSAlert:NewReport", function(data)
	local _source = source
	local newreport = {
		id = #ReportList+1,
		playername = GetPlayerName(_source),
		title = data.title,
		description = data.description,
		solved = false,
		posx = data.posx,
		posy = data.posy,
		playerid = _source
	}
	ReportList[#ReportList+1] = newreport
	print ("NewReport")

	TriggerClientEvent("Seasons_EMSAlert:AddToList",-1,newreport)
end)

RegisterNetEvent("Seasons_EMSAlert:GetReports")
AddEventHandler("Seasons_EMSAlert:GetReports", function()
	local _source = source
	TriggerClientEvent("Seasons_EMSAlert:GetReports",_source,ReportList,onesync,admin)
end)

RegisterNetEvent("Seasons_EMSAlert:Location")
AddEventHandler("Seasons_EMSAlert:Location", function(kindaid,doit)
	local _source = source
	if ESX.GetPlayerFromId(_source).job.name == 'ambulance' then
		if doit then
			local id = ReportList[kindaid].playerid
			local posx = ReportList[kindaid].posx
			local posy = ReportList[kindaid].posy
			if not ReportList[kindaid].solved then
				ReportList[kindaid].solved = "kinda"
			end
			TriggerClientEvent("Seasons_EMSAlert:sendLocation", _source, posx, posy)
			TriggerClientEvent("Seasons_EMSAlert:ReportSolved",-1,kindaid,ReportList[kindaid].solved)
		end
	else
		print("cheater cheater, pumpkin eater... id: ".._source)
	end
end)

RegisterNetEvent("Seasons_EMSAlert:ReportSolved")
AddEventHandler("Seasons_EMSAlert:ReportSolved", function(id,can)
	local _source = source
	if ESX.GetPlayerFromId(_source).job.name == 'ambulance' then
		local report = ReportList[id]
		if report then
			if report.solved ~= true or can then
				if can then
					if ReportList[id].solved == true then
						ReportList[id].solved = false
					else
						ReportList[id].solved = true
					end
				else
					ReportList[id].solved = true
				end
				TriggerClientEvent("Seasons_EMSAlert:ReportSolved",-1,id,ReportList[id].solved)
			end
		end
	else
		print("cheater cheater, pumpkin eater... id: ".._source)
	end
end)
