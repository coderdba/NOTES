#  To run two functions concurrently in Python, you can use the concurrent.futures module or the asyncio library, depending on whether your functions are CPU-bound or I/O-bound. Below are three approaches:
#  Key Considerations:
#  Use ThreadPoolExecutor or asyncio for I/O-bound tasks (e.g., file operations, network requests).
#  Use multiprocessing for CPU-bound tasks (e.g., heavy computations) to leverage multiple CPU cores.

#  2. Using asyncio (for I/O-bound tasks with async functions)

import asyncio
import time

print("\n\n2. Using asyncio (for I/O-bound tasks with async functions)")

async def function_one():
    print("Function One is running")
    await asyncio.sleep(2)  # Simulate async work
    print("Function One is done")

async def function_two():
    print("Function Two is running")
    await asyncio.sleep(1)  # Simulate async work
    print("Function Two is done")

async def main():
    await asyncio.gather(function_one(), function_two())

start = time.time()

asyncio.run(main())

print(f"\nTime taken: {time.time() - start:.2f} seconds\n")
