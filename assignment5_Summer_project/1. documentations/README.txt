
========================================================================
MULTI-STATE ANALYSIS OF ATTRITION IN ONCOLOGY TRIALS
========================================================================

This project performs a secondary analysis of clinical trial data (NCT02349412)
to model functional attrition as a multi-state process and predict patient outcomes.
The analysis focuses on understanding and mitigating the impact of missing
Quality-of-Life (QoL) data in oncology trials.

------------------------------------------------------------------------
1. PROJECT STRUCTURE
------------------------------------------------------------------------

The project is organized into a modular and reproducible folder structure:

- README.txt : This file.

- data/
    - data_brutes.csv : The primary raw data file Builed from the 9 datasets of the primary study.

- programs/
    - 01_preliminary_analysis/ : Scripts for data preparation, state definition,
      and descriptive analysis.
    - 02_multi_state_model_analysis/ : objective 1, Scripts for the multi-state model analysis.
    - 03_prediction_models/ : Objective 2, Scripts for predictive modeling (LASSO, Random Forest, XGBoost).


------------------------------------------------------------------------
2. PRELIMINARY ANALYSIS
------------------------------------------------------------------------

This phase is critical for understanding the data and preparing it for modeling.
The following steps are performed:

- Data Preparation: The raw data is cleaned, and a unified dataset is created for analysis.
- State Definition: Patients are assigned to one of three states at each time point
  (T0, T12, T24): Active, Functional Attrition, or Death.
- Descriptive Analysis: Examination of missingness patterns and baseline characteristics,
  and analysis of patient flow between states.
- Missing Data Handling: Appropriate strategies are implemented before the main analysis.

------------------------------------------------------------------------
3. OBJECTIVES
------------------------------------------------------------------------

- Primary Objective (Multi-State Analysis): To estimate transition probabilities and
  identify baseline predictors for these transitions.

- Secondary Objective (Prediction): To develop and validate predictive models for
  functional attrition, QoL deterioration, and recovery.

------------------------------------------------------------------------
4. HOW TO RUN THE ANALYSIS
------------------------------------------------------------------------

The SAS programs must be executed in a specific sequence to ensure the analysis is correct:

1. Preliminary Analysis: Run scripts in programs/01_preliminary_analysis/.
2. Multi-State Analysis: Run scripts in programs/02_msm_analysis/.
3. Predictive Modeling: Run scripts in programs/03_prediction_models/.

All generated tables, graphs, and reports will be saved in the corresponding output/
folders within each objective's directory.

------------------------------------------------------------------------
5. CONTRIBUTIONS
------------------------------------------------------------------------

This study contributes to clinical trial methodology by:

- Treating functional attrition as a clinical outcome, not merely as missing data.
- Providing a novel application of discrete multi-state models to a short-term follow-up setting.
- Offering a predictive framework to identify vulnerable patients early in a trial.

```