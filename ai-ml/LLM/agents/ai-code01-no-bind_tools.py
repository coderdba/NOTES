from langchain import OpenAI, LLMChain
from langchain.agents import initialize_agent, Tool
from langchain.prompts import PromptTemplate
 
# Initialize the Mistral model (replace with the correct model loading code)
from transformers import AutoModelForCausalLM, AutoTokenizer
 
model_name = "mistral-model-name"  # Replace with the actual model name
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)
 
# Define a prompt template
prompt_template = PromptTemplate(
    input_variables=["input"],
    template="You are a helpful assistant. Answer the following question: {input}"
)
 
# Create an LLMChain
llm_chain = LLMChain(llm=model, prompt=prompt_template)
 
# Define tools for the agent
tools = [
    Tool(
        name="Mistral",
func=llm_chain.run,
        description="Use this tool to get answers from the Mistral model."
    )
]
 
# Initialize the agent
agent = initialize_agent(tools, llm_chain, agent_type="zero-shot-react-description", verbose=True)
 
# Use the agent
response = agent.run("What is the capital of France?")
print(response)
