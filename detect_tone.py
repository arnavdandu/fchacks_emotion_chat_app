# This function is hosting on Google Cloud.
# It is not useful when run by itself without modifications, 
# as it depends on data from the app.

import json
from ibm_watson import ToneAnalyzerV3
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator


def get_tone(request):
    msg = request.get_json().get("msg")
    # Get authenticator object with api token
    authenticator = IAMAuthenticator('ngsQFCQC7eRgrFpRDpsIUF1KWQum42rmyVXMM5vZW5G3')
    # Create tone analyzer using the authenticator 
    tone_analyzer = ToneAnalyzerV3(
        version='2017-09-21',
        authenticator=authenticator
    )

    # Set API service URL
    tone_analyzer.set_service_url('https://api.us-east.tone-analyzer.watson.cloud.ibm.com/instances/9fe1358f-aa84-405a-a6ad-dfa79cc65c54')
    
    # Analyze the text, and get the result as JSON
    tone_analysis = tone_analyzer.tone(
        {'text': msg},
        content_type='application/json'
    ).get_result()

    # Check if any tones were detected
    if len(tone_analysis['document_tone']['tones']) > 0:
        # If tones were detected, return the name of the tone / emotion with the highest score
        return tone_analysis['document_tone']['tones'][0]['tone_name'] 
        # The tone score (for coloring purposes) is tone_analysis['document_tone']['tones'][0]['score']
    else:
        # If no tones were detected, return 'No emotions detected'
        return 'No emotions detected'
