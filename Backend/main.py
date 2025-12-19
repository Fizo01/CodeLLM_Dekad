from fastapi import FastAPI
from pydantic import BaseModel
import httpx
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

# Configuration
ROUTELLM_API_KEY = os.getenv("ROUTELLM_API_KEY")
ROUTELLM_BASE_URL = os.getenv("ROUTELLM_BASE_URL", "https://routellm.abacus.ai/v1")
MODEL_NAME = os.getenv("MODEL_NAME", "gpt-4.1-mini")

# Shared system prompt for all endpoints
SYSTEM_PROMPT = """
You are a Networking Guide helping professionals enhance their networking effectiveness. 
Your role is to provide concise, actionable suggestions that improve how people connect 
and communicate professionally. Be direct, valuable, and keep responses focused on the 
specific task requested.
"""

# Request models
class BioRewriteRequest(BaseModel):
    raw_bio: str
    mode: str  # professional or personal
    max_length: int

class BadgeTextRequest(BaseModel):
    badge_id: str
    event_context: str
    user_role: str

class FollowUpRequest(BaseModel):
    contact_id: str
    previous_conversation: str
    last_meeting_date: str

class NotesSummaryRequest(BaseModel):
    notes: str

# Response models
class BioRewriteResponse(BaseModel):
    rewritten_bio: str

class BadgeTextResponse(BaseModel):
    badge_id: str
    title: str
    message: str
    cta: str
    tone: str

class FollowUpResponse(BaseModel):
    contact_id: str
    suggested_message: str
    send_channel: str
    delay_days: int

class NotesSummaryResponse(BaseModel):
    summary_bullets: list[str]

async def call_routellm(prompt: str) -> str:
    """Call RouteLLM API with the given prompt"""
    async with httpx.AsyncClient() as client:
        response = await client.post(
            f"{ROUTELLM_BASE_URL}/chat/completions",
            headers={
                "Authorization": f"Bearer {ROUTELLM_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": MODEL_NAME,
                "messages": [
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": prompt}
                ]
            }
        )
        response.raise_for_status()
        data = response.json()
        return data["choices"][0]["message"]["content"]

@app.post("/api/bio-rewrite", response_model=BioRewriteResponse)
async def bio_rewrite(request: BioRewriteRequest):
    prompt = f"""
    Rewrite the following bio in {request.mode} mode with a maximum length of {request.max_length} characters:
    
    {request.raw_bio}
    """
    result = await call_routellm(prompt)
    return BioRewriteResponse(rewritten_bio=result)

@app.post("/api/badge-text", response_model=BadgeTextResponse)
async def badge_text(request: BadgeTextRequest):
    prompt = f"""
    Generate badge text for badge ID {request.badge_id} in the context of {request.event_context} 
    for a user with role {request.user_role}.
    """
    result = await call_routellm(prompt)
    # In a real implementation, you would parse the result into the expected JSON format
    # For now, returning a placeholder response
    return BadgeTextResponse(
        badge_id=request.badge_id,
        title="Event Connection",
        message="You've connected with someone new!",
        cta="View Profile",
        tone="friendly"
    )

@app.post("/api/follow-up", response_model=FollowUpResponse)
async def follow_up(request: FollowUpRequest):
    prompt = f"""
    Suggest a follow-up message for contact {request.contact_id}. 
    Previous conversation: {request.previous_conversation}
    Last meeting date: {request.last_meeting_date}
    """
    result = await call_routellm(prompt)
    # In a real implementation, you would parse the result into the expected JSON format
    # For now, returning a placeholder response
    return FollowUpResponse(
        contact_id=request.contact_id,
        suggested_message="It was great meeting you at the event!",
        send_channel="email",
        delay_days=2
    )

@app.post("/api/notes-summary", response_model=NotesSummaryResponse)
async def notes_summary(request: NotesSummaryRequest):
    prompt = f"Summarize the following notes into bullet points:\n\n{request.notes}"
    result = await call_routellm(prompt)
    # In a real implementation, you would parse the result into bullet points
    # For now, returning a placeholder response
    return NotesSummaryResponse(
        summary_bullets=[
            "Key discussion points summarized",
            "Action items identified",
            "Next steps outlined"
        ]
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)