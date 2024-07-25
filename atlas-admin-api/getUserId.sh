source ./env.conf

# Tests API access by returning all projects in your organization

curl --user "$PUBLIC_KEY:$PRIVATE_KEY" --digest \
      --header "Content-Type: application/json" \
      --header "Accept: application/vnd.atlas.2023-02-01+json" \
      --include \
      --request GET "$ATLAS_BASE_URL/api/atlas/v2/users/byName/firstname.lastname%40mongodb.com/?pretty=true"

