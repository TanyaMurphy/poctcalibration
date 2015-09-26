# Graphical preferences for the Achira-McGill project
require(ggplot2)
require(ggthemes)
require(gridExtra)
require(grDevices)
require(plotrix)
# ggplot2 preferences
original.ggplot2.style <- theme_set(theme_bw() +                                       
                                    theme(plot.title = element_text(vjust=2, face="bold"),
                                          axis.title.y = element_text(vjust=0.8), 
                                              axis.title.x = element_text(vjust=0)))

library(RColorBrewer) # requires that RColorBrewer be installed
# Colour palette for plots
blues <- brewer.pal(6, "Blues")

par(cex.main = 1, mar = c(4, 4, 3, 2), oma = c(0.5, 0.5, 2, 0))
