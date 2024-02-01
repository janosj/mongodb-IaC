source ./env.conf

# The group ID is the Project ID
GROUP_ID=$PROJECT_ID

# Custom Database Roles:
# https://www.mongodb.com/docs/atlas/reference/api-resources-spec/v2/#tag/Custom-Database-Roles

echo 

# Create a new test role.

curl --user "$PUBLIC_KEY:$PRIVATE_KEY" --digest \
      --header "Content-Type: application/json" \
      --header "Accept: application/vnd.atlas.2023-02-01+json" \
      --include \
      --request POST "$ATLAS_BASE_URL/api/atlas/v2/groups/$GROUP_ID/customDBRoles/roles" \
      --data '
         {
            "actions": [
               {
                 "action": "FIND",
                 "resources": [
                    {
                      "cluster": false,
                      "collection": "myTestColl",
                      "db": "myTestDB"
                    }
                 ]
               }
            ],
            "roleName": "MyNewTestRole"
         }'

echo
echo "Custom role created? Verifying..."
echo "Retrieving current roles for Project $GROUP_ID..."
echo "Look for 'MyNewTestRole'...."
echo

curl --user "$PUBLIC_KEY:$PRIVATE_KEY" --digest \
      --header "Content-Type: application/json" \
      --header "Accept: application/vnd.atlas.2023-02-01+json" \
      --include \
      --request GET "$ATLAS_BASE_URL/api/atlas/v2/groups/$GROUP_ID/customDBRoles/roles/?pretty=true"

echo


