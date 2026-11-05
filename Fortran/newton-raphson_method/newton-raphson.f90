program newtonraphson
	implicit none
	
	real, parameter :: error=1e-4
	real :: x0, x1
	
	integer :: iter
	integer :: max_iter

	
	
	real, external :: f
	real, external :: df

	10 read (*,*) x0
	
	iter = 0
	max_iter = 100
		

	if (abs(df(x0)).le.1e-6) then
		write(*,*) "Valor muy cercano a 0, probar otro"
		goto 10		
	endif
	15 x1 = x0 - (f(x0)/df(x0))
	
	iter = iter + 1

	write(*,*) "Iteracion N°: ", iter , " con x1: ", x1

	if (abs(x1-x0).le.error .and. abs(f(x1)).le.error) goto 20	
	if (iter.ge.max_iter) then
		write(*,*) "Maximo de iteraciones permitidas"
		stop
	endif

	x0 = x1

	if (abs(df(x0)).le.1e-6) then
		write(*,*) "Derivada muy cercada a 0"
		goto 10
	endif
	
	goto 15

	20 write(*,*) "Resutado: ", x1
	   write(*,*) "Iteracion: ", iter
end program newtonraphson

real function f(x)

	implicit none
	real :: x

	f = 3*x + sin(x) - exp(x)

end function f



real function df(x)
    implicit none

    real, intent(in) :: x
    real :: h
    real, external :: f

    h = 1e-3

    df = (f(x+h) - f(x-h))/(2.0*h)

end function df

