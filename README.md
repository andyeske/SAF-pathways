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
&nbsp; &nbsp; 2d: [ Texas and California Plots ](#texascali)

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
<br />
<br />
```BioPathways_script```: This script is the interface that the user would interact with. In essence, this script calls on the ```BioPathways_func``` function described above, and produces the plots that can be found below. In order to 

([ back to top ](#back_to_top))

---
<a name="results"></a>
### 2: Results: Biological Pathways

([ back to top ](#back_to_top))

---
<a name="inter-state"></a>
#### 2a: Inter-state Plots

([ back to top ](#back_to_top))

---
<a name="intra-state"></a>
#### 2b: Intra-state Plots

([ back to top ](#back_to_top))

---
<a name="airline"></a>
#### 2c: Airline-specific Inter-state Plots

([ back to top ](#back_to_top))

---
<a name="texascali"></a>
#### 2d: Texas and California Plots

([ back to top ](#back_to_top))

## Authors

Andy Guido Eskenazi, Bjarni Örn Kristinsson <br />
Department of Aeronautics and Astronautics <br />
Massachusetts Institute of Technology, 2024 <br />
