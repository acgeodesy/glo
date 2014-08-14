# GLONASS Frequency Channels Service
##Introduction
As we know, GLONASS is different from GPS, especially the FDMA. We need to determine the frequecy channels of 24 GLONASS satellites firstly if we want to using GLONASS data to positioning, navigation,timing and do something else such as ionosphere modeling, troposphere monitoring and so on. Obviously, GNSS receiver can receive the frequency channels through broadcast ephemeris. We actually don't have to use the navigation file to calculate frequencies of satellites everytime when we process data. Because the frequency channels won't be changed until the satellite is replaced by a new satellite.

A program is developed and running on server. It can follow the official information of GLONASS and generate a file(glo.dat) which records frequency channels of GLONASS satellites. The file is checked every 2 hours and updated everyday automatically.

An open source code is provided for calculating freqency channels of GLONASS satellites. The package contains 4 files totally, including README.md, Makefile, glo.dat, and main.cpp.

####README.md
You would have a well understanding about this frequency channels service.

####Makefile
Just input <b>make</b> to compile the program.

####glo.dat
This file should be updated when you used it. 
URL: http://geodesy.cn/glonass/glo.dat
##Usage
```
cd glo
make
cp glo.dat bin/Debug/
cd bin/Debug/
./glo
```
###More languages implementation
- <b>Matlab</b> by Hong HU
- <b>Fortran</b> by Feng ZHOU
- <b>Python</b> by Feng ZHOU
- <b>C</b> by Xu TANG

These code can be downloaded at http://geodesy.cn/glonass/index.xml



Please don't be hesitated to contact me if you have any questions.
E-mail:ac@geodesy.cn

