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
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_4_reporting_visualization/assignment_4_output.pdf"
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
title "Exploratory Analysis of the HEART Dataset: Reporting and Visualization";

/* Links to GitHub and Portfolio */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
run;

  

/*-----------------------------------------------------------
 Step 1. Import dataset
-----------------------------------------------------------*/
libname data_SP '/home/u64176007/sas_pratical_assignment/assignment5_Summer_project/2. data_SP';
proc import datafile="/home/u64176007/sas_pratical_assignment/assignment5_Summer_project/2. data_SP/data_brutes.csv"
    out=data_SP.data_brutes
    dbms=csv
    replace;
    guessingrows=max;
run;

/*-----------------------------------------------------------
 Step 2. Delete duplicate / redundant columns
-----------------------------------------------------------*/
proc datasets library=data_SP nolist;
    modify data_main_clean;
    drop arm_x_x arm_y_y arm_x_x_x arm_y_y_y arm_y
         site_num_x site_num_y sitetype_x sitetype_y
         wk24_assess_complete_y wk12_assess_complete_y
         wk12_assess_complete_x wk24_assess_complete_x;
quit;


/*-----------------------------------------------------------
 Step 3. Extract variables of interest
-----------------------------------------------------------*/
data data_SP.data_main;
    set data_SP.data_clean(keep=
        patref
        wk12_dead wk24_dead
        fact_chg12 fact_chg24 
        hads_anx_chg12 hads_dep_chg12
        n12 n12_grp
        fact_bl hads_pt_anx_bl hads_pt_dep_bl
        age sex ecogps tumrtyp cgpart
        race1 ptethncty pthighedu ptmargstat
        ptrelgn sitetype arm bsl_assess_complete
        ptpqpt1_grp ptpqpt7_grp ptpqpt9e_grp
        ptpqpt11_grp ptpqpt12_grp
    );
run;

/*-----------------------------------------------------------
 Step 4. Data cleaning and harmonization
-----------------------------------------------------------*/

/* Replace ">90" in age with "90" and convert to numeric */
data data_SP.data_main_clean;
    set data_SP.data_main;
    if age = ">90" then age = "90";
    age_num = input(age, 8.);   /* convert character to numeric */
    drop age;
    rename age_num = age;
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
    wk12_dead_c   = put(wk12_dead, best32.);
    wk24_dead_c   = put(wk24_dead, best32.);

    /* Drop old numeric variables */
    drop arm wk12_dead wk24_dead;

    /* Rename new char variables */
    rename arm_char = arm
           wk12_dead_c = wk12_dead
           wk24_dead_c = wk24_dead;
run;



/*-----------------------------------------------------------
 Step 5. Replace "" with missing in categorical variables
-----------------------------------------------------------*/
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    array charvars _character_;
    do over charvars;
        if strip(charvars) = "" then charvars = " ";
    end;
run;

/*-----------------------------------------------------------
 Step 6. Recode and regroup categories
-----------------------------------------------------------*/

/* pthighedu – regroup */
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    if pthighedu = "I prefer not to answer" then pthighedu = "Other";
    
    /* ptmargstat – regroup */
    if ptmargstat in ("I prefer not to answer","Unknown/Not reported") then ptmargstat = " ";
run;



/* ptrelgn – regroup rare categories into "Other" 
   First, count frequencies */
proc freq data=data_SP.data_main_clean;
    tables ptrelgn / out=data_SP.freq_rel;
run;

/* recode religion with <15 obs into "Other" */
/* rare_rel contient les modalités rares */
proc sql;
    create table rare_rel as
    select ptrelgn 
    from data_SP.freq_rel
    where count < 15;
quit;

/* Créer un flag dans rare_rel */
data rare_rel;
    set rare_rel;
    rare_flag = 1;
run;

/* Faire un merge */
proc sort data=data_SP.data_main_clean; by ptrelgn; run;
proc sort data=rare_rel; by ptrelgn; run;

data data_SP.data_main_clean;
    merge data_SP.data_main_clean (in=a)
          rare_rel (in=b);
    by ptrelgn;
    if a;

    /* Recode */
    if ptrelgn in ("Unknown","Not reported") then ptrelgn = " ";
    else if rare_flag=1 then ptrelgn = "Other";

    drop rare_flag;
run;

/* race1 – regroup into White / Black / Asian / Other */
data data_SP.data_main_clean;
    set data_SP.data_main_clean;
    if race1 not in ("White", "Black or African American", "Asian") then race1 = "Other";
run;

/*-----------------------------------------------------------
 Final check
-----------------------------------------------------------*/

proc odstext;
    p " 1. Information about the final dataset :" / style=[font_weight=bold];
run;
proc contents data=data_SP.data_main_clean;
run;


ods pdf startpage=now;


proc odstext;
    p " CHeck frequency table of categorical variable and confirm recoding :" / style=[font_weight=bold];
run;

proc freq data=data_SP.data_main_clean;
    tables race1 ptrelgn pthighedu ptmargstat arm;
run;


/* ----------------------------------------------------
   Close Output
   ---------------------------------------------------- */
ods pdf close;
title;
footnote;
