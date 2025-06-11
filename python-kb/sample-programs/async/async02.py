import asyncio

async def f1():
    print("f1 1")
    print("f1 2")
    
    
f1
#await f1 
asyncio.run(f1())
