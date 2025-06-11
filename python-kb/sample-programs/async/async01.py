import asyncio

async def say_hello(name, delay):
    await asyncio.sleep(delay)
    print(f"Hello, {name}!")

async def main():
    # Schedule multiple tasks to run concurrently
    task1 = asyncio.create_task(say_hello("Alice", 2))
    task2 = asyncio.create_task(say_hello("Bob", 1))
    task3 = asyncio.create_task(say_hello("Charlie", 3))

    # Wait for all tasks to complete
    await task1
    await task2
    await task3

async def main2():
    
    print("in main2")
    # Schedule multiple tasks to run concurrently
    task1 = asyncio.create_task(say_hello("Alice", 2))
    task2 = asyncio.create_task(say_hello("Bob", 1))
    task3 = asyncio.create_task(say_hello("Charlie", 3))

    # Wait for all tasks to complete
    task1
    task2
    task3
    
# Run the event loop
print("info - running main")
asyncio.run(main())

print("info - running main2")
asyncio.run(main2())


