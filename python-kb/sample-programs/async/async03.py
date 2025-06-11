import asyncio
import time
import threading

async def f1():
    for i in range(5):
        print(f"f1 {i}")
        await asyncio.sleep(0.2)
        
async def f2():
    for i in range(5):
        print(f"f2 {i}")
        await asyncio.sleep(0.2)
        
def run_async_function(coro):
    asyncio.run(coro)
  
async def main():


    '''
    # THIS DOES NOT WORK
    # Time concurrent execution with threads 2
    start = time.time()
    #t1 = threading.Thread(asyncio.run(f1()))
    #t2 = threading.Thread(asyncio.run(f2()))
    
    #t1 = threading.Thread(await f1)
    #t2 = threading.Thread(await f2)
     
    t1.start()
    t2.start()
    t1.join()
    t2.join()
    print(f"\nTime taken for threaded execution 2: {time.time() - start:.2f} seconds")
    '''


    # Time f1 execution
    start = time.time()
    await f1()
    print(f"\nTime taken for f1: {time.time() - start:.2f} seconds\n")
    
    # Time f2 execution
    start = time.time()
    await f2()
    print(f"\nTime taken for f2: {time.time() - start:.2f} seconds\n")
    
    # Time concurrent execution
    start = time.time()
    await asyncio.gather(f1(), f2())
    print(f"\nTime taken for concurrent execution: {time.time() - start:.2f} seconds")

    # Time concurrent execution with threads
    start = time.time()
    t1 = threading.Thread(target=run_async_function, args=(f1(),))
    t2 = threading.Thread(target=run_async_function, args=(f2(),))
    
    t1.start()
    t2.start()
    t1.join()
    t2.join()
    print(f"\nTime taken for threaded execution: {time.time() - start:.2f} seconds")

   # Concurrent execution using event loop and threads
    start = time.time()
    # Create new event loops for each thread
    def run_in_thread(coro):
        new_loop = asyncio.new_event_loop()
        asyncio.set_event_loop(new_loop)
        new_loop.run_until_complete(coro)
        new_loop.close()
    
    t1 = threading.Thread(target=run_in_thread, args=(f1(),))
    t2 = threading.Thread(target=run_in_thread, args=(f2(),))
    
    t1.start()
    t2.start()
    t1.join()
    t2.join()
    print(f"\nTime taken for threaded execution with event loop: {time.time() - start:.2f} seconds")

if __name__ == "__main__":
    asyncio.run(main())
