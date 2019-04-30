---
title: "The R tutorials"

---

All of the data analysis and statistical estimation procedures required for calibration and characterisation of test performance are available in the [R statistical package](http://www.r-project.org/). R is free, open-source software used in myriad academic and business applications. 

The subject of these tutorials is **statistical methods used to characterise a test's response-concentration relationship<!--, validate test performance and prepare stored calibration curves-->** ---an important part of POCT development. Many of these tutorials will apply to traditional plate-based assays as well, but future tutorials will build upon these procedures to cover special considerations for point-of-care tests. 

<!--
*Performance* includes 1) average or long-run reliability over multiple measurements, conditions and instruments, 2) agreement with a reference method, and 3) associated descriptors of the analytical measurement range (AMR) and clinically reportable range (CRR). Estimates of uncertainty for individual measurements have been neglected in the literature and we examine some issues and candidate methods for these. (These designs and analyses are intended for test developers in pre-market phase or preparation for routine use. User *verification* is well-described elsewhere.)
-->

****


1) [R software installation guide](over_tut1_software.html)

<!--**Calibration**-->

2) **Data preparation:** [Overview of the immunoassay data sets](calib_tut2_prep_data_sets.html), [O'Connell's ELISA data](calib_tut2_prep_ocon.html), [R's gtools ELISA data](calib_tut2_prep_elisa.html)

3) **Characterisation of response variance:** [Background](calib_tut3_variance_background.html), [O'Connell data](calib_tut3_variance_ocon.html), *R's ELISA (TODO)* <!-- [R's ELISA](calib_tut3_variance_elisa.html) -->

4) **Curve-fitting:** [Background](calib_tut4_curve_background.html), [O'Connell's data](calib_tut4_curve_ocon.html), *R's ELISA (TODO)* <!--[R's ELISA](calib_tut4_curve_elisa.html) -->

5) **Concentration estimation and precision statistics:** [Background](calib_tut5_precision_background.html), [O'Connell's data](calib_tut5_precision_ocon.html), *R's ELISA (TODO)* <!-- [R's ELISA](calib_tut5_precision_elisa.html) -->

<!--

*Performance: Estimating Test Accuracy*

6) Reliability (Precision) Studies - [Background](../reliability/tut6_reliabilty/background.html) - [Design Options (Simulations)](../reliability/tut6_reliabilty/design_simulations.html) - [Data Analysis](../reliability/tut6_reliabilty/analysis.html) 

7) Special Considerations for POCT - [Master and stored curves](../reliability/tut7_scale/the_poct_case.html) - [Planning adjusters and software updates](../reliability/tut7_scale/adjusters.html)

8) Agreement Studies - [Background](../agree/tut8_agree/background.html) - [Agreement Analysis (Bland-Altman)](../agree/tut8_agree/tut8_agree.html)

*Reporting: Scientific Publication and Package Inserts*

9) Pulling it all together - [Publication Quality Tables and Figures](../appendices/tut9_wrap/better_tables_and_plots.html) - [Manufacturer's Claims](../appendices/tut9_wrap/manufacturers_claims.html) - [Instructions to Users](../appendices/tut9_wrap/user_instructions.html)

-->

<br>
<button type="button" class="btn"><a href="over_tut1_software.html"> Next: Software installation guide &raquo;</a></button>
<!--
<button type="button" class="btn"><a href="../calibration/calibLit.html"> Skip the software tutorial and go to: Calibration Literature Review &raquo;</a></button>
-->
<br>

