# Login
from huggingface_hub import login
access_token = "your_access_token"
login(token=access_token)

'''
The token has not been saved to the git credentials helper. Pass `add_to_git_credential=True` in this function directly or `--add-to-git-credential` if using via `huggingface-cli` if you want to set the git credential as well.
Token is valid (permission: fineGrained).
Your token has been saved to C:\Users\myusername\.cache\huggingface\token
Login successful
'''

# Download
# NOTE: This downloads all files in the model though you may need certain versions only
# https://huggingface.co/mistralai/Mistral-7B-v0.3/tree/main
from huggingface_hub import snapshot_download
from pathlib import Path
mistral_models_path = Path.home().joinpath('c:\opt\LLM\models\mistral_models', '7B-Instruct-v0.3')
mistral_models_path.mkdir(parents=True, exist_ok=True)
snapshot_download(repo_id="mistralai/Mistral-7B-Instruct-v0.3", allow_patterns=["params.json", "consolidated.safetensors", "tokenizer.model.v3"], local_dir=mistral_models_path)
