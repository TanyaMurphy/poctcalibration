---
title: "Data Preparation"
---

<!-- Section tabs -->
<br>
<ul class="nav nav-tabs" role="tablist">
  <li><a href="calib_overview.html">&laquo; Back to calibration overview</a></li>
  <li class="active"><a href="calib_tut2_prep_background.html">Background</a></li>
  <li><a href="calib_tut2_prep_data_sets.html">Data sets</a></li>
  <li><a href="calib_tut2_prep_ocon.html">O'Connell's ELISA</a></li>
  <li><a href="calib_tut2_prep_elisa.html">R's ELISA{gtools}</a></li>
</ul>
<br>


*in development*

This tutorial will cover the basics of loading a data set and preparing it for analysis: variable creation, filtering, summarising and transposing into other formats. In these tutorials, we import existing immunoassay data---data sets from R packages aleady in tabular form or from the published literature. The tutorials also show how the data can be converted to a wide table that is nice for viewing or exporting to other software such as GraphPad.

**Important: Do not reduce your raw data to sample means or exclude possible outliers for calibration analyses.**

<br>
<button type="button" class="btn"><a href="calib_tut2_prep_data_sets.html"> Next: Data sets &raquo;</a></button>
<!--
<button type="button" class="btn"><a href="../calibration/calibLit.html"> Skip the software tutorial and go to: Calibration Literature Review &raquo;</a></button>
-->
<br>

<!--



Import your analysis sets from your database 'raw'. Do not calculate variables in the database. You want the observations as is in the database in case you change your methods or assumptions, [have to answer persnickety reviewer questions...]. Let the statistical software do the work and you will have a trail of all your data manipulation steps.

## General principles

Data preparation---also known as cleaning, 'munging', 'wrangling'---varies from quite simple, as in this tutorial, to occupying 80+% of the project time. It's an important and unavoidable part of any major analysis. Surprisingly it even carries some controversy; for example, manual editing in a spreadsheet or database (e.g. Excel or Access) vs importing data raw and documenting the cleaning steps in a script. Some say R is not best suited for data preparation and prefer to first use Python, SAS or some sql tool. It depends what you are familiar with. If R is your first script-based data analysis software, don't worry about it. There are packages and tutorials that will have you up and running as quickly as in any other software. Nevertheless, all but the simplest data should *originally* be entered into software that provides some control, efficiency and security such as a database; see [here and here] for more details. It will greatly reduce data cleaning time.

Once a subset of your data relevant to the current analysis is imported into R's working memory---probably don't need all experimental details, reagent batch numbers, etc---it can be stored and displayed as lists or rectangular tables. Rectangular data sets are pretty standard practice in data analysis, although list-like formats are gaining popularity with web-based storage and transfer. These formats such as .json and .xml differ from the R or BUGS list syntax, which are organized by variable; the former are grouped by record (such as in the BibTeX files) . These distinctions may become increasingly important with the rising popularity of web-based applications, 'BigData' techniques and 'noSQL' databases.

In tabular data sets, the variables are organized by column and each row is an *observation* or *record*. Data sets holding observations that have some repeating structure (replicates within runs, sometimes over several days or instruments) can be 'long' or 'wide'. A long data set will have all of the response data in one long column with some permutation of values or codes for calibrator concentration, run and replicate represented by other columns. Although computer functions more commonly accept long format, more than a dozen or so observations in long format is hard to view and compare results across groups and replicates. Reshaping a data set between long and wide formats is called *transposing*.

The common rectangular data format in R is the 'data.frame', which is a special instance of a matrix. For example, see [Computerworld's guide](http://www.computerworld.com/s/article/9239637/Beginner_s_guide_to_R_Get_your_data_into_R?taxonomyId=9&pageNumber=2) for more about data types in R.


### Data entry and formatting {#cc-dataForm}

Double checking manual data entry should be a standard part of the procedure and file back-ups should be made. Follow good scientific or laboratory practices here as you would in experiments. 

 **Important: Do not reduce your raw data to sample means or exclude possible outliers at this point. Also, do not transform (logarithm, subtracting the negative control, etc) in your original data tables; this is best done, as needed, in exported analysis data sets.**

Concentrations in rows, with any samples of unknown concentration below the known concentrations, has good [universality/portability]. Within a group, the data points in a replicate column may have nothing extra in common compared to the other within-group replicates, or they may be related as a serial dilution or belonging to a specific negative or positive control that is physically linked by chip, etc. These details will not be inherent to the data set structure so they must be carefully recorded in the data dictionary. ^[GraphPad organizes the columns as groups of replicates and groups are forced to have the same number of replicate columns, but they can be left blank and statistical functions can accommodate *unbalanced* groups. The group header is any free text description, but it will not be exported and identifying the data by position could be important, so record that---check these facts. Also need to understand R and BUGS lists and structures better.] These details can be represented in the statistical model.

Data sets can be stored as lists or rectangular tables (`data.frames` in R).  `Data.frames` holding data that has some sort of repeating structure (groups, replicates) can be 'long' or 'wide'. A long `data.frame` will have all the response data in one long column with some permutation of the calibrator concentration, group and replicate labels represented by 3 other columns.  Entering data in this format by hand is more error prone for the concentration, run and replicate labels (simply due to amount of repetition), and it is hard to view and compare results across groups and replicates.  The computer functions like it, though.  

Some curve fitting software or graphing procedures default to using log(concentration) and will not accept any zero values. **In a copy of your original data file**, change zero values to some near-zero value. Consider the effect on the log scale, however: '1' may be best if your lowest non-zero concentrations are [large-ish] integers. In that case, a substitution of 0.01 would plot the 'zero' calibrator 2 full steps behind for lowest calibrator on the log~10~ scale. Is this a good approximation of the pattern?

## EDA Background 

Data analysis for assay development requires a different reasoning framework than one typically learns in general statistics courses or uses in experimental sciences. For example in some biochemistry experiment, we have a compound of interest with some expected effect in lab rats. After the experiment is conducted we measure the effect in two groups of rats---controls and the experimental arm. Assuming a continuous outcome such as growth, the difference in the mean growth between the two groups is the correct parameter to estimate. Ones confidence in the estimated mean difference is rightly some multiple of the *standard error of the mean*; for example, a 95% confidence interval is the mean +/- 2 standard errors. Also, how well dose of the experimental compound, for example, explains the differences in growth could be expressed as an R-squared statisic---you weren't sure if or how much the compound would influence growth.

**In test characterisation we are ultimately interested in very different parameters.** For one, we *know* there is a relationship between concentration and response. Secondly, unlike some other applications that use calibration curves, we are not interested in estimating the mean concentration in some group, such as a toxin x in a number of test sites in the shore of a lake near the ACME chemical plant. We are interested in the estimated concentration of a series of individual results and the measurement error (or reliability) of those results. The parameter of interest is the  *standard deviation* of test results (after accounting for concentration). That may seem counter intuitive because it seems that estimated concentration should be the parameter of interest, but it isn't really a parameter---there isn't a group of patients for whom we are trying to estimate their mean analyte level.

Luckily we don't need to invent a new framework from which to reason through this problem. Standard deviation is often called *sigma* and the established manufacturing practice "Six sigma" refers to that sigma. [Someone] standardized/popularized the practice in [some decade]. It has since been adapted to business in general. It basically says this:

A company manufactures widgets. The widgets must be between 100 mm and 124 mm in diameter or the widget is incompatible with the other parts of the machine. While it is not theoretically possible to completely eliminate all such catastrophic errors, the company's profits and reputation can absorb such an error about 3 times in every million widgets made. Continuous characterics such as diameter are usually normally distributed. The parameters of a normal distribution are mean and standard deviation (or variance). The area under the normal curve, or probability density, is 68% of the total density in the mean +/- 1 SD, 95% in +/- 2 SD, and so on;  observations fall in the area past +/- 6 SD about 3 per million. Hence, the generally accepted catastrophic event rate, a "six-sigma" event, is expected to occur only 3 times per million parts made in our example if our manufacturing process has standard deviation of *sigma*. The widget in question has a mean diameter of 112 mm and a standard deviation of 3 mm. The absolute difference between the mean, 112, and the acceptable limits (100 or 124) is 12. 12 divided by 6 is 2, so a standard deviation of 3 is asking for trouble. They need to improve their process and get the standard deviation down to 2 mm. 

That is not done with statistics. Statistical methods are used to *estimate sigma*. There is some true value of *sigma* and if we could measure many thousands of widgets, we could get a very good estimate of *sigma* using simple calculations; statistical inference would be probably be a moot point. On the other hand, observing the diameter of 2 or 3 random widgets would not allow us to estimate *sigma* accurately even using the latest and greatest statistical methods. So how do we choose a sample size for our data collection?

- What is your target *sigma*?

- What is an acceptable range for *sigma*?

- Does target *sigma* differ by analyte concentration?

If setting a target *sigma* based on the six-sigma guideline is not realistic---we are dealing with natural compounds, after all, not manufactured parts---decide on a conservative, but realistic catastrophi event rate (maybe 1 in 100,000) and consult [this chart] to see how many standard deviations it corresponds to in the normal distribution..

One would assume at least some correlation between observations in the same run because experimental conditions during a run should be more constant than those between runs. Nevertheless, replicates within runs (for the same concentration) are *not* identical. The variation in response between replicates in the same run can be called *within-run* variability, the inverse of *repeatibility*. *Between-run* variability is the inverse of *reproducibility* or *interim precision*. We will evaluate repeatability and reprodicibility more formally in the test performance chapter and tutorials. 

[All] the analyses from this point on relate to minimising and describing those errors; that is, we want to be as certain as possible that we are describing the true error inherent in the system and not making it appear that there is more or less error because of a poor choice of statistical model or insufficient data. Of course, we do not know the *truth*. Instead we will try to infer reasonable conclusions based on certains premises, or *assumptions* inherent in the models we choose. 

Notably, we assume the observed data are a representative sample of all the possible samples of observations we could [theoretically] get from the system (under a particular set of conditions), and that the variability around the mean response (by concentration) is normally distributed. (When that second assumption is not reasonable, we could use 'non-parametric' methods, but the normality assumption seems reasonable based on the descriptive statistics in the last tutorial and general knowledge of immunoassays.) The errors are also assumed to be random [or independent of one another]. 


****

**Box x. NSB adjustment**

Adjustment was done by subtracting the blank, by run, from each of its 'run-mates' then adding back the **overall blank mean**. This has the effect of reducing some difference between runs (by setting the background noise equal for each run), but keeping the signal measurements in the original range. 

Rationale: It may or may not be important to have the response values in the original range, but there is no downside. That is, one small downside may be not having the series starting at zero, on average, which would have the curve *go through the origin*, but linear transformations do not affect conclusions about regression parameters (from curve-fitting). The main advantage to not having values artificially in the zero range (i.e. due to subtraction and not because the signals were originally read in that range) is it avoids negative values and very small values. Very small values take on big proportions on the log scales or relative scales, which we will use in variance regression, weighting and some parameterisations of the logistic models. For example, after the blank is sustracted, some signal values for the 2.048 calibrators are negative (due to random error)---the mean actually turns out negative. A decision would have to be made at various analysis steps about what to replace the negative values with because we can't take the log of a negative value or give a negative weight to a group of observations. On a linear scale, a value of 0.001 or 0.01 is trivial, but on a log-scale that is a big difference with a lot of leverage. 

****

### R code

These tutorials use the `ggplot2` plotting package. See [our ggplot gallery page](OtherContent/ggplot2 themes.html) for other formatting themes (and a little comic relief). [Quick-R has good instructions for `base` plotting syntax](http://www.statmethods.net/graphs/scatterplot.html).

(I am starting to warm up to Hadley Wickam's packages `plyr` and `dplyr`, `reshape2, ggplot2`. I think he is a bit of a mad genius and his syntax turned me off at first, but Google searches for data manipulation steps I want to do keep turning up his functions. Also, I like his default plots for HTML output---looks more polished---and there are good printable themes.)  

Using the log of concentration closes the gap between the higher concentration calibrators and the lower ranges, but sometimes it complicates the relationship between concentration and response. 

Outside advice? 

- "...if results close to zero are of interest, then a linear dose scale should be used." [@Law2005, p. 177]

<!--

How should we deal with potential outliers?

```{r}
# All Group D data:
# The variance trend for Group D looks so nice other than the 25 calibrator.  Are one of the points
# sufficiently different to be considered an 'outlier'?
1670 + 3*122 # 99% UCL=2036; 1883 is well within that.  Or should it be the mean and SD without that point?
mean.D25 <- mean(c(1655, 1614, 1612, 1583))
sd.D25 <- sd(c(1655, 1614, 1612, 1583))

mean.D25 + 3*sd.D25 # 99% UCL=1705.  
# Which is the correct criteria? If any? ...especially based on 5 points...
# I think http://web.eecs.umich.edu/~fessler/papers/files/tr/stderr.pdf is showing that the approximation 
# for the SE_standard deviation stabilizes (asymptotically...) for n ~> 10.
# So although the approximation is not good for our sample of 4, the 95% UCL for the SD might be
# around 
uCL.SD.D25 <- sd.D25 + 1.9*sd.D25*1/sqrt(6)
mean.D25 + 3*uCL.SD.D25
```

#### Exploratory data analysis {#cc-EDA}

It is a good idea to get to know your data well before proceeding with statistical analyses. There may be patterns or problematic individual observations that stand out to the naked eye that could be hidden by summary statistics and models. Resist any temptation to remove extreme observations that could be 'outliers' at this point unless they are obviously and unequivocally a data entry error (or some other gross error).

##### Graphical summaries {#cc-EDA-graph}

Simply plotting all the data---calibrator concentration on the x-axis and response on the y-axis---is a great beginning. It is conventional to use a log scale for the x-axis (and sometimes the y-axis). This can help visualize all the data if the concentration range is wide. It may also reflect important changes in concentration in clinical use; for example, a doubling of hCG is a useful clinical benchmark (ref). Changes in other analytes, however, such as glucose, are important on a linear scale. Log transformation of concentration should not be done automatically or blindly, but only when it helps interpretation or visualisation, and then the log base should be chosen accordingly. With modern computing, log transformations do not help in curve fitting and can introduce some complications in calculating the imprecision statistics (ref).

> "Dose scale: In general, the sigmoid log dose response curves are easier to appreciate, and with which to understand changes. However, if results close to zero are of interest, then a linear dose scale should be used. The latter allows the zero standard (B~0~) to be employed in regression analysis, which may improve the definition of the asymptote." ---Immunoassay: A practical guide ed. by Brian Law, p.177

##### Outliers {#cc-EDA-out}

When is a data point likely a mistake? 'Outliers' should rarely be dropped from the data set used to fit the calibration curve. [One must use generous criteria, if at all, and groups of 2 or 3 data points are not sufficient to make a judgement.] Weighting methods based on variance will reduce the effect of outliers while keeping the model generalizable to scenarios expected to be seen in practice.


##### Transformations

While GraphPad instructs us to use the logarithm of concentration (*log(x)*), other sources of advice (i.e. Handbook, Findlay) do not explicitly make recommendations. From a statistical point of view, when the data are largely clustered at the low end of the range with a few higher values much further out, estimation is difficult---on a linear scale, dose in GraphPad's `Antagonist` data set is virtually a binary predictor. On the log~10~ scale, however, there is nice variation in the data, and we see that large changes in response by order magnitude in the lower range of the test. Indeed, were a linear model chosen for the `Antagonist` data, *log(x)* would be a good strategy. In the data we typically we with Achira's tests, however, the concentration range spans 2, sometimes 3, orders of magnitude and we do not see the greatest change happening in the lower ranges---a more incremental change. Therefore, we recommend making the decision to *log(x)* or not should be based on the concentration range of the test; that is, there is nothing inherent to the 4- or 5-PL function that requires *log(x)*. 

### Removed from ocon.Rmd

This time the code from the source file is shown in the HTML document, but in subsequent tutorials, the code will be hidden in the formatted document using the chunk option `include=FALSE`. See the [knitr help](http://yihui.name/knitr/options) for other chunk options.

```
# If you don't like our ggplot options, reset default
# theme_set(original.ggplot2.style)

```

Entering data in long format by hand is more error prone for repeated labels (simply due to amount of repetition), and it is hard to view and compare results across groups and replicates.  Computer functions like it, though.  


We also introduce the data type, 'factor'. This tutorial will not illustrate the range of uses for factors so see the [Quick-R data types page](http://www.statmethods.net/input/datatypes.html) for more details---working with factors can be a little tricky in some situations. 


## References

-->
