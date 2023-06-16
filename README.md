**Code repository for:**
Mousley, A., Akarca, D., & Astle, D.E. (2023). Premature birth changes wiring constraints in neonatal structural brain networks. PREPRINT available at Research Square [https://doi.org/10.21203/rs.3.rs-3062369/v1]

For any questions regarding the use of this repository, please get in touch at alexa.mousley@mrc-cbu.cam.ac.uk

**Requirements**

Software
* MATLAB 2020B (installation: https://uk.mathworks.com/help/install/install-products.html)
* RStudio 4.1.2 (installation: https://rstudio.com/products/rstudio/download/)

Toolboxes/Functions
* Brain Connectivity Toolbox (https://sites.google.com/site/bctnet/home?authuser=0)
	- Rubinov, M., & Sporns, O. (2010). Complex network measures of brain connectivity: uses and interpretations. Neuroimage, 52(3), 1059-1069.
* Consensus network creation (https://www.brainnetworkslab.com/coderesources)
	- Betzel, R. F., Griffa, A., Hagmann, P., & Mišić, B. (2019). Distance-dependent consensus thresholds for generating group-representative structural brain networks. Network neuroscience, 3(2), 475-496.

**Script outline:**
1) Observed topological analysis
	- A_network_thresholding.m
	- B_create_consensus_network.m
	- C_identify_rich_club_nodes.m
	- D_calculate_organizational_measures.m
	- E_organizational_analysis.R  

3) Initial generative network model selection 
	- A_run_initial_generative_models.m
	- B_analyze_initial_generative_models.m  
	- D_compare_initial_models_plot.R

4) Individually fit generative network models 
	- A_run_individual_generative_models.m
	- B_organize_individual_model_output.m 
	- C_analyze_individual_generative_models.m 
	- D_visualize_individual_generative_models.R 

5) Group-representative developmental models 
	- A_run_developmental_generative_models.m
	- B_analyze_developmental_generative_models.m 
	- C_visualize_developmental_generative_models.R 

