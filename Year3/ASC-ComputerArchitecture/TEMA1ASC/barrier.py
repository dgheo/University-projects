"""
This module represents a barrier.

Computer Systems Architecture Course
Assignment 1
Digori Gheorghe
March 2018
"""

from threading import Semaphore, Lock

class ReusableBarrier(object):
    """
    Bariera reentranta, implementata folosind 2 semafoare.
    """

    def __init__(self, num_threads):
        """
        Constructor.
        @param num_threads: numarul de thread-uri
        """
        self.num_threads = num_threads
        self.count_threads1 = [self.num_threads]
        self.count_threads2 = [self.num_threads]

        self.counter_lock = Lock()                      # protejam accesarea/modificarea contoarelor

        self.threads_sem1 = Semaphore(0)                # blocam thread-urile in prima etapa

        self.threads_sem2 = Semaphore(0)                # blocam thread-urile in a doua etapa

    def wait(self):
        """
        Asteapta threadurile pentru ambele etape, astfel
        toate threadurile ar trebuie sa execute aquire()
        inainte de a reveni la bariera
        """
        self.phase(self.count_threads1, self.threads_sem1)
        self.phase(self.count_threads2, self.threads_sem2)

    def phase(self, count_threads, threads_sem):
        """
        Bariera pentru prima etapa.
        - num_threads-1 thread-uri vor face acquire pe semafor
        - ultimul thread face release de num_threads de ori pe semafor
        - unul din release-uri este pentru el
        Se executa bariera pentru prima etapa astfel un numar de
        num_threads - 1 executa aquire pe semafor,
        iar ultimul thread va face realese pe de num_threads
        ori pe semafor (un realese fiind pentru el insusi)
        """
        with self.counter_lock:
            count_threads[0] -= 1
            if count_threads[0] == 0:                   # a ajuns la bariera si ultimul thread
                nr_release = 0
                while nr_release < self.num_threads:
                    threads_sem.release()
                    # incrementare semafor ce va debloca num_threads thread-uri
                    nr_release += 1                     # reseteaza contorul
                count_threads[0] = self.num_threads     # num_threads-1 threaduri se blocheaza aici
        threads_sem.acquire()      # contorul semaforului se decrementeaza de num_threads ori
