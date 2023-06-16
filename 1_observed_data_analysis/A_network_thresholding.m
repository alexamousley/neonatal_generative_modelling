%% Network Thresholding
%{

Written by Alexa Mousley, MRC Cognition and Brain Sciences Unit
Email: alexa.mousley@mrc-cbu.cam.ac.uk

This script takes raw networks, performs consensus thresholding followed by
absolute thresholding and binarization.

Note: If you are using the example data, the consensus thresholding will
need to be much lower that 60% as the data is random and therefore not many
'connecitions' will be in common across the fake particpipants

%}
%% Add paths and load data
clear;clc;

% Add Brain Connectivity Toolbox
addpath('/set/your/path/');                        % <<<<<<<<<< SET

% Add data path 
addpath('/set/your/path/');                        % <<<<<<<<<< SET
% Load example networks
load('example_networks.mat'); 

nsub = size(example_networks,1); % Set number of participants

%% Perform consensus thresholding
% Set threshold
set = 0.6;                     % Percentage threshold
threshold = floor(nsub * set); % Calculate the threshold value based on the number of participants

k = example_networks ~= 0;     % Find nonzero elements (essentially creating a mask)
u = squeeze(sum(k, 1));        % Sum the values along the first dimension, squeezing the result to remove singleton dimensions

% Keep/Remove indices
ind = u < threshold;           % Find indices where the sum is less than the threshold
indkeep = u > threshold;       % Find indices where the sum is greater than the threshold

% Apply Threshold
for sub = 1:nsub
    A = squeeze(example_networks(sub,:,:)); % Select one participant
    A(ind)=0;                               % Remove edges with index
    consensus_thresholded(sub,:,:)=A;       % Save network 
end

% Look at the number of connections before and after thresholding
for sub = 1:nsub
    % Get the original network (A) and thresholded network (B)
    A = squeeze(example_networks(sub,:,:));
    B = squeeze(consensus_thresholded(sub,:,:));
    
    % Calculate the number of connections before and after thresholding
    before_threshold(sub) = nnz(A)/2;    % Count the number of nonzero elements in A and divide by 2 (due to symmetric connections)
    after_threshold(sub) = nnz(B)/2;     % Repeat for B
end

%% Perform absolute thresholding and binarize networks

% Set threshold
thr = 325;

% Initialise variables
weighted_connectomes = [];     % Empty array to store weighted connectomes
binarised_connectomes = [];    % Empty array to store binarised connectomes
density = [];                  % Empty array to store density values

% Apply thresholding
for sub = 1:nsub
    W = squeeze(consensus_thresholded(sub,:,:));        % Extract the consensus thresholded connectome for the current participant
    weighted_connectomes = threshold_absolute(W, thr);  % Apply the absolute threshold to the connectome
    density(sub) = density_und(weighted_connectomes);   % Calculate the density of the weighted network
    B = zeros(size(weighted_connectomes));              % Create a matrix of zeros with the same size as the weighted network
    B(find(weighted_connectomes)) = 1;                  % Find the connections above the threshold and set them to 1
    binarised_connectomes(sub,:,:) = B;                 % Store the binarised connectome 
end

% Print results
disp(sprintf('At this threshold, a mean density of %g%% is produced across the sample.',100*mean(density)));
