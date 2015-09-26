---
title: "R installation guide"
output:
  html_document:
    toc: true

bibliography: "../../Literature/library.bib"

---

## R software environment

This first tutorial describes the software configuration we use for data analysis in the R statistical software package. This R installation procedure provides all the analysis and reporting tools required to perform all of the statistical characterisation and validation analyses for test development and create publication-quality reports. A free (but optional) script editor, <a href="http://www.rstudio.com/products/RStudio" target="_blank">RStudio</a>, adds some convenience features. Regardless of which editor you use, there are a few R 'packages' that must be installed from within R before you proceed to the tutorials. All the software installs easily on Windows, Mac and Linux.

Another advantage of R is it is consistent with the recommendations for 'modularity' and transparency advocated in Dudley *et al* [-@Dudley1985].

## Software installation

Begin with bare-bones [R](http://cran.rstudio.com/):

At <http://cran.rstudio.com/> select the link for the latest version of R for your operating system (from the top frame, "Download and Install R"). For example, for Windows follow the Windows link then select "base" or "install R for the first time".  Follow the instructions. 

Consider using <a href="http://www.rstudio.com/products/RStudio" target="_blank">RStudio</a> as your editor:

All the tutorial steps work equally well with the native R editor (aka IDE) and RStudio, but we highly recommend the RStudio interface because of its additional convenience features: syntax highlighting, package management, file browser, plot viewing window, help menus, menus to facilitate creating reports and presentations, interface with version control systems (i.e. git and svn). RStudio installs and integrates the report writing tools we used to produce this website (e.g. Pandoc). These reporting tools also include export to PDF, Microsoft Word and other formats, and are described in more detail later. Select the RStudio 'Installer' download link for your operating system from <http://www.rstudio.com/products/rstudio/download/>.

### R packages

Most data analysis functions ship with the basic installation, but we will need a few more packages for the upcoming tutorials. User-contributed R packages bundle related functions together. For example, 'nlme' and minpack.lm' add cutting-edge nonlinear regression techniques, whereas 'grid.extra', facilitate plot formatting that looks especially good for online viewing.  Other packages include data sets and data preparation functions.

In the 'Console' (at the `>` prompt) enter the lines of code below to install all packages required for this tutorial.

```{.r}
install.packages(c("dplyr", "drc", "ggplot2", "gridExtra", "gthemes",
                    "investr", "knitr", "minpack.lm", "nCal", "nlme",
                    "nlstools", "plotrix",  "plyr", "reshape2",
                    "RColorBrewer"), 
                 repos = "http://cran.us.r-project.org", dependencies = T)                 
```

**You're done!**


### Source files

All the analysis and reporting methods presented in these tutorials use plain text files as input. Despite the possibly unfamiliar file extensions (e.g. `.R, .Rmd, .csv, .md`), they can be opened in any text editor as with `.txt` files (you will get no strange characters or illegible preamble). Basically, a `.R` or `.Rmd` file is opened in the 'Source' window of RStudio. Commands are highlighted and sent to the 'Console' with the 'Run' button or Ctrl-enter.

#### .Rmd structure

In a Rmarkdown script (extension `.Rmd`, also known as a 'knitr' script), report text is written as in any Markdown, plain text or LaTeX document file and R commands are written between code block tags:

>```
>  ```{r [chunk-name], [chunk options]} 
>  [R code]
>  ```  
>```

These 'chunks' are  distinguished from prose and interpreted by the R packages, 'knitr' and 'rmarkdown'. Comments can also be written in the code blocks by starting each comment line with `#` as in plain `.R` files. R-LaTeX scripts are differentiated from R-Markdown scripts by the extension `.Rnw` instead of `.Rmd`. Both choices, as well as the basic `.R` script, are available through RStudio's new document dialogue, which will open a simple template. Sending report text (prose, not code) or an incomplete line of code to the console will produce error messages, but is of no real consequence. If R gets stuck on something, press the stop symbol on the top of the 'Console' window (in RStudio). The [RStudio documentation](https://support.rstudio.com/hc/en-us/categories/200035113-Documentation) is thorough.

For reports, some simple 'mark-up'---character combinations---is used to add formatting instructions to the text for the *parser* or *interpreter*. `.Rmd` files use [Markdown](http://daringfireball.net/projects/markdown/) interpreters for formatting and document structure (e.g. headings). The [Rmarkdown website](http://rmarkdown.rstudio.com/) describes how stand-alone documents such as in MS Word or PDF formats, and websites such as this one are created using RStudio. If you prefer [LaTeX](http://latex-project.org/intro.html) as a mark-up language, a file format similar to `.Rmd`, 'Sweave/noweb' (extension `.Rnw`), follows the same code-text mixing principle with a few alterations in mark-up syntax (R code is the same). Techniques for presentation slides and interactive data-analysis websites are also covered in <a href="http://rmarkdown.rstudio.com/" target="_blank">RStudio's RMarkdown tutorials</a>.

*Coming soon: the source files for this website*
<!--
### This project's working directory

As introduced in [Extras/About this site)](../appendices/about.html), source files for the wiki are organized into sections using folders and separate files for each page. Most of those files (all the sections with analysis steps) were produced from .Rmd files, which are stored in the `source/R` folder. The subdirectories of `source/R` parallel the HTML directory. Copy `source` folders and files to a new directory as a template or working copy in order to preserve the original; of particular risk, the R script [exportHTMLReports.R](../../../source/R/exportHTMLReports.R) in `source/R` will overwrite wiki files. 

This is how our project directory is set up:

- `poctcalibration` contains the following folders:

    + `source` (all the raw inputs)
        - `R` (.R and .Rmd scripts; a folder for each major section)
        - `data` (data files called by scripts)

    + `Reports`
        - `HTML` (the html pages; a folder for each major section)

    
If using these directories and scripts as a template, an important structural features is the relative depth of the directories. For example, the tutorial 5 scripts are 4 levels down from the top directory `poctcalibration` and the formatted HTML directory for tutorial 5 is **also 4 levels down**, but in the `Reports/HTML` directory. Because we're trying to automate as much as possible (minimise point-and-click steps when updating reports), some use of file paths is unavoidable. In order to export this project to other computers, we use relative paths, which means it doesn't matter if my project directory is in `D:/Home/Dropbox/Projects...` and your is in `C:/Users/...` as long as relative positions under the project directory stay the same. Of course, once you are comfortable with the R code, you can alter it as needed---there is nothing hidden within system files, etc. 

More experienced programmers use other command line tools and, for example, Makefiles, to manage the file system commands for a project, but I have been learning system commands from the perspective of a heavy R user, not a broader programming base. Both perspectives work well for R statistical programming. (I've even started using RStudio for editing documents without statistical results because of the great integration with research and writing tools. You can even search PubMed or update your blog from R if you really want to!)
-->

## General R help

These tutorials will not cover all the analysis basics that an introductory text to the R language would. If you want to stray from the scripts (and we recommend you eventually do), you may need a more general understanding of data types and basic operations. There are myriad books and free online tutorials for R. A good general source is <a href="http://www.statmethods.net/" target="_blank"> Quick-R</a>. For a more advanced 'data science' point of view, <a href="http://adv-r.had.co.nz/" target="_blank">Hadley Wickham's "Advanced R" ebook</a> is great and always developing. Or just "Google" for a tutorial with examples related to your field. The R user community is very helpful. 


<br>
<button type="button" class="btn"><a href="calib_overview.html"> Next: Calibration  &raquo;</a></button>
<br>


## References



