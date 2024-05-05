<a name="back_to_top"></a>
# Pathways Towards Future Aviation Energy Carriers, CO<sub>2</sub> Capture and Reduction, Energy Carrier Production and Scale-Up

In this repository, we provide an overview of the MATLAB script and function utilized to:
1) Compute the process energy, water, and harvested land energy requirements for each choice of feedstock and pathway.
2) Adapt the code to obtain various plots, displaying the results on a per-state basis.

The case studies described below take place in the United States, and examine the thought experiment where each state would independently seek to satisfy its SAF requirements by using only local resources (i.e., farming, energy and water sourced from the state itself).

## MATLAB Code

### Table of Contents

**Biological Pathways:** <br />
1: [ Code Overview & Inputs ](#overview) <br />
2: [ Results: Biological Pathways ](#results) <br />
&nbsp; &nbsp; 2a: [ Inter-state Plots ](#inter-state) <br />
&nbsp; &nbsp; 2b: [ Intra-state Plots ](#intra-state) <br />
&nbsp; &nbsp; 2c: [ Airline-specific Inter-state Plots ](#airline) <br />
&nbsp; &nbsp; 2d: [ Combined Bar Plots ](#bars) <br />
&nbsp; &nbsp; 2e: [ Texas and California Plots ](#texascali)

**Direct Air Capture (to be added):** <br />
3: [ Code Overview & Inputs ](#overview2) <br />
4: [ Results: Direct Air Capture ](#results2) <br />
&nbsp; &nbsp; 4a: [ Inter-state Plots ](#inter-state2) <br />
&nbsp; &nbsp; 4b: [ Intra-state Plots ](#intra-state2) <br />
&nbsp; &nbsp; 4c: [ Texas and California Plots ](#texascali2)

---
<a name="overview"></a>
### 1: Code Overview & Inputs

In the [MATLAB Code](https://github.com/andyeske/SAF-pathways/tree/main/MATLAB%20Code) folder of this repository, three functions pertaining to the 'Biological Pathways' study can be found. These are ```BioPathways_func```, ```BioPathways_script```, and ```BioPathways_script_V2```. A description of each can be seen below:

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

The following section presents the results from running the ```BioPathways_script``` and ```BioPathways_script_V2``` scripts, as well as specifies areas of the script where the user can modify the code to obtain custom results. The five sub-sections below display the [ inter-state ](#interstate) plots, the [ intra-state ](#intrastate)  plots, the [ airline-specific ](#airline) inter-state plots, the [ combined bar ](#bars) plots, as well as the [ Texas & California ](#texascali)  plots.

([ back to top ](#back_to_top))

---
<a name="inter-state"></a>
#### 2a: Inter-state Plots

The first plot that running the ```BioPathways_script``` returns is the following inter-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (inter-state) fuel requirements. Here, the fuel requirements are for all flights departing the state in question, both within the state and to other states.

([ back to top ](#back_to_top))

---
<a name="intra-state"></a>
#### 2b: Intra-state Plots

The second plot that running the ```BioPathways_script``` returns is the following intra-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (intra-state) fuel requirements. Here, the fuel requirements are for all flights within the state in question.

([ back to top ](#back_to_top))

---
<a name="airline"></a>
#### 2c: Airline-specific Inter-state Plots

The third plot that running the ```BioPathways_script``` returns is the following inter-state map plot, displaying land, feedstock, energy and water requirements for each state to satisfy their (inter-state) fuel requirements, but specific to an airline. 

([ back to top ](#back_to_top))

---
<a name="bars"></a>
#### 2d: Combined Bar Plots

The fourth plot that running the ```BioPathways_script``` returns is the following bar plot, comparing the cumulative (for the entire United States) land, feedstock, energy and water for each of the nine feedstock-SAF pathways combinations.

([ back to top ](#back_to_top))

---
<a name="texascali"></a>
#### 2e: Texas and California Plots

Running ```BioPathways_script_V2``` produces plots similar in nature to ```BioPathways_script```, only that these are specific to California and Texas, the two case studies of this work.

([ back to top ](#back_to_top))

## Authors

Andy Guido Eskenazi, Bjarni Örn Kristinsson <br />
Department of Aeronautics and Astronautics <br />
Massachusetts Institute of Technology, 2024 <br />
