PROGRAM test_glofc

  USE s_glofreqchan
  IMPLICIT NONE
  
  INTEGER(KIND=4) :: iy, im, id
  INTEGER(KIND=4), DIMENSION(24) :: glofc

  iy = 2013
  im = 5
  id = 28
  
  CALL glo_freqchan(iy,im,id,glofc)

  WRITE(*,*) glofc

END PROGRAM test_glofc
