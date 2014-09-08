!--------------------------------------------------------------------------
! POsitioning Software for Education (POSE) Version 1.0
!--------------------------------------------------------------------------

MODULE s_glofreqchan

  INTEGER(KIND=4),  PARAMETER :: maxchan  = 24
  INTEGER(KIND=4),  PARAMETER :: minmjd   = 53371    ! 2005-01-01
  CHARACTER(LEN=7), PARAMETER :: glofil   = 'glo.dat'

CONTAINS

! #########################################################################
  SUBROUTINE glo_freqchan(iy,im,id,glofc)

! -------------------------------------------------------------------------
! Purpose  :  Routine to get 24 GLONASS satellites' frequency channels
!
! Author   :  Feng Zhou
!
! Created  :  05-Oct-2013
!
! Last mod.:  
!
! Changes  :  05-Oct-201325-Sep-2013 ZF: Create prototype of glo_freqchan
!
! SR called:  
!
! Reference:  
! -------------------------------------------------------------------------

! Modules
! ---------------------------------
    IMPLICIT NONE

! List of Parameters
! ---------------------------------
    INTEGER(KIND=4),                     INTENT(in)  :: iy       ! Year
    INTEGER(KIND=4),                     INTENT(in)  :: im       ! Month
    INTEGER(KIND=4),                     INTENT(in)  :: id       ! Day
    INTEGER(KIND=4), DIMENSION(maxchan), INTENT(out) :: glofc    ! GLONASS satellites' frequency channels

! Local Variables
! ---------------------------------
    INTEGER(KIND=4)                                  :: mjd      ! Modified Julian Date of input (iy,im,id)
    INTEGER(KIND=4)                                  :: j        ! Status:
                                                                 !    0 = OK
                                                                 !   -1 = bad year  (MJD not computed)
                                                                 !   -2 = bad month (MJD not computed)
                                                                 !   -3 = bad day   (MJD computed)
    INTEGER(KIND=4)                                  :: ierr     ! Status of opening file
    INTEGER(KIND=4)                                  :: yr       ! Year
    INTEGER(KIND=4)                                  :: mon      ! Month
    INTEGER(KIND=4)                                  :: day      ! Day
    INTEGER(KIND=4)                                  :: mjd1     ! Modified Julian Date of (yr,mon,day)
    INTEGER(KIND=4)                                  :: i
    CHARACTER(LEN=100)                               :: line

! Convert year, month, day to Modified Julian Date
    CALL cal2mjd(iy,im,id,mjd,j)
    IF (j /= 0) THEN
       WRITE(*,'(/,a,/)') ' *** SR cal2mjd: Year, month, or day is NOT valid!'
       STOP
    END IF
    IF (mjd < 53371) THEN
       WRITE(*,'(/,a,/)') ' *** SR glo_freqchan: Time is BEFORE year of 2005!'
       STOP
    END IF

! Open the data file
    OPEN(14,FILE=glofil,STATUS="old",IOSTAT=ierr)
    IF (ierr /= 0) THEN
       WRITE(*,'(/,a,/)') ' *** SR glo_freqchan: Opening data file is FAILED!'
       STOP
    END IF

! Skip the header component of data file
    DO WHILE (.TRUE.)
       READ(14,'(a)') line
       IF (line(61:73) == 'END OF HEADER') THEN
          EXIT
       END IF
    END DO

! Now begin the data component
    DO WHILE (.TRUE.)
       READ(14,'(a)',IOSTAT=ierr) line
       IF (ierr /= 0) EXIT
       READ(line,'(i4,2(1x,i2))') yr, mon, day
       CALL cal2mjd(yr,mon,day,mjd1,j)
       IF (mjd < mjd1) EXIT
       READ(14,'(a)') line
       READ(line,'(i2,23(1x,i2))') (glofc(i),i=1,maxchan)
    END DO
    CLOSE (14)

    RETURN

  END SUBROUTINE glo_freqchan


! #########################################################################
  SUBROUTINE cal2mjd(iy,im,id,mjd,j)
! -------------------------------------------------------------------------
! Purpose  :  Routine to convert year, month, day to Modified Julian Date
!
! Author   :  Feng Zhou
!
! Created  :  05-Oct-2013
!
! Last mod.:  
!
! Changes  :  05-Oct-201325-Sep-2013 ZF: Create prototype of cal2mjd
!
! SR called:  
!
! Reference:  
! -------------------------------------------------------------------------

! Modules
! ---------------------------------
    IMPLICIT NONE

! List of Parameters
! ---------------------------------
    INTEGER(KIND=4),                     INTENT(in)  :: iy       ! Year
    INTEGER(KIND=4),                     INTENT(in)  :: im       ! Month
    INTEGER(KIND=4),                     INTENT(in)  :: id       ! Day
    INTEGER(KIND=4),                     INTENT(out) :: mjd      ! Modified Julian Date
    INTEGER(KIND=4),                     INTENT(out) :: j        ! Status:
                                                                 !    0 = OK
                                                                 !   -1 = bad year  (MJD not computed)
                                                                 !   -2 = bad month (MJD not computed)
                                                                 !   -3 = bad day   (MJD computed)

! Local Variables
! ---------------------------------
    INTEGER(KIND=4)                                  :: my, iypmy
    INTEGER(KIND=4), PARAMETER                       :: iymin = -4799    ! Earliest year allowed (4800BC)
    INTEGER(KIND=4), DIMENSION(12)                   :: mtab             ! Month lengths in days

    mtab = (/ 31,28,31,30,31,30,31,31,30,31,30,31 /)

! Preset status
    j = 0

! Validate year
    IF (iy < iymin) THEN
       j = -1
    ELSE
! Validate month
       IF (im >=1 .AND. im <= 12) THEN
! Allow for leap year
          IF (MOD(iy,4) == 0) THEN
             mtab(2) = 29
          ELSE
             mtab(2) = 28
          END IF
          IF (MOD(iy,100) == 0 .AND. MOD(iy,400) /= 0) mtab(2) = 28

! Validate day
          IF (id < 1 .OR. id > mtab(im)) j = -3

! Result
          my    = (im-14)/12
          iypmy = iy+my
          mjd   = 1461*(iypmy+4800)/4+367*(im-2-12*my)/12-3*(iypmy+4900)/100/4+id-2432076
       ELSE
! Bad month
          j = -2
       END IF
    END IF

    RETURN
    
  END SUBROUTINE cal2mjd

END MODULE s_glofreqchan
