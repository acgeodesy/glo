function [mjd fmjd]=date2mjd(date)

% Convert civil date to modified julian date

% version: 1.0
% Date: 2010-04-05 
% Copyright(c) 2013 by huhong, all rights reserved


year=date(1);
month=date(2);
day=date(3);

if month <= 2, year = year-1; month = month+12; end

jd = floor(365.25*(year+4716))+floor(30.6001*(month+1))+day-1537.5;
mjd = jd-2400000.5;

fmjd=(3600*date(4)+60*date(5)+date(6))/86400;

