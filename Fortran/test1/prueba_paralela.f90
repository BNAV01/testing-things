program prueba_thinkpad
	use omp_lib
	implicit none
	integer :: id_thread, total_threads

	!$omp parallel private(id_thread)
	id_thread = omp_get_thread_num()
	total_threads = omp_get_num_threads()
	
	print *, "Operational military threads", id_thread, " a total of", total_threads
	!$omp end parallel
end program prueba_thinkpad
