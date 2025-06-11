#  To run two functions concurrently in Python, you can use the concurrent.futures module or the asyncio library, depending on whether your functions are CPU-bound or I/O-bound. Below are three approaches:
#  Key Considerations:
#  Use ThreadPoolExecutor or asyncio for I/O-bound tasks (e.g., file operations, network requests).
#  Use multiprocessing for CPU-bound tasks (e.g., heavy computations) to leverage multiple CPU cores.

#  1. Using concurrent.futures.ThreadPoolExecutor (for I/O-bound tasks)

from concurrent.futures import ThreadPoolExecutor
import time

print("\n\n1. Using concurrent.futures.ThreadPoolExecutor (for I/O-bound tasks)")

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

start = time.time()

with ThreadPoolExecutor() as executor:
    executor.submit(function_one)
    executor.submit(function_two)

print(f"\nTime taken: {time.time() - start:.2f} seconds\n")
