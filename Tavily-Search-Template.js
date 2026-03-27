// To install: npm i @tavily/core
const { tavily } = require('@tavily/core');
const client = tavily({ apiKey: "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" });
client.search("", {
    includeAnswer: "advanced",
    searchDepth: "advanced",
    maxResults: 8,
    timeRange: "year",
    includeUsage: true,
    includeRawContent: "markdown",
    chunksPerSource: 5
})
.then(console.log);