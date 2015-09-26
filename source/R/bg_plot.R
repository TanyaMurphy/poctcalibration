par(family = "serif")
plot(ocon$conc2, ocon$od, log = "x", axes = F, pch = 21, bg = "grey", 
     ylab = "Response", xlab = "log (Concentration)", col.lab = "grey", font.lab = 4)
curve(M.4pl(x, 0.1, 1.1, 4300, -0.75), add = T, lty = 3, col = "#FFE4C4", lwd = 3)
box(col="grey")
grid()
text(20000, 0.3, 
     expression(italic(y == d + frac(a - d, 1 + (frac(x, c))^b))), col = "grey")
