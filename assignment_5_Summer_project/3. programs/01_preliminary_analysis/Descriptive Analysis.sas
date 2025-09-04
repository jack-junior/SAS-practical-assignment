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
ods pdf file="/home/u64176007/sas_pratical_assignment/assignment_5_Summer_project/3. programs/01_preliminary_analysis/descriptive_analysis_output.pdf"
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

  

/*-----------------------------------------------------------
 Step 1. 
-----------------------------------------------------------*/


/*-----------------------------------------------------------
 Step 2. 
-----------------------------------------------------------*/

/*-----------------------------------------------------------
 Step 3. 
-----------------------------------------------------------*/

/*-----------------------------------------------------------
 Step 4. 
-----------------------------------------------------------*/






/*-----------------------------------------------------------
 Step 5. 
-----------------------------------------------------------*/


/*-----------------------------------------------------------
 Step 6. Reco
-----------------------------------------------------------*/






/*-----------------------------------------------------------
 Step 7. Define states
-----------------------------------------------------------*/

/*-----------------------------------------------------------
 Final check
-----------------------------------------------------------*/


/* ----------------------------------------------------
   Close Output
   ---------------------------------------------------- */
ods pdf close;
title;
footnote;
