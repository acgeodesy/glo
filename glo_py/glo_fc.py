#!/usr/bin/env python

################################################################################
# PROGRAM: 
################################################################################
"""
 To get 24 glonass satellites frequency channels
 
 USAGE  : glo_fc.py <year> <month> <day>

 OPTIONS: <year>    - Year  [Required]
          <month>   - Month [Required]
          <day>     - Day   [Required]

 EXAMPLE: glo_fc.py 2013 5 23

 to get help, please type:
              glo_fc.py
 or           glo_fc.py -h

"""
################################################################################
# Import Python modules
import os, sys, pydoc, datetime, time

__author__  = 'Feng Zhou'
__date__    = '$Date: 2013-10-06 13:17:20 (Sun, 06 Oct 2013) $'[7:-21]
__version__ = '$Version: glo_fc.py V1.0 $'[10:-2]

################################################################################
# FUNCTION: 
################################################################################

def secs_diff(date):
    """
    Function to get the differential seconds between the given calendar date 
    and 1970-01-01 00:00:00 hrs
    """

    date_1970jan1 = datetime.datetime(1970,1,1)
    time_delta = date-date_1970jan1

    return time_delta.days*24*3600+time_delta.seconds

################################################################################
def cal2mjd(iy,im,id):
    """
    Function to convert year, month, day to Modified Julian Date
    
    ARGUMENTS: iy    - Year
               im    - Month
               id    - Day

    RETURNED : mjd   - Modified Julian Date
    """

    date = datetime.datetime(iy,im,id)
    delta_secs = secs_diff(date)
# Calendar date 1970-01-01 00:00:00 hrs, of which Modified Julian Date is 40587
# There are 86400 seconds every day
    mjd = 40587+delta_secs/86400

# Return
    return mjd

################################################################################
def glo_fc():
    """
    Function to get 24 GLONASS satellites' frequency channels

    ARGUMENTS: iy      - Year
               im      - Month
               id      - Day

    RETURNED : glofc   - A list containing frequency channels whose length is 24
    """

# For man page of glo_fc.py
    if '-h' in sys.argv or len(sys.argv) <= 3:
        pydoc.help(os.path.basename(sys.argv[0]).split('.')[0])
        sys.exit(0)
    elif len(sys.argv) == 4:
        iy = int(sys.argv[1])
        im = int(sys.argv[2])
        id = int(sys.argv[3])
    else:
        sys.exit(0)

# Modified Julian Date of 2005-01-01
    mjd_05jan1 = 53371

# Modified Julian Date of the given iy-im-id
    mjd = cal2mjd(iy,im,id)

    if mjd < mjd_05jan1:
        print ' '
        print ' *** DEF glo_fc: Time is BEFORE year of 2005!'
        print ' '
        sys.exit(0)

# Open file for 'r'eading
    f = file('glo.dat','r')

# Skip the header component of data file
    while True:
        line = f.readline()
        if 'END OF HEADER' in line:
            break

# Now begin the data component of data file
    while True:
        line = f.readline()
        if len(line) == 0:
            break
        date = line.split()
        yr = int(date[0])
        mon = int(date[1])
        day = int(date[2])
        mjd1 = cal2mjd(yr,mon,day)
        if mjd < mjd1:
            break
        line = f.readline()
        str_glofc = line.split()
        glofc = []
        for i in range(0,24):
            glofc.append(int(str_glofc[i]))

# Close the file
    f.close()

# Return 
    return glofc

################################################################################
# Main program
################################################################################
if __name__ == '__main__':
    glofc = glo_fc()
    print glofc



