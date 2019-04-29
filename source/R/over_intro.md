# Statistical Tools for the Characterisation and Validation of POC Tests

*Authors: Tanya Murphy, Nandini Dendukuri, Dhananjaya Dendukuri*

## Introduction

Biochemical or biomarker tests can facilitate treatment decisions while being less physically invasive than other procedures such as biopsy or radiography. *Point-of-care testing* (**POCT**) further reduces the burden of testing by making the test and test results easily accessible, either at the patient's home or at a primary health care centre, thus shortening wait times for test results [@Yager2008 [view](../../../Literature/Yager_2008.pdf)].

Due to their molecular nature, biomarker-based tests present some challenges: Chemicals, hormones and antigens cannot be directly observed and are usually too small to be quantified by microscope. Well-established methods to indirectly observe such molecules, or *analytes*, include mass spectrometry, immunoassays and variants. This document will focus on non-isotopic assays (e.g. ELISA) with characteristics that may transfer well to POC applications.

Some of the limitations of immunoassays, and especially some of the additional compromises associated with POCTs, may not be well understood by users of the tests. On the other hand, developers of the tests may not appreciate the potential ensuing clinical consequences of a poorly developed or characterised test. Therefore, there is a need to regulate the use of POCTs to encourage standardization and transparency in their development. Although the process of regulating diagnostic tests is not as rigorous as for pharmaceutical interventions, guidelines have been published by a number of major organisations such as the [Clinical and Laboratory Standards Institute (CLSI)](http://clsi.org/).  

CLSI guidelines recommend:

- Standardised reporting of test performance claims (for manufacturers);
- Protocols for test evaluation and use (for clinical laboratories and other test users).

In turn, scientific articles comment and build upon the guidelines: The rapid evolution of diagnostic technologies requires that some fundamental methods be reintroduced, and other be adapted for newer applications. We are particularly interested in the **statistical methods used to characterise POCT performance**, including **calibration curve-fitting and analytical validation**, as part of pre-market test development.

### The special case of POCT

Unlike lab-based tests, POCTs must be easy to use and feasible as a single-sample-at-a-time platform (also known as a *random access system*). Once a patient sample has been properly collected *, there are a number of steps to obtaining a concentration estimate. Table 1 compares the general steps for traditional lab-based tests running concurrent calibrators versus an ideal POCT system.

\* We will not cover proper sample collection in this document. <!-- See (ref) for details. -->

|Traditional lab-based batch assays including calibrators|Quantitative POCT needing minimal user intervention|
|:-------------------------------------------------------|:--------------------------------------------------|
|- Store sample appropriately until processing|*(Sample would have been introduced immediately into the device)*|
|- Process the collected sample|*(Processing happens automatically within the chip)*|
|- Measure the generated response|- Measure the generated response|
|- Estimate calibration curve from response and concurrent calibrators|*(Calibration curve model, previously determined by manufacturer, is stored in the response reader's software)*|
|- Patient sample concentration is estimated from response and calibration curve|*(Patient sample concentration is estimated from response and calibration curve by the built-in software---indistinguishable from the measurement step for the user)*|
|- Interpret the result based on estimate, margin of error and reference values|- Interpret the result based on estimate, margin of error and reference values|

In the final stages of test development, calibration curve-fitting is followed by assessment of test *performance*. The measurements from the new test, over time and across different labs or instruments, are compared (using standard samples) to estimate reliability. The estimated concentrations of patient samples are compared to an existing *reference* method to assess agreement. Some of the statistical characteristics of the test are summarized from those validation studies and reported to test users and regulators. Underlying those downstream summary metrics are many different statistical methods and several iterations data collection and reduction.

### Need for statistical methods specific for POCT

A precursory review of the literature ---textbooks and CLSI guidelines---and some anecdotal recent publications left us with the impression that there was a lack of detailed information on procedures for statistical characterization of POCTs, especially the development of master calibration curves. 

Statistical procedures used to estimate concentration from observed response have mainly evolved in the context of lab-based assays where control samples are usually included in parallel with the experimental samples. These are especially *plate-based* batch assays where physical space considerations figure prominently in study design. We found that there is very little guidance for POCT *developers* for curve-fitting. 

For test performance statistics, the CLSI guidelines are a good starting point, but are not specific enough for POCTs. Even the literature on making test performance claims for traditional assays is sparse for test developers; the onus seems to be on test users for whom there is plenty of guidance. Manufacturers of other random-access type biomarker testing technologies do not seem to publish detailed methods and results from test development so we cannot glean much from their experience based on published material alone. We believe that statistical methods for POCTs (and other random-access systems) deserve more attention. Hence in this [Grand Challenges Canada](http://www.grandchallenges.ca/grantee-stars/0002-02-02/) funded project, we sought to review and complement the available, but overly general, recommendations for test characterization and validation by focusing on their application to POCTs.

Our results are presented here as a series of brief narrative reviews and detailed tutorials.



<br>
<button type="button" class="btn"><a href="main_sources.html"> Next: Main literature sources &raquo;</a></button>
<br>


## References  



