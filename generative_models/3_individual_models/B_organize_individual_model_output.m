%% Organize individual generative model outputs
%{

Written by Alexa Mousley, MRC Cognition and Brain Sciences Unit
Email: alexa.mousley@mrc-cbu.cam.ac.uk

This script takes individual generative model output files and puts them
into one struct to be used in further analysis.

%}

%% Add paths and load data
clear;clc;

% Set save directory 
% sdir = '/set/your/path/';        % <<<<<<<<<< SET if you would like to save the models, rather than use the example data provided (uncomment line 66 to save)

% Add data path 
addpath('/set/your/path');         % <<<<<<<<<< SET
% Load binarized networks
load('example_binarized_connectomes.mat');
% Set number of participants and number of generative runs
nsub = size(example_binarized_connectomes,1); 
nruns = 25;                        


%% Load generative model data and put it into one struct

% Initialize
energy_sample = zeros(nsub,nruns);
ks_sample = zeros(nsub,nruns,4);
networks_sample = cell(nsub,1);
parameters_sample = zeros(nsub,nruns,2);
errors = zeros(nsub,1);

% Loop over participants
for sub = 1:nsub
    try % Load this paticipant's generative models 
        load(sprintf('example_generative_output_sub-%g.mat',sub));
    catch
        % Keep if it doesn't load
        errors(sub) = 1;
        % Print missing participant
        disp(sprintf('Participant %g non-existant',sub));
    end
    % Save variables
    energy_sample(sub,:,:) = output.energy;
    ks_sample(sub,:,:) = output.ks;
    networks_sample{sub} = output.networks;
    parameters_sample(sub,:,:) = output.params;
    
    % Clear the variable
    clear output
    
    % Display
    disp(sprintf('Participant %g loaded',sub));
end

% Save data as a struct
generative_models = struct;
generative_models.energy = energy_sample;
generative_models.ks = ks_sample;
generative_models.networks = networks_sample;
generative_models.parameters = parameters_sample;
generative_models.procedure = string({'Grid search n=10000 parameters eta [-3 0] and gamma [0.1 0.6] limits'}); % Include descriptives of how the models were run
%save('generative_models.mat','generative_models','-v7.3');
