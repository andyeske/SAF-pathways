% Biological Pathways - Script (Texas and California only)
% The following script computes the energy, land and water requirements for
% the production of SAF, given a choice of feedstock and conversion
% pathway, considering 2 policy scenarios.

% ----------------------------------------------------------------------- %
% Step 1: Importing the relevant datasets
Crop_Conversion_Specs = readtable('Corn Specs.xlsx');
shts = sheetnames('Corn Data.xlsx');
Corn_Data = readtable('Corn Data.xlsx','Sheet',shts(1));
EnergyCrop_Data = readtable('Corn Data.xlsx','Sheet',shts(2));
HarvestedLand_Data = readtable('Corn Data.xlsx','Sheet',shts(3));
solar_Data = readtable('Corn Data.xlsx','Sheet',shts(4));
water_Data = readtable('Corn Data.xlsx','Sheet',shts(5));
Route_Data = readtable('US Route Data 2019.xlsx');

% Note: State 5 is California, State 43 is Texas.
selection = [5,43];

% ----------------------------------------------------------------------- %
% Step 2: Extracting data from the datasets for input into the
% "BioPathways_func" function.

% a) Yield Data (crop_Yield):
yield_Corn = zeros(50,1);
yield_Misc = zeros(50,1);
yield_Switch = zeros(50,1);
yield_Corn(:,1) = Corn_Data{1:50,14}; % t crop/ha
yield_Misc(:,1) = EnergyCrop_Data{1:50,11}; % t crop/ha
yield_Switch(:,1) = EnergyCrop_Data{1:50,12}; % t crop/ha
% Function Inputs (a):
crop_Yield = [yield_Corn,yield_Misc,yield_Switch];

% b) Farming Data:
farming_Corn_E = Crop_Conversion_Specs{9,3}; % MJ/kg crop
farming_Misc_E = Crop_Conversion_Specs{9,11}; % MJ/kg crop
farming_Switch_E = Crop_Conversion_Specs{9,7}; % MJ/kg crop
farming_Stover_E = Crop_Conversion_Specs{11,3}; % MJ/kg crop - collection
farming_Corn_H2O = Crop_Conversion_Specs{10,3}; % gal H2O/kg crop
farming_Misc_H2O = Crop_Conversion_Specs{10,11}; % gal H2O/kg crop
farming_Switch_H2O = Crop_Conversion_Specs{10,7}; % gal H2O/kg crop
farming_Stover_H2O = Crop_Conversion_Specs{12,3}; % gal H2O/kg crop - collection
RPR = Crop_Conversion_Specs{4,3};
% Function Inputs (b):
farming_E = [farming_Corn_E,farming_Misc_E,farming_Switch_E,farming_Stover_E];
farming_H2O = [farming_Corn_H2O,farming_Misc_H2O,farming_Switch_H2O,farming_Stover_H2O,RPR];

% c) Ethanol Data:
yield_EtOH = Crop_Conversion_Specs{14,3}; % gal EtOH/kg crop
process_EtOH_E = Crop_Conversion_Specs{15,3}; % MJ/gal EtOH
process_EtOH_H2O = Crop_Conversion_Specs{16,3}; % gal H2O/gal EtOH
% d) Butanol Data:
yield_BuOH = Crop_Conversion_Specs{18,3}; % gal BuOH/kg crop
process_BuOH_E = Crop_Conversion_Specs{19,3}; % MJ/gal BuOH
process_BuOH_H2O = Crop_Conversion_Specs{20,3}; % gal H2O/gal BuOH
% e) Corn Oil Data:
yield_CO = Crop_Conversion_Specs{22,3}; % gal CO/kg crop
process_CO_E = Crop_Conversion_Specs{23,3}; % MJ/gal CO
process_CO_H2O = Crop_Conversion_Specs{24,3}; % gal H2O/gal CO
% Function Inputs (c,d,e):
process_Yield =[yield_EtOH,yield_BuOH,yield_CO];
process_E =[process_EtOH_E,process_BuOH_E,process_CO_E];
process_H2O =[process_EtOH_H2O,process_BuOH_H2O,process_CO_H2O];

% f) SAF Conversion Pathways Data: 
yield_ATJ_EtOH = Crop_Conversion_Specs{26,3}; % gal SAF/gal EtOH
ATJ_EtOH_E = Crop_Conversion_Specs{27,3}; % MJ/gal SAF
yield_ATJ_BuOH = Crop_Conversion_Specs{28,3}; % gal SAF/gal BuOH
ATJ_BuOH_E = Crop_Conversion_Specs{29,3}; % MJ/gal SAF
yield_HEFA = Crop_Conversion_Specs{30,3}; % gal SAF/gal CO
HEFA_E = Crop_Conversion_Specs{31,3}; % MJ/gal SAF
yield_FT = Crop_Conversion_Specs{32,3}; % gal SAF/gal CO
FT_E = Crop_Conversion_Specs{33,3}; % MJ/gal SAF
% Function Inputs (f):
SAF_Yield = [yield_ATJ_EtOH,yield_ATJ_BuOH,yield_FT,yield_HEFA];
SAF_E = [ATJ_EtOH_E,ATJ_BuOH_E,FT_E,HEFA_E];

% g) CO2 Usage Data (kg feedstock/kg CO2 absorbed):
CO2_Corn = 1/Crop_Conversion_Specs{2,3};
CO2_Misc = 1/Crop_Conversion_Specs{2,11};
CO2_Switch = 1/Crop_Conversion_Specs{2,7};
% Function Inputs (g):
crop_CO2 = [CO2_Corn,CO2_Misc,CO2_Switch];

% h) Harvested Land Data (ha):
land_Harvested = zeros(50,1);
land_Harvested(:,1) = HarvestedLand_Data{3:52,10};
states = HarvestedLand_Data{3:52,8};

% i) Solar Data:
solar = zeros(50,2);
solar(:,1) = solar_Data{1:50,3}; % Irradiance: MJ/ha/year
solar(:,2) = solar_Data{1:50,6}; % Generation: MJ/year

% j) Water Data (gal/year):
water = zeros(50,1);
water(:,1) = water_Data{1:50,3};

% k) Route Data (gal):
fuel_reqs_Data = zeros(50,21);
fuel_reqs_Data(:,1) = Route_Data{2:51,8};
fuel_reqs_Data(:,2) = Route_Data{2:51,11};
fuel_reqs_Data(:,3:21) = Route_Data{2:51,17:35};

% Additional data: SAF gal to SAF MJ
% SAF outputs from each process

% ----------------------------------------------------------------------- %
% Step 3: Calling "BioPathways_func" to run two policy scenarios: 
% Given the 9 pathways, what are the land, water and energy requirements to
% satisfy the demand for SAF per state, considering:

% Scenario 1: inter-state flights (i.e., all flights departing a given
% state, within the state and to other states).
S1 = zeros(2,9,8);
effs = zeros(9,4);

for q = 1:2 % Iterating through every state
    s = selection(q);
    for path = 1:9 % Iterating through every pathway
        % path = 1: CG_ATJ_EtOH, 2: CG_ATJ_BuOH, 3: CS_ATJ_EtOH, 
        % 4: Misc_ATJ_EtOH, 5: Switch_ATJ_EtOH, 6: CS_FT, 7: Misc_FT, 
        % 8: Switch_FT, 9: CO_HEFA]
        v_pathways = zeros(9,1);
        v_pathways(path) = 1;

        % Calling the "BioPathways_func" function   
        [areas,area_per,feedstock,energy,area_solar,solar_per,water_req,...
         water_per,~,~,~,~] =...
         BioPathways_func(crop_Yield(s,:),farming_E,farming_H2O,...
         process_Yield,process_E,process_H2O,SAF_Yield,SAF_E,crop_CO2,...
         land_Harvested(s),fuel_reqs_Data(s,1),solar(s,:),water(s),v_pathways);

        % Populating the S1 matrix
        S1(q,path,1) = areas(areas>0); % Required Harvest Land Area Requirements (ha)
        S1(q,path,2) = area_per(area_per>0); % Required Harvested Land Area / Total State Field Crop Land Area (%)
        S1(q,path,3) = feedstock(feedstock>0); % Total Feedstock (kg)
        S1(q,path,4) = energy(energy>0); % Required Energy (MJ)
        S1(q,path,5) = area_solar(area_solar>0); % Required Solar Energy Area (assuming 10% efficiency) (ha)
        if solar_per == 0
            S1(q,path,6) = 0;
        else
            S1(q,path,6) = solar_per(solar_per>0); % Solar Required / State Installed Capacity (%)
        end
        S1(q,path,7) = water_req(water_req>0); % Required Water (gal)
        S1(q,path,8) = water_per(water_per>0); % Required Water / State Water Usage (%)
    end
    
end

% Scenario 2: only intra-state flights (i.e., all flights taking place
% within a state).
S2 = zeros(2,9,8);

for q = 1:2 % Iterating through every state
    s = selection(q);
    for path = 1:9 % Iterating through every pathway
        % path = 1: CG_ATJ_EtOH, 2: CG_ATJ_BuOH, 3: CS_ATJ_EtOH, 
        % 4: Misc_ATJ_EtOH, 5: Switch_ATJ_EtOH, 6: CS_FT, 7: Misc_FT, 
        % 8: Switch_FT, 9: CO_HEFA]
        v_pathways = zeros(9,1);
        v_pathways(path) = 1;
        if fuel_reqs_Data(s,2) ~= 0 % Ommiting those cases where there is no fuel consumption
            % Calling the "BioPathways_func" function    
            [areas,area_per,feedstock,energy,area_solar,solar_per,water_req,water_per,~,~,~,~] =...
             BioPathways_func(crop_Yield(s,:),farming_E,farming_H2O,...
             process_Yield,process_E,process_H2O,SAF_Yield,SAF_E,...
             crop_CO2,land_Harvested(s),fuel_reqs_Data(s,2),solar(s,:),water(s),v_pathways);
    
            % Populating the S2 matrix
            S2(q,path,1) = areas(areas>0); % Required Harvest Land Area Requirements (ha)
            S2(q,path,2) = area_per(area_per>0); % Required Harvested Land Area / Total State Field Crop Land Area (%)
            S2(q,path,3) = feedstock(feedstock>0); % Total Feedstock (kg)
            S2(q,path,4) = energy(energy>0); % Required Energy (MJ)
            S2(q,path,5) = area_solar(area_solar>0); % Required Solar Energy Area (assuming 10% efficiency) (ha)
            if solar_per == 0
                S2(q,path,6) = 0;
            else
                S2(q,path,6) = solar_per(solar_per>0); % Solar Required / State Installed Capacity (%)
            end
            S2(q,path,7) = water_req(water_req>0); % Required Water (gal)
            S2(q,path,8) = water_per(water_per>0); % Required Water / State Water Usage (%)
        end
    end
end

% ----------------------------------------------------------------------- %
% Step 4: Plotting the results, 
% For plotting, the user has to choose the desired conversion pathway.
pathways = {'Corn Grain ATJ EtOH';'Corn Grain ATJ BuOH';'Corn Stover ATJ EtOH';...
    'Miscanthus ATJ EtOH';'Switchgrass ATJ EtOH';'Corn Stover FT';'Miscanthus FT';...
    'Switchgrass FT';'Corn Oil HEFA'};
path = 6; % Corn Grain ATJ EtOH
states{10,1} = 'Georgia.';

centers = [35.9,-119.2; % CA (5)
           31.5,-99.3]; % TX (43)

% ----------------------------------------------------------------------- %
% Inter-State flights
figure
t1 = tiledlayout(2,2);
title(t1,[char(pathways(path)),' - Inter-State Flights'])
% Map 1: Area Percentage [S1(s,path,2)]
nexttile
Max1 = max(S1(:,path,2));
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S1(in,path,2)/Max1;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,2),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
title('Harvested Area Requirements / Total Field Crop Land')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Harvested Area (%)','Rotation',270)
caxis([0, Max1]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off

% Map 2: Total Feedstock [S1(s,path,3)]
nexttile
Max2 = max(S1(:,path,3))/10^9;
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = (S1(in,path,3)/10^9)/Max2;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,3)/10^9,3,'significant'))],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0 0.447 0.741],'Color',[0 0 0])
    end
    
end
title('Total Feedstock Requirements')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Feedstock (Mt)','Rotation',270)
caxis([0, Max2]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off

% Map 3: Solar Required / State Installed Capacity [S1(s,path,6)]
nexttile
Max3 = max(S1(:,path,6));
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S1(in,path,6)/Max3;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,6),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.929 0.694 0.125],'Color',[0 0 0])
    end
    
end
title('Solar Requirements / State Installed Capacity')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Solar Capacity (%)','Rotation',270)
caxis([0, Max3]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off

% Map 4: Required Water / State Water Usage [S1(s,path,8)]
nexttile
Max4 = max(S1(:,path,8));
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S1(in,path,8)/Max4;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,8),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.85 0.325 0.098],'Color',[0 0 0])
    end
    
end
title('Water Requirements / State Water Usage')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Water Use (%)','Rotation',270)
caxis([0, Max4]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off
t1.TileSpacing = 'compact';
t1.Padding = 'compact';

% ----------------------------------------------------------------------- %
% Intra-State flights
figure
t2 = tiledlayout(2,2);
title(t2,[char(pathways(path)),' - Intra-State Flights'])
% Map 1: Area Percentage [S2(s,path,2)]
nexttile
Max1 = max(S2(:,path,2));
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S2(in,path,2)/Max1;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,2),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
title('Harvested Area Requirements / Total Field Crop Land')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Harvested Area (%)','Rotation',270)
caxis([0, Max1]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off

% Map 2: Total Feedstock [S2(s,path,3)]
nexttile
Max2 = max(S2(:,path,3))/10^9;
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = (S2(in,path,3)/10^9)/Max2;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,3)/10^9,3,'significant'))],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0 0.447 0.741],'Color',[0 0 0])
    end
    
end
title('Total Feedstock Requirements')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Feedstock (Mt)','Rotation',270)
caxis([0, Max2]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off

% Map 3: Solar Required / State Installed Capacity [S2(s,path,6)]
nexttile
Max3 = max(S2(:,path,6));
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S2(in,path,6)/Max3;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,6),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.929 0.694 0.125],'Color',[0 0 0])
    end
    
end
title('Solar Requirements / State Installed Capacity')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Solar Capacity (%)','Rotation',270)
caxis([0, Max3]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off

% Bar 4: Required Water / State Water Usage [S2(s,path,8)]
nexttile
Max4 = max(S2(:,path,8));
colors = zeros(50,3);
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S2(in,path,8)/Max4;
        colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
        bordersm(states{k,1},'facecolor',colors(k,:))
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,8),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.85 0.325 0.098],'Color',[0 0 0])
    end
    
end
title('Water Requirements / State Water Usage')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Water Use (%)','Rotation',270)
caxis([0, Max4]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off
t2.TileSpacing = 'compact';
t2.Padding = 'compact';

% ----------------------------------------------------------------------- %
% Comparing all 9 pathways, for inter-state and intra-state flights.

% California Plot
figure
t4 = tiledlayout(2,2);
title(t4,'Comparing Feedstock and SAF Conversion Pathways - California')
% Bar 1: Area Percentage 
nexttile
B1 = [S1(1,1,1),S1(1,2,1),S1(1,3,1),S1(1,4,1),S1(1,5,1),S1(1,6,1),S1(1,7,1),S1(1,8,1),S1(1,9,1);
      S2(1,1,1),S2(1,2,1),S2(1,3,1),S2(1,4,1),S2(1,5,1),S2(1,6,1),S2(1,7,1),S2(1,8,1),S2(1,9,1)];
tot_area = land_Harvested(5);
B1 = 100*B1./tot_area;
cat = categorical(pathways);
b1 = bar(cat,B1,'FaceColor','flat');
b1(1).CData = [0.466 0.674 0.188];
b1(2).CData = [0.466 0.674 0.188];
b1(2).FaceAlpha = 0.5;
hold on
yl = yline(100,'k--','100%','LineWidth',1,'FontSize',12);
yl.LabelHorizontalAlignment = 'center';
legend('Inter-State Flights','Intra-State Flights')
title('Harvested Area Requirements / California Field Crop Land')
ylabel('Harvested Area (%)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)

% Bar 2: Total Feedstock 
nexttile
B2 = [S1(1,1,3),S1(1,2,3),S1(1,3,3),S1(1,4,3),S1(1,5,3),S1(1,6,3),S1(1,7,3),S1(1,8,3),S1(1,9,3);
      S2(1,1,3),S2(1,2,3),S2(1,3,3),S2(1,4,3),S2(1,5,3),S2(1,6,3),S2(1,7,3),S2(1,8,3),S2(1,9,3)];
cat = categorical(pathways);
b2 = bar(cat,B2/10^9,'FaceColor','flat');
b2(1).CData = [0 0.447 0.741];
b2(2).CData = [0 0.447 0.741];
b2(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Total Feedstock Requirements')
ylabel('Feedstock (Mt)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)

% Bar 3: Solar Required / State Installed Capacity
nexttile
B3 = [S1(1,1,4),S1(1,2,4),S1(1,3,4),S1(1,4,4),S1(1,5,4),S1(1,6,4),S1(1,7,4),S1(1,8,4),S1(1,9,4);
      S2(1,1,4),S2(1,2,4),S2(1,3,4),S2(1,4,4),S2(1,5,4),S2(1,6,4),S2(1,7,4),S2(1,8,4),S2(1,9,4)];
tot_solar = solar(5,2);
B3 = 100*B3./tot_solar;
cat = categorical(pathways);
b3 = bar(cat,B3,'FaceColor','flat');
b3(1).CData = [0.929 0.694 0.125];
b3(2).CData = [0.929 0.694 0.125];
b3(2).FaceAlpha = 0.5;
hold on
yl = yline(100,'k--','100%','LineWidth',1,'FontSize',12);
yl.LabelHorizontalAlignment = 'center';
legend('Inter-State Flights','Intra-State Flights')
title('Solar Requirements / California Installed Capacity')
ylabel('Solar Capacity (%)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)

% Map 4: Required Water / State Water Usage [S2(s,path,8)]
nexttile
B4 = [S1(1,1,7),S1(1,2,7),S1(1,3,7),S1(1,4,7),S1(1,5,7),S1(1,6,7),S1(1,7,7),S1(1,8,7),S1(1,9,7);
      S2(1,1,7),S2(1,2,7),S2(1,3,7),S2(1,4,7),S2(1,5,7),S2(1,6,7),S2(1,7,7),S2(1,8,7),S2(1,9,7)];
tot_water = water(5);
B4 = 100*B4./tot_water;
cat = categorical(pathways);
b4 = bar(cat,B4,'FaceColor','flat');
b4(1).CData = [0.85 0.325 0.098];
b4(2).CData = [0.85 0.325 0.098];
b4(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Water Requirements / California Water Usage')
ylabel('Water Use (%)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)
t4.TileSpacing = 'compact';
t4.Padding = 'compact';

% Texas Plot
figure
t4 = tiledlayout(2,2);
title(t4,'Comparing Feedstock and SAF Conversion Pathways - Texas')
% Bar 1: Area Percentage 
nexttile
B1 = [S1(2,1,1),S1(2,2,1),S1(2,3,1),S1(2,4,1),S1(2,5,1),S1(2,6,1),S1(2,7,1),S1(2,8,1),S1(2,9,1);
      S2(2,1,1),S2(2,2,1),S2(2,3,1),S2(2,4,1),S2(2,5,1),S2(2,6,1),S2(2,7,1),S2(2,8,1),S2(2,9,1)];
tot_area = land_Harvested(43);
B1 = 100*B1./tot_area;
cat = categorical(pathways);
b1 = bar(cat,B1,'FaceColor','flat');
b1(1).CData = [0.466 0.674 0.188];
b1(2).CData = [0.466 0.674 0.188];
b1(2).FaceAlpha = 0.5;
hold on
yl = yline(100,'k--','100%','LineWidth',1,'FontSize',12);
yl.LabelHorizontalAlignment = 'center';
legend('Inter-State Flights','Intra-State Flights')
title('Harvested Area Requirements / Texas Field Crop Land')
ylabel('Harvested Area (%)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)

% Bar 2: Total Feedstock 
nexttile
B2 = [S1(2,1,3),S1(2,2,3),S1(2,3,3),S1(2,4,3),S1(2,5,3),S1(2,6,3),S1(2,7,3),S1(2,8,3),S1(2,9,3);
      S2(2,1,3),S2(2,2,3),S2(2,3,3),S2(2,4,3),S2(2,5,3),S2(2,6,3),S2(2,7,3),S2(2,8,3),S2(2,9,3)];
cat = categorical(pathways);
b2 = bar(cat,B2/10^9,'FaceColor','flat');
b2(1).CData = [0 0.447 0.741];
b2(2).CData = [0 0.447 0.741];
b2(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Total Feedstock Requirements')
ylabel('Feedstock (Mt)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)

% Bar 3: Solar Required / State Installed Capacity
nexttile
B3 = [S1(2,1,4),S1(2,2,4),S1(2,3,4),S1(2,4,4),S1(2,5,4),S1(2,6,4),S1(2,7,4),S1(2,8,4),S1(2,9,4);
      S2(2,1,4),S2(2,2,4),S2(2,3,4),S2(2,4,4),S2(2,5,4),S2(2,6,4),S2(2,7,4),S2(2,8,4),S2(2,9,4)];
tot_solar = solar(43,2);
B3 = 100*B3./tot_solar;
cat = categorical(pathways);
b3 = bar(cat,B3,'FaceColor','flat');
b3(1).CData = [0.929 0.694 0.125];
b3(2).CData = [0.929 0.694 0.125];
b3(2).FaceAlpha = 0.5;
hold on
yl = yline(100,'k--','100%','LineWidth',1,'FontSize',12);
yl.LabelHorizontalAlignment = 'center';
legend('Inter-State Flights','Intra-State Flights')
title('Solar Requirements / Texas Installed Capacity')
ylabel('Solar Capacity (%)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)

% Bar 4: Required Water / State Water Usage [S2(s,path,8)]
nexttile
B4 = [S1(2,1,7),S1(2,2,7),S1(2,3,7),S1(2,4,7),S1(2,5,7),S1(2,6,7),S1(2,7,7),S1(2,8,7),S1(2,9,7);
      S2(2,1,7),S2(2,2,7),S2(2,3,7),S2(2,4,7),S2(2,5,7),S2(2,6,7),S2(2,7,7),S2(2,8,7),S2(2,9,7)];
tot_water = water(43);
B4 = 100*B4./tot_water;
cat = categorical(pathways);
b4 = bar(cat,B4,'FaceColor','flat');
xlim=get(gca,'xlim');
b4(1).CData = [0.85 0.325 0.098];
b4(2).CData = [0.85 0.325 0.098];
b4(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Water Requirements / Texas Water Usage')
ylabel('Water Use (%)')
%set(gca, 'YScale', 'log')
set(gca, 'FontSize', 12)
t4.TileSpacing = 'compact';
t4.Padding = 'compact';
