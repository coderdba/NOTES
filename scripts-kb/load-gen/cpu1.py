import multiprocessing
import math

def cpu_intensive_task():
    # Perform a CPU-intensive task
    for i in range(1000000):
        math.sqrt(i)

if __name__ == "__main__":
    # Create multiple processes to simulate a CPU spike
    processes = []
    for _ in range(multiprocessing.cpu_count()):
        p = multiprocessing.Process(target=cpu_intensive_task)
        processes.append(p)
        p.start()

    # Wait for all processes to complete
    for p in processes:
        p.join()

print("CPU spike simulation completed.")