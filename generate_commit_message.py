import sys
import subprocess
import boto3
import json

def get_git_diff():
    return subprocess.check_output(['git', 'diff', '--cached']).decode('utf-8')

def generate_commit_message_claude(diff):
    # Create a boto3 session using the SSO profile
    session = boto3.Session(profile_name='your_sso_profile_name')
    
    # Create a Bedrock client using the session
    bedrock = session.client('bedrock-runtime')
    
    prompt = f"""
    Generate a concise and informative commit message based on the following git diff:

    {diff}

    The commit message should:
    1. Start with a summary in imperative mood
    2. Explain the 'why' behind changes, when possible. Don't make anything up.
    3. Keep the summary under 50 characters
    4. Use bullet points for multiple changes
    """

    response = bedrock.invoke_model(
        modelId='anthropic.claude-3-5-sonnet-20240620-v1:0',
        body=json.dumps({
            "prompt": prompt,
            "temperature": 0.3,
            "top_p": 1,
            "stop_sequences": ["\n\n"]
        })
    )

    return json.loads(response['body'].read())['completion']

def update_commit_message(file_path, new_message):
    with open(file_path, 'r+') as f:
        content = f.read()
        f.seek(0)
        f.write(f"{new_message.strip()}\n\n{content}")

if __name__ == '__main__':
    commit_msg_file = sys.argv[1]
    diff = get_git_diff()
    commit_message = generate_commit_message_claude(diff)
    print(commit_message)
    #update_commit_message(commit_msg_file, commit_message)