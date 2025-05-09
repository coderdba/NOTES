
from mcp.server.fastmcp import FastMCP
from mcp.auth import AuthSettings
from mcp.auth.oauth import OAuthProvider
from fastapi.middleware.cors import CORSMiddleware

# OAuth configuration for GitHub
oauth_provider = OAuthProvider(
    client_id="your_github_client_id",
    client_secret="your_github_client_secret",
    authorize_url="https://github.com/login/oauth/authorize",
    token_url="https://github.com/login/oauth/access_token",
    user_info_url="https://api.github.com/user",
    scopes=["read:user", "user:email"],
    redirect_uri="http://localhost:8000/auth/callback"
)

# Wrap in AuthSettings
auth_settings = AuthSettings(provider=oauth_provider)

# Create the MCP server
mcp = FastMCP(
    name="OAuthMCPServer",
    description="An MCP server secured with GitHub OAuth",
    auth=auth_settings
)

# Optional: Add CORS middleware if you're testing from a browser
mcp.app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define a tool that uses the authenticated user info
@mcp.tool()
def whoami(user: dict) -> str:
    """Returns the GitHub username of the authenticated user."""
    return f"You are logged in as: {user.get('login', 'unknown')}"

# Run the server
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(mcp.app, host="0.0.0.0", port=8000)
