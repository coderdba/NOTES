====================================================
BOOTSTRAP, NEW CLUSTER COOKBOOK, CREATE RUN LIST ETC
====================================================
1. Bootstrap all nodes of the RAC cluster
2. Create new cookbook (or role-cookbook) for the cluster complete with drone configuration
Create a new cookbook directly in git, with just readme.
Clone it to laptop.
Add content from another similar cookbook.
Modify cluster name, hosts, modify/remove DB's and so on
Commit and upload the cookbook
Ensure drone configuration (if needed)
Verify if the cookbook is committed in Git with modifications
Verify if the cookbook is in chef-server

3. Edit run list in chef server for the RAC nodes - include the new cookbook

6. Refresh vaults

5. Do a chef-client run on the nodes
