% DAC Pathways - Script (Texas and California only)
% The following script computes the energy, land and water requirements for
% the production of SAF, via Direct Air Capture (DAC), Reverse Water Gas
% Shift (RWGS)/Electrolysis, and the Fischer-Tropsch (FT) process, 
% considering 2 policy scenarios.

% ----------------------------------------------------------------------- %
% Step 1: Importing the relevant datasets
Route_Data = readtable('US Route Data 2019.xlsx');
shts = sheetnames('Corn Data.xlsx');
HarvestedLand_Data = readtable('Corn Data.xlsx','Sheet',shts(3));
solar_Data = readtable('Corn Data.xlsx','Sheet',shts(4));
water_Data = readtable('Corn Data.xlsx','Sheet',shts(5));

% Note: State 5 is California, State 43 is Texas.
selection = [5,43];

% ----------------------------------------------------------------------- %
% Step 2: Extracting data from the datasets for input into the
% "DACPathways_func" function. Here, all variables will have two entries,
% which correspond to the requirements for the DAC+RWGS+FT or 
% DAC+electrolysis+FT pathways. 

% i) Main Variables (see SI for more details):
w_SAF = [11.6 7.86]./3.785; % gal H2O/gal SAF
DAC_E = [0.048 0.048]; % MJ/gal SAF
H2_E = [191 191]; % MJ/kg H2
yield_SAF = [1.3 0.88]; %kg H2/gal SAF
FT_E = [171.2 180.8].*3.785; % MJ/gal SAF
Thermo_E = FT_E - (DAC_E + H2_E.*yield_SAF); % MJ/gal SAF
CO2_SAF = [9.2 9.2]; % kg CO2/gal SAF
DAC_Area = [0.0018 0.0018]*10^-4; % ha/gal SAF/year
SAF_energy = 131.45; % MJ/gal
H2_energy = 120; % MJ/kg;

% ii) Solar Data:
solar = zeros(50,2);
solar(:,1) = solar_Data{1:50,3}; % Irradiance: MJ/ha/year
solar(:,2) = solar_Data{1:50,6}; % Generation: MJ/year

% iii) Electricity Data:
electricity = zeros(50,1);
electricity(:,1) = solar_Data{1:50,9}; % Irradiance: MJ/ha/year

% iv) Water Data (gal/year):
water = zeros(50,1);
water(:,1) = water_Data{1:50,3};

% v) Route Data (gal):
fuel_reqs_Data = zeros(50,21);
fuel_reqs_Data(:,1) = Route_Data{2:51,8};
fuel_reqs_Data(:,2) = Route_Data{2:51,11};
fuel_reqs_Data(:,3:21) = Route_Data{2:51,17:35};

% vi) States:
states = HarvestedLand_Data{3:52,8};

% ----------------------------------------------------------------------- %
% Step 3: Calculating the results for the three policy scenarios: 
% Given the 2 pathways (DAC+RWGS+FT, and DAC+electrolysis+FT), what are the 
% land, water and energy requirements to satisfy the demand for SAF per 
% state, considering:

% Scenario 1: inter-state flights (i.e., all flights departing a given
% state, within the state and to other states).
S1 = zeros(2,2,6);
for path = 1:2 % Iterating through the two pathways
    % Calculating Energy, water, and land requirements
    S1(1:2,path,1) = fuel_reqs_Data(selection,1)*(10^6)*FT_E(path); % Total Energy Required (MJ)
    S1(1:2,path,2) = fuel_reqs_Data(selection,1)*(10^6)*w_SAF(path); % Total Water Required to produce H2 (gal H2O)
    S1(1:2,path,3) = fuel_reqs_Data(selection,1)*(10^6)*DAC_Area(path); % DAC Area Required (ha)
    % Calculating representative percentages
    S1(1:2,path,4) =  100*S1(1:2,path,1)./solar(selection,2); % Solar Required / State Installed Capacity (%)
    S1(isnan(S1(:,path,4)),path,4) = 0;
    S1(isinf(S1(:,path,4)),path,4) = 0;
    S1(1:2,path,5) =  100*S1(1:2,path,1)./electricity(selection); % Solar Required / State Electricity Consumption (%)
    S1(1:2,path,6) = 100*S1(1:2,path,2)./water(selection); % Required Water / State Water Usage (%)  
end

% Scenario 2: only intra-state flights (i.e., all flights taking place
% within a state).
S2 = zeros(2,2,6);
for path = 1:2 % Iterating through the two pathways
    % Calculating Energy, water, and land requirements
    S2(1:2,path,1) = fuel_reqs_Data(selection,2)*(10^6)*FT_E(path); % Total Energy Required (MJ)
    S2(1:2,path,2) = fuel_reqs_Data(selection,2)*(10^6)*w_SAF(path); % Total Water Required to produce H2 (gal H2O)
    S2(1:2,path,3) = fuel_reqs_Data(selection,2)*(10^6)*DAC_Area(path); % DAC Area Required (ha)
    % Calculating representative percentages
    S2(1:2,path,4) =  100*S2(1:2,path,1)./solar(selection,2); % Solar Required / State Installed Capacity (%)
    S2(isnan(S2(:,path,4)),path,4) = 0;
    S2(isinf(S2(:,path,4)),path,4) = 0;
    S2(1:2,path,5) =  100*S2(1:2,path,1)./electricity(selection); % Solar Required / State Electricity Consumption (%)
    S2(1:2,path,6) = 100*S2(1:2,path,2)./water(selection); % Required Water / State Water Usage (%)  
end

% ----------------------------------------------------------------------- %
% Step 3: Plotting the results, 
% For plotting, the user has to choose the desired conversion pathway.
pathways = {'DAC+RWGS+FT','DAC+electrolysis+FT'};
path = 2;
states{10,1} = 'Georgia.';

centers = [35.9,-119.2; % CA (5)
           31.5,-99.3]; % TX (43)

% ----------------------------------------------------------------------- %
% Inter-State flights

figure
t1 = tiledlayout(2,2);
title(t1,[char(pathways(path)),' - Inter-State Flights'])
% Map 1: Area [S1(s,path,3)]
nexttile
Max1 = max(S1(:,path,3));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S1(in,path,3)/Max1;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,3),3,'significant'))],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
title('DAC Area Requirements')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'DAC Area (ha)','Rotation',270)
caxis([0, Max1]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off


% Map 2: Energy Requirements / State Electricity Consumption [S1(s,path,5)]
nexttile
Max2 = max(S1(:,path,5));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S1(in,path,5)/Max2;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,5),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
title('Energy Requirements / State Electricity Consumption')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Energy (%)','Rotation',270)
caxis([0, Max2]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off 

% Map 3: Solar Required / State Installed Capacity [S1(s,path,4)]
nexttile
Max3 = max(S1(:,path,4));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S1(in,path,4)/Max3;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,4),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
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

% Map 4: Required Water / State Water Usage [S1(s,path,6)]
nexttile
Max4 = max(S1(:,path,6));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S1(in,path,6)/Max4;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S1(in,path,6),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
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
% Map 1: Area [S2(s,path,3)]
nexttile
Max1 = max(S2(:,path,3));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S2(in,path,3)/Max1;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,3),3,'significant'))],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
title('DAC Area Requirements')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'DAC Area (ha)','Rotation',270)
caxis([0, Max1]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off

% Map 2: Energy Requirements / State Electricity Consumption [S2(s,path,5)]
nexttile
Max2 = max(S2(:,path,5));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S2(in,path,5)/Max2;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,5),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
title('Energy Requirements / State Electricity Consumption')
colormap(flipud(gray))
c = colorbar;
ylabel(c,'Energy (%)','Rotation',270)
caxis([0, Max2]);
set(gca,'FontSize',12)
axesm ('behrmann', 'Frame', 'on', 'Grid', 'on');
mlabel off
plabel off 

% Map 3: Solar Required / State Installed Capacity [S2(s,path,4)]
nexttile
Max3 = max(S2(:,path,4));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S2(in,path,4)/Max3;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,4),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
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

% Map 4: Required Water / State Water Usage [S2(s,path,6)]
nexttile
Max4 = max(S2(:,path,6));
latlim = [25 50];
lonlim = [-125 -92];
worldmap(latlim,lonlim)
bordersm('United States','k')
for k = 1:50
    
    if sum(k == selection) == 1
        in = find(k == selection);
        map = S2(in,path,6)/Max4;
        colors = [1 1 1]*(1-map);
        bordersm(states{k,1},'facecolor',colors)
        textm(centers(in,1),centers(in,2),[num2str(round(S2(in,path,6),3,'significant')),'%'],'FontSize',10,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
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
% Bar 1: DAC Area [S1(s,path,3)]
nexttile
B1 = [sum(S1(1,1,3)),sum(S2(1,1,3));
      sum(S1(1,2,3)),sum(S2(1,2,3))];
cat = categorical(pathways);
b1 = bar(cat,B1,'FaceColor','flat');
b1(1).CData = [0.466 0.674 0.188];
b1(2).CData = [0.466 0.674 0.188];
b1(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('California DAC Area Requirements')
ylabel('DAC Area (ha)')
set(gca, 'FontSize', 12)
 
% Bar 2: Energy Requirements / State Electricity Consumption [S1(s,path,5)]
nexttile
B2 = [sum(S1(1,1,5)),sum(S2(1,1,5));
      sum(S1(1,2,5)),sum(S2(1,2,5))];
cat = categorical(pathways);
b2 = bar(cat,B2,'FaceColor','flat');
b2(1).CData = [0 0.447 0.741];
b2(2).CData = [0 0.447 0.741];
b2(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Energy Requirements / California Electricity Consumption')
ylabel('Energy (%)')
set(gca, 'FontSize', 12)

% Bar 3: Solar Required / State Installed Capacity [S1(s,path,4)]
nexttile
B3 = [sum(S1(1,1,4)),sum(S2(1,1,4));
      sum(S1(1,2,4)),sum(S2(1,2,4))];
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
set(gca, 'FontSize', 12)

% Map 4: Required Water / State Water Usage [S1(s,path,6)]
nexttile
B4 = [sum(S1(1,1,6)),sum(S2(1,1,6));
      sum(S1(1,2,6)),sum(S2(1,2,6))];
cat = categorical(pathways);
b4 = bar(cat,B4,'FaceColor','flat');
b4(1).CData = [0.85 0.325 0.098];
b4(2).CData = [0.85 0.325 0.098];
b4(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Water Requirements / California Water Usage')
ylabel('Water Use (%)')
set(gca, 'FontSize', 12)
t4.TileSpacing = 'compact';
t4.Padding = 'compact';


% Texas Plot
figure
t4 = tiledlayout(2,2);
title(t4,'Comparing Feedstock and SAF Conversion Pathways - Texas')
% Bar 1: DAC Area [S1(s,path,3)]
nexttile
B1 = [sum(S1(2,1,3)),sum(S2(2,1,3));
      sum(S1(2,2,3)),sum(S2(2,2,3))];
cat = categorical(pathways);
b1 = bar(cat,B1,'FaceColor','flat');
b1(1).CData = [0.466 0.674 0.188];
b1(2).CData = [0.466 0.674 0.188];
b1(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Texas DAC Area Requirements')
ylabel('DAC Area (ha)')
set(gca, 'FontSize', 12)
 
% Bar 2: Energy Requirements / State Electricity Consumption [S1(s,path,5)]
nexttile
B2 = [sum(S1(2,1,5)),sum(S2(2,1,5));
      sum(S1(2,2,5)),sum(S2(2,2,5))];
cat = categorical(pathways);
b2 = bar(cat,B2,'FaceColor','flat');
b2(1).CData = [0 0.447 0.741];
b2(2).CData = [0 0.447 0.741];
b2(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Energy Requirements / Texas Electricity Consumption')
ylabel('Energy (%)')
set(gca, 'FontSize', 12)

% Bar 3: Solar Required / State Installed Capacity [S1(s,path,4)]
nexttile
B3 = [sum(S1(2,1,4)),sum(S2(2,1,4));
      sum(S1(2,2,4)),sum(S2(2,2,4))];
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
set(gca, 'FontSize', 12)

% Map 4: Required Water / State Water Usage [S1(s,path,6)]
nexttile
B4 = [sum(S1(2,1,6)),sum(S2(2,1,6));
      sum(S1(2,2,6)),sum(S2(2,2,6))];
cat = categorical(pathways);
b4 = bar(cat,B4,'FaceColor','flat');
b4(1).CData = [0.85 0.325 0.098];
b4(2).CData = [0.85 0.325 0.098];
b4(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Water Requirements / Texas Water Usage')
ylabel('Water Use (%)')
set(gca, 'FontSize', 12)
t4.TileSpacing = 'compact';
t4.Padding = 'compact';