% Biological Pathways - Function
% The following function computes the energy, land and water requirements for
% the production of SAF, given a choice of feedstock and conversion
% pathway.

function [areas,area_per,feedstock,energy,area_solar,solar_per,water,...
          water_per,energy_eff,energy_eff2,SAF_eff,SAF_eff2] =...
          BioPathways_func(crop_Yield,farming_E,farming_H2O,process_Yield,...
          process_E,process_H2O,SAF_Yield,SAF_E,crop_CO2,land_Harvested,...
          fuel_reqs,solar,water_state,v_pathways)

% ----------------------------------------------------------------------- %
% Step 1: Extracting the function input data

% Feedstock - SAF conversion pathway combinations (pathways_v):
% [CG_ATJ_EtOH, CG_ATJ_BuOH, CS_ATJ_EtOH, Misc_ATJ_EtOH, Switch_ATJ_EtOH,
% CS_FT, Misc_FT, Switch_FT, CO_HEFA]

% Crop yield: [yield_Corn, yield_Misc, yield_Switch]
% (t crop/ha)
yield_Corn = crop_Yield(1);
yield_Misc = crop_Yield(2);
yield_Switch = crop_Yield(3);

% Farming Energy: [farming_Corn_E, farming_Misc_E, farming_Switch_E, farming_Stover_E]
% (% MJ/kg crop)
farming_Corn_E = farming_E(1);
farming_Misc_E = farming_E(2);
farming_Switch_E = farming_E(3);
farming_Stover_E = farming_E(4);

% Farming H2O: [farming_Corn_H2O, farming_Misc_H2O, farming_Switch_H2O, farming_Stover_H2O, RPR]
% (% gal H2O/kg crop)
farming_Corn_H2O = farming_H2O(1);
farming_Misc_H2O = farming_H2O(2);
farming_Switch_H2O = farming_H2O(3);
farming_Stover_H2O = farming_H2O(4);
RPR = farming_H2O(5);

% Process Yield: [yield_EtOH, yield_BuOH, yield_CO]
% (gal EtOH/kg crop | gal BuOH/kg crop | gal CO/kg crop)
yield_EtOH = process_Yield(1);
yield_BuOH = process_Yield(2);
yield_CO = process_Yield(3);

% Process Energy: [process_EtOH_E, process_BuOH_E, process_CO_E]
% (MJ/gal EtOH | MJ/gal BuOH | MJ/gal CO)
process_EtOH_E = process_E(1);
process_BuOH_E = process_E(2);
process_CO_E = process_E(3);

% Process H2O: [process_EtOH_H2O, process_BuOH_H2O, process_CO_H2O]
% (gal H2O/gal EtOH | gal H2O/gal BuOH | gal H2O/gal CO)
process_EtOH_H2O = process_H2O(1);
process_BuOH_H2O = process_H2O(2);
process_CO_H2O = process_H2O(3);

% SAF Conversion Pathways Data: 
% SAF Yield: [yield_ATJ_EtOH, yield_ATJ_BuOH,yield_FT,yield_HEFA]
% (MJ/gal SAF)
% SAF Energy: [ATJ_EtOH_E, ATJ_BuOH_E, FT_E, HEFA_E]
% (MJ/gal SAF)
yield_ATJ_EtOH = SAF_Yield(1);
yield_ATJ_BuOH = SAF_Yield(2);
yield_FT = SAF_Yield(3);
yield_HEFA = SAF_Yield(4);
ATJ_EtOH_E = SAF_E(1);
ATJ_BuOH_E = SAF_E(2);
FT_E = SAF_E(3);
HEFA_E = SAF_E(4);

% Crop CO2: [CO2_Corn, CO2_Misc, CO2_Switch]
CO2_Corn = crop_CO2(1);
CO2_Misc = crop_CO2(2);
CO2_Switch = crop_CO2(3);

% ----------------------------------------------------------------------- %
% Step 2: Conducting the calculations for each pathways

% i) CG_ATJ_EtOH = 'Corn Grain - ATJ (Ethanol)'
q_CG_ATJ_EtOH = 1000*yield_Corn*yield_EtOH*yield_ATJ_EtOH; % gal SAF/ha
E_CG_ATJ_EtOH = 1000*yield_Corn*(farming_Corn_E + yield_EtOH*(process_EtOH_E + yield_ATJ_EtOH*ATJ_EtOH_E)); % MJ/ha
H2O_CG_ATJ_EtOH = 1000*yield_Corn*(farming_Corn_H2O + yield_EtOH*process_EtOH_H2O); % H2O/ha

% ii) CG_ATJ_BuOH = 'Corn Grain - ATJ (Butanol)'
q_CG_ATJ_BuOH = 1000*yield_Corn*yield_BuOH*yield_ATJ_BuOH; % gal SAF/ha
E_CG_ATJ_BuOH = 1000*yield_Corn*(farming_Corn_E + yield_BuOH*(process_BuOH_E + yield_ATJ_BuOH*ATJ_BuOH_E)); % MJ/ha
H2O_CG_ATJ_BuOH = 1000*yield_Corn*(farming_Corn_H2O + yield_BuOH*process_BuOH_H2O); % H2O/ha

% iii) CS_ATJ_EtOH = 'Corn Stover - ATJ (Ethanol)'
q_CS_ATJ_EtOH = 1000*(RPR*yield_Corn)*yield_EtOH*yield_ATJ_EtOH; % gal SAF/ha
E_CS_ATJ_EtOH = 1000*(RPR*yield_Corn)*(farming_Stover_E + yield_EtOH*(process_EtOH_E + yield_ATJ_EtOH*ATJ_EtOH_E)) + 1000*yield_Corn*farming_Corn_E; % MJ/ha
H2O_CS_ATJ_EtOH = 1000*(RPR*yield_Corn)*(farming_Stover_H2O + yield_EtOH*process_EtOH_H2O) + 1000*yield_Corn*farming_Corn_H2O; % H2O/ha

% iv) Misc_ATJ_EtOH = 'Miscanthus - ATJ (Ethanol)'
q_Misc_ATJ_EtOH = 1000*yield_Misc*yield_EtOH*yield_ATJ_EtOH; % gal SAF/ha
E_Misc_ATJ_EtOH = 1000*yield_Misc*(farming_Misc_E + yield_EtOH*(process_EtOH_E + yield_ATJ_EtOH*ATJ_EtOH_E)); % MJ/ha
H2O_Misc_ATJ_EtOH = 1000*yield_Misc*(farming_Misc_H2O + yield_EtOH*process_EtOH_H2O); % H2O/ha

% v) Switch_ATJ_EtOH = 'Switchgrass - ATJ (Ethanol)'
q_Switch_ATJ_EtOH = 1000*yield_Switch*yield_EtOH*yield_ATJ_EtOH; % gal SAF/ha
E_Switch_ATJ_EtOH = 1000*yield_Switch*(farming_Switch_E + yield_EtOH*(process_EtOH_E + yield_ATJ_EtOH*ATJ_EtOH_E)); % MJ/ha
H2O_Switch_ATJ_EtOH = 1000*yield_Switch*(farming_Switch_H2O + yield_EtOH*process_EtOH_H2O); % H2O/ha

% vi)   CS_FT = 'Corn Stover - FT'
q_CS_FT = 1000*(RPR*yield_Corn)*yield_FT; % gal SAF/ha
E_CS_FT = 1000*(RPR*yield_Corn)*(farming_Stover_E + yield_FT*FT_E) + 1000*yield_Corn*farming_Corn_E; % MJ/ha
H2O_CS_FT = 1000*(RPR*yield_Corn)*farming_Stover_H2O + 1000*yield_Corn*farming_Corn_H2O; % H2O/ha

% vii)  Misc_FT = 'Miscanthus - FT'
q_Misc_FT = 1000*yield_Misc*yield_FT; % gal SAF/ha
E_Misc_FT = 1000*(RPR*yield_Misc)*(farming_Misc_E + yield_FT*FT_E); % MJ/ha
H2O_Misc_FT = 1000*(RPR*yield_Misc)*farming_Misc_H2O; % H2O/ha

% viii) Switch_FT = 'Switchgrass - FT'
q_Switch_FT = 1000*yield_Switch*yield_FT; % gal SAF/ha
E_Switch_FT = 1000*(RPR*yield_Switch)*(farming_Switch_E + yield_FT*FT_E); % MJ/ha
H2O_Switch_FT = 1000*(RPR*yield_Switch)*farming_Switch_H2O; % H2O/ha

% xi)   CO_HEFA = 'Corn Oil - HEFA'
q_CO_HEFA = 1000*yield_Corn*yield_CO*yield_HEFA; % gal SAF/ha
E_CO_HEFA = 1000*yield_Corn*(farming_Corn_E + yield_CO*(process_CO_E + yield_HEFA*HEFA_E)); % MJ/ha
H2O_CO_HEFA = 1000*yield_Corn*(farming_Corn_H2O + yield_CO*process_CO_H2O); % H2O/ha

% ----------------------------------------------------------------------- %
% Step 3: Policy Scenarios

% a) Computing the fuel shares per conversion pathway
fuel = (10^6)*fuel_reqs*v_pathways;

% b) Aggregating the variables from the previous section
q_pathways = [q_CG_ATJ_EtOH;q_CG_ATJ_BuOH;q_CS_ATJ_EtOH;q_Misc_ATJ_EtOH;...
              q_Switch_ATJ_EtOH;q_CS_FT;q_Misc_FT;q_Switch_FT;q_CO_HEFA];
E_pathways = [E_CG_ATJ_EtOH;E_CG_ATJ_BuOH;E_CS_ATJ_EtOH;E_Misc_ATJ_EtOH;...
              E_Switch_ATJ_EtOH;E_CS_FT;E_Misc_FT;E_Switch_FT;E_CO_HEFA];
H2O_pathways = [H2O_CG_ATJ_EtOH;H2O_CG_ATJ_BuOH;H2O_CS_ATJ_EtOH;...
                H2O_Misc_ATJ_EtOH;H2O_Switch_ATJ_EtOH;H2O_CS_FT;...
                H2O_Misc_FT;H2O_Switch_FT;H2O_CO_HEFA];
feed_pathways = 1000*[yield_Corn;yield_Corn;RPR*yield_Corn;yield_Misc;...
                      yield_Switch;RPR*yield_Corn;yield_Misc;yield_Switch;...
                      yield_Corn*0.014];
feed_LHV = [16.3;16.3;16.5;17.4;17.3;16.5;17.4;17.3;37.7]; % (MJ/kg)

% c) Computing the macro variables

% i) Required Harvest Land Area Requirements (ha)
areas = fuel./q_pathways;

% ii) Required Harvested Land Area / Total State Field Crop Land Area (%)
area_per = 100*areas./land_Harvested; 

% iii) Total Feedstock (kg)
feedstock = areas.*feed_pathways; 

% iv) Required Energy (MJ)
energy = areas.*E_pathways; 

% v) Required Solar Energy Area (assuming 17% efficiency) (ha)
area_solar = energy./solar(1)./0.17; 

% vi) Solar Required / State Installed Capacity (%)
solar_per = 100*energy/solar(2);
solar_per(isnan(solar_per)) = 0;
solar_per(isinf(solar_per)) = 0;

% vii) Required Water (gal)
water = areas.*H2O_pathways; % gal of water

% viii) Required Water / State Water Usage (%)
water_per = 100*water/water_state; % gal of water
water_per(isnan(water_per)) = 0;

% xi) Energy Efficiency 1 (MJ of Energy/gal of SAF)
energy_eff = energy./fuel; 
energy_eff(isnan(energy_eff)) = 0;

% x) Energy Efficiency 2 (MJ of Energy/MJ of SAF)
energy_eff2 = energy_eff./131.45;
energy_eff2(isnan(energy_eff2)) = 0;

% xi) SAF Efficiency 1 (gal SAF/kg of feedstock)
SAF_eff = fuel./feedstock; 
SAF_eff(isnan(SAF_eff)) = 0;

% xii) SAF Efficiency 2 (MJ of SAF/MJ of feedstock)
SAF_eff2 = 131.45*SAF_eff./feed_LHV;
SAF_eff2(isnan(SAF_eff2)) = 0;
