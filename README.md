<a name="back_to_top"></a>
# Pathways Towards Future Aviation Energy Carriers, CO<sub>2</sub> Capture and Reduction, Energy Carrier Production and Scale-Up

In this repository, we provide an overview of the MATLAB script and function utilized to:
1) Compute the process energy, water, and harvested land energy requirements for each choice of feedstock and pathway.
2) Adapt the code to obtain various plots, displaying the results on a per-state basis.

The case studies described below take place in the United States, and examine the thought experiment where each state would independently seek to satisfy its SAF requirements by using only local resources (i.e., farming, energy and water sourced from the state itself). Two parallel SAF production pathways are considered in this work: 

Biological (Bio) Pathways, where the fuel is produced starting from biological carbon sources. Nine combinations of feedstock-pathways are considered, including:
1. Corn Grain Alcohol-to-Jet (ATJ) via Ethanol (EtOH) upgrading.
2. Corn Grain ATJ via Butanol (BuOH) upgrading.
3. Corn Stover ATJ via EtOH upgrading.
4.  Miscanthus ATJ via EtOH upgrading.
5.  Switchgrass ATJ via EtOH upgrading.
6.  Corn Stover Fischer-Tropsch (FT) synthesis.
7.  Miscanthus FT synthesis.
8.  Switchgrass FT synthesis.
9.  Corn Oil Hydrotreated Esters and Fatty Acids (HEFA) production.

Direct Air Capture (DAC) Pathways, where the fuel is producing using CO2 taken from the atmosphere as carbon sources. Two different integrated DAC systems are considered, including:
1. DAC + Reverse Water Gas Shift (RWGS) + FT.
2. DAC + electrolysis + FT.

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/Pathways%20Overview.png" width="500"> 

**Figure 1:** _Schematic of the two pathways, Biological and Direct Air Capture, considered in this work_.
</p>

## MATLAB Code

### Table of Contents

**Biological (Bio) Pathways:** <br />
1: [ Code Overview & Inputs: Bio Pathways ](#overview) <br />
2: [ Results: Bio Pathways ](#results) <br />
&nbsp; &nbsp; 2a: [ Inter-state Plots ](#inter-state) <br />
&nbsp; &nbsp; 2b: [ Intra-state Plots ](#intra-state) <br />
&nbsp; &nbsp; 2c: [ Airline-specific Inter-state Plots ](#airline) <br />
&nbsp; &nbsp; 2d: [ Combined Bar Plots ](#bars) <br />
&nbsp; &nbsp; 2e: [ Texas and California Plots ](#texascali)

**Direct Air Capture (DAC) Pathways:** <br />
3: [ Code Overview & Inputs: DAC Pathways ](#overview2) <br />
4: [ Results: DAC Pathways ](#results2) <br />
&nbsp; &nbsp; 4a: [ Inter-state Plots ](#inter-state2) <br />
&nbsp; &nbsp; 4b: [ Intra-state Plots ](#intra-state2) <br />
&nbsp; &nbsp; 4c: [ Airline-specific Inter-state Plots ](#airline2) <br />
&nbsp; &nbsp; 4d: [ Combined Bar Plots ](#bars2) <br />
&nbsp; &nbsp; 4e: [ Texas and California Plots ](#texascali2)

---
<a name="overview"></a>
### 1: Code Overview & Inputs: Bio Pathways

In the [MATLAB Code](https://github.com/andyeske/SAF-pathways/tree/main/MATLAB%20Code) folder of this repository, three functions pertaining to the 'Biological (Bio) Pathways' study can be found. These are ```BioPathways_func```, ```BioPathways_script```, and ```BioPathways_script_V2```. A description of each can be seen below:

```BioPathways_func```: For the specific choice of U.S. state, feedstock and conversion pathway, this function takes as inputs information pertaining to crop yields, farming energy and water requirements, intermediate process yields, process energy and water requirements, SAF pathway yield, as well as the SAF pathway energy requirements. Additionally, the function takes data pertaining the state's fuel requirements, installed solar capacity, and existing water consumption.

```BioPathways_script```: This script is the interface that the user would interact with. In essence, this script calls on the ```BioPathways_func``` function described above, and produces the plots that can be found below. 

In order to run this script, the user must download the following three datasets:
* 'Corn Specs.xlsx' (the version utilized in this work can be found on the [Data Tables](https://github.com/andyeske/SAF-pathways/tree/main/Data%20Tables) folder.
* 'Corn Data.xlsx' (the version utilized in this work can be found on the [Data Tables](https://github.com/andyeske/SAF-pathways/tree/main/Data%20Tables) folder.
* 'US Route Data 2019.xlsx' (the version utilized in this work can be found on this [online](https://mitprod-my.sharepoint.com/:f:/g/personal/andyeske_mit_edu/Ej3ZzrVDU-xLihXpZpC1rP4BTqM6xX6tsC07AbuM-7LDtw?e=sZmQcp) folder.

All the data contained in these datasets is publicly available online, and has been summarized in these tables for use in this work. Citations have been included within each dataset in case these are needed for further research purposes. 

In addition to the datasets, the user must ensure that the MATLAB script (which can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/MATLAB%20Code), function, as well as ```borderdata.mat``` and ```bordersm.m``` functions have all been downloaded, and saved in the same folder as the three datasets. Then, the user can _Run_ the script (although it can conduct some modifications, as will be shown below, to obtain different results according to its needs).

```BioPathways_script_V2```: This script is identical to the one above, only that the results are specific to California and Texas. 

([ back to top ](#back_to_top))

---
<a name="results"></a>
### 2: Results: Biological Pathways

The following section presents the results from running the ```BioPathways_script``` and ```BioPathways_script_V2``` scripts, as well as specifies areas of the script where the user can modify the code to obtain custom results. The five sub-sections below display the [inter-state](#interstate) plots, the [intra-state](#intrastate) plots, the [airline-specific](#airline) inter-state plots, the [combined bar](#bars) plots, as well as the [Texas & California](#texascali) plots.

([ back to top ](#back_to_top))

---
<a name="inter-state"></a>
#### 2a: Inter-state Plots

The first plot that running the ```BioPathways_script``` returns is the following inter-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (inter-state) fuel requirements. Here, the fuel requirements are for all flights departing the state in question, both within the state and to other states. An example plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20-%20Inter-state.png" width="500"> 

**Figure 2:** _Inter-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain inter-state map plots corresponding to other feedstock-SAF pathway combinations, the user must modify the index of the variable ```path``` (lines 228-231) within the ```BioPathways_script``` script:

  ```
  pathways = {'Corn Grain ATJ EtOH';'Corn Grain ATJ BuOH';'Corn Stover ATJ EtOH';...
      'Miscanthus ATJ EtOH';'Switchgrass ATJ EtOH';'Corn Stover FT';'Miscanthus FT';...
      'Switchgrass FT';'Corn Oil HEFA'};
  path = 1;
  ```

([ back to top ](#back_to_top))

---
<a name="intra-state"></a>
#### 2b: Intra-state Plots

The second plot that running the ```BioPathways_script``` returns is the following intra-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (intra-state) fuel requirements. Here, the fuel requirements are for all flights within the state in question. An example plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20-%20Intra-state.png" width="500"> 

**Figure 3:** _Intra-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain inter-state map plots corresponding to other feedstock-SAF pathway combinations, the user must modify the index of the variable ```path``` (lines 228-231) within the ```BioPathways_script``` script:

  ```
  pathways = {'Corn Grain ATJ EtOH';'Corn Grain ATJ BuOH';'Corn Stover ATJ EtOH';...
      'Miscanthus ATJ EtOH';'Switchgrass ATJ EtOH';'Corn Stover FT';'Miscanthus FT';...
      'Switchgrass FT';'Corn Oil HEFA'};
  path = 1;
  ```

([ back to top ](#back_to_top))

---
<a name="airline"></a>
#### 2c: Airline-specific Inter-state Plots

The third plot that running the ```BioPathways_script``` returns is the following inter-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (inter-state) fuel requirements, but specific to an airline. An example plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20-%20American.png" width="500"> 

**Figure 4:** _Airline-Specific Inter-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process and American Airlines. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain inter-state map plots corresponding to other airlines, the user must modify the index of the variable ```air``` (lines 531-535) within the ```BioPathways_script``` script:

  ```
  airlines = {'Spirit','Republic','Delta','United','Jetblue'...
            'Endeavor','Southwest','Sun Country','Alaska','Hawaiian',...
            'SkyWest','Piedmont','Envoy','PSA','Horizon',...
            'American','Allegiant','Frontier','Mesa'};
  air = 16; % American
  ```

([ back to top ](#back_to_top))

---
<a name="bars"></a>
#### 2d: Combined Bar Plots

The fourth plot that running the ```BioPathways_script``` returns is the following bar plot, comparing the cumulative (for the entire United States) land, feedstock, energy and water for each of the nine feedstock-SAF pathways combinations. The obtained summary plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/Bar%20Plots/Bars%20(Biological)%20-%20US.png" width="500"> 

**Figure 5:** _Inter-state vs Intra-state Land, Feedstock, Energy and Water Requirements, for the nine feedstock-SAF conversion pathways.
</p>

([ back to top ](#back_to_top))

---
<a name="texascali"></a>
#### 2e: Texas and California Plots

Running ```BioPathways_script_V2``` produces plots similar in nature to ```BioPathways_script```, only that these are specific to California and Texas, the two case studies of this work. Below, some sample plots are presented: 

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20(TexasCali)%20-%20Inter-state.png" width="500"> 

**Figure 6:** _Inter-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process, specific for California and Texas. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20(TexasCali)-%20Intra-state.png" width="500"> 

**Figure 7:** _Intra-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process, specific for California and Texas. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/Bar%20Plots/Bars%20(Biological)%20-%20Texas.png" width="500"> 

**Figure 8:** _Inter-state vs Intra-state Land, Feedstock, Energy and Water Requirements, for the nine feedstock-SAF conversion pathways, specific to Texas. The sample bar plot corresponding to California can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain California/Texas inter/intra-state map plots corresponding to other feedstock-SAF pathway combinations, the user must modify the index of the variable ```path``` (lines 234-237) within the ```BioPathways_script_V2``` script:

  ```
  pathways = {'Corn Grain ATJ EtOH';'Corn Grain ATJ BuOH';'Corn Stover ATJ EtOH';...
      'Miscanthus ATJ EtOH';'Switchgrass ATJ EtOH';'Corn Stover FT';'Miscanthus FT';...
      'Switchgrass FT';'Corn Oil HEFA'};
  path = 1;
  ```

**Note:** It is possible to modify the variable ```selection``` (line 18) to admit indeces corresponding to other states. By default, the indeces 5 and 43 correspond to California and Texas, respectively. 

([ back to top ](#back_to_top))

---
<a name="overview2"></a>
### 3: Code Overview & Inputs: DAC Pathways

Similarly to before, the [MATLAB Code](https://github.com/andyeske/SAF-pathways/tree/main/MATLAB%20Code) folder of this repository contains two functions related to the 'Direct Air Capture (DAC) Pathways' study. These are ```DACPathways_script```, and ```DACPathways_script_V2```. A description of each can be seen below:

```DACPathways_func```: The following script computes DAC land, as well as energy and water input requirements, to meet a state's SAF demand using pre-calculated factors of two systems: a DAC + Reverse Water Gas Shift (RWGS) + Fischer-Tropsch (FT) facility and a DAC + electrolysis + FT facility (see this work's supplementary information section for more detail). 

```DACPathways_script_V2```: This script is identical to the one above, only that the results are specific to California and Texas. 

In order to run this script, the user must download the following two datasets:
* 'Corn Data.xlsx' (the version utilized in this work can be found on the [Data Tables](https://github.com/andyeske/SAF-pathways/tree/main/Data%20Tables) folder.
* 'US Route Data 2019.xlsx' (the version utilized in this work can be found on this [online](https://mitprod-my.sharepoint.com/:f:/g/personal/andyeske_mit_edu/Ej3ZzrVDU-xLihXpZpC1rP4BTqM6xX6tsC07AbuM-7LDtw?e=sZmQcp) folder.

In addition to the datasets, the user must ensure that the MATLAB scripts (which can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/MATLAB%20Code), as well as ```borderdata.mat``` and ```bordersm.m``` functions have all been downloaded, and saved in the same folder as the two datasets. Then, the user can _Run_ the script (although it can conduct some modifications, as will be shown below, to obtain different results according to its needs).

([ back to top ](#back_to_top))

---
<a name="results2"></a>
### 4: Results: DAC Pathways

The following section presents the results from running the ```BioPathways_script``` and ```BioPathways_script_V2``` scripts, as well as specifies areas of the script where the user can modify the code to obtain custom results. The five sub-sections below display the [inter-state](#interstate) plots, the [intra-state](#intrastate) plots, the [airline-specific](#airline) inter-state plots, the [combined bar](#bars) plots, as well as the [Texas & California](#texascali) plots.

([ back to top ](#back_to_top))

---
<a name="inter-state2"></a>
#### 4a: Inter-state Plots

The first plot that running the ```BioPathways_script``` returns is the following inter-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (inter-state) fuel requirements. Here, the fuel requirements are for all flights departing the state in question, both within the state and to other states. An example plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20-%20Inter-state.png" width="500"> 

**Figure 9:** _Inter-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain inter-state map plots corresponding to other feedstock-SAF pathway combinations, the user must modify the index of the variable ```path``` (lines 228-231) within the ```BioPathways_script``` script:

  ```
  pathways = {'Corn Grain ATJ EtOH';'Corn Grain ATJ BuOH';'Corn Stover ATJ EtOH';...
      'Miscanthus ATJ EtOH';'Switchgrass ATJ EtOH';'Corn Stover FT';'Miscanthus FT';...
      'Switchgrass FT';'Corn Oil HEFA'};
  path = 1;
  ```

([ back to top ](#back_to_top))

---
<a name="intra-state2"></a>
#### 4b: Intra-state Plots

The second plot that running the ```BioPathways_script``` returns is the following intra-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (intra-state) fuel requirements. Here, the fuel requirements are for all flights within the state in question. An example plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20-%20Intra-state.png" width="500"> 

**Figure 10:** _Intra-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain inter-state map plots corresponding to other feedstock-SAF pathway combinations, the user must modify the index of the variable ```path``` (lines 228-231) within the ```BioPathways_script``` script:

  ```
  pathways = {'Corn Grain ATJ EtOH';'Corn Grain ATJ BuOH';'Corn Stover ATJ EtOH';...
      'Miscanthus ATJ EtOH';'Switchgrass ATJ EtOH';'Corn Stover FT';'Miscanthus FT';...
      'Switchgrass FT';'Corn Oil HEFA'};
  path = 1;
  ```

([ back to top ](#back_to_top))

---
<a name="airline2"></a>
#### 4c: Airline-specific Inter-state Plots

The third plot that running the ```BioPathways_script``` returns is the following inter-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (inter-state) fuel requirements, but specific to an airline. An example plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20-%20American.png" width="500"> 

**Figure 11:** _Airline-Specific Inter-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process and American Airlines. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain inter-state map plots corresponding to other airlines, the user must modify the index of the variable ```air``` (lines 531-535) within the ```BioPathways_script``` script:

  ```
  airlines = {'Spirit','Republic','Delta','United','Jetblue'...
            'Endeavor','Southwest','Sun Country','Alaska','Hawaiian',...
            'SkyWest','Piedmont','Envoy','PSA','Horizon',...
            'American','Allegiant','Frontier','Mesa'};
  air = 16; % American
  ```

([ back to top ](#back_to_top))

---
<a name="bars2"></a>
#### 4d: Combined Bar Plots

The fourth plot that running the ```BioPathways_script``` returns is the following bar plot, comparing the cumulative (for the entire United States) land, feedstock, energy and water for each of the nine feedstock-SAF pathways combinations. The obtained summary plot can be seen below:

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/Bar%20Plots/Bars%20(Biological)%20-%20US.png" width="500"> 

**Figure 12:** _Inter-state vs Intra-state Land, Feedstock, Energy and Water Requirements, for the nine feedstock-SAF conversion pathways.
</p>

([ back to top ](#back_to_top))

---
<a name="texascali2"></a>
#### 4e: Texas and California Plots

Running ```BioPathways_script_V2``` produces plots similar in nature to ```BioPathways_script```, only that these are specific to California and Texas, the two case studies of this work. Below, some sample plots are presented: 

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20(TexasCali)%20-%20Inter-state.png" width="500"> 

**Figure 13:** _Inter-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process, specific for California and Texas. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/ATJ%20Maps/ATJ%20(TexasCali)-%20Intra-state.png" width="500"> 

**Figure 14:** _Intra-state Land, Feedstock, Energy and Water Requirements, for the Corn Grain ATJ EtOH conversion process, specific for California and Texas. More sample plots can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

<p align="left">
<img src="https://github.com/andyeske/SAF-pathways/blob/main/Sample%20Plots/Bar%20Plots/Bars%20(Biological)%20-%20Texas.png" width="500"> 

**Figure 15:** _Inter-state vs Intra-state Land, Feedstock, Energy and Water Requirements, for the nine feedstock-SAF conversion pathways, specific to Texas. The sample bar plot corresponding to California can be found [here](https://github.com/andyeske/SAF-pathways/tree/main/Sample%20Plots)_.
</p>

To obtain California/Texas inter/intra-state map plots corresponding to other feedstock-SAF pathway combinations, the user must modify the index of the variable ```path``` (lines 234-237) within the ```BioPathways_script_V2``` script:

  ```
  pathways = {'Corn Grain ATJ EtOH';'Corn Grain ATJ BuOH';'Corn Stover ATJ EtOH';...
      'Miscanthus ATJ EtOH';'Switchgrass ATJ EtOH';'Corn Stover FT';'Miscanthus FT';...
      'Switchgrass FT';'Corn Oil HEFA'};
  path = 1;
  ```

**Note:** It is possible to modify the variable ```selection``` (line 18) to admit indeces corresponding to other states. By default, the indeces 5 and 43 correspond to California and Texas, respectively. 

([ back to top ](#back_to_top))


## Authors

Andy Guido Eskenazi, Bjarni Örn Kristinsson <br />
Department of Aeronautics and Astronautics <br />
Massachusetts Institute of Technology, 2024 <br />
