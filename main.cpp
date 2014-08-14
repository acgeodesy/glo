//#######################################################
//#author: acheng
//#date:   2013-06-08
//#usage:  get GLONASS Satellites' Frequency Channels
//update log:
//-----2013.06.16-----
// fixed a little bug, calculate GFC at or after the time of last set. 
//#######################################################
#include <iostream>
#include <fstream>
#include <vector>
using namespace std;
size_t GC2DOY(size_t year,size_t month,size_t day);//YMD2DOY
size_t GC2MJD(size_t year,size_t month,size_t day);//YMD2MJD
int main()
{
    const char*glofile="glo.dat";
    size_t year=2013,month=6,day=8;
    ifstream gfile(glofile);
    string str;
    getline(gfile,str);
    while(str.substr(60,13)!="END OF HEADER")
        getline(gfile,str);
    std::vector<std::vector<int> > dates,channels;
    while(!gfile.eof())
    {
        std::vector<int> date,channel;
        int var;
        for(size_t i=0;i<3;++i)
        {
            gfile>>var;
            date.push_back(var);
        }
        for(size_t i=0;i<24;++i)
        {
            gfile>>var;
            channel.push_back(var);
        }
        dates.push_back(date);
        channels.push_back(channel);
    }
    gfile.close();
    size_t mjd=GC2MJD(year,month,day);
    for(size_t i=0;i<dates.size()-1;++i)
    {
        size_t mjd1=GC2MJD(dates[i][0],dates[i][1],dates[i][2]);
        size_t mjd2=GC2MJD(dates[i+1][0],dates[i+1][1],dates[i+1][2]);
        if(mjd>=mjd1 && mjd<mjd2)
        {
            for(size_t j=0;j<24;++j)
                cout<<channels[i][j]<<" ";
            cout<<endl;
            break;
        }
        else if(i==dates.size()-2 && mjd>=mjd2)
        {
            for(size_t j=0;j<24;++j)
                cout<<channels[i+1][j]<<" ";
			cout<<endl;
            break;
        }       
    }
    return 0;
}

size_t GC2DOY(size_t year,size_t month,size_t day)//YMD2DOY
{
	size_t MonthDay[12],i,j;
	bool leap_year=(year%4==0) && ((year%100!=0) || (year%400==0));
	for(i=0;i<12;++i)
	{
		if(i<7)
		{
			if(i%2!=0)
				MonthDay[i]=30;
			else MonthDay[i]=31;
			if(i==1)
			{
				if(leap_year)
					MonthDay[i]=29;
				else MonthDay[i]=28;
			}
		}
		else
		{
			if(i%2!=0)
				MonthDay[i]=31;
			else MonthDay[i]=30;
		}
	}
	size_t sum=0,doy=0;
	for(j=0;j<month-1;++j)
		sum+=MonthDay[j];
	doy=sum+day;
	return doy;
}

size_t GC2MJD(size_t year,size_t month,size_t day)//YMD2MJD
{
    int t1(775),t2,t3,mjd;
    t2=(year-1861)*365+(year-1861)/4;
    t3=GC2DOY(year,month,day);
    mjd=t1+t2+t3-1;
    return mjd;
}
