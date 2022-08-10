#!/bin/bash
time=6000
profilesDir="postProcessing/extractVelocityProfiles/$time"
profilesBaseDir="postProcessing/extractVelocityProfiles/0"
profilesPIVDir="postProcessing/profileData"
CpDir="postProcessing/extractSurfacePressure/$time"
CpRefDir="postProcessing/extractSurfacePressure/0"
Uinf=34.6221019004
gnuplot<<EOF
    reset
    set terminal pdf enhanced font 'Verdana,10'; set output 'plots.pdf'
    set multiplot layout 1,2 title "Optimisation history"
     set datafile separator ","
     set grid
     set style line 1 linecolor rgb 'blue' linetype 1 linewidth 1.5 pointtype 2 pointsize 0.25
     set size square
     set xlabel "Iteration"
     set ylabel "Objective"
     set ytics font ", 8"; set xtics font ", 8";
     plot "optHistory.csv" using 1:2 notitle with linespoints linestyle 1

     set xlabel "Iteration"
     set ylabel "Optimiality"
     set size square
     set logscale y
     set format y "10^{%L}"
     plot "optHistory.csv" using 1:4 notitle with linespoints linestyle 1
     unset multiplot

    reset
    set lmargin 15
    set rmargin 15
    set tmargin 5
    set bmargin 5

    set datafile separator " "
    set grid
    set style line 2 linecolor rgb 'red' linetype 1 linewidth 1.3 pointtype -1 pointsize 0
    set style line 3 linecolor rgb '#008080' linetype 0 linewidth 0 pointtype 5 pointsize 0.25
    set style line 4 linecolor rgb 'blue' linetype 3 linewidth 1.3 pointtype -1 pointsize 0
    set size ratio -1; set xlabel "x/H"; set ylabel "C_p"
    set yrange[0.5:-1] reverse; 
    set xrange[-0.5:2]; 
    set ytics nomirror; set xtics nomirror;
    set xtics 0.5; 
    set ytics 0.5;
    #set key outside; 
    set mxtics 5; set mytics 10;
    set key right top;
    set format x "%.1f"
    set format y "%.1f"
    set ytics font ", 8"; set xtics font ", 8";
    plot "postProcessing/CpData.csv" using 1:(\$2 + 0.06) w points pt 7 ps 0.15 lc rgb "black" title "Expt.", \
         "$CpRefDir/p_lowerWall.raw" using 1:((\$4 / (0.5 * $Uinf * $Uinf))) title "S-A (baseline)" with lines linestyle 2, \
         "$CpDir/p_lowerWall.raw" using 1:((\$4 / (0.5 * $Uinf * $Uinf))) title "Field inversion" with lines linestyle 4

    reset;
    set multiplot layout 2,4 rowsfirst margins 0.1,0.98,0.13,0.98 spacing 0.03
    set font 'arial,4';
    set datafile separator ","
    set size ratio 1.2
    set mxtics 10; set mytics 10;
    set grid; 
    set style line 1 linecolor rgb 'red' linetype 1 linewidth 1.1 pointsize 0
    set style line 2 linecolor rgb 'blue' linetype 1 linewidth 1.1 pointsize 0
    set style line 3 linecolor rgb '#008080' linetype 3 linewidth 1.1 pointsize 0
    set ytics font ", 8"; set xtics font ", 8";
    set yrange[0:0.17]; set xrange[-0.5:1.5]; 
    set ytics nomirror; set xtics nomirror; set xtics 1;
    set key left bottom opaque;
    set format y "%.2f"

    set ytics 0.05; set ylabel "y"; set format x " "
    set label 1 "x=0.65" at graph 0.32,0.9 font ',8';
    plot "$profilesBaseDir/xp65_U.csv" using (\$2 / $Uinf):1 title "S-A" with lines linestyle 1, \
         "$profilesDir/xp65_U.csv" using (\$2 / $Uinf):1 title "FI" with lines linestyle 2, \
         "$profilesPIVDir/x0p65.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" title "PIV"


    set format y " "; unset ylabel; 

    set label 1 "x=0.66" at graph 0.32,0.9 font ',8'; 
    plot "$profilesBaseDir/xp66_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 1, \
         "$profilesDir/xp66_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 2, \
         "$profilesPIVDir/x0p66.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" notitle


    set label 1 "x=0.8" at graph 0.32,0.9 font ',8';
    plot "$profilesBaseDir/xp8_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 1, \
         "$profilesDir/xp8_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 2, \
         "$profilesPIVDir/x0p8.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" notitle

    set label 1 "x=0.9" at graph 0.32,0.9 font ',8';
    plot "$profilesBaseDir/xp9_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 1, \
         "$profilesDir/xp9_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 2, \
         "$profilesPIVDir/x0p9.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" notitle


########
    unset format x; unset format y;
    set format x "%.1f"
    set format y "%.2f"
    set xlabel "U_x/U_{/Symbol \245}" enhanced; set ylabel "y"
    set ytics; set xtics 1; set ytics nomirror; set xtics nomirror;
    set label 1 "x=1.0" at graph 0.32,0.9 font ',8';
    plot "$profilesBaseDir/x1_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 1, \
         "$profilesDir/x1_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 2, \
         "$profilesPIVDir/x1p0.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" notitle

    set format y " "; unset ylabel;
    set label 1 "x=1.1" at graph 0.32,0.9 font ',8';
    plot "$profilesBaseDir/x1p1_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 1, \
         "$profilesDir/x1p1_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 2, \
         "$profilesPIVDir/x1p1.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" notitle

    set label 1 "x=1.2" at graph 0.32,0.9 font ',8';
    plot "$profilesBaseDir/x1p2_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 1, \
         "$profilesDir/x1p2_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 2, \
         "$profilesPIVDir/x1p2.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" notitle


    set label 1 "x=1.3" at graph 0.32,0.9 font ',8';
    plot "$profilesBaseDir/x1p3_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 1, \
         "$profilesDir/x1p3_U.csv" using (\$2 / $Uinf):1 notitle with lines linestyle 2, \
         "$profilesPIVDir/x1p3.dat" using 3:2 w points pt 7 ps 0.15 lc rgb "black" notitle

    unset multiplot
EOF
