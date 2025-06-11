import asyncio

async def say_hello(name, delay):
    await asyncio.sleep(delay)
    print(f"Hello, {name}!")

async def main():
    print("\n\nin main")

    # Schedule multiple tasks to run concurrently
    print("info - creating tasks with create_task")
    task1 = asyncio.create_task(say_hello("Alice", 2))
    task2 = asyncio.create_task(say_hello("Bob", 1))
    task3 = asyncio.create_task(say_hello("Charlie", 3))

    # Wait for all tasks to complete
    await task1
    await task2
    await task3

async def main2():
    
    print("\n\nin main2")
    # Schedule multiple tasks to run concurrently
    print("info - creating tasks with create_task")
    task1 = asyncio.create_task(say_hello("Alice", 2))
    task2 = asyncio.create_task(say_hello("Bob", 1))
    task3 = asyncio.create_task(say_hello("Charlie", 3))

    # Wait for all tasks to complete
    print("info - running tasks without await, but with a await with small sleep at the end")
    task1
    task2
    task3
    await asyncio.sleep(2)  # This 1 second wait will not be sufficient as 3 tasks need 6+ seconds
    
async def main3():
    
    print("\n\nin main3")
    # Schedule multiple tasks to run concurrently
    print("info - creating tasks with create_task")
    task1 = asyncio.create_task(say_hello("Alice", 2))
    task2 = asyncio.create_task(say_hello("Bob", 1))
    task3 = asyncio.create_task(say_hello("Charlie", 3))

    print("info - running with gather")
    await asyncio.gather(task1, task2, task3)
    
# Run the event loop
print("info - running main")
asyncio.run(main())

print("info - running main2")
asyncio.run(main2())

print("info - running main3")
asyncio.run(main3())


