
program bisection
    implicit none

    real, parameter :: error = 1e-4
    real :: a, b, c
    real, external :: f

10  read(*,*) a, b

    if (f(a)*f(b).gt.0.0) then
        write(*,*) "Try with another values of a & b"
        goto 10
    endif

15  c = (a+b)/2.0

    if (abs(f(c)).lt.error) goto 20

    if (f(a)*f(c).lt.0.0) then
        b = c
    else
        a = c
    endif

    if (abs(b-a).gt.error) goto 15

20  write(*,*) "The root is=", c

end program bisection


real function f(x)
    implicit none

    real :: x

    f = 3*x + sin(x) - exp(x)

end function f
