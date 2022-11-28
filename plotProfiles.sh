#!/bin/bash
time=0
profilesDir="postProcessing/extractVelocityProfiles/$time"
profilesBaseDir="postProcessing/extractVelocityProfiles/0"
profilesLESDir="postProcessing/extractLES/0"
profilesPIVDir="postProcessing/profileData"
CpDir="postProcessing/extractSurfacePressure/$time"
CpRefDir="postProcessing/extractSurfacePressure/0"
Uinf=1
gnuplot<<EOF
    reset
    set terminal pdf enhanced font 'Verdana,10'; set output 'plots.pdf'
    set multiplot layout 2,4 rowsfirst margins 0.1,0.98,0.13,0.98 spacing 0.03
    set font 'arial,4';
    set datafile separator ","
    set size ratio 1.2
    set mxtics 10; set mytics 10;
    set grid; 
    set style line 1 linecolor rgb 'red' linetype 1 linewidth 1.1 pointsize 0
    set style line 2 linecolor rgb 'blue' linetype 1 linewidth 1.1 pointsize 0
    set style line 3 linecolor rgb '#008080' linetype 3 linewidth 1.1 pointsize 0
    set style line 4 linecolor rgb 'black' linetype 1 linewidth 1.1 pointsize 0
    set ytics font ", 8"; set xtics font ", 8";
    set yrange[0:0.17]; set xrange[-0.5:1.5]; 
    set ytics nomirror; set xtics nomirror; set xtics 1;
    set key left bottom opaque;
    set format y "%.2f"

    set ytics 0.05; set ylabel "y"; set format x " "
    set label 1 "x=0.65" at graph 0.32,0.9 font ',8';
    plot "$profilesLESDir/xp65_profileRefFieldInversion.csv" using 2:1 title "LES" with lines linestyle 4, \
         "$profilesBaseDir/xp65_U.csv" using 2:1 title "SST Baseline" with lines linestyle 1, \
         "$profilesDir/xp65_U.csv" using 2:1 title "FI" with lines linestyle 2


    set format y " "; unset ylabel; 

    set label 1 "x=0.66" at graph 0.32,0.9 font ',8'; 
    plot "$profilesLESDir/xp66_profileRefFieldInversion.csv" using 2:1 notitle with lines linestyle 4, \
         "$profilesBaseDir/xp66_U.csv" using 2:1 notitle with lines linestyle 1, \
         "$profilesDir/xp66_U.csv" using 2:1 notitle with lines linestyle 2


    set label 1 "x=0.8" at graph 0.32,0.9 font ',8';
    plot "$profilesLESDir/xp8_profileRefFieldInversion.csv" using 2:1 notitle with lines linestyle 4, \
         "$profilesBaseDir/xp8_U.csv" using 2:1 notitle with lines linestyle 1, \
         "$profilesDir/xp8_U.csv" using 2:1 notitle with lines linestyle 2

    set label 1 "x=0.9" at graph 0.32,0.9 font ',8';
    plot "$profilesLESDir/xp9_profileRefFieldInversion.csv" using 2:1 notitle with lines linestyle 4, \
         "$profilesBaseDir/xp9_U.csv" using 2:1 notitle with lines linestyle 1, \
         "$profilesDir/xp9_U.csv" using 2:1 notitle with lines linestyle 2


########
    unset format x; unset format y;
    set format x "%.1f"
    set format y "%.2f"
    set xlabel "U_x/U_{/Symbol \245}" enhanced; set ylabel "y"
    set ytics; set xtics 1; set ytics nomirror; set xtics nomirror;
    set label 1 "x=1.0" at graph 0.32,0.9 font ',8';
    plot "$profilesLESDir/x1_profileRefFieldInversion.csv" using 2:1 notitle with lines linestyle 4, \
         "$profilesBaseDir/x1_U.csv" using 2:1 notitle with lines linestyle 1, \
         "$profilesDir/x1_U.csv" using 2:1 notitle with lines linestyle 2

    set format y " "; unset ylabel;
    set label 1 "x=1.1" at graph 0.32,0.9 font ',8';
    plot "$profilesLESDir/x1p1_profileRefFieldInversion.csv" using 2:1 notitle with lines linestyle 4, \
         "$profilesBaseDir/x1p1_U.csv" using 2:1 notitle with lines linestyle 1, \
         "$profilesDir/x1p1_U.csv" using 2:1 notitle with lines linestyle 2

    set label 1 "x=1.2" at graph 0.32,0.9 font ',8';
    plot "$profilesLESDir/x1p2_profileRefFieldInversion.csv" using 2:1 notitle with lines linestyle 4, \
         "$profilesBaseDir/x1p2_U.csv" using 2:1 notitle with lines linestyle 1, \
         "$profilesDir/x1p2_U.csv" using 2:1 notitle with lines linestyle 2


    set label 1 "x=1.3" at graph 0.32,0.9 font ',8';
    plot "$profilesLESDir/x1p3_profileRefFieldInversion.csv" using 2:1 notitle with lines linestyle 4, \
         "$profilesBaseDir/x1p3_U.csv" using 2:1 notitle with lines linestyle 1, \
         "$profilesDir/x1p3_U.csv" using 2:1 notitle with lines linestyle 2

    unset multiplot
EOF
