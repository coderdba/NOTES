======================================
            CHEF-CLIENT
======================================

- Run once
chef-client --once 

- Run a specific recipe
chef-client -o "recipe[mycookbook::myrecipe]"

- Run a specific cookbook version
chef-client -o "recipe[mycookbook@0.1.1]"

