# Tests Atlas search against a "local Atlas deployment"
# by executing a $search aggregation pipeline.

echo "(You can run this again after index completes INITIAL_SYNC)"

mongosh --eval '

db = db.getSiblingDB("sample_mflix")

db.embedded_movies.createSearchIndex(
    "example-index",
    { mappings: { dynamic: true } }
)

stageSearch =
{
  "$search": {
    "index": "example-index",
    "text": {
      "query": "baseball",
      "path": ["title", "fullplot"]
    },
    "highlight": {
       "path": ["title", "fullplot"]
    }
  }
}

stageOut = { "$out": "searchResults" }

aggPipeline = [ stageSearch, stageOut ]

db.embedded_movies.aggregate( aggPipeline )

'

echo "Done. Check sample_mflix.searchResults collection for output."

