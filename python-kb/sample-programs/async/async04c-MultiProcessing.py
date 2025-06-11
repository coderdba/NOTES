#  To run two functions concurrently in Python, you can use the concurrent.futures module or the asyncio library, depending on whether your functions are CPU-bound or I/O-bound. Below are three approaches:
#  Key Considerations:
#  Use ThreadPoolExecutor or asyncio for I/O-bound tasks (e.g., file operations, network requests).
#  Use multiprocessing for CPU-bound tasks (e.g., heavy computations) to leverage multiple CPU cores.

# 3. Using multiprocessing (for CPU-bound tasks)

from multiprocessing import Process
import time

print("\n\n3. Using multiprocessing (for CPU-bound tasks)")

def function_one():
    print("Function One is running")
    # Simulate work
    import time; time.sleep(2)
    print("Function One is done")

def function_two():
    print("Function Two is running")
    # Simulate work
    import time; time.sleep(1)
    print("Function Two is done")

if __name__ == "__main__":
    process1 = Process(target=function_one)
    process2 = Process(target=function_two)

    start = time.time()

    process1.start()
    process2.start()

    process1.join()
    process2.join()
    
    print(f"\nTime taken: {time.time() - start:.2f} seconds\n")
