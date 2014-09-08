function glof = glofreq(date)
% =========================================================================
% Select the Frequency of GLONASS
%
% Given:
%    date          Date : example date = [2013 03 11 00 00 00]
%                  notice: 6 number
% Returned:
%    glof         GLONASS frequency
%
% author   huhong  
%          2013-10-04
% =========================================================================
[jd fjd]=date2mjd(date);
fid=fopen('./data/glo.dat','r');
% Compute the file size
fseek(fid,0,'eof');       % put the pointer at the end of the file将指针定位文件尾
f_size = ftell(fid);      % get the position and file size in bytes计算文件字节数
fseek(fid,0,'bof'); 	     % set the pointer to the beginning of the file将指针定位文件头
while 1
    line=fgetl(fid);
    tempk=findstr(line,'END OF HEADER');
    if ~isempty(tempk)
        break;
    end
end
mjd=[];
gfreq=[];
while feof(fid)==0
    line = fgetl(fid);
    % make up ' ' if the length is less than 80
    sizeline = size(line,2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if sizeline==10
        % read the first line
        if ~isempty(sscanf(line(1:4),'%f'))
            iy = sscanf(line(1:4),'%f');
        else
            continue
        end
        im = sscanf(line(6:7),'%f');
        id = sscanf(line(9:10),'%f');
        idate = [iy, im, id, 0, 0, 0];
        [djm fmjd]=date2mjd(idate);
        mjd=[mjd;djm];
    else
        r1f=sscanf(line(1:2),'%f')   ;r2f=sscanf(line(4:5),'%f')   ;r3f=sscanf(line(7:8),'%f');
        r4f=sscanf(line(10:11),'%f') ;r5f=sscanf(line(13:14),'%f') ;r6f=sscanf(line(16:17),'%f');
        r7f=sscanf(line(19:20),'%f') ;r8f=sscanf(line(22:23),'%f') ;r9f=sscanf(line(25:26),'%f');
        r10f=sscanf(line(28:29),'%f');r11f=sscanf(line(31:32),'%f');r12f=sscanf(line(34:35),'%f');
        r13f=sscanf(line(37:38),'%f');r14f=sscanf(line(40:41),'%f');r15f=sscanf(line(43:44),'%f');
        r16f=sscanf(line(46:47),'%f');r17f=sscanf(line(49:50),'%f');r18f=sscanf(line(52:53),'%f');
        r19f=sscanf(line(55:56),'%f');r20f=sscanf(line(58:59),'%f');r21f=sscanf(line(61:62),'%f');
        r22f=sscanf(line(64:65),'%f');r23f=sscanf(line(67:68),'%f');r24f=sscanf(line(70:71),'%f');
        freq=[r1f r2f r3f r4f r5f r6f r7f r8f r9f r10f r11f r12f r13f r14f r15f r16f...
            r17f r18f r19f r20f r21f r22f r23f r24f];
        gfreq=[gfreq;freq];
    end
end
fclose(fid);
glonassf=[mjd gfreq];
% jd=53370;

if jd<mjd(1)
    h=msgbox('日期超限，请确保数据在2005年以后');
    return;
end
gfn=size(glonassf,1);
m=min(find(glonassf(:,1)>jd));
if ~isempty(m)
    glof=glonassf(m-1,2:25);
else
    glof=glonassf(gfn,2:25);
end
% glof
