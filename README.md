# GLONASS Frequency Channels Service
##Introduction
As we know, GLONASS is different from GPS, especially the FDMA. We need to determine the frequecy channels of 24 GLONASS satellites firstly if we want to using GLONASS data for positioning, navigation,timing and doing something else such as ionosphere modeling, troposphere monitoring and so on. Obviously, GNSS receiver can receive the frequency channels through broadcast ephemeris. We actually don't have to use the navigation file to calculate frequencies of satellites everytime when we process data. Because the frequency channels won't be changed until the satellite is replaced by a new satellite.

A program is developed and running on server. It can follow the official information of GLONASS and generate a file(glo.dat) which records frequency channels of GLONASS satellites. The file is checked every 2 hours and updated everyday automatically.

An open source code is provided for calculating freqency channels of GLONASS satellites. The main package contains 4 files, including README.md, Makefile, glo.dat, and main.cpp. Also, other 4 languages(Matlab, Fortran, Python and C) are implemented for this. 

#####README.md
You would have a well understanding about this frequency channels service.

#####Makefile
Just input **make** to compile the program.

#####glo.dat
This file should be updated when you use it. 
URL: <http://geodesy.cn/glonass/glo.dat>
##Usage
```
cd glo
make
cp glo.dat bin/Debug/
cd bin/Debug/
./glo
```
##More languages implementation
- **Matlab** by Hong HU
- **Fortran** by Feng ZHOU
- **Python** by Feng ZHOU
- **C** by Xu TANG

Home Page: <http://geodesy.cn/glonass/index.xml>



Please don't be hesitated to contact me if you have any questions.
E-mail:ac@geodesy.cn

