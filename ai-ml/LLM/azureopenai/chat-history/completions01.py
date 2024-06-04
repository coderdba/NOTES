# Reference: https://cookbook.openai.com/examples/azure/chat
#
# Uses azure openai chat completions
# How it works: Just keep appending and sending all questions and answers together back to Azure OpenAI
#

import os
import openai
import dotenv

# Source environment
dotenv.load_dotenv()

# Authentication choice
use_azure_active_directory = False  # Set this flag to True if you are using Azure Active Directory

# Authentication NOT using Azure AD
if not use_azure_active_directory:
    endpoint = os.environ["AZURE_OPENAI_ENDPOINT"]
    api_key = os.environ["AZURE_OPENAI_API_KEY"]

    client = openai.AzureOpenAI(
        azure_endpoint=endpoint,
        api_key=api_key,
        api_version=os.getenv("OPENAI_API_VERSION")
        #api_version="2023-09-01-preview"
    )

# Authentication using Azure AD
'''
from azure.identity import DefaultAzureCredential, get_bearer_token_provider
if use_azure_active_directory:
    endpoint = os.environ["AZURE_OPENAI_ENDPOINT"]

    client = openai.AzureOpenAI(
        azure_endpoint=endpoint,
        azure_ad_token_provider=get_bearer_token_provider(DefaultAzureCredential(), "https://cognitiveservices.azure.com/.default"),
        api_version="2023-09-01-preview"
    )
'''

# Deployment
deployment=os.getenv("AZURE_OPENAI_DEPLOYMENT")  # Fill in the deployment name from the portal here

# Create chatcompletion agent
# For all possible arguments see https://platform.openai.com/docs/api-reference/chat-completions/create

## Example 1
print("INFO - Create chatcompletion agent - Example 1 ")
response = client.chat.completions.create(
    model=deployment,
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Knock knock."},
        {"role": "assistant", "content": "Who's there?"},
        {"role": "user", "content": "Orange."},
    ],
    temperature=0,
)

print(f"{response.choices[0].message.role}: {response.choices[0].message.content}")


## Example 2
print("INFO - Create chatcompletion agent - Example 2 ")
# For all possible arguments see https://platform.openai.com/docs/api-reference/chat-completions/create
response = client.chat.completions.create(
    model=deployment,
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "How old is the Universe?"},
    ],
    temperature=0,
)

print(f"{response.choices[0].message.role}: {response.choices[0].message.content}")

## Example 3 - adding previous response to the next question
print("INFO - Create chatcompletion agent - Example 3 - adding previous response to the next question ")
response2 = client.chat.completions.create(
    model=deployment,
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "How old is the Universe?"},
        {"role": "assistant", "content":  response.choices[0].message.content },
        {"role": "user", "content": "I do not believe it. Can you explain more?"},
    ],
    temperature=0,
)

print(f"{response2.choices[0].message.role}: {response2.choices[0].message.content}")

exit()

# Create 'streaming' chat completion
response_stream = client.chat.completions.create(
    model=deployment,
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Knock knock."},
        {"role": "assistant", "content": "Who's there?"},
        {"role": "user", "content": "Orange."},
    ],
    temperature=0,
    stream=True
)

for chunk in response_stream:
    if len(chunk.choices) > 0:
        delta = chunk.choices[0].delta

        if delta.role:
            print(delta.role + ": ", end="", flush=True)
        if delta.content:
            print(delta.content, end="", flush=True)
            
            
# Content filtering
import json

messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "<text violating the content policy>"}
]

try:
    completion = client.chat.completions.create(
        messages=messages,
        model=deployment,
    )
except openai.BadRequestError as e:
    err = json.loads(e.response.text)
    if err["error"]["code"] == "content_filter":
        print("Content filter triggered!")
        content_filter_result = err["error"]["innererror"]["content_filter_result"]
        for category, details in content_filter_result.items():
            print(f"{category}:\n filtered={details['filtered']}\n severity={details['severity']}")
            
            
# Checking result of content filter
messages = [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "What's the biggest city in Washington?"}
]

completion = client.chat.completions.create(
    messages=messages,
    model=deployment,
)
print(f"Answer: {completion.choices[0].message.content}")

# prompt content filter result in "model_extra" for azure
prompt_filter_result = completion.model_extra["prompt_filter_results"][0]["content_filter_results"]
print("\nPrompt content filter results:")
for category, details in prompt_filter_result.items():
    print(f"{category}:\n filtered={details['filtered']}\n severity={details['severity']}")

# completion content filter result
print("\nCompletion content filter results:")
completion_filter_result = completion.choices[0].model_extra["content_filter_results"]
for category, details in completion_filter_result.items():
    print(f"{category}:\n filtered={details['filtered']}\n severity={details['severity']}")
