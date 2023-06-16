%% Analyze developmental generative models 
%{

Written by Alexa Mousley, MRC Cognition and Brain Sciences Unit
Email: alexa.mousley@mrc-cbu.cam.ac.uk

% This script takes the develomental generative models and explores the
types of connections that were added (total number and connection lengths).

%}

%% Add path and load data 

clear;clc;

% Add Brain Connectivity Toolbox
addpath('/set/your/path/');          % <<<<<<<<<< SET

% Add data path 
addpath('/set/your/path/');          % <<<<<<<<<< SET
% Load binarized networks
load('example_binarized_connectomes.mat');
% Load consensus network
load('example_consensus_network.mat');
% Load developmental generative models
load('example_developmental_generative_models.mat');
% Load atlas euclidean distances
load('euclidean_distances.mat');
% Load rich club nodes
load('example_rich_club_nodes.mat');

%% Calculate connection types and lengths

% Initialize struct to save output
example_developmental_gnms_connections = struct;

% Loop through term and preterm models
for group = 1:2
    % Loop through each run
    for run = 1:width(example_developmental_gnms.networks)
        % Take network (it will be iterations x region x region)
        networks = squeeze(example_developmental_gnms.networks(group,run,:,:,:));
        % Loop through the number of connections
        for f = 1:length(networks)  
            % Take one iteration of the network
            net = squeeze(networks(f,:,:));
            % Define connection types and lengths
            clear c                               % Clear variable from preivous loop
            half = triu(net);                     % Only take half on the matrix
            [c(:,1) c(:,2)] = find(half==1);      % Find connections (save index of connected nodes)

            % Initialize
            counts = zeros(length(c),3); 
            con_length = zeros(length(c),3); 

            % Loop through each connection
            clear i
            for i = 1:height(c)
                if ismember(c(i,1),rich_club_nodes) && ismember(c(i,2),rich_club_nodes)       %% If both nodes are rich nodes = rich
                    counts(i,1) = 1;
                elseif ismember(c(i,1),rich_club_nodes) || ismember(c(i,2),rich_club_nodes)   %% If one node is a rich club = feeder
                    counts(i,2) = 1;
                elseif ~ismember(c(i,1),rich_club_nodes) && ~ismember(c(i,2),rich_club_nodes) %% If neither node is a rich club = local
                    counts(i,3) = 1;
                else
                    disp(sprintf('Missing condition for connention between nodes %g and %g...',c(i,1),c(i,2)));
                end
                % Find length of the connection 
                con_length(i,find(counts(i,:)==1)) = edistance(c(i,1),c(i,2)); 
            end
            % Save data
            example_developmental_gnms_connections.counts(group,run,f,:) = sum(counts);
            example_developmental_gnms_connections.lengths(group,run,f,:) = sum(con_length);
        end
    end
end
%% Organize data

% Seperate groups
term_lengths = squeeze(example_developmental_gnms_connections.lengths(1,:,:,:));
preterm_lengths = squeeze(example_developmental_gnms_connections.lengths(2,:,:,:));
term_counts = squeeze(example_developmental_gnms_connections.counts(1,:,:,:));
preterm_counts = squeeze(example_developmental_gnms_connections.counts(2,:,:,:));

% Average count and lengths for the whole network
network_term_counts = mean(squeeze(sum(term_counts,3)));
network_preterm_counts = mean(squeeze(sum(preterm_counts,3)));
network_term_lengths = mean(squeeze(sum(term_lengths,3)));
network_preterm_lengths = mean(squeeze(sum(preterm_lengths,3)));

% Average count and lengths each connection type
mean_term_lengths = squeeze(mean(term_lengths));
mean_preterm_lengths = squeeze(mean(preterm_lengths));
mean_term_counts = squeeze(mean(term_counts));
mean_preterm_counts = squeeze(mean(preterm_counts));

% Calculate average connection lengths proportional to number of connections for each connection type
for c = 1:width(mean_term_lengths)
    mean_term_connection_type_lengths(:,c) = mean_term_lengths(:,c)./mean_term_counts(:,c);
    mean_preterm_connection_type_lengths(:,c) = mean_preterm_lengths(:,c)./mean_preterm_counts(:,c);
end
