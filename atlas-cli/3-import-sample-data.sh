# Some data is needed to test atlas search and vector search.
# The embedded movies collection from the Atlas sample data set works well.

# The URI points to a "local Atlas deployment".

mongoimport \
 -v \
 --collection embedded_movies \
 --type json \
 --mode insert \
 --drop \
 --file embedded_movies.json \
 "mongodb://localhost:27017/sample_mflix"

