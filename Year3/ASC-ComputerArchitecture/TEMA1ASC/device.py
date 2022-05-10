"""
This module represents a device.

Computer Systems Architecture Course
Assignment 1
Digori Gheorghe
March 2018
"""
from threading import Event, Thread, Lock, Condition
from barrier import ReusableBarrier



class Device(object):
    """
    Class that represents a device.
    """

    def __init__(self, device_id, sensor_data, supervisor):
        """
        Constructor.

        @type device_id: Integer
        @param device_id: the unique id of this node; between 0 and N-1

        @type sensor_data: List of (Integer, Float)
        @param sensor_data: a list containing (location, data) as measured by this device

        @type supervisor: Supervisor
        @param supervisor: the testing infrastructure's control and validation component
        """
        self.device_id = device_id
        self.sensor_data = sensor_data
        self.supervisor = supervisor
        self.scripts = []
        self.timepoint_done = Event()

        # event to check if all the pre run configuration are done
        self.setup_configuration_event = Event()

        # event to check if setup is finished or not
        self.init_setup = Event()

        # barrier used to syncronyse devices
        self.dev_barrier = None

        # lock to control data streams
        self.lock_dev_data = Lock()

        # shut down order for working threads
        self.shut_down_order = False

        #counter for solved scripts
        self.solved_scripts_in_lifecycle = 0

        # lock for location
        self.list_location_lock = []

        #list to store information about device(location, data)
        self.device_data = []

        #list to store device neighbours
        self.neighbours_data = []

        #list to store devices
        self.dev_list = []

        #consummer producer semafor that use Condition
        self.producer_consumers = Condition()

        #number of ready scripts to be consumed by consumer(worker thread)
        self.waiting_for_production = 0

        #define a thread object from DeviceThread
        self.thread = DeviceThread(self)

        #start thread
        self.thread.start()


    def __str__(self):
        """
        Pretty prints this device.

        @rtype: String
        @return: a string containing the id of this device
        """
        return "Device %d" % self.device_id

    def setup_devices(self, devices):
        """
        Setup the devices before simulation begins.

        @type devices: List of Device
        @param devices: list containing all devices
        """
        # we don't need no stinkin' setup
        if self.device_id == 0:
            #create devices barrier
            self.dev_barrier = ReusableBarrier(len(devices))
            #find maxim number of locations
            max_location_number = 0
            #get max location of devices
            for device in devices:
                max_location_number = max(max_location_number, max(device.sensor_data.keys()))
            max_location_number += 1
            #create lock for each location
            for _ in xrange(max_location_number):
                self.list_location_lock.append(Lock())

            #add all the devices in a list of devices
            for device in devices:
                device.dev_list = devices
            #set a Event
            self.init_setup.set()


    def assign_script(self, script, location):
        """
        Provide a script for the device to execute.

        @type script: Script
        @param script: the script to execute from now on at each timepoint; None if the
            current timepoint has ended

        @type location: Integer
        @param location: the location for which the script is interested in
        """
        if script is not None:
            self.scripts.append((script, location))
        else:
            self.timepoint_done.set()

    def get_data(self, location):
        """
        Returns the pollution value this device has for the given location.

        @type location: Integer
        @param location: a location for which obtain the data

        @rtype: Float
        @return: the pollution value
        """
        return self.sensor_data[location] if location in self.sensor_data else None

    def set_data(self, location, data):
        """
        Sets the pollution value stored by this device for the given location.

        @type location: Integer
        @param location: a location for which to set the data

        @type data: Float
        @param data: the pollution value
        """
        with self.lock_dev_data:
            if location in self.sensor_data:
                self.sensor_data[location] = data

    def shutdown(self):
        """
        Instructs the device to shutdown (terminate all threads). This method
        is invoked by the tester. This method must block until all the threads
        started by this device terminate.
        """
        self.thread.join()


class DeviceThread(Thread):
    """
    Class that implements the device's worker thread.
    """

    def __init__(self, device):
        """
        Constructor.

        @type device: Device
        @param device: the device which owns this thread
        """
        Thread.__init__(self, name="Device Thread %d" % device.device_id)
        self.device = device

    def run(self):
        if self.device.device_id == 0:
            #wait setup to be done
            self.device.init_setup.wait()
            #get device barrier and list of locations locks
            for i in self.device.dev_list:
                i.dev_barrier = self.device.dev_barrier
                i.list_location_lock = self.device.list_location_lock
                i.setup_configuration_event.set()

        # make devices wait for configuration to be done
        self.device.setup_configuration_event.wait()

        # create WorkersThreads (workers)
        list_threads = []
        for i in range(8):
            list_threads.append(WorkerThread(self.device, i))

        #start workers
        for thrd in list_threads:
            thrd.start()


        while True:
            # get the current neighbourhood
            neighbours = self.device.supervisor.get_neighbours()
            if neighbours is None:
                break

            # wait for end of timepoint
            self.device.timepoint_done.wait()

            with self.device.producer_consumers:
                # run scripts received until now
                for pair in self.device.scripts:

                    # put the script in the work list
                    self.device.neighbours_data.append(neighbours)
                    self.device.device_data.append(pair)

                    #increment number of scripts to be consumed by worker threads
                    self.device.waiting_for_production += 1
                    self.device.producer_consumers.notify()
                    # increase the number of added scripts
                    self.device.solved_scripts_in_lifecycle += 1

            #clear timepoint
            self.device.timepoint_done.clear()

            # now wait for all device to reach this point
            self.device.dev_barrier.wait()

        # wait for all scripts to be finished
        with self.device.producer_consumers:
            while self.device.solved_scripts_in_lifecycle != 0:
                self.device.producer_consumers.wait()



        with self.device.producer_consumers:
        # inform workers to shut down
            self.device.shut_down_order = True
            self.device.producer_consumers.notify_all()

        #join the workers
        for thrd in list_threads:
            thrd.join()


class WorkerThread(Thread):
    """
    Worker thread Class. This class describe a worker thread and execute all necesary acction.

    """
    def __init__(self, device, thread_id):
        """
        Constructor.

        @type device: Device
        @param device_id: devise thread parrent

        @type thread_id: Int
        @param thread_id: the thread id
        """
        Thread.__init__(self, name="Worker Thread %d" % thread_id)
        #get informations form the device
        self.device = device
        self.thread_id = thread_id
        self.list_location_lock = device.list_location_lock
        self.device_data = device.device_data
        self.neighbours_data = device.neighbours_data

    def run(self):
        while  True:
            # wait until there are scripts produced in the data and neighbours list
            #or there is a shut down order
            with self.device.producer_consumers:
                while self.device.waiting_for_production == 0 and not self.device.shut_down_order:
                    self.device.producer_consumers.wait()
                if not self.device.shut_down_order:
                    #extract information
                    pair = self.device_data.pop()
                    (script, location) = (pair[0], pair[1])
                    neighbours = self.neighbours_data.pop()
                #decrement number of scripts
                self.device.waiting_for_production -= 1
                #notify all
                self.device.producer_consumers.notify_all()

            # if the shutdown order is given the break
            if self.device.shut_down_order is True:
                break
            #script_data list in wich I store the information about location
            script_data = []
            # using the location lock
            with self.list_location_lock[location]:
                # take data from the current neighbours
                for device in neighbours:
                    data = device.get_data(location)
                    if data is not None:
                        script_data.append(data)
                # add the current device data
                data = self.device.get_data(location)
                # if it exists
                if data is not None:
                    script_data.append(data)

                if script_data != []:
                    # run script on data
                    result = script.run(script_data)
                    # update our data
                    self.device.set_data(location, result)
                      # update data of neighbours
                    for device in neighbours:
                        device.set_data(location, result)
            with self.device.producer_consumers:
                #decrement number of scrpt to be solved
                self.device.solved_scripts_in_lifecycle -= 1
                #send a notification
                self.device.producer_consumers.notify_all()

