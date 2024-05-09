% DAC Pathways - Script
% The following script computes the energy, land and water requirements for
% the production of SAF, via Direct Air Capture (DAC), Reverse Water Gas
% Shift (RWGS)/Electrolysis, and the Fischer-Tropsch (FT) process, 
% considering 3 policy scenarios.

% ----------------------------------------------------------------------- %
% Step 1: Importing the relevant datasets
Route_Data = readtable('US Route Data 2019.xlsx');
shts = sheetnames('Corn Data.xlsx');
HarvestedLand_Data = readtable('Corn Data.xlsx','Sheet',shts(3));
solar_Data = readtable('Corn Data.xlsx','Sheet',shts(4));
water_Data = readtable('Corn Data.xlsx','Sheet',shts(5));

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
FT_E = [180.8 171.2].*3.785; % MJ/gal SAF
Thermo_E = FT_E - (DAC_E + H2_E.*yield_SAF); % MJ/gal SAF
CO2_SAF = [9.2 9.2]; % kg CO2/gal SAF
CO_SAF = CO2_SAF*(28/44); % kg CO2/gal SAF
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
S1 = zeros(50,2,6);
for path = 1:2 % Iterating through the two pathways
    % Calculating Energy, water, and land requirements
    S1(1:50,path,1) = fuel_reqs_Data(1:50,1)*(10^6)*FT_E(path); % Total Energy Required (MJ)
    S1(1:50,path,2) = fuel_reqs_Data(1:50,1)*(10^6)*w_SAF(path); % Total Water Required to produce H2 (gal H2O)
    S1(1:50,path,3) = fuel_reqs_Data(1:50,1)*(10^6)*DAC_Area(path); % DAC Area Required (ha)
    % Calculating representative percentages
    S1(1:50,path,4) =  100*S1(1:50,path,1)./solar(:,2); % Solar Required / State Installed Capacity (%)
    S1(isnan(S1(:,path,4)),path,4) = 0;
    S1(isinf(S1(:,path,4)),path,4) = 0;
    S1(1:50,path,5) =  100*S1(1:50,path,1)./electricity(:); % Solar Required / State Electricity Consumption (%)
    S1(1:50,path,6) = 100*S1(1:50,path,2)./water(:); % Required Water / State Water Usage (%)  
end

% Scenario 2: only intra-state flights (i.e., all flights taking place
% within a state).
S2 = zeros(50,2,6);
for path = 1:2 % Iterating through the two pathways
    % Calculating Energy, water, and land requirements
    S2(1:50,path,1) = fuel_reqs_Data(1:50,2)*(10^6)*FT_E(path); % Total Energy Required (MJ)
    S2(1:50,path,2) = fuel_reqs_Data(1:50,2)*(10^6)*w_SAF(path); % Total Water Required to produce H2 (gal H2O)
    S2(1:50,path,3) = fuel_reqs_Data(1:50,2)*(10^6)*DAC_Area(path); % DAC Area Required (ha)
    % Calculating representative percentages
    S2(1:50,path,4) =  100*S2(1:50,path,1)./solar(:,2); % Solar Required / State Installed Capacity (%)
    S2(isnan(S2(:,path,4)),path,4) = 0;
    S2(isinf(S2(:,path,4)),path,4) = 0;
    S2(1:50,path,5) =  100*S2(1:50,path,1)./electricity(:); % Solar Required / State Electricity Consumption (%)
    S2(1:50,path,6) = 100*S2(1:50,path,2)./water(:); % Required Water / State Water Usage (%)  
end

% Scenario 3: inter-state flights, segmented by airline (i.e., similar 
% to Scenario 1, but only considering those flights operated by a 
% specific airline).
S3 = zeros(50,19,2,6);

for path = 1:2 % Iterating through the two pathways
     for a = 1:19 % Iterating through every airline            
        % Calculating Energy, water, and land requirements
        S3(1:50,a,path,1) = fuel_reqs_Data(1:50,2+a)*(10^6)*FT_E(path); % Total Energy Required (MJ)
        S3(1:50,a,path,2) = fuel_reqs_Data(1:50,2+a)*(10^6)*w_SAF(path); % Total Water Required to produce H2 (gal H2O)
        S3(1:50,a,path,3) = fuel_reqs_Data(1:50,2+a)*(10^6)*DAC_Area(path); % DAC Area Required (ha)
        % Calculating representative percentages
        S3(1:50,a,path,4) =  100*S3(1:50,a,path,1)./solar(:,2); % Solar Required / State Installed Capacity (%)
        S3(isnan(S3(:,a,path,4)),a,path,4) = 0;
        S3(isinf(S3(:,a,path,4)),a,path,4) = 0;
        S3(1:50,a,path,5) =  100*S3(1:50,a,path,1)./electricity(:); % Solar Required / State Electricity Consumption (%)  
        S3(1:50,a,path,6) = 100*S3(1:50,a,path,2)./water(:); % Required Water / State Water Usage (%)         
     end
end

% Calculating Efficiencies
FuelUtilization = SAF_energy./(yield_SAF.*H2_energy);
ThermalEfficiencies = SAF_energy./(yield_SAF.*H2_energy + FT_E);
CO2Efficiencies = CO2_SAF;
WaterUtilization = w_SAF;

% ----------------------------------------------------------------------- %
% Step 4: Plotting the results, 
% For plotting, the user has to choose the desired conversion pathway.
pathways = {'DAC+RWGS+FT','DAC+electrolysis+FT'};
path = 2;
states{10,1} = 'Georgia.';

centers = [64.4,-152.2; % AK (1)
           33.2,-86.6; % AL  (2)
           34.6,-92.5; % AR  (3)
           34.4,-111.5; % AZ (4)       
           35.9,-119.2; % CA (5)
           39.0,-105.3; % CO  (6)
           41.6,-72.7; % CT (7) -
           38.5,-75.3; % DE (8) -
           28.4,-82.3; % FL (9)
           32.4,-83.2; % GA (10)
           20.3,-156.4; % HI (11) -
           42.1,-93.5; % IA (12)
           44.2,-114.4; % ID (13)
           39.4,-89.3; % IL (14)
           40.0,-86.3; % IN (15)
           38.5,-98.4; % KS (16)
           37.5,-85.3; % KY (17)
           31.1,-92.0; % LA (18)
           42.3,-71.8; % MA (19) -
           39.1,-76.8; % MD (20) -
           45.4,-69.2; % ME (21) -       
           44.3,-85; % MI (22)
           46.3,-94.3; % MN (23)
           38.4,-92.5; % MO (24)
           32.7,-89.7; % MS (25)
           47.1,-109.6; % MT (26)
           35.6,-79.4; % NC (27)
           47.5,-100.5; % ND (28)
           41.5,-99.8; % NE (29)
           43.7,-71.6; % NH (30) -
           40.2,-74.7; % NJ (31) -
           34.4,-106.1; % NM (32)
           39.3289,-116.6; % NV (33)
           43.0,-75.5; % NY (34)       
           40.3,-82.8; % OH (35)
           35.6,-97.5; % OK (36)
           43.9,-120.6; % OR (37)
           40.9,-77.8; % PA (38)
           41.7,-71.6; % RI (39) -
           33.9,-80.9; % SC (40)
           44.4,-100.2; % SD (41)
           35.9,-86.4; % TN (42)
           31.5,-99.3; % TX (43)
           39.3,-111.7; % UT (44)
           37.5,-78.9; % VA (45)
           44.1,-72.7; % VT (46) -
           47.4,-120.4; % WA (47)
           44.6,-90.0; % WI (48)
           39.1,-80.6; % WV (49)
           43.0,-107.6]; % WY (50)
ommit = [7,8,11,19,20,21,30,31,39,46];
ommit_states = {'CT','DE','HI','MA','MD','ME','NH','NJ','RI','VT'};

% ----------------------------------------------------------------------- %
% Inter-State flights

figure
t1 = tiledlayout(2,2);
title(t1,[char(pathways(path)),' - Inter-State Flights'])
% Map 1: Area [S1(s,path,3)]
nexttile
Max1 = max(S1(:,path,3));
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S1(k,path,3)/Max1)));
    colors = [1 1 1]*(1-map);
    bordersm(states{k,1},'facecolor',colors)
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S1(k,path,3),3,'significant'))],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S1(ommit(k),path,3),3,'significant'))],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log((S1(k,path,5))/Max2)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S1(k,path,5),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0 0.447 0.741],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S1(ommit(k),path,5),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
Max3 = max(S1([2:29,31:50],path,4));
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S1(k,path,4)/Max3)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S1(k,path,4),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.929 0.694 0.125],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S1(ommit(k),path,4),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S1(k,path,6)/Max4)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S1(k,path,6),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.85 0.325 0.098],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S1(ommit(k),path,6),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S2(k,path,3)/Max1)));
    colors = [1 1 1]*(1-map);
    bordersm(states{k,1},'facecolor',colors)
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S2(k,path,3),3,'significant'))],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S2(ommit(k),path,3),3,'significant'))],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log((S2(k,path,5))/Max2)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S2(k,path,5),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0 0.447 0.741],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S2(ommit(k),path,5),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
Max3 = max(S2([2:29,31:50],path,4));
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S2(k,path,4)/Max3)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S2(k,path,4),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.929 0.694 0.125],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S2(ommit(k),path,4),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S2(k,path,6)/Max4)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S2(k,path,6),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.85 0.325 0.098],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S2(ommit(k),path,6),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
% Inter-State flights - By Airlines
airlines = {'Spirit','Republic','Delta','United','Jetblue'...
            'Endeavor','Southwest','Sun Country','Alaska','Hawaiian',...
            'SkyWest','Piedmont','Envoy','PSA','Horizon',...
            'American','Allegiant','Frontier','Mesa'};
air = 16; % American
figure
t3 = tiledlayout(2,2);
title(t3,[char(pathways(path)),' - Inter-State Flights - ',char(airlines(air))])

% Map 1: Area [S3(s,air,path,3)]
nexttile
Max1 = max(S3(:,air,path,3));
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S3(k,air,path,3)/Max1)));
    colors = [1 1 1]*(1-map);
    bordersm(states{k,1},'facecolor',colors)
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S3(k,air,path,3),3,'significant'))],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.466 0.674 0.188],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S3(ommit(k),air,path,3),3,'significant'))],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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

% Map 2: Energy Requirements / State Electricity Consumption [S3(s,air,path,5)]
nexttile
Max2 = max(S3(:,air,path,5));
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log((S3(k,air,path,5))/Max2)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S3(k,air,path,5),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0 0.447 0.741],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S3(ommit(k),air,path,5),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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

% Map 3: Solar Required / State Installed Capacity [S3(s,air,path,4)]
nexttile
Max3 = max(S3([2:29,31:50],air,path,4));
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S3(k,air,path,4)/Max3)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S3(k,air,path,4),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.929 0.694 0.125],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S3(ommit(k),air,path,4),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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

% Map 4: Required Water / State Water Usage [S3(s,air,path,6)]
nexttile
Max4 = max(S3(:,air,path,6));
colors = zeros(50,3);
bordersm('continental us','k')
for k = 1:50
 
    map = 1/(1+abs(log(S3(k,air,path,6)/Max4)));
    colors(k,:) = [1 1 1]*(1-map) + [0 0 0]*map;
    bordersm(states{k,1},'facecolor',colors(k,:))
    if k ~= ommit
        textm(centers(k,1),centers(k,2),[num2str(round(S3(k,air,path,6),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','HorizontalAlignment','center','BackgroundColor',[0.85 0.325 0.098],'Color',[0 0 0])
    end
    
end
for k = 1:10 % For the ommited cases
    textm(44-1.1*(k-1),-64-1.1*(k-1),[ommit_states{k},': ',num2str(round(S3(ommit(k),air,path,6),3,'significant')),'%'],'FontSize',6,'FontWeight','bold','Color',[0 0 0])
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
t3.TileSpacing = 'compact';
t3.Padding = 'compact';


% ----------------------------------------------------------------------- %
% Comparing all 9 pathways, for inter-state and intra-state flights.

figure
t4 = tiledlayout(2,2);
title(t4,'Comparing Feedstock and SAF Conversion Pathways')
% Bar 1: DAC Area [S1(s,path,3)]
nexttile
B1 = [sum(S1(:,1,3)),sum(S2(:,1,3));
      sum(S1(:,2,3)),sum(S2(:,2,3))];
cat = categorical(pathways);
b1 = bar(cat,B1,'FaceColor','flat');
b1(1).CData = [0.466 0.674 0.188];
b1(2).CData = [0.466 0.674 0.188];
b1(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('DAC Area Requirements')
ylabel('DAC Area (ha)')
set(gca, 'FontSize', 12)

% Bar 2: Energy Requirements / State Electricity Consumption [S1(s,path,1)]
nexttile
B2 = [sum(S1(:,1,1)),sum(S2(:,1,1));
      sum(S1(:,2,1)),sum(S2(:,2,1))];
tot_electricity = sum(electricity);
B2 = 100*B2./tot_electricity;
cat = categorical(pathways);
b2 = bar(cat,B2,'FaceColor','flat');
b2(1).CData = [0 0.447 0.741];
b2(2).CData = [0 0.447 0.741];
b2(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Energy Requirements / State Electricity Consumption')
ylabel('Energy (%)')
set(gca, 'FontSize', 12)

% Bar 3: Solar Required / State Installed Capacity [S1(s,path,1)]
nexttile
B3 = [sum(S1(:,1,1)),sum(S2(:,1,1));
      sum(S1(:,2,1)),sum(S2(:,2,1))];
tot_solar = sum(solar(:,2));
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
title('Solar Requirements / Total U.S. Installed Capacity')
ylabel('Solar Capacity (%)')
set(gca, 'FontSize', 12)

% Bar 4: Required Water / State Water Usage [S1(s,path,2)]
nexttile
B4 = [sum(S1(:,1,2)),sum(S2(:,1,2));
      sum(S1(:,2,2)),sum(S2(:,2,2))];
tot_water = sum(water);
B4 = 100*B4./tot_water;
cat = categorical(pathways);
b4 = bar(cat,B4,'FaceColor','flat');
b4(1).CData = [0.85 0.325 0.098];
b4(2).CData = [0.85 0.325 0.098];
b4(2).FaceAlpha = 0.5;
legend('Inter-State Flights','Intra-State Flights')
title('Water Requirements / Total U.S. Water Usage')
ylabel('Water Use (%)')
set(gca, 'FontSize', 12)
t4.TileSpacing = 'compact';
t4.Padding = 'compact';

% ----------------------------------------------------------------------- %
% Step 5: Calculating efficiency metrics
LHV_H2 = 120; % MJ/kg
LHV_SAF = 131.45; % MJ/gal
LHV_CO = 10.2;

% Thermal Efficiency (eta_thermal): Qsaf*LHVsaf/(Qcrop*LHVcrop + Einput)
eta_thermal = fuel_reqs_Data(1,1)*(10^6)*LHV_SAF./S1(1,:,1); % MJ/MJ

% Fuel Utilization (Fu): Qsaf*LHVsaf/(Qcrop*LHVcrop) 
Fu = 1./((LHV_H2*[1.3 0.88] + LHV_CO.*CO_SAF)./LHV_SAF); % MJ/MJ

% Water Utilization (Wu): Qsaf/Wtotal
Wu = 1./w_SAF; % gal SAF/gal H2O

% CO2 Utilization (CO2u): Qsaf/(Qcrop*CO2crop)
CO2u = 1./CO2_SAF; % gal SAF/kg CO2