%% Create consensus network
%{

Written by Alexa Mousley, MRC Cognition and Brain Sciences Unit
Email: alexa.mousley@mrc-cbu.cam.ac.uk

This script takes binarized networks and calculates a representative
consensus network. 

The consensus network is calcuated by a function found here: 
https://www.brainnetworkslab.com/coderesources

The function is documented in this publication:
Betzel, R. F., Griffa, A., Hagmann, P., & Mišić, B. (2019). 
Distance-dependent consensus thresholds for generating group-representative
structural brain networks. Network neuroscience, 3(2), 475-496.

%}

%% Add paths and load data
clear; clc;

% Add path to the consensus network function
addpath('/set/your/path/');                        % <<<<<<<<<< SET

% Add data path 
addpath('/set/your/path/');                        % <<<<<<<<<< SET
% Load binarized networks
load('example_binarized_connectomes.mat');
% Load region labels
load('regions.mat');
% Load Euclidean distances
load('euclidean_distances.mat');

%% Create consensus network

% Reshape network (region x region x participants)
A = shiftdim(example_binarized_connectomes, 4);

% Identify hemispheres
hemiid = zeros(size(regions));           % Initialize variable for hemisphere ID
L_index = find(contains(regions, "L"));  % Find nodes in the left hemisphere
R_index = find(contains(regions, "R"));  % Find nodes in the right hemisphere
hemiid(L_index) = 1;                     % Set left hemisphere nodes to '1'
hemiid(R_index) = 2;                     % Set right hemisphere nodes to '2'

nbins = 40;                              % Choose the number of distance bins

% Create consensus network
[G, Gc] = fcn_group_bins(A, edistance, hemiid, nbins);

consensus = G;  % The distance-based consensus network was selected for further analysis

