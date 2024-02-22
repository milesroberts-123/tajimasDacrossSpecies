# To get run numbers for panicum halli
# Copy bioprojects from table S1 in this publication: https://doi.org/10.1038/s41467-018-07669-x
# to a list in doc/panicum_halli_search.txt
# then use regular expressions to make a query to be used with ENTREZ
# cat panicum_halli_search.txt | tr '\n' ' ' | sed 's/ / OR /g'
# esearch -db sra -query $QUERY | efetch --format runinfo > panicum_halli.csv

#
https://stackoverflow.com/questions/67794202/fatal-error-with-ggplot-after-updating-to-latest-rstudio-version

#
"SRR14552933" "SRR14470440" "SRR14470037" "SRR14469942" "SRR14470105" "SRR14552823"

"SRR14552933" "SRR14470440" "SRR14470037" "SRR14469942" "SRR14470105" "SRR14552823"

#
"SRR12902350" "SRR13015480" "SRR12918659" "SRR12902295" "SRR12902116" "SRR12918979"

"SRR12902350" "SRR13015480" "SRR12918659" "SRR12902295" "SRR12902116" "SRR12918979"

"SRR12902350" "SRR13015480" "SRR12918659" "SRR12902295" "SRR12902116" "SRR12918979"

"SRR13014735" "SRR13015355" "SRR13015341" "SRR12834332" "SRR12902323" "SRR13015691"

#
SAMN05660343

#

> mod_pi = pgls(log10(WCVP.popsize) ~ log10(pi) + log10(totalbp/(nidv*genome.size)) + nidv + log10(genome.size), compdata)
> summary(mod_pi)

Call:
  pgls(formula = log10(WCVP.popsize) ~ log10(pi) + log10(totalbp/(nidv * 
                                                                    genome.size)) + nidv + log10(genome.size), data = compdata)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.72360 -0.12329 -0.02051  0.16214  1.37396 

Branch length transformations:
  
  kappa  [Fix]  : 1.000
lambda [Fix]  : 1.000
delta  [Fix]  : 1.000

Coefficients:
  Estimate  Std. Error t value  Pr(>|t|)    
(Intercept)                         35.54998469  4.70742967  7.5519 5.356e-11 ***
  log10(pi)                            1.25268923  0.23004838  5.4453 5.275e-07 ***
  log10(totalbp/(nidv * genome.size)) -0.86412361  0.27405590 -3.1531 0.0022574 ** 
  nidv                                -0.00060475  0.00019749 -3.0622 0.0029715 ** 
  log10(genome.size)                  -2.16317612  0.54236979 -3.9884 0.0001438 ***
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3615 on 82 degrees of freedom
Multiple R-squared: 0.6183,	Adjusted R-squared: 0.5996 
F-statistic:  33.2 on 4 and 82 DF,  p-value: < 2.2e-16 
> 
  > mod_jac = pgls(log10(WCVP.popsize) ~ jac + log10(totalbp/(nidv*genome.size)) + nidv + log10(genome.size), compdata)
> summary(mod_jac)

Call:
  pgls(formula = log10(WCVP.popsize) ~ jac + log10(totalbp/(nidv * 
                                                              genome.size)) + nidv + log10(genome.size), data = compdata)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.69259 -0.14729 -0.01656  0.15277  1.33915 

Branch length transformations:
  
  kappa  [Fix]  : 1.000
lambda [Fix]  : 1.000
delta  [Fix]  : 1.000

Coefficients:
  Estimate  Std. Error t value  Pr(>|t|)    
(Intercept)                         12.81246837  7.27026134  1.7623  0.081743 .  
jac                                  4.01485823  0.69211409  5.8009 1.195e-07 ***
  log10(totalbp/(nidv * genome.size))  0.77961107  0.29032833  2.6853  0.008768 ** 
  nidv                                -0.00090472  0.00019193 -4.7138 9.825e-06 ***
  log10(genome.size)                  -0.35343751  0.75090991 -0.4707  0.639120    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3552 on 82 degrees of freedom
Multiple R-squared: 0.6315,	Adjusted R-squared: 0.6135 
F-statistic: 35.13 on 4 and 82 DF,  p-value: < 2.2e-16 
> 
  > mod_bcd = pgls(log10(WCVP.popsize) ~ bcd + log10(totalbp/(nidv*genome.size)) + nidv + log10(genome.size), compdata)
> summary(mod_bcd)

Call:
  pgls(formula = log10(WCVP.popsize) ~ bcd + log10(totalbp/(nidv * 
                                                              genome.size)) + nidv + log10(genome.size), data = compdata)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.24792 -0.12384  0.01189  0.18057  0.85289 

Branch length transformations:
  
  kappa  [Fix]  : 1.000
lambda [Fix]  : 1.000
delta  [Fix]  : 1.000

Coefficients:
  Estimate  Std. Error t value  Pr(>|t|)    
(Intercept)                          9.68376495  5.72064974  1.6928 0.0942949 .  
bcd                                 10.26947244  1.21401864  8.4591 8.575e-13 ***
  log10(totalbp/(nidv * genome.size))  1.01562155  0.25076430  4.0501 0.0001156 ***
  nidv                                -0.00159581  0.00019089 -8.3597 1.351e-12 ***
  log10(genome.size)                  -0.17126798  0.57882456 -0.2959 0.7680627    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3083 on 82 degrees of freedom
Multiple R-squared: 0.7224,	Adjusted R-squared: 0.7089 
F-statistic: 53.36 on 4 and 82 DF,  p-value: < 2.2e-16 




#

mywrapper <- function(data, xcol, ycol, colorVar) {
  plot <- ggplot(data = data, aes_string(x = xcol, y = ycol, color = colorVar)) + geom_point()
  print(plot)
  return(plot)
}

#

Call:
  lm(formula = log10(tf) ~ log10(sweepS) + h + log10(mu) + log10(R) + 
       tau + sigma + sigma2 + sigma * h + f0 + f1 + N + n + lambda + 
       n * lambda + rcat, data = fix_times)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.24797 -0.17344 -0.02458  0.13214  1.84352 

Coefficients:
  Estimate Std. Error  t value Pr(>|t|)    
(Intercept)    7.402e+00  7.843e-02   94.378  < 2e-16 ***
  log10(sweepS) -4.814e-01  2.782e-03 -173.021  < 2e-16 ***
  h              6.245e-02  1.111e-02    5.622 1.91e-08 ***
  log10(mu)     -1.164e-03  7.407e-03   -0.157  0.87514    
log10(R)       2.081e-03  1.380e-03    1.508  0.13153    
tau            2.691e-07  1.116e-05    0.024  0.98076    
sigma          2.760e-03  2.425e-02    0.114  0.90940    
sigma2        -1.862e-02  2.160e-02   -0.862  0.38854    
f0             2.109e+00  4.971e-02   42.424  < 2e-16 ***
  f1            -5.638e+00  4.939e-02 -114.164  < 2e-16 ***
  N              1.955e-04  1.105e-05   17.694  < 2e-16 ***
  n             -9.474e-03  9.849e-03   -0.962  0.33610    
lambda        -7.095e-04  1.173e-03   -0.605  0.54517    
rcat2-cycle    6.108e-02  5.069e-03   12.050  < 2e-16 ***
  rcatchaos     -1.350e-02  5.068e-03   -2.663  0.00775 ** 
  rcatgrowing    7.817e-02  5.069e-03   15.422  < 2e-16 ***
  rcatshrinking -7.232e-02  5.069e-03  -14.268  < 2e-16 ***
  h:sigma       -2.523e-02  1.939e-02   -1.301  0.19316    
n:lambda       6.453e-04  7.439e-04    0.868  0.38566    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2775 on 29980 degrees of freedom
Multiple R-squared:  0.608,	Adjusted R-squared:  0.6078 
F-statistic:  2584 on 18 and 29980 DF,  p-value: < 2.2e-16

#
Call:
  glm(formula = fails ~ log10(sweepS) + h + log10(mu) + log10(R) + 
        tau + sigma + sigma2 + sigma * h + f0 + f1 + N + lambda + 
        n + n * lambda + rcat, family = "quasipoisson", data = fix_times)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-44.096   -7.206   -4.368    0.948  125.778  

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)    4.876e+00  3.694e-01  13.202  < 2e-16 ***
  log10(sweepS) -5.041e-01  1.352e-02 -37.287  < 2e-16 ***
  h             -8.067e-01  5.397e-02 -14.947  < 2e-16 ***
  log10(mu)      7.202e-03  3.514e-02   0.205   0.8376    
log10(R)      -1.384e-02  6.547e-03  -2.114   0.0345 *  
  tau            5.908e-05  5.317e-05   1.111   0.2665    
sigma         -3.576e-02  1.133e-01  -0.316   0.7523    
sigma2        -8.433e-02  1.031e-01  -0.818   0.4135    
f0             2.037e+01  2.108e-01  96.607  < 2e-16 ***
  f1            -1.164e+00  2.301e-01  -5.060 4.22e-07 ***
  N              4.997e-04  5.247e-05   9.523  < 2e-16 ***
  lambda        -3.617e-03  5.250e-03  -0.689   0.4909    
n             -7.643e-01  4.951e-02 -15.438  < 2e-16 ***
  rcat2-cycle    3.918e-01  2.427e-02  16.140  < 2e-16 ***
  rcatchaos      5.627e-01  2.355e-02  23.896  < 2e-16 ***
  rcatgrowing   -2.741e-02  2.677e-02  -1.024   0.3057    
rcatshrinking -1.201e-01  2.756e-02  -4.358 1.32e-05 ***
  h:sigma        2.312e-01  9.395e-02   2.461   0.0139 *  
  lambda:n       1.315e-03  3.750e-03   0.351   0.7259    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for quasipoisson family taken to be 152.7203)

Null deviance: 5436965  on 29998  degrees of freedom
Residual deviance: 3127675  on 29980  degrees of freedom
AIC: NA

Number of Fisher Scoring iterations: 6




#
Call:
  lm(formula = log10(tf) ~ log10(sweepS) + h + log10(mu) + log10(R) + 
       tau + sigma + sigma2 + sigma * h + f0 + f1 + N + n + rcat, 
     data = fix_times)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.24894 -0.17353 -0.02443  0.13184  1.84390 

Coefficients:
  Estimate Std. Error  t value Pr(>|t|)    
(Intercept)    7.392e+00  7.707e-02   95.914  < 2e-16 ***
  log10(sweepS) -4.814e-01  2.782e-03 -173.020  < 2e-16 ***
  h              6.235e-02  1.111e-02    5.612 2.01e-08 ***
  log10(mu)     -1.243e-03  7.407e-03   -0.168  0.86669    
log10(R)       2.089e-03  1.380e-03    1.514  0.13015    
tau            3.285e-07  1.116e-05    0.029  0.97651    
sigma          2.734e-03  2.425e-02    0.113  0.91023    
sigma2        -1.863e-02  2.160e-02   -0.863  0.38835    
f0             2.109e+00  4.971e-02   42.423  < 2e-16 ***
  f1            -5.638e+00  4.939e-02 -114.164  < 2e-16 ***
  N              1.955e-04  1.105e-05   17.689  < 2e-16 ***
  n             -1.399e-03  3.206e-03   -0.436  0.66255    
rcat2-cycle    6.105e-02  5.069e-03   12.045  < 2e-16 ***
  rcatchaos     -1.355e-02  5.068e-03   -2.673  0.00753 ** 
  rcatgrowing    7.817e-02  5.069e-03   15.423  < 2e-16 ***
  rcatshrinking -7.232e-02  5.069e-03  -14.267  < 2e-16 ***
  h:sigma       -2.511e-02  1.939e-02   -1.295  0.19531    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2775 on 29982 degrees of freedom
Multiple R-squared:  0.608,	Adjusted R-squared:  0.6078 
F-statistic:  2907 on 16 and 29982 DF,  p-value: < 2.2e-16


#
glm(formula = fails ~ log10(sweepS) + h + log10(mu) + log10(R) + 
      tau + f0 + f1 + N + lambda + n + r + sigma + sigma2 + sigma * 
      h, family = "quasipoisson", data = fix_times)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-44.770   -7.215   -4.383    0.981  124.849  

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)    4.805e+00  3.644e-01  13.187  < 2e-16 ***
  log10(sweepS) -5.047e-01  1.352e-02 -37.330  < 2e-16 ***
  h             -8.051e-01  5.401e-02 -14.906  < 2e-16 ***
  log10(mu)      8.999e-03  3.516e-02   0.256   0.7980    
log10(R)      -1.356e-02  6.548e-03  -2.071   0.0383 *  
  tau            5.518e-05  5.317e-05   1.038   0.2994    
f0             2.037e+01  2.109e-01  96.596  < 2e-16 ***
  f1            -1.186e+00  2.301e-01  -5.154 2.57e-07 ***
  N              4.972e-04  5.249e-05   9.472  < 2e-16 ***
  lambda        -1.824e-03  1.750e-03  -1.042   0.2972    
n             -7.475e-01  1.630e-02 -45.870  < 2e-16 ***
  r              2.300e-01  6.434e-03  35.746  < 2e-16 ***
  sigma         -3.980e-02  1.133e-01  -0.351   0.7254    
sigma2        -8.145e-02  1.031e-01  -0.790   0.4297    
h:sigma        2.299e-01  9.404e-02   2.445   0.0145 *  
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for quasipoisson family taken to be 152.8066)

Null deviance: 5436965  on 29998  degrees of freedom
Residual deviance: 3129222  on 29984  degrees of freedom
AIC: NA

Number of Fisher Scoring iterations: 6



#
Call:
  lm(formula = log10(tf) ~ log10(sweepS) + h + log10(mu) + log10(R) + 
       tau + sigma + sigma2 + sigma * h + f0 + f1 + N + lambda + 
       n + r + K, data = fix_times)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.00005 -0.18252 -0.01897  0.15571  1.76524 

Coefficients: (2 not defined because of singularities)
Estimate Std. Error  t value Pr(>|t|)    
(Intercept)    4.546e+00  8.169e-02   55.655  < 2e-16 ***
  log10(sweepS) -4.376e-01  2.352e-03 -186.038  < 2e-16 ***
  h              5.692e-02  1.397e-02    4.073 4.65e-05 ***
  log10(mu)     -2.298e-04  9.328e-03   -0.025   0.9803    
log10(R)       2.326e-03  1.755e-03    1.326   0.1850    
tau           -2.291e-05  1.405e-05   -1.630   0.1030    
sigma          3.508e-02  3.075e-02    1.141   0.2540    
sigma2        -3.489e-02  2.729e-02   -1.279   0.2011    
f0             1.137e+00  3.138e-02   36.247  < 2e-16 ***
  f1            -2.630e+00  3.142e-02  -83.715  < 2e-16 ***
  N              1.834e-04  1.407e-05   13.032  < 2e-16 ***
  lambda         1.143e-03  4.680e-04    2.442   0.0146 *  
  n              3.779e-03  1.818e-03    2.079   0.0376 *  
  r                     NA         NA       NA       NA    
K                     NA         NA       NA       NA    
h:sigma       -2.433e-02  2.440e-02   -0.997   0.3187    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2873 on 19986 degrees of freedom
Multiple R-squared:  0.6842,	Adjusted R-squared:  0.684 
F-statistic:  3331 on 13 and 19986 DF,  p-value: < 2.2e-16


#
expected_seg_sites = function(N,mu,sigma){

4*mu*(N/(1 + sigma/(2-sigma)))*sum(1/(N-1))

}

#
castanea_mollissima
juglans_regia
ziziphus_jujuba

# species with no height data in EOL
"Amaranthus hypochondriacus" "Arachis ipaensis"           "Benincasa hispida"          "Capsella grandiflora"      
[5] "Chenopodium quinoa"         "Cucurbita argyrosperma"     "Digitaria exilis"           "Dioscorea rotundata"       
[9] "Glycine soja"               "Lens ervoides"              "Lotus japonicus"            "Macadamia integrifolia"    
[13] "Malus domestica"            "Musa acuminata"             "Nelumbo nucifera"           "Oryza glaberrima"          
[17] "Oryza rufipogon"            "Populus trichocarpa"        "Rhododendron griersonianum" "Vanilla planifolia"        
[21] "Xanthoceras sorbifolium" 

#
"#021326" "#515A79" "#A36267" "#E99973" "#FDF4D9"

#
"#021326" "#294B70" "#6B5F76" "#A36267" "#E57A61" "#E5B488" "#FDF4D9"

#
Salix tetrasperma
#
Raphanus raphanistrum subsp. sativus
#
Populus tristis
#
Erythranthe guttata
#
Vicia lenticula
#
Dioscorea cayenensis subsp. rotundata

#
species_dist = wcvp_distribution(
taxon = "Arabidopsis thaliana"
rank = "species",
native = TRUE,
introduced = FALSE,
extinct = FALSE,
location_doubtful = FALSE,
)

st_area(species_dist)

#
"#FFCE66" "#C07348" "#773339" "#4C3D72" "#5F88C3" "#80E6FF"

#
"#021326" "#3B5378" "#7F5F70" "#CE685E" "#E5AA7F" "#FDF4D9"

#
SraRunInfo_corylus_americana_PRJNA625120.csv.gz

#
4928539

#
2703230

#
5678457

#
2982748

#
2982385

#
2706415

#
4932502 7387585

#
2706411

#
5358812

#
3052680

#
8395719

#
11742811

#
2705185

#
2931738

#
2930397

#
7626470 5289666

#
3172620

#
4121049

#
2878688

#
8324181

#
3020791

#
3021284

#
5350488

#
2705162

#
4135983

#
2703463

#
7738766

#
8406703

#
2873896

#
3972444

#
3972444

#
4205640

#
6313800 8151496

#

3152653

#
3934083

#
5359681

#
2754392 2754837

#
3625708

#
7885624

#
2895317

#
2895528

#
Coffea canephora

#
2947330

#
5333237

#
3799221

#
5361880

#
p<- ggplot(df2, aes(x=dose, y=len, group=supp, color=supp)) + 
  geom_line() +
  geom_point()+
  geom_errorbar(aes(ymin=len-sd, ymax=len+sd), width=.2,
                 position=position_dodge(0.05))
                 
#
Coefficients:
  Estimate Std. Error t value  Pr(>|t|)    
(Intercept)  6.994809   0.651451 10.7373 3.997e-15 ***
  scale(pi)   -0.473634   0.149922 -3.1592  0.002571 ** 
  scale(bcd)   0.578056   0.035827 16.1346 < 2.2e-16 ***
  
#
Coefficients:
  Estimate Std. Error t value  Pr(>|t|)    
(Intercept)          7.008209   0.657308 10.6620 6.661e-15 ***
  scale(pi)           -0.480066   0.151916 -3.1601  0.002585 ** 
  scale(bcd)           0.563273   0.051451 10.9479 2.665e-15 ***
  scale(totalbp/nidv) -0.075180   0.186425 -0.4033  0.688339  

#
Show in New WindowClear OutputExpand/Collapse Output

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:
  
  filter, lag

The following objects are masked from ‘package:base’:
  
  intersect, setdiff, setequal, union

Loading required package: ape

Attaching package: ‘ape’

The following object is masked from ‘package:dplyr’:
  
  where

Loading required package: MASS

Attaching package: ‘MASS’

The following object is masked from ‘package:dplyr’:
  
  select

Loading required package: mvtnorm
Registered S3 method overwritten by 'data.table':
  method           from
print.data.table     
data.table 1.14.8 using 1 threads (see ?getDTthreads).  Latest news: r-datatable.com

Attaching package: ‘data.table’

The following objects are masked from ‘package:dplyr’:
  
  between, first, last

Show in New WindowClear OutputExpand/Collapse Output
species
<chr>
  h
<dbl>
  ntotal
<int>
  nvariant
<int>
  ninvariant
<int>
  pi
<dbl>
  bcd
<dbl>
  Actinidia chinensis	3.760000e+01	5799545	104	5799441	6.483267e-06	0.2919747	
Amaranthus hypochondriacus	1.389610e+04	3443746	77705	3366041	4.035169e-03	0.3740617	
Ananas comosus	5.504433e+04	3699292	350017	3349275	1.487969e-02	0.4742457	
Arabidopsis halleri	3.143066e+04	4732743	228408	4504335	6.641108e-03	0.3294606	
Arabidopsis lyrata	5.874893e+04	4478756	865260	3613496	1.311724e-02	0.4449381	
Arabidopsis suecica	3.252213e+04	10380293	119480	10260813	3.133065e-03	0.2181825	
Arabidopsis thaliana	3.458560e+04	4234905	442279	3792626	8.166794e-03	0.4815617	
Arabis alpina	1.699751e+04	122463	122463	0	1.387971e-01	0.2646135	
Arabis nemorensis	5.739823e+03	4644164	14489	4629675	1.235922e-03	0.1913472	
Arachis hypogaea	0.000000e+00	10060178	0	10060178	0.000000e+00	0.4777766	
...
1-10 of 74 rows | 1-7 of 13 columns
Show in New WindowClear OutputExpand/Collapse Output

Show in New WindowClear OutputExpand/Collapse Output
[1] 0.1330065
[1] 0.05217481
[1] 0.09785274
[1] -0.06411988
[1] -0.1669882
[1] 0.08553325
[1] 0.1524288
[1] 0.1713082
Show in New WindowClear OutputExpand/Collapse Output

Call:
  pgls(formula = log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(totalbp/nidv), 
       data = compdata)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.39463 -0.06737 -0.00417  0.06309  0.43897 

Branch length transformations:
  
  kappa  [Fix]  : 1.000
lambda [Fix]  : 1.000
delta  [Fix]  : 1.000

Coefficients:
  Estimate Std. Error t value  Pr(>|t|)    
(Intercept)          7.008209   0.657308 10.6620 6.661e-15 ***
  scale(pi)           -0.480066   0.151916 -3.1601  0.002585 ** 
  scale(bcd)           0.563273   0.051451 10.9479 2.665e-15 ***
  scale(totalbp/nidv) -0.075180   0.186425 -0.4033  0.688339    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1365 on 54 degrees of freedom
Multiple R-squared: 0.8424,	Adjusted R-squared: 0.8337 
F-statistic: 96.23 on 3 and 54 DF,  p-value: < 2.2e-16 
Show in New WindowClear OutputExpand/Collapse Output


R version 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> rm(list = ls())
> 
  > library(dplyr)

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:
  
  filter, lag

The following objects are masked from ‘package:base’:
  
  intersect, setdiff, setequal, union

> library(ggplot2)
> library(caper)
Loading required package: ape

Attaching package: ‘ape’

The following object is masked from ‘package:dplyr’:
  
  where

Loading required package: MASS

Attaching package: ‘MASS’

The following object is masked from ‘package:dplyr’:
  
  select

Loading required package: mvtnorm
> library(stringr)
> library(data.table)
Registered S3 method overwritten by 'data.table':
  method           from
print.data.table     
data.table 1.14.8 using 1 threads (see ?getDTthreads).  Latest news: r-datatable.com

Attaching package: ‘data.table’

The following objects are masked from ‘package:dplyr’:
  
  between, first, last

> library(cowplot)
> #library(scico)
  > 
  > today = Sys.Date()
> # List input files
  > pi = list.files("../results/2023-03-26/genome-wide-pi", full.names = T)
> bcd = list.files("../results/2023-03-26/bray-curtis-dissimilarities", full.names = T)
> jac = list.files("../results/2023-03-26/jaccard-dissimilarities", full.names = T)
> 
  > # for now, remove species that can't be processed further for whatever reason
  > jac = jac[-58]
> bcd = bcd[-58]
> 
  > # get species IDs
  > species = gsub("_pairwise-pi.txt", "", gsub("../results/2023-03-26/genome-wide-pi/", "", pi))
> 
  > # Load input files
  > pi = lapply(pi, fread, header = T, data.table = F)
> bcd = lapply(bcd, fread, header = F, data.table = F)
> jac = lapply(jac, fread, header = F, data.table = F)
> 
  > # calculate mean pairwise dissimilarity
  > bcdMean = lapply(bcd, function(x){mean(x[,2])})
> jacMean = lapply(jac, function(x){mean(x[,2])})
> 
  > # calculate average number of k-mers included in union
  > unionMean = lapply(jac, function(x){mean(x[,4])})
> 
  > # calculate number of individuals sampled for each dataset
  > # You get this equation by rewriting the formula for the number of pairwise comparisons (n^2 - n)/2 = N as a polynomial and applying the quadratic formula
  > backCalcN = function(x){
    +   sqrt(1/4 + 2*nrow(x)) + 1/2
    + }
> 
  > nidv = lapply(bcd, backCalcN)
> 
  > # cbind all diversity data into one dataframe per species
  > alldiv = Map(cbind, pi, bcdMean, jacMean, unionMean, nidv)
> 
  > # Some species have extra data, remove for now
  > speciesWithExtraData = which(unlist(lapply(alldiv, ncol)) == 12)
> for(i in speciesWithExtraData){
  +   alldiv[[i]] = alldiv[[i]][,c(1, 3:6, 9:12)]
  + }
> 
  > # rbind all species data into one dataframe
  > alldiv = lapply(alldiv, setNames, c("h", "ntotal", "nvariant", "ninvariant", "pi", "bcd", "jac", "umean", "nidv"))
> 
  > alldiv = do.call(rbind, alldiv)
> 
  > # add species names
  > alldiv$species = species
> alldiv$species = str_to_sentence(gsub("_", " ", alldiv$species))
> 
  > # For now, remove species where invariant sites were not properly called
  > # alldiv = alldiv[(alldiv$ninvariant > 0),]
  > 
  > # For now, remove species where variants sites were not properly called
  > # alldiv = alldiv[(alldiv$nvariant > 30),]
  > 
  > # remove species where there aren't many sampled individuals
  > # alldiv = alldiv[(alldiv$nidv >= 10),]
  > 
  > # add coverage covariate
  > coverage = read.table("../results/2023-03-26/bp_sequenced_2023-09-19.txt", header = T, sep = "\t")
> alldiv = merge(alldiv, coverage, by = "species", all.x = TRUE)
> 
  > # 
  > # gsize = read.table("../results/2023-03-26/genome_size.txt", header = T, sep = "\t")
  > # alldiv = merge(alldiv, gsize, by = "species")
  > # 
  > # alldiv$totalcov = alldiv$totalbp/alldiv$assemblySize
  > # load range data
  > areas = list.files("../results/2023-03-26/ranges/areas", full.names = T)
> 
  > # extract species names
  > areas_species = gsub("_areas.txt", "", gsub("../results/2023-03-26/ranges/areas/", "", areas))
> areas_species = str_to_sentence(gsub("_", " ", areas_species))
> 
  > # load data
  > areas = lapply(areas, read.table, header = T, sep = "\t")
> 
  > # add names to list
  > names(areas) = areas_species
> 
  > #str(areas)
  > # Refer to plants of the world online for native range maps
  > # powo.science.kew.org
  > 
  > # Amaranthus hybridus native to only North and South America
  > areas$`Amaranthus hypochondriacus` = areas$`Amaranthus hypochondriacus`[c(4,6),]
> 
  > # Arabidopsis thaliana is only native to Europe, Asia, and Africa
  > areas$`Arabidopsis thaliana` = areas$`Arabidopsis thaliana`[2:4,]
> 
  > # Arachis glabrata is native to Brazil, remove North America
  > areas$`Arachis hypogaea` = areas$`Arachis hypogaea`[1,]
> 
  > # Beta vulgaris subsp. vulgaris is native to only Europe and Africa
  > areas$`Beta vulgaris` = areas$`Beta vulgaris`[1:2,]
> 
  > # Brachypodium distachyon is native to Europe, Asia, Africa
  > areas$`Brachypodium distachyon` = areas$`Brachypodium distachyon`[3:5,]
> 
  > # Brassica cretica native to europe
  > areas$`Brassica oleracea` = areas$`Brassica oleracea`[1,]
> 
  > # Brassica fruticulosa native to europe
  > areas$`Brassica rapa` = areas$`Brassica rapa`[2,]
> 
  > # Buddleja alternifolia is native to Asia
  > areas$`Buddleja alternifolia` = areas$`Buddleja alternifolia`[2,]
> 
  > # Cajanus scarabaeoides native to Africa, Asia, Australia
  > areas$`Cajanus cajan` = areas$`Cajanus cajan`[c(1,3,4),]
> 
  > # Cucurbita palmata is only native to North America
  > areas$`Cucurbita pepo` = areas$`Cucurbita pepo`[1,]
> 
  > # Digitaria longiflora native to africa, asia, australia
  > areas$`Digitaria exilis`= areas$`Digitaria exilis`[3:5,]
> 
  > # Gossypium arboreum native to asia
  > areas$`Gossypium arboreum` = areas$`Gossypium arboreum`[2,]
> 
  > # Lactuca sativa is native to Iraq
  > areas$`Lactuca sativa` = areas$`Lactuca sativa`[3,]
> 
  > # Malus sylvestris is only native to Europe
  > areas$`Malus sylvestris` = areas$`Malus sylvestris`[2,]
> 
  > # Medicago truncatula only native to europe and africa
  > areas$`Medicago truncatula` = areas$`Medicago truncatula`[c(4,5),]
> 
  > # Mimulus guttatus only native to North America
  > areas$`Mimulus guttatus` = areas$`Mimulus guttatus`[1,]
> 
  > # Musa relative only native to asia and india
  > areas$`Musa acuminata` = areas$`Musa acuminata`[2,]
> 
  > # Populus deltoides only native to north america
  > areas$`Populus deltoides` = areas$`Populus deltoides`[1,]
> 
  > # Nicotiana glauca only native to South America
  > areas$`Nicotiana tabacum` = areas$`Nicotiana tabacum`[2,]
> 
  > # Raphanus raphanistrum is native to europe and africa
  > areas$`Raphanus sativus` = areas$`Raphanus sativus`[3:4,]
> 
  > # Setaria viridis 
  > areas$`Setaria viridis` = areas$`Setaria viridis`[3:6,]
> # function to get non-water area
  > get_nonwater_area = function(x){
    +   sum(x[,"total_area"] - x[,"water_area"])
    + }
> 
  > # format area data as frame
  > areas = data.frame(
    +   species = areas_species,
    +   rangeArea = unlist(lapply(areas, get_nonwater_area))
    + )
> 
  > # merge with diversity data
  > alldiv = merge(alldiv, areas, by = "species", all.x = T)
> 
  > print(alldiv)
> 
  > # save final table
  > #write.csv(alldiv, paste("../results/2023-03-26/diversityAndRangeData_", today, ".csv", sep = ""), row.names = F, quote = F)
  > # write species list to upload to timetree.org
  > #write.table(alldiv$species, paste("../results/2023-03-26/species_list_", today, ".txt", sep = ""), row.names = F, col.names = F, quote = F)
  > 
  > # load time tree
  > phy = read.tree("../results/2023-03-26/species_list_2023-09-19.nwk")
> 
  > # remove underscores
  > phy$tip.label = gsub("_", " ", phy$tip.label)
> 
  > # remove variety names
  > phy$tip.label = gsub(" var..*", "", phy$tip.label)
> 
  > # sanity check
  > plot(phy)
> # Does pi correlate with k-mer diversity?
  > cor(alldiv$pi, alldiv$bcd, method = "spearman", use = "pairwise.complete.obs")
[1] 0.1330065
> cor(alldiv$pi, alldiv$jac, method = "spearman", use = "pairwise.complete.obs")
[1] 0.05217481
> 
  > # Does k-mer diversity correlate with population size (i.e. range area) more than pi?
  > cor(alldiv$pi, alldiv$rangeArea, method = "spearman", use = "pairwise.complete.obs")
[1] 0.09785274
> cor(alldiv$bcd, alldiv$rangeArea, method = "spearman", use = "pairwise.complete.obs")
[1] -0.06411988
> cor(alldiv$jac, alldiv$rangeArea, method = "spearman", use = "pairwise.complete.obs")
[1] -0.1669882
> 
  > # How does the number of individuals correlate with the diversity measures
  > # More individuals = more opportunities to discover variants
  > cor(alldiv$pi, alldiv$nidv)
[1] 0.08553325
> cor(alldiv$bcd, alldiv$nidv)
[1] 0.1524288
> cor(alldiv$jac, alldiv$nidv)
[1] 0.1713082
> # For now, remove species where invariant sites were not properly called
  > alldiv = alldiv[(alldiv$ninvariant > 0),]
> 
  > # For now, remove species where variants sites were not properly called
  > alldiv = alldiv[(alldiv$nvariant > 500),]
> 
  > # remove critically endangered species
  > alldiv = alldiv[(alldiv$rangeArea > 10),]
> 
  > # remove species where there aren't many sampled individuals
  > alldiv = alldiv[(alldiv$nidv >= 10),]
> mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv) + scale(totalbp/nidv), compdata)
Error in pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv) +  : 
                object 'compdata' not found
              > # create comparative data object for caper models
                > compdata = comparative.data(phy, alldiv, names.col = "species", vcv = T)
              > plot(compdata$phy)
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv) + scale(totalbp/nidv), compdata)
              > summary(mod_bcd)
              
              Call:
                pgls(formula = log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv) + 
                       scale(totalbp/nidv), data = compdata)
              
              Residuals:
                Min       1Q   Median       3Q      Max 
              -0.40456 -0.04279 -0.01261  0.03703  0.23712 
              
              Branch length transformations:
                
                kappa  [Fix]  : 1.000
              lambda [Fix]  : 1.000
              delta  [Fix]  : 1.000
              
              Coefficients:
                Estimate Std. Error t value  Pr(>|t|)    
              (Intercept)          7.031085   0.472638 14.8763 < 2.2e-16 ***
                scale(pi)           -0.320232   0.111483 -2.8725  0.005845 ** 
                scale(bcd)           0.172188   0.065891  2.6132  0.011647 *  
                scale(nidv)          0.184823   0.025768  7.1726 2.379e-09 ***
                scale(totalbp/nidv) -0.064791   0.134054 -0.4833  0.630861    
              ---
                Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
              
              Residual standard error: 0.09817 on 53 degrees of freedom
              Multiple R-squared:  0.92,	Adjusted R-squared: 0.914 
              F-statistic: 152.5 on 4 and 53 DF,  p-value: < 2.2e-16 
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + nidv + totalbp/nidv, compdata)
              Error in solve.default(xVix, tol = .Machine$double.eps) : 
                system is computationally singular: reciprocal condition number = 6.32216e-34
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + log10(nidv) + totalbp/nidv, compdata)
              Error in solve.default(xVix, tol = .Machine$double.eps) : 
                system is computationally singular: reciprocal condition number = 4.28735e-34
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv) + totalbp/nidv, compdata)
              Error in solve.default(xVix, tol = .Machine$double.eps) : 
                system is computationally singular: reciprocal condition number = 5.07539e-34
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv) + scale(totalbp/nidv), compdata)
              > summary(mod_bcd)
              
              Call:
                pgls(formula = log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv) + 
                       scale(totalbp/nidv), data = compdata)
              
              Residuals:
                Min       1Q   Median       3Q      Max 
              -0.40456 -0.04279 -0.01261  0.03703  0.23712 
              
              Branch length transformations:
                
                kappa  [Fix]  : 1.000
              lambda [Fix]  : 1.000
              delta  [Fix]  : 1.000
              
              Coefficients:
                Estimate Std. Error t value  Pr(>|t|)    
              (Intercept)          7.031085   0.472638 14.8763 < 2.2e-16 ***
                scale(pi)           -0.320232   0.111483 -2.8725  0.005845 ** 
                scale(bcd)           0.172188   0.065891  2.6132  0.011647 *  
                scale(nidv)          0.184823   0.025768  7.1726 2.379e-09 ***
                scale(totalbp/nidv) -0.064791   0.134054 -0.4833  0.630861    
              ---
                Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
              
              Residual standard error: 0.09817 on 53 degrees of freedom
              Multiple R-squared:  0.92,	Adjusted R-squared: 0.914 
              F-statistic: 152.5 on 4 and 53 DF,  p-value: < 2.2e-16 
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd), compdata)
              > summary(mod_bcd)
              
              Call:
                pgls(formula = log10(rangeArea) ~ scale(pi) + scale(bcd), data = compdata)
              
              Residuals:
                Min       1Q   Median       3Q      Max 
              -0.39383 -0.06574 -0.00267  0.06114  0.43903 
              
              Branch length transformations:
                
                kappa  [Fix]  : 1.000
              lambda [Fix]  : 1.000
              delta  [Fix]  : 1.000
              
              Coefficients:
                Estimate Std. Error t value  Pr(>|t|)    
              (Intercept)  6.994809   0.651451 10.7373 3.997e-15 ***
                scale(pi)   -0.473634   0.149922 -3.1592  0.002571 ** 
                scale(bcd)   0.578056   0.035827 16.1346 < 2.2e-16 ***
                ---
                Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
              
              Residual standard error: 0.1355 on 55 degrees of freedom
              Multiple R-squared: 0.842,	Adjusted R-squared: 0.8362 
              F-statistic: 146.5 on 2 and 55 DF,  p-value: < 2.2e-16 
              The legacy packages maptools, rgdal, and rgeos, underpinning the sp package,
              which was just loaded, will retire in October 2023.
              Please refer to R-spatial evolution reports for details, especially
              https://r-spatial.org/r/2023/05/15/evolution4.html.
              It may be desirable to make the sf package available;
              package maintainers should consider adding sf to Suggests:.
              The sp package is now running under evolution status 2
              (status 2 uses the sf package in place of rgdal)
              > # control for the number of individuals sequenced
                Warning message:
                multiple methods tables found for ‘elide’ 
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv), compdata)
              > summary(mod_bcd)
              
              Call:
                pgls(formula = log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(nidv), 
                     data = compdata)
              
              Residuals:
                Min       1Q   Median       3Q      Max 
              -0.40388 -0.04308 -0.01142  0.03185  0.23703 
              
              Branch length transformations:
                
                kappa  [Fix]  : 1.000
              lambda [Fix]  : 1.000
              delta  [Fix]  : 1.000
              
              Coefficients:
                Estimate Std. Error t value  Pr(>|t|)    
              (Intercept)  7.019555   0.468674 14.9775 < 2.2e-16 ***
                scale(pi)   -0.314573   0.110077 -2.8578  0.006048 ** 
                scale(bcd)   0.184642   0.060212  3.0665  0.003380 ** 
                scale(nidv)  0.184958   0.025583  7.2297 1.745e-09 ***
                ---
                Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
              
              Residual standard error: 0.09747 on 54 degrees of freedom
              Multiple R-squared: 0.9197,	Adjusted R-squared: 0.9152 
              F-statistic: 206.1 on 3 and 54 DF,  p-value: < 2.2e-16 
              > mod_bcd = pgls(log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(totalbp/nidv), compdata)
              > summary(mod_bcd)
              
              Call:
                pgls(formula = log10(rangeArea) ~ scale(pi) + scale(bcd) + scale(totalbp/nidv), 
                     data = compdata)
              
              Residuals:
                Min       1Q   Median       3Q      Max 
              -0.39463 -0.06737 -0.00417  0.06309  0.43897 
              
              Branch length transformations:
                
                kappa  [Fix]  : 1.000
              lambda [Fix]  : 1.000
              delta  [Fix]  : 1.000
              
              Coefficients:
                Estimate Std. Error t value  Pr(>|t|)    
              (Intercept)          7.008209   0.657308 10.6620 6.661e-15 ***
                scale(pi)           -0.480066   0.151916 -3.1601  0.002585 ** 
                scale(bcd)           0.563273   0.051451 10.9479 2.665e-15 ***
                scale(totalbp/nidv) -0.075180   0.186425 -0.4033  0.688339 
              
#
Coefficients:
  Estimate Std. Error t value  Pr(>|t|)    
(Intercept)  6.994809   0.651451 10.7373 3.997e-15 ***
  scale(pi)   -0.473634   0.149922 -3.1592  0.002571 ** 
  scale(bcd)   0.578056   0.035827 16.1346 < 2.2e-16 ***
  
#
"#191900" "#663329" "#D85F4D" "#ECAC54" "#FFFECB"

#
 "#351338" "#6F2C06" "#6C702C" "#69A3A5" "#DAD2FF"
#
theme(strip.background =element_rect(fill="red"))+
  theme(strip.text = element_text(colour = 'white'))
  
#
df %>% arrange(factor(player, levels = c('P1', 'P3', 'P2', 'P5', 'P4', 'P6', 'P7')))

# Make the original plot
p <- ggtree(tree)

# generate some random values for each tip label in the data
d1 <- data.frame(id=tree$tip.label, val=rnorm(30, sd=3))

# Make a second plot with the original, naming the new plot "dot", 
# using the data you just created, with a point geom.
p2 <- facet_plot(p, panel="dot", data=d1, geom=geom_point, aes(x=val), color='red3')

# Make some more data with another random value.
d2 <- data.frame(id=tree$tip.label, value = abs(rnorm(30, mean=100, sd=50)))

# Now add to that second plot, this time using the new d2 data above, 
# This time showing a bar segment, size 3, colored blue.
p3 <- facet_plot(p2, panel='bar', data=d2, geom=geom_segment, 
           aes(x=0, xend=value, y=y, yend=y), size=3, color='blue4') 

# Show all three plots with a scale
p3 + theme_tree2()

#
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("ggtree")

#
7221300

#
5832702

#
2803330

#
3040983

#
2878373

#
5293186

#
2703464

#
3625538

#
5357027

#
3140467

#
Rscript scripts/download_gbif.R glycine_soja $GBIF_USER $GBIF_EMAIL $GBIF_PWD 20 200 5359668

#
3152663

#
2876032

#
3625134

#
3083905


#
2960284


#
5582578

#
8089775

#
5289974

#
3623807

#
8105068

#
3590844

#
3042809

#
3042837





2982409
#
5529117

#
3171159

#
4097481
4097481

#
3799678

#
2930642 8402242

#
7901873 2931761

#
5289684

#
7266664

#
4174687

#
4174017

#
6362904

#
3040232

#
5356701

#
2888443

#
2705116

#
9167736

#
2703462

#
4940610 11365001 5942013

#
4110272

#
2703457

#
7506783

#
7503234


#
2762950

#
3042551

#
3042624

#
5290146

# SE that should actually be PE
SRR1261957
SRR1250413
SRR1261704
SRR1261701
SRR1261610

#
7346090

#
2965201

#

3060733

#
3190640

#
3001509

#
3001162

#
2964374

#
5350011

#

7267415

#
3119206

#

7994689

#


ERR636156

#
2705953

#
8791596

#
4073136

#
2755063

#
2874513

#
2895430

#
5375425

#
5375387

#
3173337

# brachypodium distachyon
5290143

# Arabidopsis lyrata bioprojects
PRJNA357693
PRJEB30473

#
SraRunInfo_arabidopsis_lyrata_PRJEB23202.csv.gz
SraRunInfo_arabidopsis_lyrata_PRJEB30473.csv.gz
SraRunInfo_arabidopsis_lyrata_PRJNA284572.csv.gz

#
#obtain data from GBIF via rgbif
dat <- occ_search(scientificName = "Panthera leo", limit = 5000, hasCoordinate = T)

dat <- dat$data

# names(dat) #a lot of columns

#select columns of interest
dat <- dat %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
         gbifID, family, taxonRank, coordinateUncertaintyInMeters, year,
         basisOfRecord, institutionCode, datasetName)
         
#plot data to get an overview
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = dat, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

# https://github.com/vsbuffalo/paradox_variation/blob/master/R/range_funcs.r
# get continent from coordinates  
countriesSP <- rworldmap:::getMap(resolution='low')
coords2continent = function(lat, lon) {  
  # https://stackoverflow.com/questions/21708488/get-country-and-continent-from-longitude-and-latitude-point-in-r
  points <- data.frame(lon=lon, lat=lat)
  # converting points to a SpatialPoints object
  # setting CRS directly to that from rworldmap
  pointsSP = sp:::SpatialPoints(points, proj4string=sp:::CRS(sp:::proj4string(countriesSP)))  

  # use 'over' to get indices of the Polygons object containing each point 
  indices = sp:::over(pointsSP, countriesSP)

  #indices$REGION   # returns the continent (7 continent model)
  indices$continent
}

#
y = spTransform(x, CRS("+proj=longlat +datum=WGS84"))

# draw convex hulls
# "proj.4" notation of CRS
projection(cn) <- "+proj=longlat +datum=WGS84"
# the CRS we want
laea <- CRS("+proj=laea  +lat_0=0 +lon_0=-80")
clb <- spTransform(cn, laea)
pts <- spTransform(sp, laea)
plot(clb, axes=TRUE)
points(pts, col='red', cex=.5)
# get the (Lambert AEA) coordinates from the SpatialPointsDataFrame
xy <- coordinates(pts)
# draw convex hulls on projected points
hull <- list()
for (s in 1:length(sp)) {
    p <- unique(xy[pts$SPECIES == sp[s], ,drop=FALSE])
    # need at least three points for hull
    if (nrow(p) > 3) {
        h <- convHull(p, lonlat=FALSE)
        pol <- polygons(h)
        hull[[s]] <- pol
    }
}
# combine hulls
# which elements are NULL
i <- which(!sapply(hull, is.null))
h <- hull[i]
# combine them
hh <- do.call(bind, h)
plot(hh)
# calculate area of hulls
ahull <- sapply(hull, function(i) ifelse(is.null(i), 0, area(i)))
plot(rev(sort(ahull))/1000, ylab='Area of convex hull')





# https://babichmorrowc.github.io/post/2019-03-18-alpha-hull/
ashape2poly <- function(ashape){
  # Convert node numbers into characters
  ashape$edges[,1] <- as.character(ashape$edges[,1])
  ashape_graph <- graph_from_edgelist(ashape$edges[,1:2], directed = FALSE)
  if (!is.connected(ashape_graph)) {
    stop("Graph not connected")
  }
  if (any(degree(ashape_graph) != 2)) {
    stop("Graph not circular")
  }
  if (clusters(ashape_graph)$no > 1) {
    stop("Graph composed of more than one circle")
  }
  # Delete one edge to create a chain
  cut_graph <- ashape_graph - E(ashape_graph)[1]
  # Find chain end points
  ends = names(which(degree(cut_graph) == 1))
  path = get.shortest.paths(cut_graph, ends[1], ends[2])$vpath[[1]]
  # this is an index into the points
  pathX = as.numeric(V(ashape_graph)[path]$name)
  # join the ends
  pathX = c(pathX, pathX[1])
  return(pathX)
}


#
"Amaranthus hypochondriacus",
"Amaranthus tuberculatus",
"Amborella trichopoda",
"Ananas comosus",
"Aquilegia coerulea",
"Arabidopsis halleri",
"Arabidopsis lyrata",
"Arabidopsis thaliana",
"Arachis hypogaea",
"Asparagus officinalis",
"Beta vulgaris",
"Betula platyphylla",
"Boechera stricta",
"Brachypodium distachyon",
"Brachypodium hybridum",
"Brachypodium stacei",
"Brassica oleracea capitata",
"Brassica rapa",
"Capsella grandiflora",
"Capsella orientalis",
"Capsella rubella",
"Carica papaya",
"Carya illinoinensis",
"Chenopodium quinoa",
"Cicer arietinum",
"Cinnamomum kanehirae",
"Citrullus lanatus",
"Citrus clementina",
"Citrus sinensis",
"Corymbia citriodora",
"Cucumis sativus",
"Daucus carota",
"Dioscorea alata",
"Diphasiastrum complanatum",
"Eucalyptus grandis",
"Eutrema salsugineum",
"Fragaria vesca",
"Fragaria x ananassa",
"Glycine max",
"Glycine soja",
"Gossypium barbadense",
"Gossypium darwinii",
"Gossypium hirsutum",
"Gossypium mustelinum",
"Gossypium raimondii",
"Gossypium tomentosum",
"Helianthus annuus",
"Hordeum vulgare",
"Kalanchoe fedtschenkoi",
"Lactuca sativa",
"Lens culinaris",
"Lens ervoides",
"Linum usitatissimum",
"Liriodendron tulipifera",
"Lotus japonicus",
"Lupinus albus",
"Manihot esculenta",
"Medicago truncatula",
"Mimulus guttatus",
"Miscanthus sinensis",
"Musa acuminata",
"Nymphaea colorata",
"Olea europaea",
"Oropetium thomaeum",
"Oryza sativa",
"Panicum hallii",
"Panicum virgatum",
"Phaseolus acutifolius",
"Phaseolus vulgaris",
"Poncirus trifoliata",
"Populus trichocarpa",
"Prunus persica",
"Ricinus communis",
"Salix purpurea",
"Schrenkiella parvula",
"Setaria italica",
"Setaria viridis",
"Solanum lycopersicum",
"Solanum tuberosum",
"Sorghum bicolor",
"Spinacia oleracea",
"Spirodela polyrhiza",
"Theobroma cacao",
"Thinopyrum intermedium",
"Trifolium pratense",
"Triticum aestivum",
"Triticum turgidum",
"Vaccinium darrowii",
"Vigna unguiculata",
"Vitis vinifera",
"Zea mays",
"Zostera marina",
"Arabis alpina",
"Actinidia chinensis",
"Aegilops tauschii",
"Brassica juncea",
"Brassica napus",
"Secale cereale",
"Camelina sativa",
"Cannabis sativa",
"Capsicum annuum",
"Chara braunii",
"Chlamydomonas reinhardtii",
"Chondrus crispus",
"Coffea canephora",
"Corchorus capsularis",
"Corylus avellana",
"Corymbia citriodora",
"Cucumis melo",
"Cyanidioschyzon merolae",
"Cynara cardunculus",
"Digitaria exilis",
"Dioscorea rotundata",
"Echinochloa crus-galli",
"Eragrostis curvula",
"Eragrostis tef",
"Ficus carica",
"Galdieria sulphuraria",
"Ipomoea triloba",
"Juglans regia",
"Leersia perrieri",
"Lolium perenne",
"Lupinus angustifolius",
"Marchantia polymorpha",
"Nicotiana attenuata",
"Oryza barthii",
"Oryza brachyantha",
"Oryza glaberrima",
"Oryza glumipatula",
"Oryza longistaminata",
"Oryza meridionalis",
"Oryza nivara",
"Oryza punctata",
"Oryza rufipogon",
"Ostreococcus lucimarinus",
"Papaver somniferum",
"Physcomitrium patens",
"Pistacia vera",
"Pisum sativum",
"Prunus avium",
"Prunus dulcis",
"Quercus lobata",
"Quercus suber",
"Rosa chinensis",
"Saccharum spontaneum",
"Selaginella moellendorffii",
"Sesamum indicum",
"Triticum dicoccoides",
"Triticum spelta",
"Triticum urartu",
"Vigna angularis",
"Vigna radiata",
"Vigna unguiculata",
"Picea abies",
"Phoenix dactylifera",


###
Abrus precatorius
Actinidia rufa
Adiantum capillus-veneris
Adiantum nelumboides
Arabidopsis suecica
Arabis nemorensis
Arachis duranensis
Arachis ipaensis
Aristolochia fimbriata
Bauhinia variegata
Benincasa hispida
Brassica carinata
Brassica oleracea
Buddleja alternifolia
Cajanus cajan
Camellia sinensis
Carex littledalei
Castanea mollissima
Ceratodon purpureus
Ceratopteris richardii
Coffea arabica
Coffea eugenioides
Coptis chinensis
Cucurbita argyrosperma
Cucurbita maxima
Cucurbita moschata
Cucurbita pepo
Cuscuta campestris
Cuscuta epithymum
Cuscuta europaea
Dendrobium chrysotoxum
Dendrobium nobile
Dioscorea cayenensis
Diospyros lotus
Durio zibethinus
Elaeis guineensis
Eleusine coracana
Ensete ventricosum
Erigeron canadensis
Genlisea aurea
Gossypium anomalum
Gossypium arboreum
Gossypium aridum
Gossypium armourianum
Gossypium davidsonii
Gossypium gossypioides
Gossypium harknessii
Gossypium klotzschianum
Gossypium laxum
Gossypium lobatum
Gossypium schwendimanii
Gossypium stocksii
Gossypium trilobum
Heliosperma pusillum
Herrania umbratica
Hevea brasiliensis
Impatiens glandulifera
Jatropha curcas
Kingdonia uniflora
Lithospermum erythrorhizon
Lolium rigidum
Macadamia integrifolia
Malus domestica
Malus sylvestris
Mangifera indica
Marchantia paleacea
Melastoma candidum
Microthlaspi erraticum
Miscanthus lutarioriparius
Momordica charantia
Morus notabilis
Musa troglodytarum
Nelumbo nucifera
Nymphaea thermarum
Papaver armeniacum
Papaver atlanticum
Papaver bracteatum
Papaver californicum
Paulownia fortunei
Perilla frutescens
Phtheirospermum japonicum
Populus deltoides
Populus tomentosa
Potentilla anserina
Prosopis alba
Prunus armeniaca
Psidium guajava
Punica granatum
Quercus robur
Rhodamnia argentea
Rhododendron griersonianum
Rhododendron simsii
Salix dunnii
Salix suchowensis
Salvia hispanica
Salvia splendens
Senna tora
Shorea leprosula
Sinapis alba
Solanum commersonii
Solanum pennellii
Solanum stenotomum
Spirodela intermedia
Striga hermonthica
Tarenaya hassleriana
Taxus chinensis
Telopea speciosissima
Tetracentron sinense
Thalictrum thalictroides
Thlaspi arvense
Tripterygium wilfordii
Vanilla planifolia
Vigna umbellata
Vitis riparia
Xanthoceras sorbifolium
Zingiber officinale
Zizania palustris
Ziziphus jujuba

# 12 species with the fewest samples
arachis_duranensis            camelina_sativa          nicotiana_tabacum           arachis_ipaensis 
brassica_nigra             cucurbita_pepo          arabis_nemorensis             oryza_punctata 
arabidopsis_suecica         solanum_stenotomum               ficus_carica          solanum_melongena 

#
ott_in_tree <- ott_id(taxon_search)[is_in_tree(ott_id(taxon_search))]
tr <- tol_induced_subtree(ott_ids = ott_in_tree)

tr$tip.label <- strip_ott_ids(tr$tip.label, remove_underscores = TRUE)

#
"Arabidopsis suecica" 
"Arabis nemorensis"   
"Arachis hypogaea"    
"Arachis ipaensis"    
"Camelina sativa"    
"Ficus carica"        
"Nicotiana tabacum"   
"Oryza punctata"

# Arachis glabrata
5353813


# Actinidia polygama
3189692 7379759 7620678 7879124

#
5353784


# Actinidia callosa
7270822


#
7915981 3052544

# Actinidia eriantha
3644693 7270743 3644698 3644711

# Aegilops tauschii
5289779 5677746 5677750 7226877 5677755 5677762 5677759 5677753

# Amaranthus hybridus
5384364 7554918 8111324 7442708 10145116 10538632 10634896 10279930 5547885 7867601

# Ananas comosus var. microstachys
5288770

# Arabidopsis halleri
3052450 9403166 3052459 11097917 3689665 7225571 10906894 3052455 10999708 10940826

# Arabidopsis lyrata
3052468 3052469 3052478 7225570 9372560

# Arabidopsis thaliana
3052436 7758053 3052446

# Beta vulgaris
8372932 7657202

# Arabis alpina
5375020 5374885 8576900 9044273 7694599 8349130 5375026 5551157 7785553 9614998

# Arabis nemorensis
8288982 5374937 5552336 7292834 5374934

# Arachis stenosperma
5353758

# Arachis duranensis
5353841

# Arachis ipaensis
5353793

# Benincasa pruriens
3623456 7317644 2874524 3623445 3623491 8312084 2874525 7317643

# Boechera stricta
3043392

# Camelina sativa
3042439 7528991 3042443 3042441 3689020 3042425 3042427 3042396

# Nicotiana sylvestris
2928767

# Brassica nigra
3042658 8010384 7509066 3042673 3692032 3042665 7437326 6306670 7844947

# Oryza punctata
2703461 8663541 11356139 5941998

# Solanum stenotomum
3799678 9673874 4937418

# Ficus erecta
5571945 6135850 7616056 9534337 7433549 5834128 8126416 7581614 11354470 11283465
