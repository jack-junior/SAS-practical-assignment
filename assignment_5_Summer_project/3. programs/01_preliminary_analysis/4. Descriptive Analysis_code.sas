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
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_5_Summer_project/3. programs/01_preliminary_analysis/5. descriptive_analysis_output.pdf"
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
title "Summer project: Descriptive analysis";

/* Links to GitHub and Portfolio */
proc odstext;
    p "Access the GitHub Repository: ^{style [url='https://github.com/jack-junior/SAS-practical-assignment'] Click Here}";
run;


/* ============================================================================
    Step 1. Flow of patients between states (transition counts from T0→T12 and T12→T24)
   ============================================================================ */

/*  Transition T0 → T12                                 */

proc odstext;
    p "1. Transition Table from T0 to T12: Count (Proportion):" / style=[font_weight=bold];
run;
proc freq data=data_SP.data_main_clean_imputed;
    tables state_t0*state_t12 / out=data_SP.trans01 outpct nocol nopercent;
run;

/* Add panel variable + rename states for consistency */
data data_SP.trans01;
    set data_SP.trans01;
    transition = "T0 to T12";
    From = state_t0;   /* Source */
    To = state_t12;  /* Target */
    label = catx(" ", count, "(", put(percent, 5.1), "%)"); 
run;


proc odstext;
    p"";
    p"";
    p"";
    p"";
    p"";
    p"";
run;

/*  Transition T12 → T24                                */

proc odstext;
    p "2. Transition Table from T12 to T24: Count (Proportion):" / style=[font_weight=bold];
run;

proc freq data=data_SP.data_main_clean_imputed;
    tables state_t12*state_t24 / out=data_SP.trans12 nopercent nocol outpct;
run;

/* Add panel variable + rename states for consistency */
data data_SP.trans12;
    set data_SP.trans12;
    transition = "T12 to T24";
    From = state_t12;  /* Source */
    To = state_t24;  /* Target */
    label = catx(" ", count, "(", put(percent, 5.1), "%)");
run;


/* 3. Combine both datasets                               */

data data_SP.transitions;
    length transition $10;   /* enough to store both labels */
    set data_SP.trans01 data_SP.trans12;
run;

ods pdf startpage=now;
         
/*   Transition visualisation  */


proc odstext;
    p "3. Heatmap Flow of patients between states (transition counts and overall percent from T0 to T12 and T12 to T24):" / style=[font_weight=bold];
run;
proc sgpanel data=data_SP.transitions;
    panelby transition / layout=columnlattice onepanel novarname;
    heatmapparm x=From y=To colorresponse=count /
        colormodel=(white blue) outline;
    text x=From y=To text=label / position=center;
    rowaxis discreteorder=data;
    colaxis discreteorder=data;
    title Heatmap transition counts from T0→T12 and T12→T24);
run;

proc odstext;
    p "percentage displayed are overall percentage and not row percent:" / style=[font_weight=bold];
run;

ods pdf startpage=now;

/* ============================================================================
    Step 2. Baseline Characteristics by attrition status at Week 12
   ============================================================================ */

proc odstext;
    p "4. Baseline Characteristics by attrition status at Week 12:" / style=[font_weight=bold];
run;

proc tabulate data=data_SP.data_main_clean format=8.2;
    class state_t12 sex ecogps tumrtyp arm ptmargstat race1;
    var age fact_bl hads_pt_anx_bl hads_pt_dep_bl n12;

    table 
        /* Continuous variables: mean ± standard deviation */
        (age fact_bl hads_pt_anx_bl hads_pt_dep_bl n12) * (mean std)

        /* Categorical variables: count and column percent */
        sex* (n colpctn)
        ecogps* (n colpctn)
        tumrtyp* (n colpctn)
        arm* (n colpctn)
        ptmargstat* (n colpctn)
        race1* (n colpctn),

        /* Columns: by attrition status at week 12, plus overall */
        state_t12 all
        / box="Baseline Characteristics by attrition status at Week 12";
run;

ods pdf startpage=now;

/* ============================================================================
    Step 3. Baseline Characteristics by attrition status at Week 24
   ============================================================================ */

proc odstext;
    p "5. Baseline Characteristics by attrition status at Week 12:" / style=[font_weight=bold];
run;

proc tabulate data=data_SP.data_main_clean format=8.2;
    class state_t24 sex ecogps tumrtyp arm ptmargstat race1;
    var age fact_bl hads_pt_anx_bl hads_pt_dep_bl n12;

    table 
        /* Continuous variables: mean ± standard deviation */
        (age fact_bl hads_pt_anx_bl hads_pt_dep_bl n12) * (mean std)

        /* Categorical variables: count and column percent */
        sex* (n colpctn)
        ecogps* (n colpctn)
        tumrtyp* (n colpctn)
        arm* (n colpctn)
        ptmargstat* (n colpctn)
        race1* (n colpctn),

        /* Columns: by attrition status at week 24, plus overall */
        state_t24 all
        / box="Baseline Characteristics by attrition status at Week 24";
run;


/* ----------------------------------------------------
   Close Output
   ---------------------------------------------------- */
ods pdf close;
title;
footnote;






