curl -X POST https://api.tavily.com/search \
-H 'Content-Type: application/json' \
-H 'Authorization: Bearer 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' \
-d '{
    "query": "",
    "include_answer": "advanced",
    "search_depth": "advanced",
    "max_results": 8,
    "time_range": "year",
    "include_usage": true,
    "include_raw_content": "markdown",
    "chunks_per_source": 5
}'
