# Creates a "Local Atlas Deployment",
# which runs in a local Docker container (Docker Desktop is required)
# and provides Search and Vector Search functionality, 
# in addition to being a standard MongoDB database.

# Blog:
# https://www.mongodb.com/blog/post/introducing-local-development-experience-atlas-search-vector-search-atlas-cli

atlas deployments setup --type local

atlas deployments list

# atlas deployments delete

