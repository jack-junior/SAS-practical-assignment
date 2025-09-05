/* ====================================================
   Assignment 5 : Summer project - Data preparation
   Author   : Gayi Komi Selassi & Prerna Priyam
   ID       : RA2422021010003 & 
   Program  : MSc Epidemiology & Biostatistics
   ==================================================== */
  
/* ----------------------------------------------------
   Setup ODS for Output
   ---------------------------------------------------- */ 
/* Escape character for hyperlinks */
ods escapechar="^";

/* Define PDF output file */
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_5_Summer_project/3. programs/01_preliminary_analysis/2. data_preparation_output.pdf"
        style=journal;
ods graphics / reset=all;                

/* Disable automatic page breaks initially */
ods pdf startpage=never; 

proc odstext;
    p "Assignment 3 - Data Analysis" / style=[font_weight=bold];
    p "Author   : Gayi Komi Selassi";
    p "ID       : RA2422021010003";
    p "Program  : MSc Epidemiology & Biostatistics";
    p "Portfolio: ^{style [url='https://sites.google.com/view/gayikomiselassi/home'] Click Here}";
 run; 

/* Custom footer*/
footnote j=l "GAYI KOMI SELASSI, RA2422021010003, MSc Epidemiology & Biostatistics";

/* Cover page title */
title "Summer project: data preparation";

/* Links to GitHub and Portfolio */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
run;


  

/*-----------------------------------------------------------
 Step 1. Import dataset
-----------------------------------------------------------*/
libname data_SP '/home/u64176007/sas_pratical_assignment/assignment_5_Summer_project/2. data_SP';
proc import datafile="/home/u64176007/sas_pratical_assignment/assignment_5_Summer_project/2. data_SP/data_brutes.csv"
    out=data_SP.data_brutes
    dbms=csv
    replace;
    guessingrows=max;
run;


/*-----------------------------------------------------------
 Step 2. Extract variables of interest
-----------------------------------------------------------*/
data data_SP.data_main;
    set data_SP.data_main(keep=
        patref
        wk12_dead wk24_dead
        fact_chg12 fact_chg24 
        hads_anx_chg12 hads_dep_chg12
        n12 n12_grp
        fact_bl hads_pt_anx_bl hads_pt_dep_bl
        age sex ecogps tumrtyp cgpart
        race1 pthighedu ptmargstat
        ptrelgn arm bsl_assess_complete
        ptpqpt1_grp ptpqpt7_grp ptpqpt9e_grp
        ptpqpt11_grp ptpqpt12_grp
    );
run;

/*-----------------------------------------------------------
 Step 3. Data cleaning and harmonization
-----------------------------------------------------------*/

/* Replace ">90" in age with "90" and convert to numeric alon with some others variables  */
data data_SP.data_main_clean;
    set data_SP.data_main;
    if age = ">90" then age = "90";
    
    /* convert character to numeric */
    age_num = input(age, 8.);   
    fact_bl_num        = input(fact_bl, ?? 8.);
    fact_chg12_num     = input(fact_chg12, ?? 8.);
    fact_chg24_num     = input(fact_chg24, ?? 8.);
    hads_anx_chg12_num = input(hads_anx_chg12, ?? 8.);
    hads_dep_chg12_num = input(hads_dep_chg12, ?? 8.);
    hads_pt_anx_bl_num = input(hads_pt_anx_bl, ?? 8.);
    hads_pt_dep_bl_num = input(hads_pt_dep_bl, ?? 8.);
    n12_num            = input(n12, ?? 8.);
    ecogps_num            = input(ecogps, ?? 8.);
    
    /*  drop old variable  */
    drop age fact_bl fact_chg12 fact_chg24 hads_anx_chg12 hads_dep_chg12 
         hads_pt_anx_bl hads_pt_dep_bl n12 ecogps;
         
    /* rename new variable with old name*/
    rename age_num = age
	        fact_bl_num=fact_bl
	        fact_chg12_num=fact_chg12
	        fact_chg24_num=fact_chg24
	        hads_anx_chg12_num=hads_anx_chg12
	        hads_dep_chg12_num=hads_dep_chg12
	        hads_pt_anx_bl_num=hads_pt_anx_bl
	        hads_pt_dep_bl_num=hads_pt_dep_bl
	        n12_num=n12
	        ecogps_num=ecogps;
run;

/* Delete rows with only arm and patref non-missing (others missing) */
data data_SP.data_main_clean;
    set data_SP.data_main_clean;

    array nums  _numeric_;
    array chars _character_;

    nvars      = dim(nums) + dim(chars);
    miss_all   = nmiss(of nums[*]) + cmiss(of chars[*]);

    if not missing(arm) and not missing(patref) and (nvars - miss_all) = 2 then delete;

    drop nvars miss_all;
run;


/* Convert selected variables to categorical (character/factor equivalent) */

data data_SP.data_main_clean;
    set data_SP.data_main_clean;

    /* Create new variables as character */
    arm_char      = put(arm, best32.);

    /* Drop old numeric variables */
    drop arm;

    /* Rename new char variables */
    rename arm_char = arm;
run;



/*-----------------------------------------------------------
 Step 4. Replace "" with missing in categorical variables
-----------------------------------------------------------*/
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    array charvars _character_;
    do over charvars;
        if strip(charvars) = "" then charvars = "";
    end;
run;

/*-----------------------------------------------------------
 Step 5. Recode and regroup categories
-----------------------------------------------------------*/

/* pthighedu – regroup */
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    if pthighedu = "I prefer not to answer" then pthighedu = "Other";
    
    /* ptmargstat – regroup */
    if ptmargstat in ("I prefer not to answer","Unknown/Not reported") then ptmargstat = "";
run;



/* ptrelgn – regroup rare categories into "Other" 
   First, count frequencies */
proc freq data=data_SP.data_main_clean noprint;
    tables ptrelgn / out=data_SP.freq_rel;
run;

/* recode religion with <15 obs into "Other" */
/* rare_rel encompasses rares categories */
proc sql;
    create table rare_rel as
    select ptrelgn 
    from data_SP.freq_rel
    where count < 15;
quit;

/* Create a flag in rare_rel */
data rare_rel;
    set rare_rel;
    rare_flag = 1;
run;

/* merge */
proc sort data=data_SP.data_main_clean; by ptrelgn; run;
proc sort data=rare_rel; by ptrelgn; run;

data data_SP.data_main_clean;
    merge data_SP.data_main_clean (in=a)
          rare_rel (in=b);
    by ptrelgn;
    if a;

    /* Recode */
    if ptrelgn in ("Unknown","Not reported") then ptrelgn = "";
    else if rare_flag=1 then ptrelgn = "Other";

    drop rare_flag;
run;

/* race1 – regroup into White / Black / Asian / Other */
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    if race1 not in ("White", "Black or African American", "Asian") then race1 = "Other";
run;

/*-----------------------------------------------------------
 Step 6. Define states
-----------------------------------------------------------*/

/* Restrict to baseline completers */
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    if bsl_assess_complete = 1;
run;

/* At baseline (T0): everyone is "A" */
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    length state_t0 state_t12 state_t24 $1.;
    state_t0 = "A";

    /* At week 12 (T12) */
    if wk12_dead = 1 then state_t12 = "D";
    else if not missing(fact_chg12) then state_t12 = "A";
    else state_t12 = "F";

    /* At week 24 (T24) */
    if wk24_dead = 1 then state_t24 = "D";
    else if not missing(fact_chg24) then state_t24 = "A";
    else state_t24 = "F";
run;




/*-----------------------------------------------------------
 Step 7. Visualize missing data
-----------------------------------------------------------*/
ods exclude all;
/* Count missing values per variable for numeric variable */
proc means data=data_SP.data_main_clean n nmiss;
    ods output Summary=miss_num;  
run;

/* clean the output miss_num */
data miss_num;
    set miss_num;
    length varname $32;
    varname = scan(variable,1); /* nom variable */
    percent = 100 * NMiss / N;  /* taux de missing */
    keep varname nmiss percent;
run;

/* Count missing values per variable for character variable */
proc freq data=data_SP.data_main_clean nlevels;
    tables _character_ / missing;
    ods output NLevels=miss_char;
run;

/* clean the output miss_char */
data miss_char;
    set miss_char;
    length varname $32;
    varname = TableVar;
    nmiss = NMissLevels;
    percent = 100 * nmiss / (NNonMissLevels + NMissLevels);
    keep varname nmiss percent;
run;

/* combine both miss_num and miss_char*/
data miss_summary;
    set miss_num miss_char;
run;

ods exclude none;
/* Horizontal bar plot */

proc odstext;
    p "1. Visualization of missing value :" / style=[font_weight=bold];
run;
proc sgplot data=miss_summary;
    hbar varname / response=percent datalabel;
    xaxis label="Percent Missing";
    yaxis discreteorder=data;
    title "Missing Values by Variable";
run;



/*-------------------------------------------------------------------------
 Step 8. Handle missing data - Deleting variable with >= 15% missing value
 and performing mode imputation for remaining character variables.
---------------------------------------------------------------------------*/

/*Deleting variable with >= 15% missing value*/

data data_SP.data_main_clean_filtered;
    set data_SP.data_main_clean;
    drop ptrelgn ptpqpt1_grp ptpqpt7_grp 
         ptpqpt9e_grp ptpqpt11_grp ptpqpt12_grp;
run;

/*Compute frequency distribution of pthighedu and keep the mode */
proc freq data=data_SP.data_main_clean_filtered noprint;
    tables pthighedu / missing out=mode_pthighedu;
run;

proc sort data=mode_pthighedu;
    by descending count;
run;

data mode_pthighedu;
    set mode_pthighedu;
    if _n_ = 1 then call symputx("mode_pthighedu", pthighedu);
run;

/*Compute frequency distribution of ptmargstat and keep the mode */

proc freq data=data_SP.data_main_clean_filtered noprint;
    tables ptmargstat / missing out=mode_ptmargstat;
run;

proc sort data=mode_ptmargstat;
    by descending count;
run;

data mode_ptmargstat;
    set mode_ptmargstat;
    if _n_ = 1 then call symputx("mode_ptmargstat", ptmargstat);
run;

/* mode imputation */

data data_SP.data_main_clean_imputed;
    set data_SP.data_main_clean_filtered;
     if missing(pthighedu)  then pthighedu  = "&mode_pthighedu";
    if missing(ptmargstat) then ptmargstat = "&mode_ptmargstat";
run;


/*-----------------------------------------------------------
 Step 9. Final check
-----------------------------------------------------------*/
/*-----------------------------------------------------------
  Visualize missing data after the imputation
-----------------------------------------------------------*/

ods exclude all;
/* Count missing values per variable for numeric variable */

proc means data=data_SP.data_main_clean_imputed n nmiss;
   ods output Summary=miss_num_imputed;
run;




/* clean the output miss_num */
data miss_num_imputed;
    set miss_num_imputed;
    length varname $32;
    varname = scan(variable,1); /* nom variable */
    percent = 100 * NMiss / N;  /* taux de missing */
    keep varname nmiss percent;
run;

/* Count missing values per variable for character variable */
proc freq data=data_SP.data_main_clean_imputed nlevels;
    tables _character_ / missing;
    ods output NLevels=miss_char_imputed;
run;

/* clean the output miss_char */
data miss_char_imputed;
    set miss_char_imputed;
    length varname $32;
    varname = TableVar;
    nmiss = NMissLevels;
    percent = 100 * nmiss / (NNonMissLevels + NMissLevels);
    keep varname nmiss percent;
run;

/* combine both miss_num and miss_char*/
data miss_summary_imputed;
    set miss_num_imputed miss_char_imputed;
run;

ods exclude none;

/* Horizontal bar plot */

proc odstext;
    p "2. Visualization of missing value after filtering and imputation:" / style=[font_weight=bold];
run;
proc sgplot data=miss_summary_imputed;
    hbar varname / response=percent datalabel;
    xaxis label="Percent Missing";
    yaxis discreteorder=data;
    title "Missing Values by Variable after filtering and imputation";
run;


ods pdf startpage=now;

proc odstext;
    p " 3. Information about the final dataset :" / style=[font_weight=bold];
run;
proc contents data=data_SP.data_main_clean_imputed;
run;


ods pdf startpage=now;





proc odstext;
    p "4. CHeck frequency table of categorical variable and confirm recoding and imputation:" / style=[font_weight=bold];
run;

proc freq data=data_SP.data_main_clean_imputed;
    tables _character_ / missing;
run;


/* ----------------------------------------------------
   Close Output
   ---------------------------------------------------- */
ods pdf close;
title;
footnote;
