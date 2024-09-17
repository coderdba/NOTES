import multiprocessing
import math
import time

def cpu_intensive_task(duration):
    # Perform a CPU-intensive task for a specified duration
    end_time = time.time() + duration
    while time.time() < end_time:
        for i in range(1000000):
            math.sqrt(i)

if __name__ == "__main__":
    duration = 60  # Duration in seconds
    processes = []
    print("INFO - CPU Count: ", multiprocessing.cpu_count())
    for _ in range(multiprocessing.cpu_count()):
        p = multiprocessing.Process(target=cpu_intensive_task, args=(duration,))
        processes.append(p)
        p.start()

    for p in processes:
        p.join()

print("CPU spike simulation assigned to CPUs.")