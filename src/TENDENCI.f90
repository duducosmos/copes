!> Convective parametrization based in K. A. Emanuel (1991,1999) scheme
!>   Copyright (C) 2011  Grupo de Modelagem da Atmosfera e Interfaces (GMAI)
!>                http://meioambiente.cptec.inpe.br/gmai/index.php
!>
!> @Author Eduardo S. Pereira
!>
!>    This program is free software: you can redistribute it and/or modify
!>    it under the terms of the GNU General Public License as published by
!>    the Free Software Foundation, either version 3 of the License, or
!>    (at your option) any later version.
!>
!>    This program is distributed in the hope that it will be useful,
!>    but WITHOUT ANY WARRANTY; without even the implied warranty of
!>    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!>    GNU General Public License for more details.
!>
!>    You should have received a copy of the GNU General Public License
!>    along with this program.  If not, see <http://www.gnu.org/licenses/>.

module TENDENCI
    use VarDeclared
    implicit none
    
    contains
        
        subroutine copes_tendenci()
            integer :: I,J,K
            real :: DPINV,AM,AMDE

            !
            !   ***  CALCULATE DOWNDRAFT VELOCITY SCALE AND SURFACE TEMPERATURE AND  ***
            !   ***                    WATER VAPOR FLUCTUATIONS                      ***
            !
            WD=BETA*ABS(MP(ICB))*0.01*RD*T(ICB)/(SIGD*P(ICB))
            QPRIME=0.5*(QP(1)-Q(1))
            TPRIME=LV0*QPRIME/CPD
            !
            !   ***  CALCULATE TENDENCIES OF LOWEST LEVEL POTENTIAL TEMPERATURE  ***
            !   ***                      AND MIXING RATIO                        ***
            !
            DPINV=0.01/(PH(1)-PH(2))
            AM=0.0
            IF(NK.EQ.1)THEN
            
                DO  K=2,INB
                    AM=AM+M(K)
                ENDDO
                
            END IF
            
            IF((2.*G*DPINV*AM).GE.DELTI)IFLAG=4
            FT(1)=FT(1)+G*DPINV*AM*(T(2)-T(1)+(GZ(2)-GZ(1))/CPN(1))
            FT(1)=FT(1)-LVCP(1)*SIGD*EVAP(1)
            FT(1)=FT(1)+SIGD*WT(2)*(CL-CPD)*WATER(2)*(T(2)-T(1))*DPINV/CPN(1)
            FQ(1)=FQ(1)+G*MP(2)*(QP(2)-Q(1))*DPINV+SIGD*EVAP(1)
            FQ(1)=FQ(1)+G*AM*(Q(2)-Q(1))*DPINV
            FU(1)=FU(1)+G*DPINV*(MP(2)*(UP(2)-U(1))+AM*(U(2)-U(1)))
            FV(1)=FV(1)+G*DPINV*(MP(2)*(VP(2)-V(1))+AM*(V(2)-V(1)))
            
            DO J=1,NTRA
            
                FTRA(1,J)=FTRA(1,J)+G*DPINV*(MP(2)*(TRAP(2,J)-TRA(1,J))+&
                          AM*(TRA(2,J)-TRA(1,J)))
            END DO
            
            AMDE=0.0
            
            do_four_hundred_fifiteen: DO  J=2,INB
            
                FQ(1)=FQ(1)+G*DPINV*MENT(J,1)*(QENT(J,1)-Q(1))
                FU(1)=FU(1)+G*DPINV*MENT(J,1)*(UENT(J,1)-U(1))
                FV(1)=FV(1)+G*DPINV*MENT(J,1)*(VENT(J,1)-V(1))
                DO K=1,NTRA
                    FTRA(1,K)=FTRA(1,K)+G*DPINV*MENT(J,1)*(TRAENT(J,1,K)-&
                              TRA(1,K))
                END DO
                
            END DO do_four_hundred_fifiteen
        
        end subroutine copes_tendenci
        
end module TENDENCI
