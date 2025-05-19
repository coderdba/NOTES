can you add code in fc01.py file to send a word document mydoc.docx to azureopenai and obtain a text output that contains the process flow in the document. The flow format should be amenable to be used by draw io.

For LLM model use the function llm_init_AzureOpenAi_Langchain() in src/llmfunctions.py

=================
To use this code:

Make sure you have required packages:
Place your Word document (mydoc.docx) in the same directory as fc01.py

The code will:

Extract text from the Word document
Use Azure OpenAI to analyze the text and create a process flow
Output the flow in a format compatible with draw.io
Save the result to process_flow.txt
The output format will look like:

You can then:
Open draw.io
Create a new flowchart
Use the output text as a guide to create the visual flowchart
Each [ ] becomes a process box
Each { } becomes a decision diamond
Arrows connect the elements as indicated by ->
The code uses your existing llm_init_AzureOpenAi_Langchain() function and assumes your environment variables are properly set up for Azure OpenAI access.


=================

from docx import Document
from src.llmfunctions import llm_init_AzureOpenAi_Langchain
from langchain_core.prompts import PromptTemplate
import os
from dotenv import load_dotenv

def extract_text_from_docx(file_path):
    """Extract text from Word document"""
    doc = Document(file_path)
    full_text = []
    for paragraph in doc.paragraphs:
        full_text.append(paragraph.text)
    return "\n".join(full_text)

def get_process_flow(text, llm):
    """Convert document text to process flow using Azure OpenAI"""
    
    prompt_template = """
    Analyze the following text and extract the process flow in a format suitable for draw.io flowchart.
    Use the following guidelines:
    1. Identify the main steps or stages in the process
    2. Use -> to indicate flow between steps
    3. Use [ ] for process steps
    4. Use { } for decision points
    5. Keep the flow linear and clear
    6. Include only the key process steps
    
    Text to analyze:
    {text}
    
    Output the process flow in a format like this example:
    [Start] -> [Step 1] -> {Decision 1} -> [Step 2] -> [End]
    
    Process Flow:
    """

    PROMPT = PromptTemplate(template=prompt_template, input_variables=["text"])
    
    # Get response from LLM
    response = llm.invoke(PROMPT.format(text=text))
    return response

def main():
    # Load environment variables
    load_dotenv()
    
    # Initialize Azure OpenAI
    llm = llm_init_AzureOpenAi_Langchain()
    
    # Path to Word document
    doc_path = "mydoc.docx"
    
    try:
        # Extract text from document
        document_text = extract_text_from_docx(doc_path)
        
        # Get process flow
        flow_text = get_process_flow(document_text, llm)
        
        # Save output to file
        with open("process_flow.txt", "w") as f:
            f.write(flow_text)
        
        print("Process flow has been extracted and saved to process_flow.txt")
        print("\nFlow diagram text:")
        print(flow_text)
        
    except Exception as e:
        print(f"Error processing document: {str(e)}")

if __name__ == "__main__":
    main()
