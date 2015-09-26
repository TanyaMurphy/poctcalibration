---
title: "Calibration overview"
---

Our goal in this section is to implement established methods and fit a robust calibration model that reliably returns sample concentration estimates under controlled conditions. At this time we will concentrate on *immunometric* tests; that is, tests with a positive relationship between concentration and response. Most of the same concepts apply to competitive assays, but the interpretation of some parameters changes with the inverse relationship.


## Methods 

Methods for calibration curve fitting may differ from ordinary least squares linear regression in three ways:

- Variance may not be constant over the range of concentrations (heteroscedastic). Weighted least squares can accommodate this.
  
- The relationship between concentration and response may not be linear. Non-linear models are needed (e.g. 4PL). 

- Data may be collected in groups (e.g. reagent batches) and the calibration curve parameters may vary between groups. Modeling such data will allow us to study the reliability of the curve under different settings. Adjustments for these different settings can be included in the master calibration curve.

Try the analyses described in this chapter with the preliminary measurements that accumulate as you develop your system. Do not, however, put too much stock in the results yet. Use this practice to get comfortable with the software and the methods. You will gather clues about the variance structure, curve model and potential problems, which can be tested once you have a large number of replicates from a stable system. 

<br>
<!--
<button type="button" class="btn"><a href="calibLit.html"> Next: Calibration literature review &raquo;</a></button>
-->
<button type="button" class="btn"><a href="calib_tut2_prep_background.html"> Tutorial: Data preparation &raquo;</a></button>
<br>

<!--
**Background Outline**

- Introduction
    - What is the purpose of a calibration curve?
    - Definitions
    - How does it relate to the rest of the test development process?
    - What sub-topics are included and excluded in this topic?
- Data analysis (links to section background pages)
    - Exploratory Data Analysis
    - Preparing for non-standard variance structure
    - Curve-fitting
    - Accuracy of the fitted values along the concentration range
- Miscellaneous topics
    - Curve-fitting software
    
-->
