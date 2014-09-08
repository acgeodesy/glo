//#######################################################
//#author: Xu. Tang & Wang Cheng
//#date:   2013-10-07
//#usage:  get GLONASS Satellites' Frequency Channels
//#######################################################






#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#define LineSIZE 2048

// data type
struct data_body
{
    int time[3];
    int channel[24];
};


//declare function
int GC2DOY(int year, int month, int day);
int GC2MJD(int year, int month, int day);

int main()
{
    const FILE *fp = fopen("glo.dat", "r");
    char line[LineSIZE];
    int num_line = 0;
    struct data_body *data = NULL;
    int year = 2013, month = 6, day = 8;
    int i_line = 0;
    int i = 0;
    int j = 0;
    int mjd = 0, mjd1 = 0, mjd2 = 0;
    char line_temp[LineSIZE];

    if(fp == NULL)
    {
        printf("cannot open this file\n");
        exit(0);
    }
    fgets(line, LineSIZE, fp);
    while(strstr(line, "END OF HEADER") == NULL)
        fgets(line, LineSIZE, fp);

    // count the lines
    while(fgets(line, LineSIZE, fp))
        ++num_line;
    num_line = num_line / 2;
    fseek(fp, 0, SEEK_SET);
    data = (struct data_body*)malloc(sizeof(struct data_body) * (num_line + 1));

    while(strstr(line, "END OF HEADER") == NULL)
        fgets(line, LineSIZE, fp);

    while(fgets(line, LineSIZE, fp))
    {
        strncpy(line_temp, line, 4), line_temp[4] ='\0';
        data[i_line].time[0] = atoi(line_temp);
        strncpy(line_temp, line + 5, 2), line_temp[2] = '\0';
        data[i_line].time[1] = atoi(line_temp);
        strncpy(line_temp, line + 8, 2), line_temp[2] = '\0';
        data[i_line].time[2] = atoi(line_temp);

        fgets(line, LineSIZE, fp);
        for(i = 0; i < 24; ++i)
        {
            strncpy(line_temp, line + i * 3, 2), line_temp[2] = '\0';
            data[i_line].channel[i] = atoi(line_temp);
        }
        ++i_line;
    }
    fclose(fp);


    mjd = GC2MJD(year, month, day);
    for(i = 0; i < num_line - 1; ++i)
    {
        mjd1 = GC2MJD(data[i].time[0], data[i].time[1], data[i].time[2]);
        mjd2 = GC2MJD(data[i + 1].time[0], data[i + 1].time[1], data[i + 1].time[2]);
        if(mjd >= mjd1 && mjd < mjd2)
        {
            for(j = 0; j < 24; ++j)
                printf("%d ", data[i].channel[j]);
            printf("\n");
            break;
        }
        else if(i == num_line - 2 && mjd >= mjd2)
        {
            for(j = 0; j < 24; ++j)
                printf("%d ",data[i + 1].channel[j]);
            printf("\n");
            break;
        }
    }
    return 0;
}

int GC2DOY(int year, int month, int day)//YMD2DOY
{
	int MonthDay[12], i, j;
	int leap_year = (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
	for(i = 0; i < 12; ++i)
	{
		if(i < 7)
		{
			if(i % 2 != 0)
				MonthDay[i] = 30;
			else MonthDay[i] = 31;
			if(i == 1)
			{
				if(leap_year)
					MonthDay[i] = 29;
				else MonthDay[i] = 28;
			}
		}
		else
		{
			if(i % 2 != 0)
				MonthDay[i] = 31;
			else MonthDay[i] = 30;
		}
	}
	int sum = 0, doy = 0;
	for(j = 0; j < month - 1; ++j)
		sum += MonthDay[j];
	doy = sum + day;
	return doy;
}

int GC2MJD(int year, int month, int day)//YMD2MJD
{
    int t1 = 775, t2, t3, mjd;
    t2 = (year - 1861) * 365 + (year - 1861) / 4;
    t3 = GC2DOY(year, month, day);
    mjd = t1 + t2 + t3 - 1;
    return mjd;
}
